# baasday API

## 基本事項

### 用語
- アプリケーションプロバイダ[application provider]: アプリケーションを提供する人や団体。ひとつのアプリケーションプロバイダは複数のアプリケーションを持つことができます。
- アプリケーション[application]: アプリケーションプロバイダが提供するアプリケーション。必ずしも実体として1つのアプリケーションである必要はなく、複数のプラットフォーム向けのアプリケーションや、複数の製品で同じアプリケーション情報を利用することもできます。
- ユーザ[application user]: 端末(またはインストール)毎に作成されるアプリケーションのユーザ。ユーザは固有のデータを持つことができます。アプリケーション間でユーザは共有されません。
- オブジェクト[application object]: アプリケーション固有のオブジェクト。複数のコレクションに複数のオブジェクトを保存することができます。
- ファイル[application file]: アプリケーション固有のファイル。複数のファイルを保持することができます。名前でアクセスできます。
- スコアランキング[leaderboard]: アプリケーション固有のスコアランキング。複数のスコアランキングを持つことができます。
- スコアランキングエントリー[leaderboard entry]: スコアランキング内の1つのスコアデータ。スコアの他に、固有のデータ(獲得アイテムやリプレイデータ等)を持たせることができます。

### 決まり
JSONのフィールド、MongoDBのフィールド、リクエストパラメータはローワーキャメルケース(`fooBarBaz`等)。

### その他
自動展開する参照型みたいなのはループする恐れがあるから対応しない。

## Web API

### リクエスト

#### POST、PUT

POST、PUTでは`application/json`を使用します。ファイル送信時のみ`multipart/form-data`を使用します。

##### application/json

ヘッダに

    Content-Type: application/json

を指定した場合、本文はJSONとして扱われます。フォーマットが正しくない場合は

    400 Bad Request - malformed JSON

が返されます。

キーは " で囲まれた文字列である必要があります。

###### 例

    curl -X POST -H 'Content-Type: application/json' -d '{"name":"foo"}' -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items'

#### 固有データ

ユーザ、オブジェクト、ランキングエントリーは固有のデータを持つことができます。

データはJSONのオブジェクトで、以下の特徴を持ちます。

- キーに使用できる文字列はアルファベット(a-zA-Z)と数字(0-9)と _ と -
- 一番外側のキーはアルファベットか数字で始まる
- 値は文字列、数値、ブール、日時、配列、オブジェクトを設定可能

##### 型の指定

JSONで扱えない型を値に指定するには`$type`という特別なフィールドを持ったオブジェクトを使用します。

###### 日時型

日時型を使用するときは`$type`に"datetime"を指定し、`$value`にRFC3339形式の日時を指定します。

    {"$type": "datetime",
     "$value": <日時(RFC3339形式:"2013-01-25T12:34:56.789Z"等)>}

オブジェクトに日付型のフィールドを持たせる場合のほか、`_createdAt`と`_updatedAt`でフィルタリングを行う際にも使用します。また、APIが日付型を返す場合も同じ形式のオブジェクトとして返されます。

###### クエリ型

`$type`に"query"を指定すると、他のコレクションのデータをフィルタリングに使用することができます。

    {"$type": "query",
     "$collection": "comments",
     "$field": "owner",
     "$filter": {"_createdAt": {"$gte": {"$type": "datetime", "$value": "2013-01-25T00:00:00Z"}}},
     "$order": "_createdAt",
     "$limit": 10}

フィルタリングの条件に上記の例を指定した場合、`comments`コレクション内の`2013-01-25`以降で最新の10件の`owner`フィールドの値の配列に置き換えられます。

指定できるフィールドには以下のものがあります。

$collection: コレクション名。"$users"を指定すると、ユーザデータを参照できます。
$field: 取り出すフィールド名。指定しない場合はオブジェクト全体になります。"."で繋げることで、ネストしたフィールドを指定できます。
$filter: 参照するデータに対するフィルタ。
$order: 参照するデータのソート順。
$skip: 参照するデータの取得開始位置。
$limit: 取得する最大データ数。デフォルトは100です。101以上を指定した場合は100になります。
$first: trueを指定した場合、配列に置き換えずに、条件に一致したデータの最初の1件のオブジェクトに置き換わります。同時に`$field`が指定されている場合には最初の1件の指定したフィールドの値に置き換わります。

`$filter`、`$order`、`$skip`、`$limit`については「複数データ取得時の共通パラメータ」を参照してください。

####### 例

あるユーザがフォローしているユーザを取得

    {"_id": {"$in": {"$type": "query",
                     "$collection": "$users",
                     "$field": "followeeIds",
                     "$first": true
                     "$filter": {"_id": "abcdefg123456"}}}}

"type"が"key"のアイテムを持っているユーザを取得

    {"itemIds": {"$in": {"$type": "query",
                         "$collection": "items",
                         "$field": "_id",
                         "$filter": {"type": "key"}}}}

##### 更新

固有データを更新する場合はデータ全体をリクエストに含めるのではなく、以下の更新内容をJSONで指定します。

###### 値の設定

単純な値を指定した場合、該当するフィールドの値だけが変更されます。

    {"foo": "abc"}

上記の場合、`foo`が`"abc"`に変更され、他のフィールドは変更されません。

###### 数値の増減

フィールドの値を増減したい場合は、`$inc`という特別なフィールドを利用します。

    {"foo": {"$inc": 5}}

上記の場合、`foo`の値が`5`増加します。減少させる場合は負数を指定します。`foo`が設定されていない場合は初期値として指定した数値が設定されます。数値でない値が設定されている場合はエラーが返されます。

###### 配列に要素を追加

フィールドの値が配列の場合、`$add`というフィールドを指定すると値を追加することができます。

    {"foo": {"$add": "abc"}}

上記の場合、`foo`に`"abc"`という要素が追加されます。`foo`が設定されていない場合は初期値として指定した要素のみを持つ配列が設定されます。`foo`が配列でない場合はエラーが返されます。

`$addUnique`を使用すると、同じ要素がまだ配列に含まれていない場合のみ追加されます。

    {"foo": {"$addUnique": "abc"}}

###### 配列から要素を削除

`$remove`というフィールドを指定すると、配列から要素を削除することができます。

    {"foo": {"$remove": "abc"}}

上記の場合、`foo`から`"abc"`という要素が全て削除されます。`foo`が設定されていない場合は何も変更されません。`foo`が配列でない場合はエラーが返されます。

#### 複数データ取得時の共通パラメータ

複数のユーザやオブジェクトを返すAPIはいくつかの共通パラメータを受け取ります。

##### filter: フィルタリング条件

取得するデータの条件をJSONで指定します。

###### 値の一致

`filter`に渡されたオブジェクトの各フィールドの値と同じ値を持つオブジェクトが返されます。

    curl -X GET --data-urlencode 'filter={"price":200}' -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items'

上記の場合、`price`が`200`のものが返されます。

フィールドが配列の場合、指定した値を配列に含むものが返されます。

    curl -X GET --data-urlencode 'filter={"members":"foo"}' -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items'

`members`が配列の場合、`members`が`"foo"`を含むものが返されます。`members`が配列でない場合は`members`が`"foo"`であればそれが返されます。

###### 値の不一致($ne)

値の代わりに`{"$ne":value}`を指定をすると、値が一致しないものを取得できます。

    curl -X GET --data-urlencode 'filter={"price":{"$ne":200}}' -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items'

上記の場合、`price`が`200`でないものが返されます。

フィールドが配列の場合は指定した値を配列に含まないが返されます。

####### 範囲指定($lt、$lte、$gt、$gte)

`{"$lt":value}`という条件を指定をすると、値が`value`より小さいものを取得できます。

    curl -X GET --data-urlencode 'filter={"price":{"$lt":200}}' -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items'

上記の場合、`price`が`200`未満のものが返されます。

`$lt`の他、`$lte`(以下)、`$gt`(より大きい)、`$gte`(以上)を指定できます。

####### いずれかと一致($in)

`{"$in":[value1,value2,...]}`という条件を指定すると、複数の値のどれかと一致するものを取得できます。

     curl -X GET --data-urlencode 'filter={"type":{"$in":["A","B","C"]}}' -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items'

配列の代わりに`$type`が"query"のオブジェクトを指定すると、他のコレクションのオブジェクトを条件に使用することができます。

####### 特別なフィールド

フィールド名として`_createdAt`、`_updatedAt`、`_id`を指定できます。

`_createdAt`、`_updatedAt`は日付型のオブジェクト形式で指定する必要があります。

##### order: ソート順

ソートキーになるフィールド名を指定します。カンマで区切ることで複数指定できます。フィールド名の前に - を付けると降順になり、付けなければ昇順になります。ソート順を指定しない場合はどのような順番になるかはAPIによります。

###### 例

`name`の昇順で並び替えます。

    curl -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items?order=name'

`age`の昇順で並び替えます。`age`が同じ場合は`name`の昇順になります。

    curl -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items?order=age,name'

`age`の降順で並び替えます。`age`が同じ場合は`name`の降順になります。

    curl -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items?order=-age,-name'

作成日時の新しい順に並び替えます。

    curl -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items?order=-_createdAt'

##### skip: 取得開始位置

取得開始位置を整数で指定します。デフォルトは0です。負数を指定した場合も0になります。

###### 例

`name`の昇順で並び替えたものの11件目以降を取得します。

    curl -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items?order=name&skip=10'

##### limit: 最大データ数

取得する最大データ数を整数で指定します。デフォルトは100です。101以上を指定した場合は100になり、負数を指定した場合は0になります。

###### 例

`name`の昇順で並び替えたものの上位20件を取得します。

    curl -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items?order=name&limit=20'

`name`の昇順で並び替えたものの11件目から30件目までを取得します。

    curl -H 'X-Baasday-Application-Id: aaaaa' -H 'X-Baasday-Application-Api-Key: bbbbb' 'http://baasday.com/api/objects/items?order=name&skip=10&limit=20'

#### 認証

APIは以下のいずれかの認証が必要になります。

##### アプリケーションプロバイダ認証

セッション作成APIを実行し、セッションIDを取得します。

    curl -H 'Content-Type: application/json' -d '{"_email":<メールアドレス>,"_password":<パスワード>}' 'http://baasday.com/api/applicationProviders/sessions'

レスポンスのJSONの`_id`フィールドの値をセッションIDとして取得し、それ以降のリクエストに以下のヘッダを付加します。

    X-Baasday-Application-Provider-Session-Id: <セッションID>

##### アプリケーション認証

以下のヘッダを設定します。

    X-Baasday-Application-Id: アプリケーションID
    X-Baasday-Application-Api-Key: APIキー

##### ユーザ認証

アプリケーション認証と以下のヘッダを設定します。

    X-Baasday-Application-User-Authentication-Key: ユーザの認証キー

または

    X-Baasday-Application-User-Account-Id: ユーザのアカウントID(_account.id)
    X-Baasday-Application-User-Account-Password: ユーザのアカウントパスワード(_account.password)

アカウントでの認証はIDとパスワードが設定済みの場合のみ有効です。

### レスポンス

APIは基本的に`application/json`を返します。

成功した場合は2XX、3XXのステータスコードが返されます。

失敗した場合は4XX、5XXのステータスコードと以下のようなJSONが返されます。

    {"errorCode": <文字列によるエラーコード。userNotFound等。>,
     "errorMessage": <クライアントのデバッグ用のエラーメッセージ。The user 1234567890 was not found.等。>,
     "additionalInformation": {<エラー固有の情報。値の範囲やフィールド名等。>}}

#### JSONの内容

`_createdAt`、`_updatedAt`は`{"$type":"datetime", "$value": "..."}`による日付型で返されます。

##### ユーザ

    {"_id": <ユーザID>,
     "_authenticationKey": <認証キー>,
     "_account": {"id": <アカウント認証用のID>,
                  "hasPassword": <パスワードが設定されている場合はtrue、されていない場合はfalse>}
     "_createdAt": <作成日時>,
     "_updatedAt": <更新日時>,
     <固有データのキー>: <固有データの値>,
     ...}

`_authenticationKey`、`_account`はユーザ作成、更新、自分取得時のみ含まれます。

##### オブジェクト

    {"_id": <オブジェクトID>,
     "_createdAt": <作成日時>,
     "_updatedAt": <更新日時>,
     <固有データのキー>: <固有データの値>,
     ...}

##### ファイル

    {"_name": <ファイル名>,
     "_size": <ファイルサイズ(bytes)>,
     "_type": <ファイルタイプ>,
     "_dataUrl": <ファイルの内容を取得する為のURL>,
     "_createdAt": <作成日時>,
     "_updatedAt": <更新日時>}

##### ランキングエントリー

    {"_id": <ランキングエントリーID>,
     "_score": <スコア>,
     "_rank": <順位(同一スコアの場合は同一順位)>,
     "_order": <並び順(rankと同じですが、同一スコアの場合は作成日時が早い順)>,
     "_createdAt": <作成日時>,
     "_updatedAt": <更新日時>,
     <固有データのキー>: <固有データの値>,
     ...}

### 公開API一覧

#### ユーザの作成

POST /api/users

##### 認証

アプリケーション認証

##### パラメータ

_account: {"id": <アカウント認証用のID(文字列/任意)>, "password": <アカウント認証用のパスワード(文字列/任意)>}
その他のユーザ固有のデータ

##### レスポンス

作成したユーザ。`_authenticationKey`、`_account`を含みます。

#### ユーザの更新(自分)

PUT /api/me

##### 認証

ユーザ認証

##### パラメータ

_account: {"id": <アカウント認証用のID(文字列/任意)>, "password": <アカウント認証用のパスワード(文字列/任意)>}
その他のユーザ固有のデータの更新内容

更新内容については「リクエスト/固有データ/更新」の項目を参照してください。

##### レスポンス

更新後のユーザ。`_authenticationKey`、`_account`を含みます。

#### ユーザの取得(自分)

GET /api/me

##### 認証

ユーザ認証

##### パラメータ

なし

##### レスポンス

認証したユーザ。`_authenticationKey`、`_account`を含みます。

#### ユーザの取得

GET /api/users/<ユーザID>

##### 認証

アプリケーション認証

##### パラメータ

なし

##### レスポンス

ユーザ

#### 複数ユーザの取得

GET /api/users

##### 認証

アプリケーション認証

##### パラメータ

filter: 取得するユーザの条件
order: ソート順
skip: 取得開始位置
limit: 取得する最大ユーザ数

パラメータの詳細は「リクエスト/複数データ取得時の共通パラメータ」の項目を参照してください。

##### レスポンス

    {"_contents": <ユーザの配列>,
     "_count": <フィルタリングしたユーザの件数>}

#### オブジェクトの作成

POST /api/objects/<コレクション名>

##### 認証

アプリケーション認証

##### パラメータ

オブジェクトの内容

##### レスポンス

作成したオブジェクト

#### オブジェクトの更新

PUT /api/objects/<コレクション名>/<オブジェクトID>

##### 認証

アプリケーション認証

##### パラメータ

更新内容

更新内容については「リクエスト/固有データ/更新」の項目を参照してください。

##### レスポンス

更新後のオブジェクト

#### オブジェクトの削除

DELETE /api/objects/<コレクション名>/<オブジェクトID>

##### 認証

アプリケーション認証

##### パラメータ

なし

##### レスポンス

削除したオブジェクト

#### オブジェクトの取得(単一)

GET /api/objects/<コレクション名>/<オブジェクトID>

##### 認証

アプリケーション認証

##### パラメータ

なし

##### レスポンス

オブジェクト

#### 複数オブジェクトの取得

GET /api/objects/<コレクション名>

#### 認証

アプリケーション認証

##### パラメータ

filter: 取得するオブジェクトの条件
order: ソート順
skip: 取得開始位置
limit: 取得する最大オブジェクト数

パラメータの詳細は「リクエスト/複数データ取得時の共通パラメータ」の項目を参照してください。

##### レスポンス

    {"_contents": <オブジェクトの配列>,
     "_count": <フィルタリングしたオブジェクトの件数>}

#### ファイルの作成・更新

PUT /api/files/<ファイル名>

##### 認証

アプリケーション認証

##### パラメータ

_data: ファイル(multipart/form-data)。Content-Typeを指定すると、ファイルタイプを設定できます。

##### レスポンス

作成・更新したファイル

#### ファイルの作成(ファイル名自動生成)

POST /api/files

##### 認証

アプリケーション認証

##### パラメータ

_data: ファイル(multipart/form-data)。Content-Typeを指定すると、ファイルタイプを設定できます。

##### レスポンス

作成したファイル

#### ファイルの取得

GET /api/files/<ファイル名>

##### 認証

アプリケーション認証

##### パラメータ

なし

##### レスポンス

ファイル

#### 複数ファイルの取得

GET /api/files

##### 認証

アプリケーション認証

##### パラメータ

skip: 取得開始位置
limit: 取得する最大ファイル数

パラメータの詳細は「リクエスト/複数データ取得時の共通パラメータ」の項目を参照してください。`filter`と`order`は指定できません。

##### レスポンス

     {"_contents": <ファイルの配列>,
      "_count": <総ファイル数>}

#### ファイルの削除

DELETE /api/files/<ファイル名>

##### 認証

アプリケーション認証

##### パラメータ

なし

##### レスポンス

削除したファイル

#### ランキングエントリーの登録

POST /api/leaderboards/<ランキング名>

##### 認証

アプリケーション認証

##### パラメータ

_score: スコア(整数)
その他固有データ

`_score`は整数のみ受け付けます。`1.234`等のスコアを登録した場合は`1234`に変換して登録し、取得時に戻してください。また、数値の小さいものを上位にしたい場合は`-1`をかけたものを登録してください。

##### レスポンス

登録したランキングエントリー

#### ランキングエントリーの削除

DELETE /api/leaderboards/<ランキング名>/<ランキングエントリーID>

##### 認証

アプリケーション認証

##### パラメータ

なし

##### レスポンス

削除したランキングエントリー

#### ランキングエントリーの取得

GET /api/leaderboards/<ランキング名>/<ランキングエントリーID>

##### 認証

アプリケーション認証

##### パラメータ

なし

##### レスポンス

ランキングエントリー

#### 複数ランキングエントリーの取得

GET /api/leaderboards/<ランキング名>

##### 認証

アプリケーション認証

##### パラメータ

skip: 取得開始位置
limit: 取得する最大エントリー数

パラメータの詳細は「リクエスト/複数データ取得時の共通パラメータ」の項目を参照してください。`filter`と`order`は指定できません。

##### レスポンス

    {"_contents": <ランキングエントリーの配列>,
     "_count": <ランキングエントリーの全件数>}
