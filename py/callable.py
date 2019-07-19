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
