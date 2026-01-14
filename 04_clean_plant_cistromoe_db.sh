#!/bin/bash

# ============================================================================
# Script Purpose:
# Clean up motif names in Plant Cistrome DB by removing suffixes like "_a"
# and "_col" to standardize motif naming conventions.
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

# Define file paths
R_SCRIPT="scripts/motify_meme_name_and_altname_plant_cistrome_db.R"
MEME_FILE="data/motif_databases/Plant_Cistrome_DB.meme"

echo ""
echo "============================================================================"
echo "  Plant Cistrome DB Motif Name Cleanup"
echo "============================================================================"
echo ""

# Check if R script exists
if [ ! -f "$R_SCRIPT" ]; then
    print_red "✗ R script not found: $R_SCRIPT"
    exit 1
fi

# Check if MEME file exists
if [ ! -f "$MEME_FILE" ]; then
    print_red "✗ MEME file not found: $MEME_FILE"
    exit 1
fi

print_green "This script will clean motif names by removing suffixes (_a, _col, etc.)"
print_green "Press any key to continue, or wait 5 seconds to proceed automatically..."
read -t 5 -n 1
echo ""
echo ""

print_green "Processing Plant Cistrome DB motif names..."
Rscript "$R_SCRIPT" "$MEME_FILE"

if [ $? -eq 0 ]; then
    echo ""
    print_green "Plant Cistrome DB cleanup completed successfully!"
else
    echo ""
    print_red "Error occurred during processing"
    exit 1
fi

echo ""
echo "============================================================================"
echo ""