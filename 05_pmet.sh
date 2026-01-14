#!/bin/bash

# ============================================================================
# Script Purpose:
# Run PMET (Promoter Motif Enrichment Tool) analysis pipeline for all species
# using multiple motif databases. This script:
#   1. Clones and sets up PMET analysis pipeline
#   2. Processes all species genomes in data/genome_n_annotation
#   3. Runs analysis with multiple motif databases per species
#   4. Generates homotypic analysis results
# ============================================================================

# ============================================================================
# CONFIGURATION PARAMETERS
# ============================================================================

# PMET analysis parameters
PROM_LENGTH=1000          # Promoter length (bp upstream of TSS)
MAX_K=5                   # Maximum k-mer size
TOP_N=5000                # Number of top motifs to consider
FIMO_THRESH=0.05          # FIMO p-value threshold
OVERLAP="NoOverlap"       # Overlap mode
UTR="no"                  # Include UTR regions
GFF3_ID="gene_id="        # GFF3 gene ID attribute
DELETE_TEMP="yes"         # Delete temporary files after processing
THREADS=16                # Number of CPU threads to use

# Directory settings
RESULT_DIR="homotypic_out111111"
EXTERNAL_DIR="external"
PMET_REPO="https://github.com/duocang/PMET_analysis_pipeline.git"

# Motif database list
MOTIF_DATABASES=(
    "CIS-BP2"
    "plantTFDB"
    "Franco-Zorrilla_et_al_2014"
    "Jaspar_plants_non_redundant_2022"
    "Plant_Cistrome_DB"
    "Plant_Cistrome_DB_with_family_info"
)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Print text in red color
print_red(){
    RED='\033[0;31m'
    NC='\033[0m'
    printf "${RED}$1${NC}\n"
}

# Print text in green color
print_green(){
    GREEN='\033[0;32m'
    NC='\033[0m'
    printf "${GREEN}$1${NC}\n"
}

# Print text in yellow color
print_yellow(){
    YELLOW='\033[1;33m'
    NC='\033[0m'
    printf "${YELLOW}$1${NC}\n"
}

# ============================================================================
# SETUP PMET PIPELINE
# ============================================================================

echo ""
echo "============================================================================"
echo "  PMET Analysis Pipeline Setup"
echo "============================================================================"
echo ""

# Clone PMET pipeline if not exists
if [ -d "$EXTERNAL_DIR" ]; then
    print_yellow "External directory already exists, skipping clone..."
else
    print_green "Cloning PMET analysis pipeline..."
    git clone "$PMET_REPO"
    mv PMET_analysis_pipeline "$EXTERNAL_DIR"
    
    cd "$EXTERNAL_DIR"
    bash run.sh 00_requirements_reminder.sh
    cd ..
fi

# Make scripts executable
print_green "Setting script permissions..."
find "$EXTERNAL_DIR/scripts" -type f \( -name "*.sh" -o -name "*.pl" \) -exec chmod a+x {} \;

# Create output directory
mkdir -p "$RESULT_DIR"

echo ""
echo "============================================================================"
echo "  Processing Species and Motif Databases"
echo "============================================================================"
echo ""

# ============================================================================
# MAIN PROCESSING LOOP
# ============================================================================

# Loop through all species
# Loop through all species
find data/genome_n_annotation -mindepth 1 -maxdepth 1 -type d | sort | while read dir
do
    species=$(basename "$dir")
    print_yellow "\nProcessing species: $species"
    
    # Initialize arrays for genome files
    gff3=()
    fa=()
    
    # Collect GFF3 and FASTA files
    for file in "$dir"/*; do
        if [[ $file == *.gff3 ]]; then
            gff3+=("$file")
            elif [[ $file == *.fa ]] || [[ $file == *.fasta ]]; then
            fa+=("$file")
        fi
    done
    
    # Check if genome files were found
    if [ ${#gff3[@]} -eq 0 ] || [ ${#fa[@]} -eq 0 ]; then
        print_red "  ✗ Missing genome files for $species (GFF3: ${#gff3[@]}, FASTA: ${#fa[@]})"
        continue
    fi
    
    print_green "  ✓ Found genome files (GFF3: ${#gff3[@]}, FASTA: ${#fa[@]})"
    
    # Loop through all motif databases
    for motif_db in "${MOTIF_DATABASES[@]}"; do
        print_green "    → Processing motif database: $motif_db"
        
        # Determine motif database path
        case "$motif_db" in
            "CIS-BP2")
                if [ -d "data/motif_databases/CIS-BP2/$species" ]; then
                    meme_dir="data/motif_databases/CIS-BP2/$species/TF_binding_motifs.meme"
                else
                    meme_dir="no_value"
                fi
            ;;
            "plantTFDB")
                if [ -d "data/motif_databases/plantTFDB/$species" ]; then
                    meme_dir="data/motif_databases/plantTFDB/$species/TF_binding_motifs.meme"
                else
                    meme_dir="no_value"
                fi
            ;;
            "Franco-Zorrilla_et_al_2014")
                meme_dir="data/motif_databases/Franco-Zorrilla_et_al_2014.meme"
            ;;
            "Jaspar_plants_non_redundant_2022")
                meme_dir="data/motif_databases/JASPAR2022_CORE_plants_non-redundant_pfms_meme.meme"
            ;;
            "Plant_Cistrome_DB")
                meme_dir="data/motif_databases/Plant_Cistrome_DB_parsed.meme"
            ;;
            "Plant_Cistrome_DB_with_family_info")
                meme_dir="data/motif_databases/Plant_Cistrome_DB.meme"
            ;;
            *)
                print_red "      ✗ Unknown motif database: $motif_db"
                continue
            ;;
        esac
        
        # Skip if motif database not available for this species
        if [ "$meme_dir" == "no_value" ]; then
            print_yellow "      ⊘ Motif database not available for $species, skipping..."
            continue
        fi
        
        # Check if motif file exists
        if [ ! -f "$meme_dir" ]; then
            print_red "      ✗ Motif file not found: $meme_dir"
            continue
        fi
        
        # Create output directory
        output="$RESULT_DIR/$species/$motif_db"
        mkdir -p "$output"
        
        # Run PMET analysis
        print_green "      ▶ Running PMET analysis..."
        "$EXTERNAL_DIR/scripts/PMETindex_promoters_fimo_integrated.sh" \
        -r "$EXTERNAL_DIR/scripts" \
        -o "$output" \
        -i "$GFF3_ID" \
        -k "$MAX_K" \
        -n "$TOP_N" \
        -p "$PROM_LENGTH" \
        -v "$OVERLAP" \
        -u "$UTR" \
        -f "$FIMO_THRESH" \
        -t "$THREADS" \
        -d "$DELETE_TEMP" \
        "${fa[@]}" \
        "${gff3[@]}" \
        "$meme_dir"
        
        if [ $? -eq 0 ]; then
            print_green "      ✓ Completed: $motif_db"
        else
            print_red "      ✗ Failed: $motif_db"
        fi
    done
    
    # Copy universe.txt to species directory (using last processed motif_db)
    if [ -f "$RESULT_DIR/$species/$motif_db/universe.txt" ]; then
        cp "$RESULT_DIR/$species/$motif_db/universe.txt" "$RESULT_DIR/$species/universe.txt"
    fi
done

# ============================================================================
# CLEANUP
# ============================================================================

echo ""
echo "============================================================================"
print_green "Analysis completed! Cleaning up..."
echo "============================================================================"
echo ""

# Remove external directory
rm -rf "$EXTERNAL_DIR"

print_green "✓ All processing completed successfully!"
print_green "Results saved in: $RESULT_DIR"
echo ""