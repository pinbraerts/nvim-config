; extends

(command
  argument: (word) @_arg
  .
  argument: [
    (string)
    (raw_string)
  ] @injection.content
  (#any-of? @_arg "--data" "-d")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "json"))

(command
  name: (command_name
    (word) @_command)
  argument: (word) @_arg
  .
  argument: [
    (string)
    (raw_string)
  ] @injection.content
  (#match? @_command "(^|/)python\d?")
  (#eq? @_arg "-c")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "python"))

(command
  name: (command_name
    (word) @_command)
  argument: (word)? @_arg
  .
  argument: [
    (string)
    (raw_string)
  ] @injection.content
  (#match? @_command "(^|/)jq")
  (#match? @_arg "^-")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "jq"))
