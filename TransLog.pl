:-use_module('translator').

%_____________________________________________
% transLog: Main program in charge of running the program loop for the
%           menus.
%
% Params: Input - input the define whether the language to translate
%         will be english or spanish.
%_____________________________________________
transLog:-
    write("Welcome to TransLog/Bienvenido a TransLog"),
    nl,
    write("-For english please enter the number 1 followed by a period (.)"),
    nl,
    write("-Para español favor ingresar el número 2 seguido de un punto (.)"),
    nl,
    read(Input),
    nl,
    language_code_converter(Input, Language),
    subMenu(Language).

subMenu(Language):-
    sub_menu_language_loader(Language, [Main_Message, Option_1, Option_2, Option_3]),
    write(Main_Message),
    nl,
    write(Option_1),
    nl,
    write(Option_2),
    nl,
    write(Option_3),
    nl,
    read(Input),
    language_code_converter(Input, Chosen_Language),
    translate(Chosen_Language, Language).


%_____________________________________________
% translate: Secondary loop for translating spanish and english.
%
% Params: Input - input that is going to be translate using the
%         translator module
% _____________________________________________
translate('english', Language):-
    translate_language_loader('english', Language, Main_Message),
    write(Main_Message),
    nl,
    read(Input),
    nl,
    ask_translate_ESP(Language, Input).
translate('spanish', Language):-
    translate_language_loader('spanish', Language, Main_Message),
    write(Main_Message),
    nl,
    read(Input),
    nl,
    ask_translate_ENG(Language, Input).
translate(3, Language):-
    translate_language_loader(3, Language, Main_Message),
    write(Main_Message),
    nl,
    transLog.
translate(_, Language):-
    translate_language_loader(Language, Main_Message),
    write(Main_Message),
    nl,
    subMenu(Language).




%_____________________________________________
% fail_translation : Case for when translate fails to be completed
%                    successfully.
%
% Params: None
%_____________________________________________

fail_translation(Language):-
    fail_translation_language_loader(Language, Message),
    write(Message),
    nl.

%_____________________________________________
% ask_translate_ESP: Function for interacting with module translator.pl
%                    for spanish traslation specifically.
%
% Params: Input - word, phrase or paragraph to be translated
%         Output - Result received by module translator.pl
%_____________________________________________

ask_translate_ESP(Language,'salir'):-
    closing_language_loader(Language, [Session_Message, Session_Back_To_Menu]),
    write(Session_Message),
    nl,
    write(Session_Back_To_Menu),
    nl,
    transLog.
ask_translate_ESP(Language,Input):-translate_ESP(Input, Output),
    write_translate_ESP(Language, Output),
    !.
ask_translate_ESP(Language, _):-fail_translation(Language),
    nl,
    translate('english', Language).

%_____________________________________________
% ask_translate_ENG : Function for interaction with module translator.pl
%                     for english translation specifically.
%
% Params: Input - word, phrase or paragraph to be translated
%         Output - Result received by module translator.pl
%_____________________________________________

ask_translate_ENG(Language,'salir'):-
    closing_language_loader(Language, [Session_Message, Session_Back_To_Menu]),
    write(Session_Message),
    nl,
    write(Session_Back_To_Menu),
    nl,
    transLog.
ask_translate_ENG(Language,Input):-translate_ENG(Output, Input),
    write_translate_ENG(Language, Output),
    !.
ask_translate_ENG(Language, _):-fail_translation(Language),
    nl,
    translate('spanish', Language).

%_____________________________________________
% write_translate_ESP : Writes the spanish result back to the user in
%                       the terminal.
%
% Params: Output - Result from module translator.pl
%         NewInput - User's next instruction to the program
%_____________________________________________

write_translate_ESP(Language, Output):-
    write(Output),
    nl,
    write_translation_language_loader(Language, Message),
    write(Message),
    nl,
    read(NewInput),
    nl,
    ask_translate_ESP(Language, NewInput).

%_____________________________________________
% write_translate_ENG : Writes the english result back to the user in
%                       the terminal.
%
% Params: Output - Result from module translator.pl
%         NewInput - User's next instruction to the program
%_____________________________________________
write_translate_ENG(Language, Output):-
    write(Output),
    nl,
    write_translation_language_loader(Language, Message),
    write(Message),
    nl,
    read(NewInput),
    nl,
    ask_translate_ENG(Language, NewInput).

%_____________________________________________
% language_code_converter: Languages code database
%_____________________________________________
language_code_converter(1, 'english').
language_code_converter(2, 'spanish').
language_code_converter(3, 3).

%_____________________________________________
% sub_menu_languaje_loader : Loads
%
% Params: Language - Chosen language of the program
%         Main_Message - Main message in the menu
%         Option_1 - Option 1 in the chosen language
%         Option_2 - Option 2 in the chosen language
%         Option_3 - Option 3 in the chosen language
%_____________________________________________
sub_menu_language_loader(Language, [Main_Message, Option_1, Option_2, Option_3]):-
    sub_menu_main_message(Language, Main_Message),
    sub_menu_option_1(Language, Option_1),
    sub_menu_option_2(Language, Option_2),
    sub_menu_option_3(Language, Option_3).

%_____________________________________________
% SubMenu Database
%_____________________________________________
sub_menu_main_message('english', "Which language would you like to translate to?").
sub_menu_main_message('spanish', "A que lenguaje desea traducir").

sub_menu_option_1('english', "-Enter 1 for translating to spanish to english").
sub_menu_option_1('spanish', "-Ingrese 1 para traducir de espanol a ingles").

sub_menu_option_2('english', "-Enter 2 for translating to english to spanish").
sub_menu_option_2('spanish', "-Ingrese 2 para traducir de ingles a espanol").

sub_menu_option_3('english', "-Enter 3 for returning to the main menu").
sub_menu_option_3('spanish', "-Ingrese 3 para returnar al menu principal").

%_____________________________________________
% translate_language_loader: Loads the text in the translate menu.
%
% Params: Main_Message - Main message in the translate menu
%_____________________________________________
translate_language_loader('english', Language, Main_Message):-
    translate_english_option('english', Language, Main_Message).
translate_language_loader('spanish', Language, Main_Message):-
    translate_spanish_option('spanish', Language, Main_Message).
translate_language_loader(3, Language, Main_Message):-
    translate_exit_option(Language, Main_Message).
translate_language_loader(Language, Main_Message):-
    translate_default_option(Language, Main_Message).

%_____________________________________________
% translateMenu Database
%_____________________________________________
translate_english_option('english', 'english', "Enter the word, sentence or phrase the you wanna to translate to english").
translate_english_option('english', 'spanish', "Ingrese la palabra, oracion o frase que desea traducir al ingles").

translate_spanish_option('spanish', 'english', "Enter the word, sentence or phrase that you wanna to translate to spanish").
translate_spanish_option('spanish', 'spanish', "Ingrese la palabra, oracion o frase que desea traducir al espanol").

translate_exit_option('english', "Returning to main menu...").
translate_exit_option('spanish', "Regresando al menu principal...").

translate_default_option('english', "Please choice between one of the three given options").
translate_default_option('spanish', "Por favor eliga entre una de las tres opciones dadas").

%_____________________________________________
% closing_language_loader: Loads the text in the closing screen
%
% Params: Language - Language - being currently used in the program
%                    Session_Message - Message displaying session status
%                    Session_Back_To_Menu - Message back to menu
%_____________________________________________
closing_language_loader(Language, [Session_Message, Session_Back_To_Menu]):-
    closing_session_message(Language, Session_Message),
    closing_session_back_to_menu(Language, Session_Back_To_Menu).

%_____________________________________________
% closing_session Database
%_____________________________________________
closing_session_message('english', "This traslating sesion has been closed").
closing_session_message('spanish', "Esta sesion de traduccion se ha cerrado").

closing_session_back_to_menu('english', "Returning to main menu...").
closing_session_back_to_menu('spanish', "Regresando al menu principal...").

%_____________________________________________
% fail_translation_language_loader: Loads the text in the fail
%                                   translation screen.
%
% Params: Language - Language - being currently used in the program
%                    Message - Message displaying on screen
%_____________________________________________
fail_translation_language_loader(Language, Message):-
    fail_translation_message(Language, Message).

%_____________________________________________
% fail translation Database
%_____________________________________________
fail_translation_message('english', "Was not able to translate the given input or it doesn't match the structure in the database, please check your input and try again").
fail_translation_message('spanish', "No ha sido posible traducir la entrada dada o no coincide con la estructura en la base de datos, favor verificar su entrada e intentarlo de nuevo").

write_translation_language_loader(Language, Message):-
    write_translation_message(Language, Message).

write_translation_message('english', "Enter another word, sentence or paragraph to translate or enter the word 'salir' to exit to main menu").
write_translation_message('spanish', "Ingrese otra palabra, oracion o parafo para traducir o bien, ingrese la palabra 'salir' para ir al menu principal").
