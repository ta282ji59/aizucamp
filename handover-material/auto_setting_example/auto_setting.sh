#!/usr/bin/env bash

# Auto Setting File for Computer Science Summer Camp 2022 
#
# CSSC用の自動設定シェルスクリプトです。このシェルスクリプト単体では動作しません。
# Created by KASUYA Shunsuke (s1300071@u-aizu.ac.jp)



timeout_nomal=5
timeout_long=15
# 秘密鍵のパスワードを指定
PASSWORD=SECRET_KEY_PASSWORD

cat user_list.txt | while read username
do
 expect -c "
    set timeout ${timeout_long}
    # SCPでサンプルをコピー
    spawn scp -i ~/.ssh/id_ed25519 -r -o StrictHostKeyChecking=no -C ./Sample ${username}@sshgate.u-aizu.ac.jp:~/
    expect -re \"Enter passphrase for key .*:\"
    send \"${PASSWORD}\n\"
    # SCPでVSCodeのsetings.jsonをコピー
    spawn scp -i ~/.ssh/id_ed25519 -r -o StrictHostKeyChecking=no -C ./VSCode/settings.json ${username}@sshgate.u-aizu.ac.jp:~/.config/Code/User/settings.json
    expect -re \"Enter passphrase for key .*:\"
    send \"${PASSWORD}\n\"
    # SCPでNode.js v16.16.0をコピー
    spawn scp -i ~/.ssh/id_ed25519 -r -o StrictHostKeyChecking=no -C ./node_v16.16.0 ${username}@sshgate.u-aizu.ac.jp:~/
    expect -re \"Enter passphrase for key .*:\"
    send \"${PASSWORD}\n\"
    # 公開鍵認証方式でSSH
    spawn ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no ${username}@sshgate.u-aizu.ac.jp
    expect -re \"Enter passphrase for key .*:\"
    send \"${PASSWORD}\n\"
    expect \"$\"
    # Node v16を使用するようにalias
    send \"echo alias node='~/node_v16.16.0/bin/node' >> ~/.bashrc\n\"
    expect \"$\"
    # 一旦、VSCodeを実行させないと、~/.vscodeディレクトリが作成されないらしい
    send \"code &\n\"
    expect \"$\"
    # エスケープが気持ち悪いが、VSCodeの日本語化設定
    send \"sed -i \\\"$ i ,\\\\\\\"locale\\\\\\\": \\\\\\\"ja\\\\\\\"\\\" ~/.vscode/argv.json\n\"
    expect \"$\"
    set timeout ${timeout_long}
    # VSCodeの拡張機能を追加
    send \"code --install-extension 'MS-CEINTL.vscode-language-pack-ja' --install-extension 'ritwickdey.LiveServer'\n\"
    expect \"$\"
    set timeout ${timeout_nomal}
    send \"cd ~/\n\"
    expect \"$\"
    send \"mkdir Project\n\"
    expect \"$\"
    send \"exit\"
    exit 0
  "
done 

