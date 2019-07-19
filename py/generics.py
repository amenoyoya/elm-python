from typing import Sequence, Tuple, NewType, TypeVar, Generic

T = TypeVar('T') # ジェネリクス型'T'

# 何らかの型の連続体の最初の値を取り出す関数: Sequence<T> -> T
def first(l: Sequence[T]) -> T:
    return l[0]

# first関数は、List<int> でも Tuple<str> でも、型の連続体であれば、どのような型でも処理できる
print(first([99, 88, 77])) # -> 99
print(first(('Hello', 'World'))) # -> Hello


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
