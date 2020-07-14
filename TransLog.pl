:-use_module('translator').

transLog:- write("Bienvenido a TransLog, que idioma desea traducir a?"), nl, read(Input), nl, string_lower(Input, InputLower), translate(InputLower).

translate("ingles"):-write("Ingrese la oracion o parrafo que desea traducir a ingles"), nl, read(Input), nl, askTranslate_ESP(Input).
translate("espanol"):-write("Ingrese la oracion o parrafo que desea traducir a espanol"), nl, read(Input), nl, askTranslate_ENG(Input).

failTranslation:-write("No he podido entender o no se como traducir la entrada dada, favor verificar si es correcta"), nl.

askTranslate_ESP('salir'):-write("Se ha cerrado la sesion de traduccion"), nl, !.
askTranslate_ESP(Input):-translate_ESP(Input, Output), writeTranslate_ESP(Output), !.
askTranslate_ESP(_):-failTranslation, nl, translate("ingles").

writeTranslate_ESP(Output):-write(Output), nl, write("Ingrese otra oracion o frase que desea traducir, o bien ingrese la palabra salir para acabar la sesion"), nl, read(NewInput), nl, askTranslate_ESP(NewInput).

askTranslate_ENG('salir'):-write("Se ha cerrado la sesion de traduccion"), nl, !.
askTranslate_ENG(Input):-translate_ENG(Output, Input), writeTranslate_ENG(Output), !.
askTranslate_ENG(_):-failTranslation, nl, translate("espanol").

writeTranslate_ENG(Output):- write(Output), nl, write("Ingrese otra oracion o frase que desea traducir o bien ingrese la palabra salir para acabar la sesion"), nl, read(NewInput), nl, askTranslate_ENG(NewInput).
