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
