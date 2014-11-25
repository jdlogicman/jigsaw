#!/bin/bash

# parse arguments, set
# RUN_DIR
# OUT_DIR
# SCRATCH_DIR
# CLEANUP_SCRATCH

usage() { echo "Usage: $0 -r run_dir -o output_directory [-s scratch_root]" 1>&2; exit 1; }

if [ -z "$SCRATCH_DIR" ]
then
	SCRATCH_ROOT=/scratch
	CLEANUP_SCRATCH=true


	while getopts "r:o:s:" o; do
		case "${o}" in
			r)
				export RUN_DIR=${OPTARG}
				;;
			o)
				export OUT_DIR=${OPTARG}
				;;
			s)
				export SCRATCH_ROOT=${OPTARG}
				;;
			*)
				usage
				;;
		esac
	done
	shift $((OPTIND-1))

	if [ -z "$OUT_DIR" ]; then
		usage
	fi

	if ! [ -d "$OUT_DIR" ] || ! mkdir -p "$OUT_DIR"
	then
		echo "Unable to make output directory"
		usage
	fi
	OUT_DIR=$(readlink -e $OUT_DIR)


	if ! [ -z "$JOB_ID" ]
	then
		export SCRATCH_DIR=$SCRATCH_ROOT/$JOB_DIR
	else
		export SCRATCH_DIR=$OUT_DIR/_scratch
	fi 
fi
