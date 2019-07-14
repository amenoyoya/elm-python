import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

-- MAIN
-- Browser.sandboxアプリケーション作成
main =
  Browser.sandbox { init = init, update = update, view = view }


{- MODEL
  {
    String型nameフィールド: 入力された名前を保持
    String型passwordフィールド: 入力されたパスワードを保持
    String型passwordAgainフィールド: 入力された確認用パスワードを保持
  }
-}
type alias Model =
  {
    name : String,
    password : String,
    passwordAgain : String
  }

-- 初期状態: name = "", password = "", passwordAgain = ""
init : Model
init = Model "" "" ""


-- UPDATE
{- Events
    - Name<String>イベント: 名前入力時に発生
    - Password<String>イベント: パスワード入力時に発生
    - PasswordAgain<String>イベント: 確認用パスワード入力時に発生
-}
type Msg
  = Name String
  | Password String
  | PasswordAgain String

-- 更新処理: 各イベント受信時、対応するModelのフィールド値を更新
update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }


-- VIEW
view : Model -> Html Msg
view model =
  div []
    [
      -- viewInput関数でinputボックスコンポーネント表示
      viewInput "text" "Name" model.name Name,
      viewInput "password" "Password" model.password Password,
      viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain,
      -- viewValidation関数で入力値チェックコンポーネント表示
      viewValidation model
    ]

{- viewInput関数（コンポーネント）
    - 機能:
      - inputボックスを構築する
    - 引数:
      - type: String = input type: "text", "password", ...etc
      - placeholder: String = プレースホルダーとして表示する文字列
      - value: String = inputボックスのvalue値
      - toMsg: (String -> Msg) = onInputイベント発生時に発行するイベントメッセージ
    - 戻り値:
      - Html<Msg>: HTML
-}
viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

{- viewInput関数（コンポーネント）
    - 機能:
      - 入力されたpasswordとpasswordAgainの値が同一であるか判定する
    - 引数:
      - model: Model = アプリケーションの状態
    - 戻り値:
      - Html<Msg>: HTML
-}
viewValidation : Model -> Html msg
viewValidation model =
  if model.password == model.passwordAgain then
    div [ style "color" "green" ] [ text "OK" ]
  else
    div [ style "color" "red" ] [ text "Passwords do not match!" ]
