Main = Salute "," __ who:Noun End { return `Greetings to ${who}` }

End = "..." / "." / "!"

Noun = $[a-z]i+

Salute = "Hello"i / "Greetings"i / "Hi"

__ "obligatory whitespace" = " "+ { return null }

_ "any whitespace" = " "* { return null }
