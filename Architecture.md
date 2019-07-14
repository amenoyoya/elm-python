# The Elm Architecture

## What's The Elm Architecture

- The Elm Architecture は、Webアプリケーションを構築するためのシンプルなパターン
- モジュール性やコードの再利用性、テストのしやすさなどに優れる
- ReduxなどのUIフレームワークの源流

### 基本的なパターン
すべてのElmプログラムは次の３つの要素に明確に分割することができる

- **Model**: アプリケーションの状態
- **Update**: 状態を更新する方法
- **View**: HTMLとして状態を閲覧する方法

このパターンに従って、以下のような骨組みからプロジェクトを開始するのが The Elm Architecture の本質となる

```elm
import Html exposing (..)

-- MODEL
type alias Model = { ... }

-- UPDATE
type Msg = Reset | ...

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> ...
    ...

-- VIEW
view : Model -> Html Msg
view model =
  ...
```

***

## The Elm Architecture サンプルアプリケーション構築

### ボタン
まず、インクリメントやデクリメントを行うシンプルなカウンタを作成する

仕様は以下の通り

- モデル（アプリケーションの状態）:
    - このアプリケーションにおいて状態と呼べるものはカウンタ（Int型）のみ
    - 初期状態においてモデル（カウンタ）は`0`とする
- イベント:
    - インクリメント: モデル（カウンタ）を +1 する
    - デクリメント: モデル（カウンタ）を -1 する
- 画面表示:
    - インクリメントボタン:
        - ラベル: `+`
        - クリック時にインクリメントイベントを起こす
    - デクリメントボタン:
        - ラベル: `-`
        - クリック時にデクリメントイベントを起こす
    - モデル表示部:
        - モデル（カウンタ）の現在値を表示する

上記仕様に沿って Architecture を組み立てると [src/01.button.elm](./src/01.button.elm) のようなコードになる

#### Run
```bash
# Elm開発サーバー起動
$ yarn elm reactor

## => http://localhost:8000 でサーバー起動
## => http://localhost:8000/src/01.button.elm にアクセスし、上記アプリケーションの動作確認を行う
```

---

### テキスト入力
inputボックスに入力された文字列を逆さまにするアプリケーションを構築する

仕様は以下の通り

- モデル:
    - 状態として保持するのは inputボックスに入力された文字列（String）
    - 単純にModelの型をStringにしても良いが、今回は**String型のcontentフィールドを持つレコード**をModelとする
    - 初期状態においてモデルの`content`フィールドは空文字`""`とする
- イベント:
    - `Change<String>`イベント: inputボックスに文字列が入力されたときに発生する
- 画面表示:
    - inputボックス:
        - value: モデルの`content`フィールドとリンクさせる
        - onInputイベント時: `Change<String>`イベントを起こす
    - 逆さま文字列表示部:
        - モデルの`content`フィールドを `String.reverse` したものを表示

上記仕様に沿って Architecture を組み立てると [src/02.text.elm](./src/02.text.elm) のようなコードになる

Elm開発サーバーを起動し http://localhost:8000/src/02.text.elm で動作確認する

---

### フォーム
フォームに入力された文字列の入力値チェックを行う

仕様は以下の通り

- モデル:
    - 以下の3つのフィールドを持つレコードとする
        - String型`name`フィールド: 名前入力用inputボックスのvalueとリンク
        - String型`password`フィールド: パスワード入力用inputボックスのvalueとリンク
        - String型`passwordAgain`フィールド: 確認用パスワード入力用inputボックスのvalueとリンク
    - 初期状態においてモデルの各フィールドは空文字`""`とする
- イベント:
    - `Name<String>`イベント: 名前入力用inputボックスに文字列が入力されたときに発生する
    - `Password<String>`イベント: パスワード入力用inputボックスに文字列が入力されたときに発生する
    - `PasswordAgain<String>`イベント: 確認用パスワード入力用inputボックスに文字列が入力されたときに発生する
- 画面表示:
    - inputボックス:
        - 以下の仕様を属性を持つコンポーネントを作成し、Name、Password、PasswordAgain用のinputボックスを作成
            - type: パスワード入力用なら "password", それ以外なら "text" を選ぶ
            - value: モデルの各フィールドとリンクさせる
            - onInputイベント時: 対応するイベントを起こす
    - バリデーション結果表示部:
        - モデルの`password`フィールドと`passwordAgain`フィールドの値を比較する
            - 同値なら: 緑文字で "OK" と表示
            - 違うなら: 赤文字で "Passwords do not match!" と表示

上記仕様に沿って Architecture を組み立てると [src/03.form.elm](./src/03.form.elm) のようなコードになる

Elm開発サーバーを起動し http://localhost:8000/src/03.form.elm で動作確認する
