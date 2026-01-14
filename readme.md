# Homotypic Motifs from Multiple Databases in Promoters of 21 Plant Species

## Project Overview

This project performs comprehensive analysis of **homotypic transcription factor binding motifs (TFBMs)** in promoter regions across 21 plant species. We employ the [PMET (Promoter Motif Enrichment Tool)](https://github.com/duocang/PMET_analysis_pipeline) analysis pipeline combined with FIMO to identify and index motif occurrences, utilizing 6 distinct motif databases:

- **CIS-BP2** (species-specific)
- **PlantTFDB** (species-specific)
- **Franco-Zorrilla et al. 2014**
- **JASPAR 2022 - CORE plants non-redundant**
- **Plant Cistrome DB**
- **Plant Cistrome DB with family information**

## Project Objective

Our research aims to unravel the molecular mechanisms underlying plant gene expression regulation by analyzing:

- Promoter patterns that consistently appear across different species
- Homotypic motif clustering in upstream regulatory regions
- Species-specific and conserved regulatory elements

The pre-calculated datasets provide a foundation for understanding fundamental regulatory roles that these promoter patterns play in plant development and physiology.

## Project Structure

```
.
├── data/
│   ├── species.json                    # Metadata for all analyzed species
│   ├── genome_n_annotation/            # Genome sequences and GFF3 annotations
│   │   ├── Arabidopsis_thaliana/
│   │   ├── Oryza_sativa_*/ (multiple subspecies/varieties)
│   │   ├── Triticum_aestivum/
│   │   └── ... (21 species total)
│   └── motif_databases/                # Motif database files
│       ├── CIS-BP2/
│       ├── plantTFDB/
│       ├── Plant_Cistrome_DB.meme
│       ├── JASPAR2022_CORE_plants_non-redundant_pfms_meme.meme
│       └── Franco-Zorrilla_et_al_2014.meme
├── homotypic_out/                      # PMET analysis results
│   └── [species]/
│       ├── CIS-BP2/
│       ├── plantTFDB/
│       ├── Franco-Zorrilla_et_al_2014/
│       ├── Jaspar_plants_non_redundant_2022/
│       ├── Plant_Cistrome_DB/
│       ├── Plant_Cistrome_DB_with_family_info/
│       └── universe.txt                # Gene universe file
├── scripts/                            # Processing and analysis scripts
│   ├── 01_download_genome_from_esmbl.sh
│   ├── 02_download_genome_manually.sh
│   ├── 03_process_gff3.sh
│   ├── 04_clean_plant_cistromoe_db.sh
│   ├── 05_pmet.sh
│   └── *.py, *.R                       # Supporting scripts
└── README.md                           # This file
```

## Running the Analysis Pipeline

### Prerequisites

- Bash shell
- Python 3
- R environment
- FIMO and PMET tools (automatically installed by scripts)
- 16+ CPU cores recommended (configurable in scripts)

### Step-by-Step Execution

1. **Download genome and annotation files**

   ```bash
   bash 01_download_genome_from_esmbl.sh    # Automated downloads
   bash 02_download_genome_manually.sh      # Check manual downloads needed
   ```

2. **Process GFF3 annotations** (remove version suffixes)

   ```bash
   bash 03_process_gff3.sh
   ```

3. **Clean motif database names** (Plant Cistrome DB)

   ```bash
   bash 04_clean_plant_cistromoe_db.sh
   ```

4. **Run PMET analysis** (main analysis - longest step)
   ```bash
   bash 05_pmet.sh
   ```

All scripts include:

- Automatic file validation
- Colored status messages (✓ success, ✗ error)
- User confirmation prompts
- Configurable parameters

## Output Data

The analysis generates comprehensive results in `homotypic_out/`:

- **Per-species, per-database folders** containing PMET index results
- **universe.txt** - Complete gene list for each species
- **Motif occurrence data** - Ready for downstream analysis and visualization

## Integration with PMET-Shiny App

All output data are formatted for direct integration with the [PMET-Shiny App](https://github.com/duocang/PMET-Shiny-App):

1. Extract output files from `homotypic_out/`
2. Place in PMET-Shiny's `data/indexing/` folder
3. Launch the Shiny app for interactive exploration

## Authors

- **Xuesong Wang** - Project creator and lead researcher

## Citation

If you use this dataset in your research, please cite this project and the underlying tools:

- PMET: [github.com/duocang/PMET_analysis_pipeline](https://github.com/duocang/PMET_analysis_pipeline)
- FIMO: Grant et al. (2011) - Bioinformatics

## License

[Specify license - e.g., MIT, GPL, CC-BY]

## Support

For issues, questions, or contributions, please refer to the PMET pipeline documentation or contact the project maintainers.
