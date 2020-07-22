:-use_module('translator').

%_____________________________________________
% transLog: Main program in charge of running the program loop for the
%           menus.
%
% Structure: transLog, NO PARAMETERS
%
% Params: Input - input the define whether the language to translate
%         will be english or spanish.
%_____________________________________________
transLog:-
    nl,
    write("Welcome to TransLog / Bienvenido a TransLog"),
    nl,
    write("-Please enter 1. for english"),
    nl,
    write("-Por favor digite 2. para español"),
    nl,
    read(Input),
    nl,
    language_code_converter(Input, Language),
    subMenu(Language).

%_____________________________________________
% subMenu: Sub Menu for selecting which way the user wants the
%          translation to go.
%
% Structure: subMenu(Language)
%
% Params: Language - Language the program is going to run in
%         Main_Message - description message that introduces the user t
%                        the menu
%         Option_1 - Option 1 message displayed in the selected language
%         Option_2 - Option 2 message displayed in the selected language
%         Option_3 - Exit message displayed in the selected language
%_____________________________________________

subMenu(Language):-
    nl,
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
% Structure: translate(Chosen_Language, Language)
%
% Params: Input - input that is going to be translate using the
%         translator module
% _____________________________________________
translate('english', Language):-
    nl,
    translate_language_loader('english', Language, Main_Message),
    write(Main_Message),
    nl,
    read(Input),
    nl,
    ask_translate_ESP(Language, Input).
translate('spanish', Language):-
    nl,
    translate_language_loader('spanish', Language, Main_Message),
    write(Main_Message),
    nl,
    read(Input),
    nl,
    ask_translate_ENG(Language, Input).
translate(3, Language):-
    nl,
    translate_language_loader(3, Language, Main_Message),
    write(Main_Message),
    nl,
    transLog.
translate(_, Language):-
    nl,
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
    nl,
    fail_translation_language_loader(Language, Message),
    write(Message),
    nl.

%_____________________________________________
% ask_translate_ESP: Function for interacting with module translator.pl
%                    for spanish traslation specifically.
%
% Structure: ask_translate_ESP(Language, Input)
%
% Params: Input - word, phrase or paragraph to be translated
%         Output - Result received by module translator.pl
%_____________________________________________

ask_translate_ESP(Language,'exit'):-
    nl,
    closing_language_loader(Language, [Session_Message, Session_Back_To_Menu]),
    write(Session_Message),
    nl,
    write(Session_Back_To_Menu),
    nl,
    subMenu(Language).
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
% Structure: ask_translate_ENG(Language, Input)
%
% Params: Input - word, phrase or paragraph to be translated
%         Output - Result received by module translator.pl
%_____________________________________________

ask_translate_ENG(Language,'salir'):-
    nl,
    closing_language_loader(Language, [Session_Message, Session_Back_To_Menu]),
    write(Session_Message),
    nl,
    write(Session_Back_To_Menu),
    nl,
    subMenu(Language).
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
% Structure: write_translate_ESP(Language, Output)
%
% Params: Output - Result from module translator.pl
%         NewInput - User's next instruction to the program
%_____________________________________________

write_translate_ESP(Language, Output):-
    nl,
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
% Structure: write_translate_ENG(Language, Output)
%
% Params: Output - Result from module translator.pl
%         NewInput - User's next instruction to the program
%_____________________________________________
write_translate_ENG(Language, Output):-
    nl,
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
%
% Structure: language_code_converter(Code, Language)
%
% Params: Code - Code of the language
%         Language - Language for a given code
%_____________________________________________
language_code_converter(1, 'english').
language_code_converter(2, 'spanish').
language_code_converter(3, 3).

%_____________ subMenu Database ____________


%_____________________________________________
% sub_menu_languaje_loader : Loads
%
% Structure: sub_menu_language_loader(Language, [Main_Message,
%            Option_1, Option_2, Option_3])
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
% sub_menu_main_message: Gets main message for the subMenu
%
% Structure: sub_main_message(Language, Message)
%
% Params: Language - Language selected by the user
%         Message - Message to be displayed to the user
%_____________________________________________
sub_menu_main_message('english', "Which language would you like to translate to?").
sub_menu_main_message('spanish', "¿A que lenguaje desea traducir?").

%_____________________________________________
% sub_menu_option_n: Gets messages for the subMenu to be displayed
%
% Structure: sub_main_option_n(Language, Message)
%
% Params: Language - Language selected by the user
%         Message - Message to be displayed to the user
%_____________________________________________

sub_menu_option_1('english', "-Enter 1. for translating from spanish to english").
sub_menu_option_1('spanish', "-Ingrese 1. para traducir de español a ingles").

sub_menu_option_2('english', "-Enter 2. for translating from english to spanish").
sub_menu_option_2('spanish', "-Ingrese 2. para traducir de ingles a español").

sub_menu_option_3('english', "-Enter 3. for returning to the lenguage selection").
sub_menu_option_3('spanish', "-Ingrese 3. para returnar a la selección de lenguaje").

%_____________ translate Database ____________


%_____________________________________________
% translate_language_loader: Loads the text in the translate menu.
%
% Params: Chosen_Language: Language of the message needed
%         Language: Language selected by the user
%         Main_Message - Main message in the translate menu
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
% translate_Language_option
%
% Structure: translate_Language_Option(Chosen_Language, Language,
%            Message)
%
% Params: Chosen_Language: Language chosen by the user
%         Language: Language needed for the message
%_____________________________________________
translate_english_option('english', 'english', "Enter the word, sentence or phrase that you want to translate to english inside single quotes and followed by a period or enter 'exit'. to go to the menu").
translate_english_option('english', 'spanish', "Ingrese la palabra, oración o párrafo que desea traducir al ingles dentro de comillas simples seguido de un punto o bien, digite 'salir'. para ir al menu").

translate_spanish_option('spanish', 'english', "Enter the word, sentence or phrase that you want to translate to english inside single quotes and followed by a period").
translate_spanish_option('spanish', 'spanish', "Ingrese la palabra, oración o párrafo que desea traducir al ingles dentro de comillas simples seguido de un punto o bien, digite 'salir'. para ir al menu").

translate_exit_option('english', "Returning to the menu...").
translate_exit_option('spanish', "Regresando al menu...").

translate_default_option('english', "Please choose between one of the three options").
translate_default_option('spanish', "Por favor eliga entre una de las tres opciones").

%_____________ closing session Database ____________



%_____________________________________________
% closing_language_loader: Loads the text in the closing screen
%
% Structure: closing_language_loader(Language,[Session_Message,
%            Session_Back_To_Menu])
%
% Params: Language - Language - being currently used in the program
%                    Session_Message - Message displaying session status
%                    Session_Back_To_Menu - Message back to menu
%_____________________________________________
closing_language_loader(Language, [Session_Message, Session_Back_To_Menu]):-
    closing_session_message(Language, Session_Message),
    closing_session_back_to_menu(Language, Session_Back_To_Menu).

%_____________________________________________
% closing_session_option: Gives feedback for the user to know, it is
%                         going to the main menu
%
% Structure: closing_session_option(Language, Message)
%
% Params: Language - Chosen language by the user
%         Message - Message to be displayed?
%_____________________________________________
closing_session_message('english', "This traslating session has been closed").
closing_session_message('spanish', "Esta sesión de traducción se ha cerrado").

closing_session_back_to_menu('english', "Returning...").
closing_session_back_to_menu('spanish', "Regresando...").

%_____________________________________________
% fail_translation_language_loader: Loads the text in the fail
%                                   translation screen.
%
% Structure: fail_translation_language_loader(Language, Message)
%
% Params: Language - Language - being currently used in the program
%                    Message - Message displaying on screen
%_____________________________________________
fail_translation_language_loader(Language, Message):-
    fail_translation_message(Language, Message).

%_____________________________________________
% fail translation_message: Gets message to be displayed at user when
%                           the translation is failed
%
% Structure: fail_translation_message(Language, Message)
%
% Params: Language - Chosen language by the user
%         Message - Message to be displayed
%_____________________________________________
fail_translation_message('english', "Was not able to translate the given input or it doesn't match the structure in the database, please check your input and try again").
fail_translation_message('spanish', "No ha sido posible traducir la entrada dada o no coincide con la estructura en la base de datos, favor verificar su entrada e intentarlo de nuevo").



%_____________________________________________
% write_translation_language_loader:
%
% Structure: fail_translation_language_loader(Language, Message)
%
% Params: Language - Language - being currently used in the program
%                    Message - Message displaying on screen
%_____________________________________________

write_translation_language_loader(Language, Message):-
    write_translation_message(Language, Message).


%_____________________________________________
% write_translation_message: Gets message to be displayed at user when
%                           a translation has been done
%
% Structure: write_translation_message(Language, Message)
%
% Params: Language - Chosen language by the user
%         Message - Message to be displayed
%_____________________________________________

write_translation_message('english', "Enter another word, sentence or paragraph inside single quotes and followed by a period to translate or enter 'exit'. to go to the menu").
write_translation_message('spanish', "Ingrese otra palabra, oración o párafo para traducir dentro de comillas simples seguido de un punto o bien, digite 'salir'. para ir al menu").
