#!/usr/bin/env bash

# Group Project Backup Script File for Computer Science Summer Camp 2022  
#
# CSSC用のグループ開発時バックアップ用シェルスクリプトです。
# Created by KASUYA Shunsuke (s1300071@u-aizu.ac.jp)

while true
do
  DATE=$(date '+%d_%R')
  mkdir ~/GraduationProjects/snapshot/${DATE}
  cat group_snapshot_list.txt | while read groupname
do
      cd  ~/GraduationProjects/snapshot/${DATE}/
      # tar.gzで圧縮してバックアップ
      tar -czvf ${groupname}.tar.gz ../../${groupname}/
done
# 300秒(5分)待機
sleep 300
done
