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

**※ 2019年7月現在、PyrightはNewTypeの型強制をスルーしてしまう**

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
