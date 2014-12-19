#!/bin/bash

replace_genome_paths()
{
# input - stdin
# output - stdout
	sed 's/\\/\//g' |  \
	sed 's/WholeGenomeFASTA/WholeGenomeFasta/g' | \
	sed 's/Escherichia_coli_K_12_MG1655\/NCBI\/2001-10-15/Escherichia_coli_K_12_MG1655\/NCBI\/2013-09-26/g' |  \
	sed 's/Rhodobacter_sphaeroides_2.4.1\/NCBI\/2005-10-07/Rhodobacter_sphaeroides_2.4.1\/NCBI\/2012-06-25/g' 
}

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
# copy the [Reads] and [Data] sections 
# along the way, replace any genomes with the proper versions of them
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
	echo -e "$line" | replace_genome_paths >> $SRCDEST
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
		sample_line=$(echo $sample_line | replace_genome_paths)
		if [ -f $sample_line/genome.fa ]
		then
			echo $sample_line/genome.fa
		elif [ -f /illumina/scratch/Jigsaw/genomes/$sample_line/genome.fa ]
		then
			echo /illumina/scratch/Jigsaw/genomes/$sample_line/genome.fa
		fi
	fi
}
