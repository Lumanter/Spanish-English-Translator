
:-module(translator, [translate_ESP/2, translate_ENG/2]).

%_____________________________________________
% translate_ESP: Translates text, with single quotes, from spanish to english. 
%                Can't be used the other way around due to text to list conversion indefinitions.
%
% Params: ESP - input spanish text
%         ENG  - output translated english text
%_____________________________________________
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



%_____________________________________________
% translate_ENG: Translates text, with single quotes, from english to spanish. 
%                Can't be used the other way around due to text to list conversion indefinitions.
%
% Params: ENG - input english text
%         ESP  - output translated spanish text
%_____________________________________________
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



%_____________________________________________
% word: Translates a single word, with single quotes, 
%       from english to spanish and the other way around. 
%
% Params: ESP - word in spanish
%         ENG  - word in english
%_____________________________________________
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



%_____________________________________________
% translation_text: Translates a list of words from english to spanish,
%                   and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
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



%_____________________________________________
% connector: Grammar connector, used to link two grammar phrases. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
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



%_____________________________________________
% phrase: Translates a phrase, as list of words, from english to spanish
%         and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% phrase -> phrase_noun
phrase(ESP, ESP_rest, ENG, ENG_rest):-  
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, _, _, _).


% phrase -> phrase_verb
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_verb(ESP, ESP_rest, ENG, ENG_rest, _, _, _).


% phrase -> phrase_adverb
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).



%_____________________________________________
% phrase_noun: Translates a noun phrase (sintagma nominal in spanish), as list of words, 
%              from english to spanish and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Gender - grammatical gender of the grammar particle
%_____________________________________________
% phrase_noun -> noun_core, noun_complement
phrase_noun(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    noun_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Number, Person, Gender),
    noun_complement(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, Number, Person, Gender).

% phrase_noun -> noun_core
phrase_noun(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    noun_core(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender).



%_____________________________________________
% noun_core: Translates the core of the noun phrase (sintagma nominal in spanish), as list of words, 
%            from english to spanish and the other way around. 
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Gender - grammatical gender of the grammar particle
%_____________________________________________
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


% noun_core -> determinant, pre_noun_adjective, subject
noun_core([Determinante, Pre_sujeto_adjetivo, Sujeto|ESP_rest], ESP_rest, [Determinant, Pre_noun_adjective, Subject|ENG_rest], ENG_rest, Number, third, Gender):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject),
    pre_noun_adjective(Gender, Number, Pre_sujeto_adjetivo, Pre_noun_adjective).


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



%_____________________________________________
% noun_complement: Translates the complement of the noun phrase (sintagma nominal in spanish), 
%                  as list of words, from english to spanish and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Gender - grammatical gender of the grammar particle
%_____________________________________________
% noun_complement -> phrase_verb
noun_complement(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender).


% noun_complement -> phrase_preposition
noun_complement(ESP, ESP_rest, ENG, ENG_rest, _, _, _):-
    phrase_preposition(ESP, ESP_rest, ENG, ENG_rest).


% noun_complement -> phrase_adverb
noun_complement(ESP, ESP_rest, ENG, ENG_rest, _, _, _):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).



%_____________________________________________
% phrase_verb: Translates a verb phrase (sintagma verbal in spanish), 
%              as list of words, from english to spanish and the other way around. 
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Gender - grammatical gender of the grammar particle
%_____________________________________________
% phrase_verb -> verb_core, verb_complement
phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    verb_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Number, Person, Gender),
    verb_complement(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, Number, Person).


% verb -> verb_core
phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    verb_core(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender).



%_____________________________________________
% verb_core: Translates the core of the verb phrase (sintagma verbal in spanish), as list of words, 
%            from english to spanish and the other way around. 
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Gender - grammatical gender of the grammar particle
%_____________________________________________
% verb_core -> verb, adjective
% with verb to be, matches phrase_noun and adjective gender
verb_core([Verbo, Adjetivo|ESP_rest], ESP_rest, [Verb, Adjective|ENG_rest], ENG_rest, Number, Person, Gender):-
    verb(Number, Person, _, Verbo, Verb),
    verb_to_be(Verb),
    adjective(Gender, Number, Adjetivo, Adjective).


% verb_core -> verb, adjective
verb_core([Verbo, Adjetivo|ESP_rest], ESP_rest, [Verb, Adjective|ENG_rest], ENG_rest, Number, Person, _):-
    verb(Number, Person, _, Verbo, Verb),
    adjective(_, Number, Adjetivo, Adjective).


% verb_core -> verb, phrase_adjective
verb_core([Verbo|ESP_mid_rest], ESP_rest, [Verb|ENG_mid_rest], ENG_rest, Number, Person, _):-
    verb(Number, Person, _, Verbo, Verb),
    phrase_adjective(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, _, _).



%_____________________________________________
% verb_complement: Translates the complement of the verb phrase (sintagma verbal in spanish), 
%                  as list of words, from english to spanish and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%_____________________________________________
% verb_complement -> phrase_noun
verb_complement(ESP, ESP_rest, ENG, ENG_rest, Number, Person):-
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, Number, Person, _).


% verb_complement -> phrase_adverb
verb_complement(ESP, ESP_rest, ENG, ENG_rest, _, _):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).



%_____________________________________________
% phrase_adverb: Translates a adverb phrase (sintagma adverbial in spanish), 
%              as list of words, from english to spanish and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% phrase_adverb -> adverb_core
phrase_adverb(ESP, ESP_rest, ENG, ENG_rest):-
    adverb_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    phrase_preposition(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% phrase_adverb -> adverb_core
phrase_adverb(ESP, ESP_rest, ENG, ENG_rest):-
    adverb_core(ESP, ESP_rest, ENG, ENG_rest).



%_____________________________________________
% adverb_core: Translates the core of a adverb phrase (sintagma adverbial in spanish), 
%              as list of words, from english to spanish and the other way around. 
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% adverb_core -> quantifier, adverb
adverb_core([Cuantificador, Adverbio|ESP_rest], ESP_rest, [Quantifier, Adverb|ENG_rest], ENG_rest):-
    quantifier(Cuantificador, Quantifier),
    adverb(Adverbio, Adverb).


% adverb_core -> adverb
adverb_core([Adverbio|ESP_rest], ESP_rest, [Adverb|ENG_rest], ENG_rest):-
    adverb(Adverbio, Adverb).



%_____________________________________________
% phrase_preposition: Translates a preposition phrase (sintagma preposicional in spanish), 
%                     as list of words, from english to spanish and the other way around. 
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% phrase_preposition -> preposition, preposition_complement
phrase_preposition([Preposicion|ESP_mid_rest], ESP_rest, [Preposition|ENG_mid_rest], ENG_rest):-
    preposition(Preposicion, Preposition),
    preposition_complement(ESP_mid_rest, ESP_rest,ENG_mid_rest, ENG_rest).



%_____________________________________________
% preposition_complement: Translates the complement of a preposition phrase (sintagma preposicional in spanish), 
%                         as list of words, from english to spanish and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% preposition_complement -> phrase_noun
preposition_complement(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, _, _, _).


% preposition_complement -> phrase_adverb
preposition_complement(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).


% preposition_complement -> phrase_adverb
preposition_complement(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, _, _).



%_____________________________________________
% phrase_adjective: Translates an adjective phrase (sintagma adjectival in spanish), 
%                   as list of words, from english to spanish and the other way around. 
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Gender - grammatical gender of the grammar particle
%         Person - grammatical person of the grammar particle
%_____________________________________________
% phrase_adjective -> adjective_core
phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Gender, Person):-
    adjective_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Gender, Person),
    phrase_preposition(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% phrase_adjective -> adjective_core
phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Gender, Person):-
    adjective_core(ESP, ESP_rest, ENG, ENG_rest, Gender, Person).



%_____________________________________________
% adjective_core: Translates the core of an adjective phrase (sintagma adjectival in spanish), 
%                 as list of words, from english to spanish and the other way around. 
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Gender - grammatical gender of the grammar particle
%         Person - grammatical person of the grammar particle
%_____________________________________________
% adjective_core -> quantifier, adjective
adjective_core([Cuantificador, Adjetivo|ESP_rest], ESP_rest, [Quantifier, Adjective|ENG_rest], ENG_rest, Gender, Person):-
    quantifier(Cuantificador, Quantifier),
    adjective(Gender, Person, Adjetivo, Adjective).


% adjective_core -> adjective
adjective_core([Adjetivo|ESP_rest], ESP_rest, [Adjective|ENG_rest], ENG_rest, Gender, Person):-
    adjective(Gender, Person, Adjetivo, Adjective).




%_____________ Knowledge Database ____________

%_____________________________________________
% determinant: Creates correspondence between a grammar determinant in Spanish and English.
%
% Structure: determinant(Gender, Number, ESP, ENG)
%
% Params: Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
determinant(male, singular, 'el', 'the').
determinant(male, plural, 'los', 'the').
determinant(female, singular, 'la', 'the').

%_____________________________________________
% pronoun: Creates correspondence between a grammar pronoun in Spanish and English.
%
% Structure: pronoun(Gender, Number, Person, ESP, ENG)
%
% Params: Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         Person - grammatical number of the grammar person
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
pronoun(female, singular, third, 'ella', 'she').
pronoun(_, singular, first, 'yo', 'i').
pronoun(male, singular, third, 'uno', 'one').


%_____________________________________________
% proper_noun: Creates correspondence between a grammar proper pronoun in Spanish and English.
%
% Structure: proper_noun(Gender, Number, ESP, ENG)
%
% Params: Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
proper_noun(male, singular, 'prolog', 'prolog').


%_____________________________________________
% subject: Creates correspondence between a grammar subject in Spanish and English.
%
% Structure: subject(Gender, Number, ESP, ENG)
%
% Params: Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
subject(male, singular, 'carro', 'car'). 
subject(male, singular, 'ladron', 'thief'). 
subject(male, plural, 'lenguajes', 'languages'). 
subject(female, singular, 'pista', 'track'). 
subject(female, singular, 'programacion', 'programming'). 


%_____________________________________________
% verb: Creates correspondence between a grammar verb in Spanish and English.
%
% Structure: verb(Number, Person, Time, ESP, ENG)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
verb(singular, third, present, 'compite', 'competes').
verb(singular, third, present, 'tiene', 'has').
verb(singular, third, present, 'corre', 'runs').
verb(singular, first, present, 'salto', 'jump').
verb(singular, third, present, 'salta', 'jumps').
verb(singular, third, present, 'es', 'is').


%_____________________________________________
% verb_to_be: Confirms that a verb is a form of the english verb to be.
%
% Structure: verb_to_be(Verb)
%
% Params: Verb - word in english
%_____________________________________________
verb_to_be('is').


%_____________________________________________
% adjective: Creates correspondence between a grammar adjective in Spanish and English.
%
% Structure: adjective(Gender, Number, ESP, ENG)
%
% Params: Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
adjective(male, singular, 'grande', 'big').
adjective(male, singular, 'ladron', 'thief').
adjective(male, singular, 'azul', 'blue').
adjective(male, singular, 'lento', 'slow').
adjective(female, singular, 'lenta', 'slow').
adjective(female, singular, 'logica', 'logical').


%_____________________________________________
% pre_noun_adjective: Creates correspondence between a grammar pre noun adjective (hyperbaton) in Spanish and English.
%
% Structure: pre_noun_adjective(Gender, Number, ESP, ENG)
%
% Params: Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
pre_noun_adjective(male, plural, 'primeros', 'first').


%_____________________________________________
% preposition: Creates correspondence between a grammar preposition in Spanish and English.
%
% Structure: preposition(ESP, ENG)
%
% Params: ESP - word in spanish
%         ENG - word in english
%_____________________________________________
preposition('en', 'in').
preposition('de', 'of').
preposition('con', 'with').


%_____________________________________________
% quantifier: Creates correspondence between a grammar quantifier in Spanish and English.
%
% Structure: quantifier(ESP, ENG)
%
% Params: ESP - word in spanish
%         ENG - word in english
%_____________________________________________
quantifier('muy', 'very').
quantifier('un poco', 'a little').


%_____________________________________________
% adverb: Creates correspondence between a grammar adverb in Spanish and English.
%
% Structure: adverb(ESP, ENG)
%
% Params: ESP - word in spanish
%         ENG - word in english
%_____________________________________________
adverb('pronto', 'soon').
adverb('cerca', 'near').
adverb('aqui', 'here').


%_____________________________________________
% conjunction: Creates correspondence between a grammar conjunction in Spanish and English.
%
% Structure: conjunction(ESP, ENG)
%
% Params: ESP - word in spanish
%         ENG - word in english
%_____________________________________________
conjunction('y', 'and').
conjunction('pero', 'but').

%_____________________________________________
% punctuation_sign: Creates correspondence between a grammar punctuation_sign in Spanish and English. 
%                   Not really translated but used for the overall translation.
%
% Structure: punctuation_sign(ESP, ENG)
%
% Params: ESP - word in spanish
%         ENG - word in english
%_____________________________________________
punctuation_sign('.', '.').
punctuation_sign(',', ',').
