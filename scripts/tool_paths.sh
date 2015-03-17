#!/bin/bash

SPADES_DIR=/illumina/thirdparty/spades/SPAdes-3.5.0-Linux/bin
FASTQ_TOOLKIT=/illumina/scratch/Jigsaw/tools/FastqToolkit/latest
QUAST_DIR=/illumina/thirdparty/quast-2.3
PYTHON_DIR=/illumina/thirdparty/python/python-2.7.8/bin
export PYTHONPATH_DIR=/illumina/thirdparty/python/python_libraries/packages:$PYTHONPATH

PICARD_DIR=/illumina/thirdparty/picard-tools/picard-tools-1.85
MUMMER_DIR=$QUAST_DIR/libs/MUMmer3.23-linux
LAST_DIR=/illumina/thirdparty/last
SAMTOOLS_DIR=/illumina/thirdparty/samtools/latest
BEDTOOLS_DIR=/illumina/thirdparty/bedtools/bedtools2-2.20.1/bin
BWA_DIR=/illumina/thirdparty/bwa/latest
FIREBRAND_DIR=/illumina/development/Firebrand/el6/FIRE-00.14.06.25_GeL/scripts
