import json
import os
import requests
import gzip
import shutil

# 读取JSON数据
with open('data/species.json', 'r') as file:
    data = json.load(file)

# 创建目录
os.makedirs('data/genome_n_annotation', exist_ok=True)

def download_and_extract(url, path):
    """下载并解压缩文件"""
    print("Downloading ", url)
    # 从URL下载文件
    r = requests.get(url, stream=True)
    if r.status_code == 200:
        with open(path, 'wb') as f:
            f.write(r.content)

        # 如果文件是gzip压缩的，则解压缩
        if path.endswith('.gz'):
            with gzip.open(path, 'rb') as f_in:
                with open(path[:-3], 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)
            os.remove(path)  # 删除压缩文件

# 存储未压缩的物种名称
non_gz_species = []

for item, details in data.items():
    # 下载并解压缩genome和annotation文件
    genome_link = details['genome_link']
    annotation_link = details['annotation_link']
    if genome_link.endswith('.gz'):
        # 为每个项目创建目录
        item_dir = os.path.join('data/genome_n_annotation', item)
        os.makedirs(item_dir, exist_ok=True)

        download_and_extract(genome_link, os.path.join(item_dir, details['genome_name'] + ".gz"))
        download_and_extract(annotation_link, os.path.join(item_dir, details['annotation_name'] + ".gz"))
    else:
        non_gz_species.append(item)

# 打印所有未压缩的物种名称
print("No download：", non_gz_species)

print("Done！")
