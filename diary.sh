#!/bin/bash

createConfigFile() {
	if [ $# -eq 2 ]
	then 
	diary_path=$1
	editor=$2
	else
	diary_path=$HOME/diary
	editor=nano
	fi

	echo export DIARY_PATH=$diary_path > $HOME/.diaryrc
	echo export EDITOR=$editor >> $HOME/.diaryrc
}

setEditor() {
        `createConfigFile $DIARY_PATH $1`
}

setPath() {
        `createConfigFile` $1 $EDITOR
}


createNote() {
	$EDITOR `generateFile`
}

generateFile() {
	year=`date +%Y`
	mounth=`date +%m`

	path=$DIARY_PATH/notes/$year/$mounth
	if [ ! -d $path ]
	then
		mkdir -p $path
	fi

	id=`uuidgen`
	fileName=$id\__`date +%Y-%m-%d_%H-%M`.md
	echo $path/$fileName
}

createTemplate() {
	name=$1
	path=$DIARY_PATH/templates
	if [ ! -d $path ]
	then
		mkdir -p $path
	fi

	$EDITOR $path/$name
}

printTemplates(){
	ls $DIARY_PATH/templates -1
}

printBasket(){
	ls $DIARY_PATH/basket -1
}

printNotes() {
  find $DIARY_PATH/notes -type f
}

createNoteFromTemplate() {
	name=`generateFile`
	templatePath=$DIARY_PATH/templates/$1
	if [ ! -e templatePath ]
	then
		echo $templatePath not found
	else
		cp $templatePath $name
		$EDITOR $name
	fi
}

openNote() {
	id=$1
	file=`find $DIARY_PATH/notes -name $id*`
	fileExist=`find $DIARY_PATH/notes -name "$id*" | wc -l`
	if [ $fileExist == 0 ]
	then
	   echo "file with id = $id not found"
	elif [ ! $fileExist = 1 ]
	then
	  echo "input more digit in id"
	else
	  $EDITOR $file
	fi
}

deleteNote() {
  id=$1
  file=`find $DIARY_PATH/notes -name $id*`
  fileExist=`find $DIARY_PATH/notes -name "$id*" | wc -l`
  if [ ! -e $DIARY_PATH/basket ]
  then
    mkdir $DIARY_PATH/basket
  fi

  if [ $fileExist = 0 ]
	then
	   echo "file with id = $id not found"
	elif [ ! $fileExist = 1 ]
	then
	  echo "input more digit in id"
	else
    mv $file $DIARY_PATH/basket
  fi
}

restoreNote(){
  id=$1

  file=`find $DIARY_PATH/basket -name $id*`
  fileExist=`find $DIARY_PATH/basket -name "$id*" | wc -l`

   if [ $fileExist = 0 ]
	then
	   echo "file with id = $id not found"
	elif [ ! $fileExist = 1 ]
	then
	  echo "input more digit in id"
	else
	  year=${file: -19: -15}
    mounth=${file: -14: -12}
    path=$DIARY_PATH/notes/$year/$mounth
    if [ ! -e $path ]
    then
      mkdir $path
    fi
    mv $file $path
  fi

}

help() {
  echo "
  diary note          create new note
  diary note -l       show all notes
  diary template      create new template
  diary template -l   show all templates
  diary open [id]     open note by id
  diary delete [id]   delete note by id
  diary basket        show all notes in basket
  diary restore [id]  restore note by id

  diary editor [EDITOR] set default text editor
  diary path [PATH]     set default path to diary"
}

if [ ! -f $HOME/.diaryrc ]
then
createConfigFile
fi

source $HOME/.diaryrc


if [[ $# -eq 1 && $1 = "note" ]]
then
	createNote
elif [[ $# -eq 1 &&  $1 = "help" ]]
then
	help
elif [[ $# -eq 2 &&  $1 = "note"  && $2 = "-l" ]]
then
	printNotes
elif [[ $# -eq 2 &&  $1 = "restore" ]]
then
	restoreNote $2
elif [[ $# -eq 2 &&  $1 = "open" ]]
then
	openNote $2
elif [[ $# -eq 1 &&  $1 = "basket" ]]
then
  printBasket
elif [[ $# -eq 2 && $1 = "delete" ]]
then
	deleteNote $2
elif [[ $# -eq 2 && $1 = "template" && $2 = "-l" ]]
then
	printTemplates
elif [[ $# -eq 2 && $1 = "template" ]]
then
	createTemplate $2
elif [[ $# -eq 3 && $1 = "note" && $2 = "-t" ]]
then
	createNoteFromTemplate $3
elif [[ $# -eq 2 && $1 = "editor" ]]
then
	setEditor $2
elif [[ $# -eq 2 && $1 = "path" ]]
then
	setPath $2
fi
