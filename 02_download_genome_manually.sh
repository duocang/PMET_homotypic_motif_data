#!/bin/bash

# ============================================================================
# Script Purpose:
# Some species genomes need to be downloaded manually from their respective
# databases as they are not available through automated download scripts.
# This script checks if manual downloads are needed and lists the species.
# ============================================================================


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

# Define a function to print text in yellow color
print_yellow(){
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    printf "${YELLOW}$1${NC}\n"
}

# Check if manually downloaded genomes exist by testing a representative file
FILE="data/genome_n_annotation/Hordeum_vulgare_R1/Hvulgare_462_r1.fa"

echo ""
echo "============================================================================"
echo "  Manual Download Check for Genome and Annotation Files"
echo "============================================================================"
echo ""

if [ -f "$FILE" ]; then
    print_green "✓ Sample genome file found: Manual downloads appear to be complete."
    echo ""
    print_yellow "However, please verify the following species data are complete:"
    echo ""
    print_yellow "Reference: data/species.json"
    echo ""
    echo "  • Hordeum_vulgare_R1"
    echo "  • Oryza_sativa_japonica_V7.1"
    echo "  • Oryza_sativa_indica_IR8"
    echo "  • Oryza_sativa_indica_MH63"
    echo "  • Oryza_sativa_indica_ZS97"
    echo "  • Oryza_sativa_japonica_Kitaake"
    echo "  • Oryza_sativa_japonica_Nipponbare"
    echo ""
else
    print_red "✗ Manual genome files not found!"
    echo ""
    print_yellow "Please manually download genome and annotation files for:"
    echo ""
    print_yellow "Reference: data/species.json for download URLs"
    echo ""
    echo "  • Hordeum_vulgare_R1"
    echo "  • Oryza_sativa_japonica_V7.1"
    echo "  • Oryza_sativa_indica_IR8"
    echo "  • Oryza_sativa_indica_MH63"
    echo "  • Oryza_sativa_indica_ZS97"
    echo "  • Oryza_sativa_japonica_Kitaake"
    echo "  • Oryza_sativa_japonica_Nipponbare"
    echo ""
fi

echo "============================================================================"
echo ""
