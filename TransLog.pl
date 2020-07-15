:-use_module('translator').

%_____________________________________________
% transLog: Main program in charge of running the program loop for the
%           menus.
%
% Params: Input - input the define whether the language to translate
%         will be english or spanish.
%         InputLower - lower case copy of the variable Input.
%_____________________________________________
transLog:-
    write("Bienvenido a TransLog, que idioma desea traducir a?"),
    nl,
    read(Input),
    nl,
    string_lower(Input, InputLower),
    translate(InputLower).

%_____________________________________________
% translate: Secondary loop for translating spanish and english.
%
% Params: Input - input that is going to be translate using the
%         translator module
% _____________________________________________
translate("ingles"):-
    write("Ingrese la oracion o parrafo que desea traducir a ingles"),
    nl,
    read(Input),
    nl,
    ask_translate_ESP(Input).
translate("espanol"):-
    write("Ingrese la oracion o parrafo que desea traducir a espanol"),
    nl,
    read(Input),
    nl,
    ask_translate_ENG(Input).

%_____________________________________________
% fail_translation : Case for when translate fails to be completed
%                    successfully.
%
% Params: None
%_____________________________________________

fail_translation:-write("No He Podido entender o no se como traducir la entrada dada, favor verificar si es correcta"),
    nl.

%_____________________________________________
% ask_translate_ESP: Function for interacting with module translator.pl
%                    for spanish traslation specifically.
%
% Params: Input - word, phrase or paragraph to be translated
%         Output - Result received by module translator.pl
%_____________________________________________

ask_translate_ESP('salir'):-
    write("Se ha cerrado la sesion de traduccion"),
    nl,
    !.
ask_translate_ESP(Input):-translate_ESP(Input, Output),
    write_translate_ESP(Output),
    !.
ask_translate_ESP(_):-fail_translation,
    nl,
    translate("ingles").

%_____________________________________________
% ask_translate_ENG : Function for interaction with module translator.pl
%                     for english translation specifically.
%
% Params: Input - word, phrase or paragraph to be translated
%         Output - Result received by module translator.pl
%_____________________________________________

ask_translate_ENG('salir'):-
    write("Se ha cerrado la sesion de traduccion"),
    nl,
    !.
ask_translate_ENG(Input):-translate_ENG(Output, Input),
    write_translate_ENG(Output),
    !.
ask_translate_ENG(_):-fail_translation,
    nl,
    translate("espanol").

%_____________________________________________
% write_translate_ESP : Writes the spanish result back to the user in
%                       the terminal.
%
% Params: Output - Result from module translator.pl
%         NewInput - User's next instruction to the program
%_____________________________________________

write_translate_ESP(Output):-
    write(Output),
    nl,
    write("Ingrese otra oracion o frase que desea traducir, o bien ingrese la palabra salir para acabar la sesion"),
    nl,
    read(NewInput),
    nl,
    ask_translate_ESP(NewInput).

%_____________________________________________
% write_translate_ENG : Writes the english result back to the user in
%                       the terminal.
%
% Params: Output - Result from module translator.pl
%         NewInput - User's next instruction to the program
%_____________________________________________
write_translate_ENG(Output):-
    write(Output),
    nl,
    write("Ingrese otra oracion o frase que desea traducir o bien ingrese la palabra salir para acabar la sesion"),
    nl,
    read(NewInput),
    nl,
    ask_translate_ENG(NewInput).
