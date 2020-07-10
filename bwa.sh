#!/bin/bash

###########################################################################
# 
# Edit by hudeneil
# 
# This script will doing alignment
# 
# 
# edit time :
# 
# 
# 


###########################################################################
# 
# Print current time 
# 
time_printer()
{
	now=`date '+%Y-%m-%d_%H:%M:%S'`
	printf "%s\n" "$now"
}
time_printer


###########################################################################
# 
# Making folder and links
# 
now=`date '+%Y-%m-%d_%H-%M-%S'`


###########################################################################
# 
# Doing bwa 
# 
# I.	Generate *.sai file
# II.	Generate *.sam file
# 

index="$HOME/test_data/bwa-build-index/hg38"

for i in `ls *.gz`
do
	r1=`echo $i | sed "s/.fq.gz//g" `
	name=`echo $r1 | sed "s/_R1_001//g"`
	
	
	if [ ! -f "$name.bwa.sam" ];then

		if [ ! -f "$r1.P.qtrim.sai" ];then
			
			echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"\
					"Generating $r1.sai\n"
			time bwa aln $index -t 4 $r1.fq.gz > $r1.sai
			
			if [ ! -f "$r1.sai" ];then
				echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"\
						"bwa aln failed $r1.sai cannot be build\n"
				exit 1
			fi
			
		fi

	echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"\
			"Doing bwa samse\n"
	
		time bwa samse $index $r1.sai  $r1.fq  > $name.bwa.sam

		check_size=`ls -al |grep $name.bwa.sam| awk '{print $5}'`
		if [ $check_size -lt 100 ] ;then
			echo "Detected too tiny size with $name.bwa.sam file"
			exit 1
		fi
		echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"\
				"$name.bwa.sam completed\n"
	fi
done	
		
cd ..		
		
echo "bwa finish"


