
:-module(translator, [translate_ESP/2, translate_ENG/2]).

%___________ Top Input Processing ____________
% input_text_ESP -> word
translate_ESP(ESP, ENG):-
    atomic_list_concat(ESP_list, ' ', ESP),
    length(ESP_list, Len),
    Len is 1,
    word(ESP, ENG),!.

% input_text_ESP -> translation_text
translate_ESP(ESP, ENG):-
    atomic_list_concat(ESP_list, ' ', ESP),
    translation_text(ESP_list, [], ENG_list, []),
    atomic_list_concat(ENG_list, ' ', ENG),!.

% input_text_ENG -> word
translate_ENG(ENG, ESP):-
    atomic_list_concat(ENG_list, ' ', ENG),
    length(ENG_list, Len),
    Len is 1,
    word(ESP, ENG),!.

% input_text_ENG -> translation_text
translate_ENG(ENG, ESP):-
    atomic_list_concat(ENG_list, ' ', ENG),
    translation_text(ESP_list, [], ENG_list, []),
    atomic_list_concat(ESP_list, ' ', ESP),!.



%___________ Word ____________________________
% word -> noun | propper_noun | determinant | subject |
%         verb | adjective | preposition | quantifier | 
%         adverb | conjunction 
word(ESP, ENG):- pronoun(_, _, ESP, ENG); 
                 determinant(_, _, ESP, ENG); 
                 subject(_,_, ESP, ENG);
                 proper_noun(_, _, ESP, ENG); 
                 verb(_, _, _, ESP, ENG);
                 adjective(_, _, ESP, ENG);
                 preposition(ESP, ENG);
                 quantifier(ESP, ENG);
                 adverb(ESP, ENG);
                 conjunction(ESP, ENG);
                 punctuation_sign(ESP, ENG). 


%___________ Translation Text ________________
% translation_text -> phrase, phrase_left
translation_text(ESP, ESP_rest, ENG, ENG_rest):- 
    phrase(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    text_left(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).

% text_left -> empty
text_left([], _, [], _).

% text_left -> connector, translation_text
text_left(ESP, ESP_rest, ENG, ENG_rest):-  
    connector(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    translation_text(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


%___________ Connector _______________________
% connector -> conjunction
connector([Conjuncion|ESP_rest], ESP_rest, [Conjunction|ENG_rest], ENG_rest):-
    conjunction(Conjuncion, Conjunction).

% connector -> punctuation_sign
connector([Signo_puntuacion|ESP_rest], ESP_rest, [Punctuation_sign|ENG_rest], ENG_rest):-
    punctuation_sign(Signo_puntuacion, Punctuation_sign).


%___________ Phrase __________________________
% phrase -> phrase_noun
phrase(ESP, ESP_rest, ENG, ENG_rest):-  
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, _, _).


%___________ Phrase Noun _____________________
% phrase_noun -> determinant, subject, adjective
phrase_noun([Determinante, Sujeto, Adjetivo|ESP_rest], ESP_rest, [Determinant, Adjective, Subject|ENG_rest], ENG_rest, Number, third):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject),
    adjective(Gender, Number, Adjetivo, Adjective).

% phrase_noun -> determinant, subject, proper_noun
phrase_noun([Determinante, Sujeto, Nombre_propio|ESP_rest], ESP_rest, [Determinant, Subject, Proper_noun|ENG_rest], ENG_rest, Number, third):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject),
    proper_noun(Gender, Number, Nombre_propio, Proper_noun).

% phrase_noun -> determinant, subject
phrase_noun([Determinante, Sujeto|ESP_rest], ESP_rest, [Determinant, Subject|ENG_rest], ENG_rest, Number, third):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject).

% phrase_noun -> subject, adjective
phrase_noun([Sujeto, Adjetivo|ESP_rest], ESP_rest, [Adjective, Subject|ENG_rest], ENG_rest, Number, third):-
    subject(Gender, Number, Sujeto, Subject),
    adjective(Gender, Number, Adjetivo, Adjective).

% phrase_noun -> pronoun
phrase_noun([Pronombre|ESP_rest], ESP_rest, [Pronoun|ENG_rest], ENG_rest, Number, Person):-
    pronoun(Number, Person, Pronombre, Pronoun).

% phrase_noun -> pronoun
phrase_noun([Pronombre|ESP_rest], ESP_rest, [Pronoun|ENG_rest], ENG_rest, Number, Person):-
    pronoun(Number, Person, Pronombre, Pronoun).

% phrase_noun -> subject
phrase_noun([Sujeto|ESP_rest], ESP_rest, [Subject|ENG_rest], ENG_rest, Number, third):-
    subject(_, Number, Sujeto, Subject).

% phrase_noun -> subject
phrase_noun([Sujeto|ESP_rest], ESP_rest, [Subject|ENG_rest], ENG_rest, Number, third):-
    subject(_, Number, Sujeto, Subject).

% phrase_noun -> proper_noun
phrase_noun([Nombre_propio|ESP_rest], ESP_rest, [Proper_noun|ENG_rest], ENG_rest, Number, third):-
    proper_noun(_, Number, Nombre_propio, Proper_noun).

%_____________________________________________
determinant(male, singular, 'el', 'the').
determinant(female, singular, 'la', 'the').

pronoun(singular, third, 'ella', 'she').
pronoun(singular, first, 'yo', 'i').

proper_noun(male, singular, 'prolog', 'prolog').

subject(male, singular, 'carro', 'car'). 
subject(male, singular, 'lenguaje', 'language'). 
subject(female, singular, 'pista', 'track'). 

verb(singular, third, present, 'compite', 'competes').
verb(singular, third, present, 'tiene', 'has').
verb(singular, third, present, 'corre', 'runs').
verb(singular, first, present, 'salto', 'jump').

adjective(male, singular, 'grande', 'big').
adjective(male, singular, 'azul', 'blue').

preposition('en', 'in').

quantifier('un poco', 'a little').

adverb('pronto', 'soon').

conjunction('y', 'and').
conjunction('pero', 'but').

punctuation_sign('.', '.').
punctuation_sign(',', ',').
