#!/usr/bin/env bash

# Group Project Chmod Script File for Computer Science Summer Camp 2022 
#
# CSSC用のグループ開発の権限変更用シェルスクリプトです。
# Created by KASUYA Shunsuke (s1300071@u-aizu.ac.jp)

timeout_nomal=5
timeout_long=15
# 秘密鍵のパスワードを指定
PASSWORD=SECRET_KEY_PASSWORD

while true
do
  cat user_list.txt | while read username
  do
  expect -c "
      set timeout ${timeout_nomal}
      spawn ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no ${username}@sshgate.u-aizu.ac.jp chmod -Rf 775 ./TeamProject/*
      expect -re \"Enter passphrase for key .*:\"
      send \"${PASSWORD}\n\"
      expect \"$\"
      exit 0
    "
  sleep 1
  done 
  sleep 5
done
