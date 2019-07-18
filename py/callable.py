from typing import List, Callable, Iterable, Any

# List[int]の各要素にcallback関数（int -> int）を適用する関数
## List[int] -> List[int]
def map(array: List[int], callback: Callable[[int], int]) -> List[int]:
    return [callback(e) for e in array]

print(map([1, 2, 3], lambda e: e * 2))
## -> [2, 4, 6]


# より関数型言語っぽく書くなら以下のような感じ
map2: Callable[[List[int], Callable[[int], int]], List[int]] \
    = lambda array, callback: [callback(e) for e in array]

print(map2([1, 2, 3], lambda e: e * 2))
## -> [2, 4, 6]


# さらに関数型言語っぽく書くなら。。。

## 中置演算子でコールバック関数を渡すためのクラス
class pipe(object):
    def __init__(self, any: Any) -> None:
        self.value: Any = any
    
    def __rshift__(self, callback: Callable[[Any], Any]) -> Any:
        return callback(self.value)

## 関数合成
apply: Callable[[Callable[[Any], Any]], Callable[[Iterable[Any]], pipe]] \
    = lambda f: lambda any: pipe([f(e) for e in any])

pipe([1, 2, 3]) >> apply(lambda e: e * 2) >> print
## -> [2, 4, 6]
