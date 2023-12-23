# SSM auth test

## Synopsis

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
