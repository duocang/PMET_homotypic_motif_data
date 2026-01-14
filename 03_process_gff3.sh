#!/bin/bash

# ============================================================================
# Script Purpose:
# Some annotation files contain version numbers or text markers in gene names.
# For example:
#   - Oryza_sativa_japonica_Kitaake: gene names contain version suffix ".v3.1"
#   - Oryza_sativa_japonica_V7.1: gene names contain version suffix ".MSUv7.0"
#   - Solanum_tuberosum: chromosome identifiers start with "00" instead of "1"
# This script removes these markers to standardize gene naming conventions.
# ============================================================================


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

# Prompt user for confirmation
print_green "This script will process GFF3 files to remove version markers from gene names."
print_green "Press any key to continue, or wait 5 seconds to proceed automatically..."
read -t 5 -n 1
echo ""
print_green "Starting GFF3 processing..."
echo ""

# ============================================================================
# Process Oryza_sativa_japonica_V7.1: Remove .MSUv7.0 suffix
# ============================================================================
gff3=data/genome_n_annotation/Oryza_sativa_japonica_V7.1/Osativa_323_v7.0.gene.gff3
FILE="data/genome_n_annotation/Oryza_sativa_japonica_V7.1/modified.gff3"

if [ -f "$FILE" ]; then
    print_green "Modified file already exists: $FILE"
else
    if [ ! -f "$gff3" ]; then
        print_red "Source file not found: $gff3"
    else
        print_green "Processing: $gff3"
        sed 's/\.MSUv7\.0//g' $gff3 > $FILE
        rm -rf $gff3
        print_green "Created: $FILE"
    fi
fi
echo ""

# ============================================================================
# Process Oryza_sativa_japonica_Kitaake: Remove .v3.1 suffix
# ============================================================================
gff3=data/genome_n_annotation/Oryza_sativa_japonica_Kitaake/Oryza_sativa_japonica_Kitaake.gff3
FILE="data/genome_n_annotation/Oryza_sativa_japonica_Kitaake/modified.gff3"

if [ -f "$FILE" ]; then
    print_green "Modified file already exists: $FILE"
else
    if [ ! -f "$gff3" ]; then
        print_red "Source file not found: $gff3"
    else
        print_green "Processing: $gff3"
        sed 's/\.v3\.1//g' $gff3 > $FILE
        rm -rf $gff3
        print_green "Created: $FILE"
    fi
fi
echo ""

# ============================================================================
# Process Solanum_tuberosum: Replace chromosome "00" with "1"
# ============================================================================
gff3=data/genome_n_annotation/Solanum_tuberosum/Solanum_tuberosum.SolTub_3.0.57.gff3
FILE="data/genome_n_annotation/Solanum_tuberosum/modified.gff3"

if [ -f "$FILE" ]; then
    print_green "Modified file already exists: $FILE"
else
    if [ ! -f "$gff3" ]; then
        print_red "Source file not found: $gff3"
    else
        print_green "Processing: $gff3"
        sed 's/^00\t/1\t/' $gff3 > $FILE
        rm -rf $gff3
        print_green "Created: $FILE"
    fi
fi

print_green "\nGFF3 processing completed!"
