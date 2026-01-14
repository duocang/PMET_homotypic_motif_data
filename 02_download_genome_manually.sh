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

FILE="data/genome_n_annotation/Hordeum_vulgare_R1/Hvulgare_462_r1.fa"
if [ -f "$FILE" ]; then
    print_green "It seems that the genomic data that needs to be downloaded is already available."
    print_green "But I still want you to check out the genome and annotation files for the species below."
    echo        ""
    print_red   "Check data/sepcies.json"
    print_red   "Hordeum_vulgare_R1, Oryza_sativa_japonica_V7.1, Oryza_sativa_indica_IR8, Oryza_sativa_indica_MH63, Oryza_sativa_indica_ZS97, Oryza_sativa_japonica_Kitaake, Oryza_sativa_japonica_Nipponbare"
else
    print_red "Check data/sepcies.json"
    print_red " Manually download Hordeum_vulgare_R1, Oryza_sativa_japonica_V7.1, Oryza_sativa_indica_IR8, Oryza_sativa_indica_MH63, Oryza_sativa_indica_ZS97, Oryza_sativa_japonica_Kitaake, Oryza_sativa_japonica_Nipponbare"
fi



