## 使い方

```
$ mdir app_name && $_
$ git clone git@github.com:tko-t/vue_base.git .
$ rm -rf .git*
$ vi .env
=> 自分の環境に合わせて編集。特にUSERとGROUPとAPP_PORTk

$ docker-compose build
$ docker-compose run app vue init webpack .
$ git init
$ docker-compose up
```

or

```
$ mkdir {{APP_NAME}} && $_
$ git clone git@github.com:tko-t/vue_base.git .
$ make
$ make clean

"ユーザー名とアプリケーション名を実行環境から拾って作ります。
```

### build and hosting

#### to firebase

```
$ make yarn_build
$ firebase login
=> 予めプロジェクトとかは作っとく
$ firebase init hosting
=> distを指定
$ firebase deploy --only hosting
=> 公開
$ firebase hosting:disable
=> 終わったら消す
```
