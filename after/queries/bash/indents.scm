; extends

(command) @indent.begin

; (command
;   name: (command_name
;     (word) @_command)
;   argument: (word)? @_command
;   argument: (word) @_arg @indent.ignore
;   .
;   argument: [
;     (string)
;     (raw_string)
;   ] @indent.ignore
;   (#any-of? @_command "curl" "grpcurl")
;   (#any-of? @_arg "--data" "-d"))
