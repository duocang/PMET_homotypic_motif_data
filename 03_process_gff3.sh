#!/bin/bash


# 先定义一个函数，用于将文本打印成红色
# Define a function to print text in red color
print_red(){
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}$1${NC}\n"
}

print_green(){
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    printf "${GREEN}$1${NC}\n"
}

# remove string from gene name
gff3=data/genome_n_annotation/Oryza_sativa_japonica_V7.1/Osativa_323_v7.0.gene.gff3
FILE="data/genome_n_annotation/Oryza_sativa_japonica_V7.1/modified.gff3"
if [ -f "$FILE" ]; then
    echo ""
else
    # Oryza_sativa_japonica_V7.1
    sed 's/\.MSUv7\.0//g' $gff3 > $FILE
    rm -rf $gff3
fi

gff3=data/genome_n_annotation/Oryza_sativa_japonica_Kitaake/Oryza_sativa_japonica_Kitaake.gff3
FILE="data/genome_n_annotation/Oryza_sativa_japonica_Kitaake/modified.gff3"
if [ -f "$FILE" ]; then
    echo ""
else
    # Oryza_sativa_japonica_Kitaake
    sed 's/\.v3\.1//g' $gff3 > $FILE
    rm -rf $gff3
fi

gff3=data/genome_n_annotation/Solanum_tuberosum/Solanum_tuberosum.SolTub_3.0.57.gff3
FILE="data/genome_n_annotation/Solanum_tuberosum/modified.gff3"
if [ -f "$FILE" ]; then
    echo ""
else
    # Oryza_sativa_japonica_Kitaake
    sed 's/^00\t/1\t/' $gff3 > $FILE
    rm -rf $gff3
fi
