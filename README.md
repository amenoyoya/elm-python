# Elm入門 + Pythonで関数型プログラミング

## What's Elm?

- Elm は JavaScript にコンパイルできる関数型プログラミング言語
- Redux(FluxベースのReactJS用UIフレームワーク)の元になった言語
- Elm はシンプルであること、簡単に使えること、高品質であることを大切にする
- 根底にある考え方や方針に納得できる一部の人たちが最高に満足できるものを目指す
- Elm は汎用言語ではなく、The Elm Architecture というフレームワークの DSL (ドメイン固有言語) の一種と考えられる
    - 徹底して「高品質なWebアプリケーションをつくりやすくする」という目的を達成することを起点にして設計されている

### Reference
- [Elm公式ガイド](https://guide.elm-lang.jp/)
- [Elmはどんな人にオススメできないか](https://qiita.com/arowM/items/dfb38d1c5f3dfde8b8bf)
- [ElmとPureScript、どっちを選べばいいんだよ](https://qiita.com/hiruberuto/items/c65e7629d3b1597840d9)

***

## Setup

### Environment
- CLI:
    - nodejs: `10.15.3`
    - yarn (package manager): `1.15.2`

---

### Installation
```bash
$ yarn add -D elm
```

#### If on Windows
- Edit **package.json** if on windows
    ```diff
    {
        // ...
    +   "scripts": {
    +       "elm": "node_modules/elm/bin/elm.exe"
    +   }
    }
    ```

---

### Test run

#### REPL
```bash
# run elm repl mode
$ yarn elm repl
---- Elm 0.19.0 ----------------------------------------------------------------
Read <https://elm-lang.org/0.19.0/repl> to learn more: exit, help, imports, etc.
--------------------------------------------------------------------------------
# 1 / 2 => 0.5
> 1 / 2
0.5 : Float

# exit
> :exit
```

#### Development Server
- First, initialize elm project
    ```bash
    $ yarn elm init
    Knowing all that, would you like me to create an elm.json file now? [Y/n]: # <= `y`
    ## => Generate `elm.json`
    ```
- Create test script: **src/test.elm**
    ```elm
    import Html
    -- main function: display html text "Hello, world!"
    main = Html.text "Hello, world!"
    ```
- Run elm development server
    ```bash
    $ yarn elm reactor
    ## => Development Server will run in http://localhost:8000
    
    # Access to http://localhost:8000/src/test.elm
    ## => Display: "Hello, world!"
    ```

***

## 言語の基礎

### 構文記法

#### 文字列そのものの表現
以下の表現は、その文字列そのものを表す

- アルファベットや記号がそのまま並んでいるもの
    ```javascript
    if    // <= if そのものを表す
    ```
- アルファベットや記号をクォートで囲んだもの
    ```javascript
    'if'  // <= if に等しい
    ```

#### () で囲まれた要素
`()`で囲まれた要素はグルーピングを表現し、一つのかたまりとして扱われる

例えば以下の記述は、`if()`という文字の並びをひとまとめにしたものを表す

```javascript
('if' '(' ')')  // <= if() というかたまりを表す
```

#### <> で囲まれた要素
`<>`で囲まれた要素は、何らかの構文であることを表現する

例えば `<式>` という記述は、「式」という概念を表現する構文要素を示す

#### 要素の後ろに * が付加されたもの
何らかの要素に続いて`*`が付加されたものは、その要素が**0回以上繰り返される**ことを表現する

例えば以下の記述は、`<式>`の後に`;`が来るような要素が0回以上現れることを示す

```javascript
(<式> ;)*
```

#### 要素の後ろに + が付加されたもの
何らかの要素に続いて`+`が付加されたものは、その要素が**1回以上繰り返される**ことを表現する

例えば以下の記述は、`<式>`の後に`;`が来るような要素が1回以上現れることを示す

```javascript
(<式> ;)+
```

#### 要素の後ろに ? が付加されたもの
何らかの要素に続いて`?`が付加されたものは、その要素が**0回または1回現れる**ことを表現する（オプショナルであることを表現する）

例えば以下の記述は、`else`の後に`<式>`が来るような要素が0回または1回現れることを示す

```javascript
(else <式>)?
```

#### 2つの要素の間に | が付加されたもの
何らかの2つの要素AとBの間に`|`が付加されたものは、 **AかBのどちらかが現れる**ことを表現する

例えば以下は、 `val`または`var`のどちらでも良いことを示す

```javascript
('val'|'var')
```

ここで`a|b`について、「`a|b`」という3文字なのか、「`a`または`b`」なのかが曖昧であるが、明示的に`'|'`としない限り、「`a`または`b`」という解釈が優先されることとする

#### 何らかの要素の後に ... が続くもの
任意個数の要素が繰り返されるときに、最初の数個を例示し、残りは同じパターンで出現することを表現する

例えば以下は、`[`と`]`で囲まれ、式が任意の回数繰り返されるパターンを示す

```javascript
'[' <式1>, <式2>, ... ']'
```

---

### 基本文法
以下は、REPLモードで動作確認すると良い

#### 値
```elm
{-
# 文字列
- 文字列: "..." で囲む
- 長文文字列: """...""" で囲む
    - 改行OK
    - REPLで改行する場合は'\'が必要
-}
"hello"
--> "heelo" : String

"""
a
b
c
"""
--> "\na\nb\nc\n" : String

-- # 文字: ' ' で囲む
'a'
--> 'a' : Char

-- # 数値
1
--> 1 : number

1.0
--> 1 : Float

-- 浮動小数点の除算: /
-- 整数の除算: //
9 / 2
--> 4.5 : Float

9 // 2
--> 4 : Int
```

#### 演算子
```elm
-- # 論理演算子
-- Bool型のみ指定可能
-- AND
True && False
--> False : Bool

-- OR
True || False
--> True : Bool

-- XOR: xor関数
xor True True
--> False :Bool

-- NOT
not True
--> False : Bool

-- # 文字列やListの連結: ++ 演算子
"hello" ++ " " ++ "world"
--> "hello world" : String

-- # 算術演算子
-- 加算
1 + 2
--> 3 : number

-- 減算
1 - 2
--> -1 : number

-- 乗算
2 * 8
--> 16 : number

-- べき乗
2 ^ 8
--> 256 : number

-- 除算（浮動小数点）
7 / 2
--> 3.5 : Float

-- 除算（整数）
7 // 2
--> 3 : Int

-- 剰余: modBy関数
modBy 2 7 -- <= 7 % 2
--> 1 : Int

-- # 比較演算子
-- 同値
("eq" == "eq")
--> True : Bool

-- 同値否定
("eq" /= "eq")
--> False : Bool

-- より小さい
1 < 1
--> False : Bool

-- 以下
1 <= 1
--> True : Bool

-- より大きい
10 > 1
--> True : Bool

-- 以上
1 >= 1
--> True : Bool
```

#### 関数
関数定義は以下のような式で行う

```elm
<関数名> (引数)* = <式>

--> '<function>' : (<引数1型名> -> <引数2型名> -> ...) -> <戻り値型名>
```

```elm
-- 引数に渡した数値が負かどうか判定
isNegative n = n < 0
--> <function> : number -> Bool

-- 引数に渡した数値2つを加算
add x y = x + y
--> <function> : number -> number -> number

isNegative 0
--> False : Bool

add 1 2
--> 3 : number

isNegative (add 3 -4)
-- True : Bool
```

以下の式で無名関数を定義することもできる

```elm
'\' (引数)* '->' <式>

--> '<function>' : (<引数1型名> -> <引数2型名> -> ...) -> <戻り値型名>
```

```elm
-- 無名関数を使って加算を行う
(\ x y -> x + y) 100 23
--> 123 : number
```

#### if式
以下のような式で条件分岐を行うことができる

他の言語と違い、else式はオプションではなく必須となっている

```elm
if <条件式> then <then式> else <else式>
```

```elm
-- ageが20歳以上なら"成人", それ以外なら"未成年"を返す関数
displayAdult age = if age >= 20 then "成人" else "未成年"
--> <function> : number -> String

displayAdult 18
--> "未成年" : String
```

#### リスト
リストは関連する値の連続を保持するデータ構造

リスト内の値は全て同じ型である必要がある

```elm
-- 変数namesにリストを代入
names = ["Bob", "Alice", "Chuck"]
--> ["Bob","Alice","Chuck"] : List String

-- isEmptyメソッドでリストが空かどうか判定
List.isEmpty names
--> False : Bool

-- リストの長さを取得
List.length names
--> 3 : Int

-- リストの並び順を逆にする
List.reverse names
--> ["Chuck","Alice","Bob"] : List String

-- リストをソートする
List.sort names
--> ["Alice","Bob","Chuck"] : List String

-- リスト内の要素に対して関数を適用する
-- function: String: <name> -> String: "I'm <name>"
List.map (\e -> "I'm " ++ e) names
--> ["I'm Bob","I'm Alice","I'm Chuck"] : List String
```

#### タプル
タプルは固定された個数の値を保持するデータ構造

リストと異なり、保持する値の型はそれぞれ別々にすることが可能

2つ以上の値を返す関数を作りたいときなどに使う

```elm
-- goodName関数: 20文字以内の名前か判定する
-- タプルを使い (20文字以内かどうか, メッセージ) を返す
goodName name =
  if String.length name <= 20 then
    (True, "Name accepted!")
  else
    (False, "Name was too long; Please limit it to 20 characters")
--> <function> : String -> ( Bool, String )

-- 関数実行
goodName "John"
--> (True, "Name accepted!") : ( Bool, String )
```

#### レコード
レコードは辞書配列やオブジェクトと似たようなデータ構造で、任意このフィールドに値を設定することができる

ただし、Elmのレコードのフィールドは固定されていて、動的にフィールドを加えたり取り除いたりはできない

また、フィールドの値を変更することもできない（immutable）

```elm
-- name, ageフィールドを持つレコードをbillに代入
point = {x = 3, y = 4}
--> { x = 3, y = 4 } : { x : number, y : number1 }

-- xフィールドを取得
point.x
--> 3 : number

-- `.フィールド名`で関数のようにフィールド値を取得できる
.y point
--> 4 : number

List.map .x [point, point, point]
--> [3,3,3] : List number

-- レコードを引数とする関数を定義
-- ageフィールドが70未満か判定
under70 {age} = age < 70
--> <function> : { a | age : number } -> Bool

yoya = {name = "amenoyoya", age = 120}
--> { age = 120, name = "amenoyoya" } : { age : number, name : String }

under70 yoya
--> False : Bool

-- レコードの値を更新して新しいレコードを作る
{ yoya | name = "hoge" }
--> { age = 120, name = "hoge" } : { age : number, name : String }

under70 { yoya | age = 31 }
--> True : Bool
```

***

## 型について

See [型.md](./型.md)

***

## エラーハンドリング

See [エラーハンドリング.md](./エラーハンドリング.md)

***

## The Elm Architecture

See [Architecture.md](./Architecture.md)

***

## Pythonで静的型付け関数型プログラミング

See [FunctionalPython.md](./FunctionalPython.md)

***

## まとめ

- 型を意識せよ
    - 型を意識することでデータがどのように変化していくのか分かりやすくなり、プログラム全体を抽象的に考えられるようになる
    - 型の種類は以下の3つがあることを意識しておくと良い
        1. **プリミティブ型**（int, float, str, bool 等）
        2. **ジェネリクス型**: 複数の型になりうる型
            - 代入される値が決まってはじめて型が決まる
        3. **コンテナ型**: 複数のプリミティブ型を内蔵した型（List, Tuple 等）
            - 通常コンテナ型はジェネリクス型と共に宣言される
            - ジェネリクス型の型が決定したときにはじめて型として認識される
- 全ては関数であると知れ
    - 関数をトップレベルとして考えることで、プログラミングの筋が良くなる
    - **関数の本質はデータの変換**である: `<引数型> -> <戻り値型>`
        - 一連の処理をまとめたものが関数ではない
        - 究極的には、関数とは一つの式で書けるものを言う
    - 複数の引数をとる関数は、部分適用関数で書けることを知っておくべし
        - `(int, int) -> int` は `int -> int -> int` と書ける
