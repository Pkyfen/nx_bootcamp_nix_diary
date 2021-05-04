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

	path=$DIARY_PATH/$year/$mounth
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

createNoteFromTemplate() {
	name=`generateFile`
	templatePath=$DIARY_PATH/templates/$1
	if [! -e templatePath ]
	then
		echo $templatePath not found
	else
		cp $templatePath $name
		$EDITOR $name
	fi
}

openNote() {
	id=$1
	file=`find $DIARY_PATH -name $id*`
	$EDITOR $file 
}

if [ ! -f $HOME/.diaryrc ]
then
createConfigFile
fi

source $HOME/.diaryrc


if [[ $# -eq 1 && $1 = "note" ]]
then
	createNote
elif [[ $# -eq 2 &&  $1 = "open" ]]
then
	openNote $2
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
