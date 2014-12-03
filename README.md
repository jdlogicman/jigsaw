Jigsaw Scripts
==============

These scripts are designed to work on the San Diego and San Francisco clusters.

The tools are installed in /illumina/scratch/Jigsaw/tools/jigsaw.

If you need to make any changes, a pull request is appreciated so I can keep track of things. If you clone your own copy, the pipeline will use the scripts in your source tree, so you can feel safe making related changes to several scripts.

<h2>Usage</h2>

In general, most of the scripts require 2 parameters:
<pre>
-r : run folder
-o : output folder
</pre>
Example:
<pre>
jigsaw/assemble_flowcell -r /illumina/scratch/Jigsaw/NMP/NMP_Seq_Runs/MyFlowcell \
  -o /illumina/scratch/Jigsaw/Assemblies/MyAssemblies
</pre>
Other parameters are usually just for internal helper scripts. Once exception is -s for setting the scratch root directory. By default, it is /scratch for SGE jobs and output/_scratch for interactive jobs.

The output folder may not be a subdirectory of the run folder - this makes it difficult to sync to local scratch space, and it's a bad habit to mix inputs & outputs anyway.

<h2>The scripts</h2>
<h3>assemble_flowcell</h3>
This script takes the primary parameters and submits an SGE job to assemble the flowcell. The output from the job is captured in the output directory you specify, and you will be emailed when the job completes.
<h3>scripts/assemble_flowcell</h3>
This is the script submitted to SGE. If you want to run the whole pipeline interactively, and you have a whole node, you can run this.
<h3>scripts/align_samples</h3>
Uses Isis/BWA to align the samples to the references provided in the sample sheet. Also creates the FASTQ files with adapters trimmed and reads reverse-complemented.

The results are placed in  <em>output</em>/Alignment.

<h3>scripts/assemble_samples</h3>
Uses SPAdes 3.3.1 to assemble the FASTQ files. The results are placed in <em>output</em>/spades/<em>SampleID</em>.

<h3>scripts/generate_all_metrics</h3>
Uses various tools to create metrics. The following folders are placed in <em>output</em>:
<ul>
<li>picard/<em>SampleID</em></li>
<li>quast/<em>SampleID</em></li>
<li>visualization/<em>SampleID</em></li>
</ul>

<h2>Visualizations</h2>
A file called <pre>summary.html</pre> will appear in the <em>output</em> directory. This will like to the Quast and Isis reports. It will also contain a thunmnail/link to a dot plot of the assembly.

The visualization directory will contain a version of the assembly scaffolds aligned back to the reference genome. It will also contain a BED file called gaps.bed that can be used in IGV to quickly locate regions of the reference not covered by any contigs in the assembly.
