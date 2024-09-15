#!/bin/bash

# 设置要保留的文件夹和文件
KEEP_DIRS=( ".pydio" "backups" "domains" "mail" "repo" )
KEEP_FILES=( ".cshrc" ".devil_lang_en" ".login" ".login_conf" ".mail_aliases" ".mailrc" ".profile" ".shrc" )

# 将保留的文件夹转换为正则表达式
KEEP_DIRS_REGEX=$(printf "^(%s)$\n" "${KEEP_DIRS[@]}" | paste -sd '|' -)
# 将保留的文件转换为正则表达式
KEEP_FILES_REGEX=$(printf "^(%s)$\n" "${KEEP_FILES[@]}" | paste -sd '|' -)

# 删除所有不在保留列表中的文件夹和文件
find . -type d ! -regex ".*/$KEEP_DIRS_REGEX" -exec rm -rf {} +
find . -type f ! -regex ".*/$KEEP_FILES_REGEX" -exec rm -f {} +

echo "删除完成，保留指定的文件和文件夹。"
