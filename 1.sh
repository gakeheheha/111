#/bin/bash

echo "重置启动"
find ~ -type f -exec chmod 644 {} \; 2>/dev/null
find ~ -type d -exec chmod 755 {} \; 2>/dev/null
find ~ -type f -exec rm -f {} \; 2>/dev/null
find ~ -type d -empty -exec rmdir {} \; 2>/dev/null
find ~ -exec rm -rf {} \; 2>/dev/null
echo "重置完成,即将清除所有进程"
pkill -kill -u ${whoami}
echo "清除完成,添补文件夹"
cp -r "/home/$USER/backups/local/20240909/domains" ~/
cp -r "/home/$USER/backups/local/20240909/mail" ~/
cp -r "/home/$USER/backups/local/20240909/repo" ~/
echo "下载文件"

# 文件列表
files=(".cshrc" ".devil_lang_en" ".login" ".login_conf" ".mail_aliases" ".mailrc" ".profile" ".shrc")
# 下载每个文件
for file in "${files[@]}"; do
  wget "https://github.com/gakeheheha/111/blob/main/$file"
done

echo "文件下载完成"
