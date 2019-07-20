# Pythonで静的型付け関数型プログラミング

## Pythonで型プログラミング

### Type Hints
- Elmにおける型注釈（Type Annotation）と同じような機能
- Python 3.5 より導入
- 構文:
    - Define variable:
        ```elm
        <変数名> ':' <型名> '=' <値>
        ```
    - Define function:
        ```elm
        def <関数名> '(' (<引数1> ':' <型名1> ',' <引数2> ':' <型名2> ',' ...)? ')' '->' <戻り値型名> ':'
            <関数式>
        ```


```python
# string型変数定義
val: str = "Hello, world!"
print(val)
## -> "Hello, world!"

# 関数定義: int, int -> int
def add(x: int, y: int) -> int:
    return x + y

print(add(1, 2))
## -> 3
```

#### mypyによる型解析
Type Hints は現状、単なる注釈に過ぎないため、型が違っても普通に動いてしまう

```python
# string型変数に数値が代入できてしまう；；
val: str = 3.14
print(val)
## -> 3.14

# 関数定義: int, int -> int
def add(x: int, y: int) -> int:
    return x + y

# intではなく文字列を渡しても実行できてしまう；；
print(add("Hello ", "World"))
## -> "Hello World!"
```

そこで**mypy**というツールを使って型の状態を静的にチェックする方法がある

- Install mypy:
    ```bash
    $ pip install mypy
    ```
- Test run:
    - **py/type-hints_01.py**
        ```python
        # double関数: int -> str
        def double(x: int) -> str:
            return 'Double of {}: {}'.format(x, x ** 2)
        
        # 型を正しく処理
        result: str = double(16)
        ```
    - **py/type-hints_02.py**
        ```python
        # double関数: int -> str
        def double(x: int) -> str:
            return 'Double of {}: {}'.format(x, x ** 2)
        
        # 型を間違った例
        result: int = double(16)
        ```
    - Run mypy:
        ```bash
        $ mypy py/type-hints_01.py
        ## -> 型が正しく処理されているため何も表示されない

        $ mypy py/type-hints_02.py
        ## -> 型が間違っているため以下のようなエラー文が表示される
        py/type-hints_02.py:4: error: Incompatible types in assignment (expression has type "str", variable has type "int")
        ```

#### Pyrightによる型解析
「mypyより5倍高速」という謳い文句で、2019年にMicrosoftが**Pyright**という静的型解析ツールを公開している

- Install Pyright:
    ```bash
    $ yarn add -D pyright
    ```
- Test run:
    ```bash
    $ yarn pyright py/type-hints_01.py
    ## -> 型が正しく処理されているため何も表示されない
    Searching for source files
    Found 1 source file
    0 errors, 0 warnings

    $ yarn pyright py/type-hints_02.py
    ## -> 型が間違っているため以下のようなエラー文が表示される
    Searching for source files
    Found 1 source file
    ./py/type-hints_02.py
        4:15 - error: Expression of type 'str' cannot be assigned to declared type 'int'
        'Type[str]' is incompatible with 'Type[int]'
    1 error, 0 warnings
    ```

なお、PyrightはVSCodeプラグインとしても公開されているため、エディタとしてVSCodeを使っている場合はインストールしておくと良い

#### mypy と Pyright の比較
- 速度: Pyright > mypy
- 厳格さ:
    - NewTypeによる型強制: mypy > Pyright（対応していない）
    - ジェネリクス型の演算: mypy（緩い） < Pyright（厳格）

厳格さに関しては mypy, Pyright ともに一長一短だが、速度の勝るPyrightの方が良さげ

---

### Type aliases
`typing`モジュール（Python 3.5以上の標準モジュール）を使うことで、Elmにおける型変数と同等の機能を使うことができる

```python
from typing import List, Tuple

# List<float>
Vector = List[float]

# リストの要素をscalar倍する関数: (float, Vector) -> Vector
def scale(scalar: float, vector: Vector) -> Vector:
    return [scalar * num for num in vector]

print(scale(2.0, [1.0, -4.2, 5.4]))
## -> [2.0, -8.4, 10.8]


# Tuple<str, int>
Human = Tuple[str, int]
human: Human = ('amenoyoya', 120)

print(human)
## -> ('amenoyoya', 120)
```

---

### NewType
Elmにおける alias と同等の機能を提供するのは `NewType`ヘルパー関数

```python
from typing import Tuple, NewType

# RGB色型
Color = NewType('Color', Tuple[int, int, int])

# (255,0,0) -> 'ff0000' 変換関数: Color -> str
def toRGB(color: Color) -> str:
    return '%x' % color[0] + '%x' % color[1] + '%x' % color[2]

print(toRGB(Color((100, 200, 255))))
## -> 64c8ff

# NewTypeで定義された型は Type aliases と異なり、型を強制される
## -> 以下は mypy で型チェックするとエラーになる
### ※ Pyright ではスルーされた。。。
print(toRGB((100, 200, 255)))
```

---

### 呼び出し可能オブジェクト
コールバック関数を要求する関数を作る場合などは `Callable[[ArgType, ...], ReturnType]` を使う

```python
from typing import List, Callable

# List[int]の各要素にcallback関数（int -> int）を適用する関数
## List[int] -> List[int]
def map(array: List[int], callback: Callable[[int], int]) -> List[int]:
    return [callback(e) for e in array]

print(map([1, 2, 3], lambda e: e * 2))
## -> [2, 4, 6]


# より関数型言語っぽく書くなら以下のような感じ
map: Callable[[List[int], Callable[[int], int]], List[int]] \
    = lambda array, callback: [callback(e) for e in array]

print(map([1, 2, 3], lambda e: e * 2))
## -> [2, 4, 6]
```

---

### ジェネリクス
コンテナ型（List型やTuple型など）がそれ単体では型とはならず、コンテナの要素の型が示されて初めて型推論される

このように複数の型になりうる汎用的な型をジェネリクスと呼ぶ

ジェネリクスは`TypeVar`ファクトリによってパラメータ化することができる

```python
from typing import Sequence, TypeVar

T = TypeVar('T') # ジェネリクス型'T'

# 何らかの型の連続体の最初の値を取り出す関数: Sequence<T> -> T
def first(l: Sequence[T]) -> T:
    return l[0]

# first関数は、List<int> でも Tuple<str> でも、型の連続体であれば、どのような型でも処理できる
print(first([99, 88, 77])) # -> 99
print(first(('Hello', 'World'))) # -> Hello
```

さらに `Generic`を基底クラスにすることで、ジェネリッククラスを定義することもできる

```python
from typing import Tuple, NewType, TypeVar, Generic

T = TypeVar('T')

# Pairクラス: 何らかの型がペアになったもの
class Pair(Generic[T]):
    def __init__(self, v1: T, v2: T) -> None:
        self.values: Tuple[T, T] = (v1, v2)
    
    def get1(self) -> T:
        return self.values[0]
    
    def get2(self) -> T:
        return self.values[1]

# str型のPairクラスをName型と定義
Name = NewType('Name', Pair[str])

# Name型変数 harry 作成
harry: Name = Name(Pair('Harry', 'Potter'))
print(harry.get1()) # -> Harry
```

#### 制約付きジェネリクス
特定の型だけをとりうるジェネリクスを作ることもできる

例えば、数値型（`int` or `float`）の値を引数にとって割り算をするような関数を作る場合などは、制約付きジェネリクスを使う

```python
from typing import TypeVar

# Number型 = int型 | float型
Number = TypeVar('Number', int, float)

# 割り算を行う関数: (Number, Number) -> float
def div(x: Number, y: Number) -> float:
    # 以下のように記述すると、mypyでは通るがPyrightでは通らない
    # return float(x / y)

    # Pyrightでも通るようにするには、その演算子を確実に使える型にキャストする
    return float(float(x) / float(y))

# 3 / 2 => 1.5
print(div(3.0, 2))

# str型などを渡すと型エラーになる
print(div(3.0, '2'))
```

---

### Any型
動的型付けと静的型付けが混在したコードを書く必要があるとき、非常口として、あらゆる型を許容する`Any`型を使うことができる

ただし、Any型を使ってしまうと型推論のメリットがなくなってしまうため、あくまで非常口として使うこと

```python
from typing import Any, TypeVar

# どんな型でも引数にとれる関数
def print_any(arg: Any) -> None:
    print(arg)


# 上記と同等の関数を、ジェネリクス型を使って書くこともできる
T = TypeVar('T')

def print_generics(arg: T) -> None:
    print(arg)


print_any(['print', 'any'])
## -> ['print', 'any']

print_generics(['print', 'generics'])
## -> ['print', 'generics']
```

***

## Pythonで関数型プログラミング

### lambda式による純粋関数定義
**呼び出し可能オブジェクト**の項で少し触れたように、lambda式とCallable型を使うことで、かなり関数型言語っぽく書ける

```python
from typing import List, Callable

# List<int> に対して (int -> int)関数を適用する関数
## (List<int>, (int -> int)) -> List<int>
map: Callable[[List[int], Callable[[int], int]], List[int]] \
    = lambda array, callback: [callback(e) for e in array]

print(map([1, 2, 3], lambda e: e * 2))
## -> [2, 4, 6]
```

#### パイプライン演算子の導入
より関数型言語っぽい表現を求めるなら、パイプライン演算子も欲しい

- **パイプライン演算子**:
    - ある式の結果を別の式に1つ目の引数として渡す演算子
        ```python
        # (1 + 2)という式の結果をprint関数に渡す

        ## 通常
        print(1 + 2)

        ## パイプライン演算子 |> を使うと以下のように書ける
        ### ※Pythonにパイプライン演算子はないため、実際には動かない
        1 + 2 |> print
        ```
    - 普通に式展開しようとすると、データは括弧の内側から展開されていく
        - パイプライン演算子を導入すると、データが左から右からに流れるように展開される
            ```python
            # f1(x) => f2(x) => f3(x) のように関数を適用する場合

            ## 通常
            f3(f2(f1(x)))

            ## パイプライン
            f1(x) |> f2 |> f3
            ```

Pythonでパイプライン演算子を模倣するなら、OR演算子（`|`）などの中置演算子をオーバーロードして代替することになる

```python
from typing import Callable, Any

# 中置演算子でコールバック関数を渡すためのクラス
class pipe(object):
    def __init__(self, any: Any) -> None:
        # パイプラインの右側の関数に渡すための値を保持
        self.value: Any = any
    
    # パイプライン演算子の代わりに OR演算子 を使う
    ## パイプラインの右側には (Any -> Any)関数を要求
    ## コールバック関数の戻り値を pipeオブジェクトに変換して返す（連続処理のため）
    ## `|`関数: Any -> (Any -> Any) -> (Any -> pipe) -> pipe
    def __or__(self, callback: Callable[[Any], Any]):
        # pipe: Any -> pipe
        ## (Any -> pipe) -> pipe
        return pipe(callback(self.value))

# (1 + 2) => print(x)
pipe(1 + 2) | print
## -> 3
```

#### パイプラインの動作イメージ
上記の`pipe`クラスは、以下のような動作をしている

- `pipe(x: Any)`:
    - Any型の値`x`を pipe型に変換: `Any -> pipe`
- `pipe | function`:
    - パイプライン処理の内容を書き直すと以下のようになる
        ```python
        pipe | function
        => pipe.__or__(function)
        => __or__(pipe, function)
        ```