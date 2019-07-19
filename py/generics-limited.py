from typing import TypeVar

# Number型 = int型 | float型
Number = TypeVar('Number', int, float)

# 割り算を行う関数: (Number, Number) -> float
def div(x: Number, y: Number) -> float:
    # 以下のように記述すると、mypyでは通るがPyrightでは通らない
    # return float(x / y)
    return float(float(x) / float(y))

# 3 / 2 => 1.5
print(div(3.0, 2))

# str型などを渡すと型エラーになる
print(div(3.0, '2'))
