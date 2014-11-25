#!/bin/bash

rewrite_samplesheet()
{
	local SRCDEST=$1
	TMPFILE=/tmp/sstmp.$$

	shopt -s nocasematch
	cp $SRCDEST $TMPFILE
echo "[Header]
IEMFileVersion,4
Experiment Name,Jigsaw
Workflow,GenerateFastq

[Settings],,,,,,,,
ReverseComplement,1
Adapter,CTGTCTCTTATACACATCT+AGATGTGTATAAGAGACAG
" > $SRCDEST
# copy the [Reads] and [Data] sections verbatim
	local in_section=0

	while read line
	do
		if [[ $line =~ ^\[.* ]]
		then
			# section start
			if [[ $line =~ ^\[Reads].* || $line =~ ^\[Data].* ]]
			then
				in_section=1
			else
				in_section=0
			fi
		fi
		if [ $in_section == 1 ]
		then
			echo $line >> $SRCDEST
		fi
	done < $TMPFILE
	rm -f $TMPFILE
}
