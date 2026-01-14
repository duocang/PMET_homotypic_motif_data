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

find ../01_PMETDEV-code/debug/scripts -type f \( -name "*.sh" -o -name "*.pl" \) -exec chmod a+x {} \;

# find data/genome_n_annotation -mindepth 1 -maxdepth 1 -type d | sort | while read dir
# do
#     species=$(basename "$dir")
#     echo $dir
# done

# 1. loop all species
species="Medicago_truncatula"
dir="data/genome_n_annotation/Medicago_truncatula"

# 初始化变量
gff3=()
fa=()
# 遍历目录中的所有文件
for file in "$dir"/*; do
    if [[ $file == *.gff3 ]]; then
        gff3+=("$file")
    elif [[ $file == *.fa ]] || [[ $file == *.fasta ]]; then
        fa+=("$file")
    fi
done

# 2. loop all motif databases
for motif_db in "plantTFDB"; do
    if [[ $motif_db == "CIS-BP2" ]]; then
        if [ -d "data/motif_databases/CIS-BP2/$species" ]; then
            meme_dir=data/motif_databases/CIS-BP2/$species/TF_binding_motifs.meme
        else
            meme_dir="no_value"
        fi
    elif [[ $motif_db == "plantTFDB" ]]; then
        if [ -d "data/motif_databases/plantTFDB/$species" ]; then
            meme_dir=data/motif_databases/plantTFDB/$species/TF_binding_motifs.meme
        else
            meme_dir="no_value"
        fi
    elif [[ $motif_db == "Franco-Zorrilla_et_al_2014" ]]; then
        meme_dir=data/motif_databases/Franco-Zorrilla_et_al_2014.meme
    elif [[ $motif_db == "Jaspar_plants_non_redundant_2022" ]]; then
        meme_dir=data/motif_databases/JASPAR2022_CORE_plants_non-redundant_pfms_meme.meme
    elif [[ $motif_db == "Plant_Cistrome_DB" ]]; then
        meme_dir=data/motif_databases/Plant_Cistrome_DB_parsed.meme
    # motif name is longer, dut to family name
    elif [[ $motif_db == "Plant_Cistrome_DB_with_family_info" ]]; then
        meme_dir=data/motif_databases/Plant_Cistrome_DB.meme
    else
        echo "Unknown motif_db: $motif_db"
    fi

    ################################ Running homotypic ###################################
    if [ "$meme_dir" != "no_value" ]; then
        # print_green "$gff3  $fa"
        # print_red "$species $meme_dir"
        # echo ""
        output=homotypic_out/$species/$motif_db
        mkdir -p $output
        promlength=1000
        maxk=5
        topn=5000
        fimothresh=0.05
        overlap="NoOverlap"
        utr=no
        gff3id="gene_id="
        delete_temp=yes

        threads=16

        # if $species in "Hordeum_vulgare_R1" "Oryza_sativa_japonica_Nipponbare" "Oryza_sativa_japonica_Ensembl" "Oryza_sativa_indica_ZS97" "Oryza_sativa_japonica_V7.1" "Oryza_sativa_indica_MH63" "Oryza_sativa_indica_IR8" "Oryza_sativa_japonica_Kitaake" "Vicia_faba"
        # fi

        ../01_PMETDEV-code/debug/scripts/PMETindex_promoters_fimo_integrated.sh \
            -r ../01_PMETDEV-code/debug/scripts \
            -o $output      \
            -i $gff3id      \
            -k $maxk        \
            -n $topn        \
            -p $promlength  \
            -v $overlap     \
            -u $utr         \
            -f $fimothresh  \
            -t $threads     \
            -d $delete_temp \
            $fa             \
            $gff3           \
            $meme_dir
    fi
done

cp homotypic_out/$species/$motif_db/universe.txt homotypic_out/$species/universe.txt
