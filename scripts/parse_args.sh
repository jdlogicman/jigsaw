#!/bin/bash

# parse arguments, set
# RUN_DIR
# OUT_DIR
# SCRATCH_DIR

usage() { echo "Usage: $0 -r run_dir -o output_directory [-s scratch_root] [-d depth] [-l readlength]" 1>&2; exit 1; }


SCRATCH_ROOT=/scratch
# need a maximum depth
DEPTH=140


while getopts "r:o:s:d:l:" o; do
	case "${o}" in
		r)
			RUN_DIR=$(readlink -m ${OPTARG})
			;;
		o)
			OUT_DIR=$(readlink -m ${OPTARG})
			;;
		s)
			SCRATCH_ROOT=${OPTARG}
			;;
		d)
			DEPTH=${OPTARG}
			;;
		l)
			READLENGTH=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done
ALL_ARGS=($@)
shift $((OPTIND-1))


if [[ -z "$OUT_DIR"  || -z "$RUN_DIR" ]]; then
	usage
fi
if [[ $RUN_DIR =~ $OUT_DIR || $RUN_DIR =~ $OUT_DIR/.* || $OUT_DIR =~ $RUN_DIR/.* ]]
then
	echo "Input and output directories must not overlap"
	exit 1
fi

if [[ ! -z "$DEPTH" && ! $DEPTH =~ ^[0-9]+$ ]]
then
	echo "Depth must be a number"
	usage
fi

if [[ ! -z "$READLENGTH" && ! $READLENGTH =~ ^[0-9]+$ ]]
then
	echo "read length must be a number"
	usage
fi

if ! [ -d "$OUT_DIR" ] && ! mkdir -p "$OUT_DIR"
then
	echo "Unable to make output directory"
	usage
fi

if ! [ -f "$RUN_DIR/SampleSheet.csv" ]
then
	echo "Run or SampleSheet.csv do not exist"
	exit 1
fi


if [ -z "$SCRATCH_DIR" ]
then
	if ! [ -z "$JOB_ID" ]
	then
		export SCRATCH_DIR=$(echo $SCRATCH_ROOT/${JOB_ID}*)
		if ! [ -d $SCRATCH_DIR ]
		then
			echo "Error: Unable to find SGE scratch directory under $SCRATCH_ROOT"
			exit 1
		fi
	else
		export SCRATCH_DIR=$OUT_DIR/_scratch
	fi 
fi
#if [ -z "$JOB_ID" ]
#then
	#NAME=$(basename $0)
	#echo $0 ${ALL_ARGS[@]} | \
	#qsub -pe threaded 16 -l 'h_vmem=120G' -cwd -N $NAME -e $OUT_DIR/$NAME.err \
	#-o $OUT_DIR/$NAME.out -m es -M $USER@illumina.com
	#exit 0
#fi
runMaxReads()
{
        echo cat '//Read[@Number=1]/@NumCycles' | xmllint -shell $RUN_DIR/RunInfo.xml | grep "=" | cut -f2 -d\"
}
