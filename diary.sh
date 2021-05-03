#!/bin/bash

createConfigFile() {
	echo export DIARY_PATH=$HOME/diary > $HOME/.diaryrc
	echo export EDITOR=nano >> $HOME/.diaryrc
}

if [ ! -f $HOME/.diaryrc ]
then
createConfigFile
fi

source $HOME/.diaryrc

echo $DIARY_PATH
echo $EDITOR

