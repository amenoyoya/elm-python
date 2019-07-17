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
