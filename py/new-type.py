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
