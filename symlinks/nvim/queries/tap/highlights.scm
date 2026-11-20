; Keywords
[
  "var"
  "function"
  "if"
  "else"
  "while"
  "return"
] @keyword

; Built-in functions (optional, if you want to highlight specific names)
((identifier) @function.builtin
  (#any-of? @function.builtin "Cmd" "bind" "alias"))

; Literals
(string) @string
(number) @number
(boolean) @boolean

; Key Chords (!C!g)
(key_chord) @string.special

; Functions and variables
(function_declaration name: (identifier) @function)
(call_expression function: (identifier) @function.call)

; Punctuation
[
  "{"
  "}"
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

[
  "."
  ","
  ":"
] @punctuation.delimiter

; Operators
[
  "+"
  "-"
  "*"
  "/"
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
  "="
] @operator

; Comments
(comment) @comment
