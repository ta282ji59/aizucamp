#!/usr/bin/env bash

# Group Setting File for Computer Science Summer Camp 2022 
#
# CSSC用のグループ開発用シェルスクリプトです。
# Created by KASUYA Shunsuke (s1300071@u-aizu.ac.jp)

timeout_nomal=5
timeout_long=15
PASSWORD=cssc
groupNo=1

rm group_setting.result
echo -e "Group:${groupNo}" >> group_setting.result

cat group_list.txt | while read username
do
 echo ${groupNo}
 # 読み込んだ行が空行だったら、次のグループへ
 if [ -z "$username" ]; then
 	$((groupNo++))
	echo -e "\nGroup:${groupNo}" >> group_setting.result
 	continue
 fi
 expect -c "
    set timeout $timeout_nomal
    spawn ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no ${username}@sshgate.u-aizu.ac.jp
    expect -re \"Enter passphrase for key .*:\"
    send \"${PASSWORD}\n\"
    expect \"$\"
    # 参加者のTeamProjectとマスタアカウントのグループのディレクトリをシンボリックリンク
    send  \"ln -s /home/seminar/g2java/g2java00/GraduationProjects/Group0${groupNo} ~/TeamProject\n\"
    expect \"$\"
    send \"exit\"
    exit 0
  "
 echo -e "${username}" >> group_setting.result 
done 

