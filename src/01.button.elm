-- 必要モジュールのimport
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

-- Elmプログラムのエントリーポイント
-- main関数の定義
main =
  {- sandboxアプリケーションを構築
    sandboxはAPI等は使えず、単純にユーザーからの入力に対して状態遷移を行うだけ
      - init: アプリケーションの初期状態 = Model定義
      - update: アプリケーション状態の更新関数 = 引数: (イベント, Model) -> 戻り値: 更新後のModel
      - view: HTML描画関数 = 引数: (Model) -> 戻り値: HTML
  -}
  Browser.sandbox { init = init, update = update, view = view }


{- MODEL
  Modelという型を定義し、アプリケーションの初期状態として使う
  type alias <新規型名> = <型名>: <新規型名>を<型名>の別名として定義
-}
type alias Model = Int
-- 初期状態では カウンタ = 0 とする
init : Model
init = 0


{- UPDATE
  Msgという型を定義し、入力イベントを媒介させる
  このWebアプリケーションのイベントとしては、以下の二つがある
    - Increment: カウンタを+1する
    - Decrement: カウンタを-1する
  従って、イベントを媒介するMsg型は Increment または Decrement となる
-} 
type Msg = Increment | Decrement
-- update関数: イベントとアプリケーション状態を引数にとり、更新後のアプリケーション状態を返す
update : Msg -> Model -> Model
update msg model =
  -- msgに対してパターンマッチングを行い、発生したイベントに応じて状態を更新する
  case msg of
    -- Incrementイベントが起こった場合は model + 1 を返す
    Increment -> model + 1
    -- Decrementイベントが起こった場合は model - 1 を返す
    Decrement -> model - 1


{- VIEW
  view関数: アプリケーション状態を引数にとり、HTMLを返す
  ここで Html型 は List等と同じように 引数を必要とする型であることに注意
  例) List型: { ["a","b","c"]: List String, [1,2,3]: List number }
    => 内部に入る要素によって型が変化する型
  Html型も内部要素によって型が定められる
  => このview関数は、Msg型を引数とする Html<Msg> という型の値を返すことを意味する
-}
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
  {-
  <div>
    <button onClick="Decrementイベント">-</button>
    <div>{{ アプリケーション状態 }}</div>
    <button onClick="Incrementイベント">-</button>
  </div>
  -}
