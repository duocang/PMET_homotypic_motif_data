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

# 定义文件路径
FILE="data/genome_n_annotation/Arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.56.gff3"
# 检查文件是否存在
if [ -f "$FILE" ]; then
else
    python scripts/download_genome_n_annotation.py
fi
