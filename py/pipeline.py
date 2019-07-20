'''
Pythonでパイプライン演算子
'''
from typing import Callable, Any, Iterable

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

# パイプライン演算子の動作イメージ
## pipe(x) | callback
## => パイプラインの左側の値を引数として、右側の関数に渡す
##      callback(pipe(x))
## == 部分適用: pipe(x) は、xを処理するための関数を引数とする関数を返す
##      pipe(x): x -> (x -> pipe)
##      pipe(x)(callback)

# (1 + 2) => print(x)
pipe(1 + 2) | print
## -> 3

# 引数にとった数値から3を引く関数: int -> int
sub3: Callable[[int], int] = lambda x: x - 3

# 10 - 3
pipe(10) | sub3 | print
## -> 7

# 引数にとった数値からnを引く関数: int -> int -> int
def sub(n: int) -> Callable[[int], int]:
    return lambda x: x - n

# 10 - 3
pipe(10) | sub(3) | print
## -> 7
