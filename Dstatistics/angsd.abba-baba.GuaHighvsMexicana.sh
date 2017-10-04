#!/bin/bash
#PBS  -o ${PBS_JOBNAME}.o${PBS_JOBID}
#PBS  -e ${PBS_JOBNAME}.e${PBS_JOBID}
#PBS -N angsd
#PBS -l vmem=256Gb,pmem=4Gb,mem=256Gb,nodes=1:ppn=32:ib,walltime=48:00:00
   cd $PBS_O_WORKDIR
module use /data004/software/GIF/modules
module load R
#-checkBamHeaders 0 -rf scaffoldNamesWithData.txt 
#Those two flags are important, as in Tripsacum some small scaffolds have no reads mapped on. In that case, the consensus sequence file of Tripsacum (Tripsacum.fa) will have no sequence for those scaffolds. 
#While those scaffold exist in the three ingroup bam files, angsd will scream "chromosome length inconsistency error". 
#-checkBamHeaders 0 just ask it to skip checking the bam headers. The analyzed chromosomes are given by "-rf scaffoldNamesWithData.txt", which is generated by "cut -f1 Tripsacum.fa.fai" (the first column of samtools faidxed Tripsacum.fa file)
#-bam P3_luxurians.txt simply gives the directory of the three ingroup bam files
/data004/software/GIF/packages/ANGSD/0.614/angsd -doAbbababa 1 -blockSize 1000 -anc /home/lwang/lwang/SRA/Tripsacum/Tripsacum.fa -doCounts 1 -bam GuaHighvsMexicana.txt -uniqueOnly 1 -minMapQ 30 -minQ 20 -minInd 3 -P 30 -checkBamHeaders 0 -rf /home/lwang/lwang/SRA/scaffoldNamesWithData.txt -out GuaHighvsMexicana

#jackKnife.R is provided with angsd.
Rscript jackKnife.R file=GuaHighvsMexicana.abbababa indNames=GuaHighvsMexicana.txt outfile=GuaHighvsMexicana

