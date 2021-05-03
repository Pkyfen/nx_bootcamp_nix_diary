#!/bin/bash

createConfigFile() {
	echo export DIARY_PATH=$HOME/diary > $HOME/.diaryrc
	echo export EDITOR=nano >> $HOME/.diaryrc
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

if [ ! -f $HOME/.diaryrc ]
then
createConfigFile
fi

source $HOME/.diaryrc

createNote

