#!/usr/bin/env bash

# Backup Script for Computer Science Summer Camp 2022
# 
# CSSCバックアップ用スクリプト. 777なパーミッションの検証用アカウントのbackupディレクトリに、tar.gzで保存される。
# この後、css-campグループが付与されているアカウントから/home/project/20XX/students/g2java/にcpすること。
# Created by KASUYA Shunsuke (s1300071@u-aizu.ac.jp)

timeout_long=10
timeout_tar=30
timeout_nomal=5

PASSWORD=cssc

cat user_list.txt | while read username
do
 expect -c "
    set timeout ${timeout_long}
    spawn ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no ${username}@sshgate.u-aizu.ac.jp
    expect -re \"Enter passphrase for key .*:\"
    send \"${PASSWORD}\n\"
    expect \"$\"
    set timeout ${timeout_tar}
    send \"tar -cvzf /home/seminar/g1cssc/g1cssc3/backup/${username}.tar.gz ../${username}/\n\"
    expect \"$\"
    set timeout ${timeout_nomal}
    send \"chmod 777 /home/seminar/g1cssc/g1cssc3/backup/${username}.tar.gz\n\"
    expect \"$\"
    send \"exit\"
    exit 0
  "
done 

