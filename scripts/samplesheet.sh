#!/bin/bash

rewrite_samplesheet_for_alignment()
{
# $1 = source & target sample sheet
# $2 (optional) read length trimming
	local SRCDEST=$1
	TMPFILE=/tmp/sstmp.$$
	if ! [ -z "$2" ]
	then
		local TRIMLINE1="Read1EndWithCycle,$2"
		local TRIMLINE2="Read2EndWithCycle,$2"
	fi
	

	shopt -s nocasematch
	cp $SRCDEST $TMPFILE
echo "[Header]
IEMFileVersion,4
Experiment Name,Jigsaw
Workflow,Resequencing

[Settings],,,,,,,,
aligner,bwa
variantcaller,None
ReverseComplement,1
$TRIMLINE1
$TRIMLINE2
runcnvdetection,None
runsvdetection,None
svannotation,None
indelrealignment,None
Adapter,CTGTCTCTTATACACATCT+AGATGTGTATAAGAGACAG+GATCGGAAGAGCACACGTCTGAACTCCAGTCAC+GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
" > $SRCDEST
# copy the [Reads] and [Data] sections verbatim
	local in_section=0

	while read -r line
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
			echo -e "$line" >> $SRCDEST
		fi
	done < $TMPFILE
	rm -f $TMPFILE
}

get_sample_genome()
{
	local sample_sheet=$1
	local sample=$2
	local sample_line=$(grep -i $sample $sample_sheet | tr "," "\n" | grep -i WholeGenome | head -1 | tr '\\' '/' | sed 's/FASTA/Fasta/g')
	if ! [ -z "$sample_line" ]
	then
		if [ -f $sample_line/genome.fa ]
		then
			echo $sample_line/genome.fa
		elif [ -f /illumina/scratch/Jigsaw/genomes/$sample_line/genome.fa ]
		then
			echo /illumina/scratch/Jigsaw/genomes/$sample_line/genome.fa
		fi
	fi
}
