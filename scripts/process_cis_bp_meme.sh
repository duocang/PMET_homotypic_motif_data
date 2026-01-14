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


for dir in $(find data/motif_databases/CIS-BP2 -mindepth 1 -maxdepth 1 -type d)
do

    # 使用 find 命令查找指定的目录，并使用 grep 检查是否包含 'cis' 或 'CIS'
    matching_dirs=$(find "$dir/" -type d -iname "*cis*" | grep -i "cis")

    echo $matching_dirs

    # 指定输入目录和输出文件
    # Specify the input directory and output file
    input_dir="$matching_dirs/pwms_all_motifs/"
    output_file="$dir/TF_binding_motifs.meme"

    print_green "meme file: $input_dir"

    # 创建输出文件并写入MEME文件的头部信息
    # Create the output file and write the header information of the MEME file
    echo "MEME version 4.4" > $output_file
    echo "" >> $output_file
    echo "ALPHABET= ACGT" >> $output_file
    echo "" >> $output_file
    echo "strands: + -" >> $output_file
    echo "" >> $output_file

    # 初始化计数器
    # Initialize counters
    empty_count=0
    wrong_value_count=0
    valid_count=0

    # 处理输入目录中的每个文件
    # Process each file in the input directory
    for input_file in $input_dir/*.txt
    do
        # 获取不带扩展名的文件名作为motif名称
        # Get the filename without extension as the motif name
        motif_name=$(basename $input_file .txt)

        # 计算文件的行数（减1是因为第一行是标题行）
        # Calculate the number of lines in the file (subtract 1 because the first line is the title line)
        motif_length=$(($(wc -l < $input_file) - 1))

        if (( $motif_length > 0 )); then
            # 如果motif的长度大于0，那么检查文件中的所有数字是否都在0和1之间
            # If the length of the motif is greater than 0, then check whether all numbers in the file are between 0 and 1
            if awk 'NR>1 {for (i=2; i<=NF; i++) if ($i<0 || $i>1) exit 1}' $input_file; then
                # 如果所有数字都在0和1之间，那么写入motif的信息到MEME文件
                # If all numbers are between 0 and 1, then write the information of the motif to the MEME file

                # 写入motif的头部信息
                # Write the header information of the motif
                echo "MOTIF $motif_name $motif_name" >> $output_file
                echo "letter-probability matrix: alength= 4 w= $motif_length nsites= 20 E= 0" >> $output_file

                # 从输入文件中读取位点矩阵并添加到输出文件
                # Read the position matrix from the input file and add it to the output file
                tail -n +2 $input_file | awk '{print $2, $3, $4, $5}' >> $output_file
                echo "" >> $output_file

                # 增加合格文件计数
                # Increase the count of valid files
                ((valid_count++))
            else
                # 如果有数字不在0和1之间，那么将文件名添加到"wrong_value_motif.txt"，并增加错误值计数器
                # If there are numbers not between 0 and 1, then add the filename to "wrong_value_motif.txt" and increase the wrong value counter
                echo "$motif_name has wrong value"
                echo $motif_name >> "$dir/wrong_value_motif.txt"
                ((wrong_value_count++))
            fi
        else
            # 如果motif的长度为0，那么将文件名添加到"empty_pwm_motif.txt"，并增加空文件计数器
            # If the length of the motif is 0, then add the filename to "empty_pwm_motif.txt" and increase the empty file counter
            # echo "$motif_name is empty"
            echo $motif_name >> "$dir/empty_pwm_motif.txt"
            ((empty_count++))
        fi
    done

    # 在console打印空文件和值错误的文件数量
    # Print the number of empty files and wrong value files on the console
    echo "Number of empty files: $empty_count"
    echo "Number of files with wrong values: $wrong_value_count"
    echo "Valid files: $valid_count"
done








