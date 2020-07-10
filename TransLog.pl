:-use_module('translator').

transLog:- write("Bienvenido a TransLog, que idioma desea traducir a?"), nl, read(Input), nl, string_lower(Input, InputLower), traslate(InputLower).

traslate("ingles"):-write("Ingrese la oracion o parrafo que desea traducir a ingles"), nl, read(Input), nl, traducir(Input, Output), write(Output), nl, !.
traslate("espanol"):-write("Ingrese la oracion o parrafo que desea traducir a espanol"), nl, read(Input), nl, traducir(Output, Input), write(Output), nl, !.
