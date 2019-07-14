# Elm入門

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">クリエイティブ・コモンズ 表示 - 非営利 4.0 国際 ライセンス</a>の下に提供されています。

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
'\' (引数)* -> <式>

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
