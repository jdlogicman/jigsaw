# convert show-coords output, minus header lines and and self-match line, into bed format
NR==1{b=$1;e=$2;contig=$NF;next}
{
    if ($1>e||$NF!=contig){
	print contig "\t" b-1 "\t" e;
	contig=$NF;
	b=$1;
	e=$2;
    } else {
	if ($2>e) e=$2;
    }
}
END{
    print contig "\t" b-1 "\t" e;
}
