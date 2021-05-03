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

setEditor() {
	`createConfigFile $DIARY_PATH $1`
}

setPath() {
	`createConfigFile` $1 $EDITOR
}

if [ ! -f $HOME/.diaryrc ]
then
createConfigFile
fi

source $HOME/.diaryrc

createNote
