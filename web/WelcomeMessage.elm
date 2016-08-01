module MessageForm exposing (..)

import Html.App
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class)
import Http
import Task exposing (Task)
import Json.Decode exposing (succeed, list, string)
import Json.Encode as JS


view model =
    form [ id "message-form" ]
        [ h1 [] [ text "Save a message for a given user" ]
        , label [ for "userId-field" ] [ text "User ID: " ]
        , input
            [ id "userId-field"
            , type' "text"
            , value model.userId
            , onInput (\str -> { msgType = "SET_USERNAME", payload = str })
            ]
            []
          --, div [ class "validation-error" ] [ text (viewUsernameErrors model) ]
          --, div [ class "validation-error" ] [ text model.errors.username ]
        , label [ for "message" ] [ text "Message: " ]
        , input
            [ id "message"
            , type' "text"
            , value model.message
            , onInput (\str -> { msgType = "SET_PASSWORD", payload = str })
            ]
            []
          --, div [ class "validation-error" ] [ text model.errors.password ]
        , div [ class "signup-button", onClick { msgType = "VALIDATE", payload = "" } ] [ text "Update message" ]
        ]


viewUsernameErrors model =
    if model.errors.usernameTaken then
        "That username is taken!"
    else
        model.errors.userId


getErrors model =
    { userId =
        if model.userId == "" then
            "Please enter a user number!"
        else
            ""
    , message =
        if model.message == "" then
            "Please enter a message!"
        else
            ""
    , usernameTaken = model.errors.usernameTaken
    }


update msg model =
    if msg.msgType == "VALIDATE" then
        let
            url =
                "http://localhost:4000/api/users/" ++ (Debug.log "userId" model.userId) ++ "/message"

            failureToMsg err =
                { msgType = "USERNAME_AVAILABLE", payload = "" }

            successToMsg result =
                { msgType = "USERNAME_TAKEN", payload = "" }

            request =
                Http.post
                    (list string)
                    url
                    --(Debug.log "string is resolving to: " (Http.string """{ "message": "figure out the whole message thing"}"""))
                    (Http.multipart
                        [ Http.stringData "user" (JS.encode 0 (JS.string "adam"))
                        , Http.stringData "payload" (JS.encode 0 (JS.string "message"))
                        ]
                    )

            cmd =
                Task.perform failureToMsg successToMsg request
        in
            ( { model | errors = getErrors model }, cmd )
    else if msg.msgType == "USERNAME_TAKEN" then
        ( withUsernameTaken True model, Cmd.none )
    else if msg.msgType == "USERNAME_AVAILABLE" then
        ( withUsernameTaken False model, Cmd.none )
    else if msg.msgType == "SET_USERNAME" then
        ( { model | userId = msg.payload }, Cmd.none )
    else if msg.msgType == "SET_PASSWORD" then
        ( { model | message = msg.payload }, Cmd.none )
    else
        ( model, Cmd.none )


withUsernameTaken isTaken model =
    let
        currentErrors =
            model.errors

        newErrors =
            { currentErrors | usernameTaken = isTaken }
    in
        { model | errors = newErrors }


initialModel =
    { userId = "", message = "", errors = initialErrors }


initialErrors =
    { userId = "", message = "", usernameTaken = False }



--main =
--    view { username = "", password = "", errors = initialErrors }


main =
    Html.App.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
