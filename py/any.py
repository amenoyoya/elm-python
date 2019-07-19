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
