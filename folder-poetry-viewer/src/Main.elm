module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, a, div, p, span, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)



---- MODEL ----


getTitle : String -> String
getTitle str =
    String.slice 9 23 str


getTxt : String -> String
getTxt str =
    String.split "---" str
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""


initProblems =
    """
problems/problem-01.txt---it's cold outside
problems/problem-02.txt---i don't have any money
problems/problem-03.txt---i forgot to have lunch
problems/problem-04.txt---it's to hot out
problems/problem-05.txt---i have to go to work
problems/problem-06.txt---i worked late last night
problems/problem-07.txt---i need to go to the gym
problems/problem-08.txt---i climbed last night and my fingers are sore
problems/problem-09.txt---it's to nice in my confort zone
problems/problem-10.txt---i'm scard
"""
        |> dropFirstLine
        |> String.lines
        |> (\l -> List.take (List.length l - 1) l)
        |> List.map
            (\str ->
                { open = False
                , txt = getTxt str
                , fileName = getTitle str
                }
            )


type alias ProblemElement =
    { open : Bool
    , txt : String
    , fileName : String
    }


type alias Model =
    { problems : List ProblemElement
    }


init : ( Model, Cmd Msg )
init =
    ( { problems = initProblems
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ToggleProblem Int


toggleProblem : Int -> List ProblemElement -> List ProblemElement
toggleProblem index problems =
    List.indexedMap
        (\i p ->
            if i == index then
                { p | open = not p.open }

            else
                p
        )
        problems


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleProblem index ->
            ( { model | problems = toggleProblem index model.problems }, Cmd.none )



---- VIEW ----


dropFirstLine : String -> String
dropFirstLine str =
    String.lines str
        |> List.drop 1
        |> String.join "\n"


view : Model -> Html Msg
view model =
    div [ class "main-wrapper" ]
        [ terminalView model ]


prefixZubTen : Int -> String
prefixZubTen num =
    String.concat
        [ if num <= 9 then
            "0"

          else
            ""
        , String.fromInt num
        ]


problemTxt : String -> String
problemTxt str =
    String.replace "%s" str "├── %s\n"


problemView : ( Int, ProblemElement ) -> Html Msg
problemView ( index, problem ) =
    div []
        [ span [ class "terminal-spacer" ] [ text (String.repeat 4 " ") ]
        , a [ onClick (ToggleProblem index) ] [ text (problemTxt problem.fileName) ]
        , p
            (if not problem.open then
                [ class "empty" ]

             else
                []
            )
            [ text problem.txt ]
        ]


terminalView : Model -> Html Msg
terminalView model =
    div [ class "terminal-wrapper" ]
        (List.append
            [ p [ class "terminal-text" ]
                [ text (dropFirstLine """
.
└── problems
""")
                ]
            ]
            (List.indexedMap
                (\i p -> problemView ( i, p ))
                model.problems
            )
        )



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
