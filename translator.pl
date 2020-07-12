
:-module(translator, [translate_ESP/2, translate_ENG/2]).

%___________ TOP INPUT PROCESSING ____________
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




%___________ WORD ____________________________
% word -> noun | propper_noun | determinant | subject |
%         verb | adjective | preposition | quantifier | 
%         adverb | conjunction 
word(ESP, ENG):- pronoun(_, _, _, ESP, ENG); 
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



%___________ TRANSLATION TEXT ________________
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



%___________ CONNECTOR _______________________
% connector -> punctuation_sign, conjunction
connector([Signo_puntuacion, Conjuncion|ESP_rest], ESP_rest, [Punctuation_sign, Conjunction|ENG_rest], ENG_rest):-
    punctuation_sign(Signo_puntuacion, Punctuation_sign),
    conjunction(Conjuncion, Conjunction).


% connector -> conjunction
connector([Conjuncion|ESP_rest], ESP_rest, [Conjunction|ENG_rest], ENG_rest):-
    conjunction(Conjuncion, Conjunction).


% connector -> punctuation_sign
connector([Signo_puntuacion|ESP_rest], ESP_rest, [Punctuation_sign|ENG_rest], ENG_rest):-
    punctuation_sign(Signo_puntuacion, Punctuation_sign).



%___________ PHRASE __________________________
% phrase -> phrase_noun, phrase_verb
% phrase(ESP, ESP_rest, ENG, ENG_rest):-  
%     phrase_noun(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Number, Person, Gender),
%     phrase_verb(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, Number, Person, Gender).


% phrase -> phrase_noun
phrase(ESP, ESP_rest, ENG, ENG_rest):-  
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, _, _, _).


% phrase -> phrase_verb
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_verb(ESP, ESP_rest, ENG, ENG_rest, _, _, _).


% phrase -> phrase_adverb
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).

%___________ PHRASE NOUN _____________________
% phrase_noun -> noun_core
phrase_noun(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    noun_core(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender).

% phrase_noun -> noun_core, noun_complement
phrase_noun(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    noun_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Number, Person, Gender),
    noun_complement(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, Number, Person, Gender).


% noun_core -> determinant, subject, adjective, proper_noun
noun_core([Determinante, Sujeto, Adjetivo, Nombre_propio|ESP_rest], ESP_rest, [Determinant, Adjective, Subject, Proper_noun|ENG_rest], ENG_rest, Number, third, Gender):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject),
    adjective(Gender, Number, Adjetivo, Adjective),
    proper_noun(Gender, Number, Nombre_propio, Proper_noun).


% noun_core -> determinant, subject, adjective
noun_core([Determinante, Sujeto, Adjetivo|ESP_rest], ESP_rest, [Determinant, Adjective, Subject|ENG_rest], ENG_rest, Number, third, Gender):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject),
    adjective(Gender, Number, Adjetivo, Adjective).


% noun_core -> determinant, subject, proper_noun
noun_core([Determinante, Sujeto, Nombre_propio|ESP_rest], ESP_rest, [Determinant, Subject, Proper_noun|ENG_rest], ENG_rest, Number, third, Gender):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject),
    proper_noun(Gender, Number, Nombre_propio, Proper_noun).


% noun_core -> subject, adjective
noun_core([Sujeto, Adjetivo|ESP_rest], ESP_rest, [Adjective, Subject|ENG_rest], ENG_rest, Number, third, Gender):-
    subject(Gender, Number, Sujeto, Subject),
    adjective(Gender, Number, Adjetivo, Adjective).


% noun_core -> determinant, subject
noun_core([Determinante, Sujeto|ESP_rest], ESP_rest, [Determinant, Subject|ENG_rest], ENG_rest, Number, third, Gender):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject).


% noun_core -> pronoun
noun_core([Pronombre|ESP_rest], ESP_rest, [Pronoun|ENG_rest], ENG_rest, Number, Person, Gender):-
    pronoun(Gender, Number, Person, Pronombre, Pronoun).


% noun_core -> subject
noun_core([Sujeto|ESP_rest], ESP_rest, [Subject|ENG_rest], ENG_rest, Number, third, Gender):-
    subject(Gender, Number, Sujeto, Subject).


% noun_core -> proper_noun
noun_core([Nombre_propio|ESP_rest], ESP_rest, [Proper_noun|ENG_rest], ENG_rest, Number, third, Gender):-
    proper_noun(Gender, Number, Nombre_propio, Proper_noun).


% noun_complement -> phrase_verb
noun_complement(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender).

% noun_complement -> phrase_preposition
noun_complement(ESP, ESP_rest, ENG, ENG_rest, _, _, _):-
    phrase_preposition(ESP, ESP_rest, ENG, ENG_rest).

%___________ PHRASE VERB _____________________
% phrase_verb -> verb, adjective
% with verb to be, matches phrase_noun and adjective gender
phrase_verb([Verbo, Adjetivo|ESP_rest], ESP_rest, [Verb, Adjective|ENG_rest], ENG_rest, Number, Person, Gender):-
    verb(Number, Person, _, Verbo, Verb),
    verb_to_be(Verb),
    adjective(Gender, Number, Adjetivo, Adjective).


% phrase_verb -> verb, adjective
phrase_verb([Verbo, Adjetivo|ESP_rest], ESP_rest, [Verb, Adjective|ENG_rest], ENG_rest, Number, Person, _):-
    verb(Number, Person, _, Verbo, Verb),
    adjective(_, Number, Adjetivo, Adjective).


% phrase_verb -> verb, phrase_noun
phrase_verb([Verbo|ESP_mid_rest], ESP_rest, [Verb|ENG_mid_rest], ENG_rest, Number, Person, _):-
    verb(Number, Person, _, Verbo, Verb),
    phrase_noun(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, _, Person, _).


% phrase_verb -> verb, phrase_adverb
phrase_verb([Verbo|ESP_mid_rest], ESP_rest, [Verb|ENG_mid_rest], ENG_rest, Number, Person, _):-
    verb(Number, Person, _, Verbo, Verb),
    phrase_adverb(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% phrase_verb -> verb
phrase_verb([Verbo|ESP_rest], ESP_rest, [Verb|ENG_rest], ENG_rest, Number, Person, _):-
    verb(Number, Person, _, Verbo, Verb).



%___________ PHRASE ADVERB ___________________
% phrase_adverb -> adverb_core
phrase_adverb(ESP, ESP_rest, ENG, ENG_rest):-
    adverb_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    phrase_preposition(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% phrase_adverb -> adverb_core
phrase_adverb(ESP, ESP_rest, ENG, ENG_rest):-
    adverb_core(ESP, ESP_rest, ENG, ENG_rest).


% adverb_core -> quantifier, adverb
adverb_core([Cuantificador, Adverbio|ESP_rest], ESP_rest, [Quantifier, Adverb|ENG_rest], ENG_rest):-
    quantifier(Cuantificador, Quantifier),
    adverb(Adverbio, Adverb).


% adverb_core -> adverb
adverb_core([Adverbio|ESP_rest], ESP_rest, [Adverb|ENG_rest], ENG_rest):-
    adverb(Adverbio, Adverb).



%___________ PHRASE PREPOSITION ______________
% phrase_preposition -> preposition, preposition_complement
phrase_preposition([Preposicion|ESP_mid_rest], ESP_rest, [Preposition|ENG_mid_rest], ENG_rest):-
    preposition(Preposicion, Preposition),
    preposition_complement(ESP_mid_rest, ESP_rest,ENG_mid_rest, ENG_rest).


% preposition_complement -> phrase_noun
preposition_complement(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, _, _, _).


% preposition_complement -> phrase_adverb
preposition_complement(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).


% preposition_complement -> phrase_adverb
preposition_complement(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, _, _).



%___________ PHRASE ADJECTIVE ________________
% phrase_adjective -> adjective_core
phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Genre, Person):-
    adjective_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Genre, Person),
    phrase_preposition(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% phrase_adjective -> adjective_core
phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Genre, Person):-
    adjective_core(ESP, ESP_rest, ENG, ENG_rest, Genre, Person).


% adjective_core -> quantifier, adjective
adjective_core([Cuantificador, Adjetivo|ESP_rest], ESP_rest, [Quantifier, Adjective|ENG_rest], ENG_rest, Genre, Person):-
    quantifier(Cuantificador, Quantifier),
    adjective(Genre, Person, Adjetivo, Adjective).


% adjective_core -> adjective
adjective_core([Adjetivo|ESP_rest], ESP_rest, [Adjective|ENG_rest], ENG_rest, Genre, Person):-
    adjective(Genre, Person, Adjetivo, Adjective).



%_____________________________________________
determinant(male, singular, 'el', 'the').
determinant(female, singular, 'la', 'the').

pronoun(female, singular, third, 'ella', 'she').
pronoun(_, singular, first, 'yo', 'i').

proper_noun(male, singular, 'prolog', 'prolog').

subject(male, singular, 'carro', 'car'). 
subject(male, singular, 'lenguaje', 'language'). 
subject(female, singular, 'pista', 'track'). 

verb(singular, third, present, 'compite', 'competes').
verb(singular, third, present, 'tiene', 'has').
verb(singular, third, present, 'corre', 'runs').
verb(singular, first, present, 'salto', 'jump').
verb(singular, third, present, 'salta', 'jumps').
verb(singular, third, present, 'es', 'is').

verb_to_be('is').

adjective(male, singular, 'grande', 'big').
adjective(male, singular, 'azul', 'blue').
adjective(male, singular, 'lento', 'slow').
adjective(female, singular, 'lenta', 'slow').

preposition('en', 'in').
preposition('de', 'of').
preposition('con', 'with').

quantifier('muy', 'very').
quantifier('un poco', 'a little').

adverb('pronto', 'soon').
adverb('cerca', 'near').
adverb('aqui', 'here').

conjunction('y', 'and').
conjunction('pero', 'but').

punctuation_sign('.', '.').
punctuation_sign(',', ',').
