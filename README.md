Jigsaw Scripts
==============

These scripts are designed to work on the San Diego and San Francisco clusters.

The tools are installed in /illumina/scratch/Jigsaw/tools/jigsaw.

If you need to make any changes, a pull request is appreciated so I can keep track of things. 

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
