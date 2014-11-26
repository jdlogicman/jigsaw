#!/bin/bash

# parse arguments, set
# RUN_DIR
# OUT_DIR
# SCRATCH_DIR

usage() { echo "Usage: $0 -r run_dir -o output_directory [-s scratch_root]" 1>&2; exit 1; }


SCRATCH_ROOT=/scratch


while getopts "r:o:s:" o; do
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
		*)
			usage
			;;
	esac
done
shift $((OPTIND-1))

if [[ -z "$OUT_DIR"  || -z "$RUN_DIR" ]]; then
	usage
fi
if [[ $RUN_DIR =~ $OUT_DIR || $RUN_DIR =~ $OUT_DIR/.* || $OUT_DIR =~ $RUN_DIR/.* ]]
then
	echo "Input and output directories must not overlap"
	exit 1
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
