#!/bin/bash

replace_genome_paths()
{
# input - stdin
# output - stdout
	sed 's/\\/\//g' |  \
	sed 's/WholeGenomeFASTA/WholeGenomeFasta/g' | \
	sed 's/Escherichia_coli_K_12_MG1655\/NCBI\/2001-10-15/Escherichia_coli_K_12_MG1655\/NCBI\/2013-09-26-Aaron/g' |  \
	sed 's/Rhodobacter_sphaeroides_2.4.1\/NCBI\/2005-10-07/Rhodobacter_sphaeroides_2.4.1\/NCBI\/2012-06-25/g' | \
	sed 's/,Escherichia_coli_K_12_MG1655/,\/illumina\/scratch\/Jigsaw\/genomes\/Escherichia_coli_K_12_MG1655/g' | \
	sed 's/,Bacillus_cereus_ATCC_10987/,\/illumina\/scratch\/Jigsaw\/genomes\/Bacillus_cereus_ATCC_10987/g' | \
	sed 's/,Rhodobacter_sphaeroides_2.4.1/,\/illumina\/scratch\/Jigsaw\/genomes\/Rhodobacter_sphaeroides_2.4.1/g' | \
	sed 's/,Saccharomyces_cerevisiae/,\/illumina\/scratch\/Jigsaw\/genomes\/Saccharomyces_cerevisiae/g' | \
	sed 's/,Bordetella_pertussis_18323/,\/illumina\/scratch\/Jigsaw\/genomes\/Bordetella_pertussis_18323/g' | \
	sed 's/,Mycobacterium_tuberculosis_H37Rv/,\/illumina\/scratch\/Jigsaw\/genomes\/Mycobacterium_tuberculosis_H37Rv/g' | \
	sed 's/,Listeria_monocytogenes_EGD_e/,\/illumina\/scratch\/Jigsaw\/genomes\/Listeria_monocytogenes_EGD_e/g' | \
	sed 's/2013-09-26\//2013-09-26-Aaron\//g' 
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
	local sample_line=$(grep -i $sample $sample_sheet | tr "," "\n" | grep -i WholeGenome | head -1 | tr '\\' '/' | sed 's/FASTA/Fasta/g' | tr -d '\r')
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

get_sample_field()
{
# $1 - sample sheet file name
# $2 = sample id
# $3 = field name
	local sample_sheet=$1
	local sample_id=$2
	local field_name=$3
	local headers
	local values
	local in_section=0

	declare -A sample

	shopt -s nocasematch
	while read -r line
	do
		line=$(echo $line | sed -e 's///g')
		if [ $in_section == 1 ]
		then
			if [ -z "${headers[0]}" ]
			then
				IFS=',' read -a headers <<< "$line"
				unset IFS
			else
				IFS=',' read -a values <<< "$line"
				unset IFS
				for idx in $(seq 0 $(( ${#headers[@]} - 1 )) )
				do
					sample[${headers[$idx]}]="${values[$idx]}"
				done
				if [[ ${sample["SampleID"]} =~ $sample_id || ${sample["Sample_ID"]} =~ $sample_id ]]
				then
					echo "${sample[$field_name]}"
					return
				fi
			fi
		fi
		if [[ $line =~ ^\[.* ]]
		then
			# section start
			if [[ $line =~ ^\[Data].* ]]
			then
				in_section=1
			else
				in_section=0
			fi
		fi
	done < $sample_sheet
}
