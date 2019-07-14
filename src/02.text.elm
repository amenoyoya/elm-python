import Browser
import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

-- MAIN
-- Browser.sandboxアプリケーション作成
main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL
-- Model: String型のcontentフィールドを持つレコード
type alias Model = { content : String }
-- 初期状態: { content = 空文字 }
init : Model
init = { content = "" }


-- UPDATE
-- イベント: Change<String>型
type Msg = Change String
-- update関数: Change<String>型のイベントを受信したら、contentフィールドを newContent : String に更新したmodelを返す
update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }


-- VIEW
view : Model -> Html Msg
view model =
  div []
    [
      {- inputタグ:
          - value値をmodelのcontentフィールドとリンクさせる
          - onInput時(入力時)、Changeイベントを発生させる
      -}
      input [ placeholder "Text to reverse", value model.content, onInput Change ] [],
      -- divタグ: modelのcontentフィールドの値を逆にして表示
      div [] [ text (String.reverse model.content) ]
    ]
