#!/bin/bash


# Define a function to print text in red color
print_red(){
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}$1${NC}\n"
}

# Define a function to print text in green color
print_green(){
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    printf "${GREEN}$1${NC}\n"
}

# Define file path to check
FILE="data/genome_n_annotation/Arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.56.gff3"

# Check if file exists
if [ -f "$FILE" ]; then
    print_green "File already exists: $FILE"
else
    print_red "File not found: $FILE"
    # Create directory if it doesn't exist
    mkdir -p data/genome_n_annotation
    print_green "Created directory: data/genome_n_annotation"
    # Download genome and annotation files
    python scripts/download_genome_n_annotation.py
fi
