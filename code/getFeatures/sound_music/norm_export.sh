#!/bin/bash

for i in $(ls *.wav | sed -e s/\.wav$//); 
	do 
		echo $i;
		sox $i.wav ~/Dropbox/projets/ssf/interface/sound_music/$i.ogg; 
	done 

