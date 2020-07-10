
#!/bin/bash
###############################################
# 
# This is bwa alignment automatic shell scipt
# 
# Usage :
# time_printer() { now=`date '+%Y-%m-%d_%H:%M:%S'`; printf "%s\n" "$now"; }
# ( bash cmd.sh 2>&1 ) |tee bwa`time_printer`.log
# 

time_printer()
{
	now=`date '+%Y-%m-%d_%H:%M:%S'`
	printf "%s\n" "$now"
}

index="$HOME/test_data/bwa-build-index/hg38"

for i in `ls *.fq.gz `
do
    k=`echo $i | sed 's/.fq.gz//' `
    echo "$k"
    echo -e "time bwa aln $index -t 8 $k.fq.gz > $k.sai ";
    time_printer
    time bwa aln $index -l 25 -t 8 $k.fq.gz > $k.sai

    #-l INT	Take the first INT subsequence as seed. If INT is larger than
    #       the query sequence, seeding will be disabled. For long reads,
    #       this option is typically ranged from 25 to 35 for ‘-k 2’. [inf]
    #-N	    Disable iterative search. All hits with no more than maxDiff 
    #       differences will be found. 
    #       This mode is much slower than the default.
    echo -e "$i bwa aln done\n~~~~~~~~~~~~~~~~~~~~~"
    time_printer
    echo ""
    
    echo -e "time bwa samse $index $k.sai  $k.fq.gz > $k.bwa.sam";
    time_printer
    #sleep 1
    time bwa samse $index $k.sai $k.fq.gz > $k.bwa.sam
    echo -e "$i bwa samse done\n~~~~~~~~~~~~~~~~~~~~~"
    time_printer
    echo ""

    echo -e "samtools view -S -b -@ 8 $i.bwa.sam > $k.bwa.bam"
    time_printer
    samtools view -S -b -@ 8 $k.bwa.sam > $k.bwa.sam

    echo -e "$k.bwa.sam to .bam done\n~~~~~~~~~~~~~~~~~~~~~"
    time_printer
    echo ""
    
    if [ ! -f "$k.bwa.sam" ] ;then
        echo "!!!!!!!!!!!!!!bwa is not complete!!!!!!!!!!!!!!"
        exit 1
    fi
    filesize=`ls -al $k.bwa.sam | awk {'print $5'}`
    
    if [ $filesize >0 ] ;then
        #rm $k.bwa.sam
    fi

    echo -e "samtools view -b -f 4 -@ 8 $k.bwa.bam > $k.bwa.unmapped.bam"
    time_printer
    samtools view -b -f 4 -@ 8 $k.bwa.bam > $k.bwa.unmapped.bam
    echo -e "$k.bwa.bam extracting unmapped reads done\n~~~~~~~~~~~~~~~~~~~~~"
    time_printer
    echo ""

    echo -e "samtools bam2fq -@ 8 $k.bwa.unmapped.bam > $k.bwa.unmapped.fq"
    time_printer
    samtools bam2fq -@ 8 $k.bwa.unmapped.bam > $k.bwa.unmapped.fq
    echo -e "$k.bwa.unmapped.bam extracting unmapped reads done\n~~~~~~~~~~~~~~~~~~~~~"
    time_printer
    echo ""
    
done





