# SSM auth test

## Synopsis

AWSCLIを自端末から実行するとき、アクセスキーの発行を回避する方法の実証実験です。
セキュリティ的に何も担保されていないので、実運用では使用しないでください。

## Usage

下記のドキュメントに従ってロールとアクティベーションコードのセットアップを行う。(STEP2まで実行)

- [ハイブリッド環境の設定](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/systems-manager-managedinstances.html)

```bash
# 事前に"System Manager > ハイブリッドアクティベーション"でアクティベーションコードを生成する
# アクティベーションコードを.envファイルに記入しておく
$ cat > .env
SSM_ACTIVATION_CODE=....
SSM_ACTIVATION_ID=....

# docker composeを起動する
$ docker compose up -d

# 正しくロールが設定されていることを確認
$ docker compose exec con aws sts get-caller-identity

# ロールの権限が行使できるか確認(例)
$ docker compose exec con aws s3 ls

# aliasを切ればawsコマンドと同様に使用可能
# alias aws="docker compose exec con aws"
# aws s3 ls
```

## Details

アクセスキーと比べたときのメリット/デメリットについて(コメント求む)

- アクティベーション期限を設けられる
  - アクティベーションコードが流失しても、期限が過ぎていれば問題にならない
- Volumeに格納しているSSMの認証データが流出したときに問題にならないか？
  - 安全性に関するドキュメントが確認できなかった
  - 多分、違うPCに移し替えてそのまま実行できない仕組みになっていると思われるが、未検証
- IAM Identity Reportに載らない
  - アカウント侵害が起きたとき真っ先に確認するサービスなので、これから漏れてしまうのは危険
- MFAを要求できない
  - アクセスキーの場合はGetSessionTokenなどでMFAを要求する方式があるが、この方式ではそれができない

結論 → * `"Effect":"deny","Action": ["ssm:generateActivation"]` を設定しておいたほうが良さげ.*
