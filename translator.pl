
:-module(translator, [translate_ESP/2, translate_ENG/2]).

%_____________________________________________
% translate_ESP: Translates text, with single quotes, from spanish to english. 
%                Can't be used the other way around due to text to list conversion indefinitions.
%
% Structure: translate_ESP(ESP, ENG)
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
% Structure: translate_ENG(ENG, ESP)
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
% Structure: word(ESP, ENG)
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
                 conjunction(ESP, ENG).



%_____________________________________________
% translation_text: Translates a list of words from english to spanish,
%                   and the other way around. 
%
% Structure: translation_text(ESP, ESP_rest, ENG, ENG_rest)
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
% Structure: connector(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% connector -> punctuation_sign, conjunction
connector([Punctuation_sign, Conjuncion|ESP_rest], ESP_rest, [Punctuation_sign, Conjunction|ENG_rest], ENG_rest):-
    punctuation_sign(Punctuation_sign),
    conjunction(Conjuncion, Conjunction).


% connector -> conjunction
connector([Conjuncion|ESP_rest], ESP_rest, [Conjunction|ENG_rest], ENG_rest):-
    conjunction(Conjuncion, Conjunction).


% connector -> punctuation_sign
connector([Punctuation_sign|ESP_rest], ESP_rest, [Punctuation_sign|ENG_rest], ENG_rest):-
    punctuation_sign(Punctuation_sign).



%_____________________________________________
% phrase: Translates a phrase, as list of words, from english to spanish
%         and the other way around. 
%
% Structure: phrase(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% phrase -> question
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    question(ESP, ESP_rest, ENG, ENG_rest).


% phrase -> phrase_noun
phrase(ESP, ESP_rest, ENG, ENG_rest):-  
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, _, _, _).

% phrase -> phrase_verb
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_verb(ESP, ESP_rest, ENG, ENG_rest, _, _, _).


% phrase -> phrase_adverb
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).


% phrase -> phrase_exclamation
phrase(ESP, ESP_rest, ENG, ENG_rest):-
    phrase_exclamation(ESP, ESP_rest, ENG, ENG_rest).



%_____________________________________________
% phrase_noun: Translates a noun phrase (sintagma nominal in spanish), as list of words, 
%              from english to spanish and the other way around. 
%
% Structure: phrase_noun(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender)
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
% Structure: noun_core(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender)
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


% noun_core -> determinant, subject, adjective, adjective
noun_core([Determinante, Sujeto, Adjetivo_1, Adjetivo_2|ESP_rest], ESP_rest, [Determinant, Adjective_1, Adjective_2, Subject|ENG_rest], ENG_rest, Number, third, Gender):-
    determinant(Gender, Number, Determinante, Determinant),
    subject(Gender, Number, Sujeto, Subject),
    adjective(Gender, Number, Adjetivo_1, Adjective_1),
    adjective(Gender, Number, Adjetivo_2, Adjective_2).


% noun_core -> determinant, subject_compound
noun_core([Determinante, Sujeto_1, Adverbio, Sujeto_2|ESP_rest], ESP_rest, [Determinant, Subject_2, Subject_1|ENG_rest], ENG_rest, Number, third, Gender):-
    determinant(Gender, Number, Determinante, Determinant),
    subject_compound(Gender, Number, Sujeto_1, Adverbio, Sujeto_2, Subject_2, Subject_1). 


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


% noun_core -> subject, adjective, adjective
noun_core([Sujeto, Adjetivo_1, Adjetivo_2|ESP_rest], ESP_rest, [Adjective_1, Adjective_2, Subject|ENG_rest], ENG_rest, Number, third, Gender):-
    subject(Gender, Number, Sujeto, Subject),
    adjective(Gender, Number, Adjetivo_1, Adjective_1),
    adjective(Gender, Number, Adjetivo_2, Adjective_2).


% noun_core -> subject_compound
noun_core([ Sujeto_1, Adverbio, Sujeto_2|ESP_rest], ESP_rest, [Subject_2, Subject_1|ENG_rest], ENG_rest, Number, third, Gender):-
    subject_compound(Gender, Number, Sujeto_1, Adverbio, Sujeto_2, Subject_2, Subject_1). 



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
% Structure: noun_complement(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender)
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
% Structure: phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender)
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
% with verb to be, matches phrase_noun and adjective gender
phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender):-
    verb_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Number, Person, Verb),
    verb_to_be(Verb),
    verb_complement(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, Number, Person, Gender).


% phrase_verb -> verb_core, verb_complement
phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, _):-
    verb_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Number, Person, _),
    verb_complement(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, Number, Person, _).


% phrase_verb -> verb_core
phrase_verb(ESP, ESP_rest, ENG, ENG_rest, Number, Person, _):-
    verb_core(ESP, ESP_rest, ENG, ENG_rest, Number, Person, _).



%_____________________________________________
% verb_core: Translates the core of the verb phrase (sintagma verbal in spanish), as list of words, 
%            from english to spanish and the other way around. 
%
% Structure: verb_core(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Verb)
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Verb - the matched verb in english (used for verb to be check)
%_____________________________________________
% verb_core -> verb_conjugated
verb_core(ESP, ESP_rest, ENG, ENG_rest, Number, Person, _):-
    verb_conjugated(ESP, ESP_rest, ENG, ENG_rest, Number, Person, _).


% verb_core -> verb
% with verb to be, matches phrase_noun and adjective gender
verb_core([Verbo|ESP_rest], ESP_rest, [Verb|ENG_rest], ENG_rest, Number, Person, Verb):-
    verb(Number, Person, _, Verbo, Verb),
    verb_to_be(Verb).


% verb_core -> verb
verb_core([Verbo|ESP_rest], ESP_rest, [Verb|ENG_rest], ENG_rest, Number, Person, Verb):-
    verb(Number, Person, _, Verbo, Verb).


% verb_core -> verb_exception
verb_core([Verbo|ESP_rest], ESP_rest, [Pronoun, Verb|ENG_rest], ENG_rest, Number, Person, Verb):-
    verb_exception(Number, Person, _, Verbo, Pronoun, Verb).

%_____________________________________________
% verb_conjugated: Translates a conjutated verb, as list of words, 
%                  from english to spanish and the other way around. 
%
% Structure: verb_conjugated(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Time)
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%_____________________________________________
% verb_conjugated -> verb_conjugated_3x3
verb_conjugated([Verbo_1, Verbo_2, Verbo_Accion|ESP_rest], ESP_rest, [Verb_1, Verb_2, Verb_action|ENG_rest], ENG_rest, Number, Person, Time):-
    verb_conjugated_3x3(Number, Person, Time, Verbo_1, Verbo_2, Verbo_Accion, Verb_1, Verb_2, Verb_action).


% verb_conjugated -> verb_conjugated_2x3
verb_conjugated([Verbo_1, Verbo_Accion|ESP_rest], ESP_rest, [Verb_1, Verb_2, Verb_action|ENG_rest], ENG_rest, Number, Person, Time):-
    verb_conjugated_2x3(Number, Person, Time, Verbo_1, Verbo_Accion, Verb_1, Verb_2, Verb_action).


% verb_conjugated -> verb_conjugated_2x2
verb_conjugated([Verbo_1, Verbo_Accion|ESP_rest], ESP_rest, [Verb_1, Verb_action|ENG_rest], ENG_rest, Number, Person, Time):-
    verb_conjugated_2x2(Number, Person, Time, Verbo_1, Verbo_Accion, Verb_1, Verb_action).


% verb_conjugated -> verb_conjugated_2x2
verb_conjugated([Verbo_Accion|ESP_rest], ESP_rest, [Verb_1, Verb_action|ENG_rest], ENG_rest, Number, Person, Time):-
    verb_conjugated_2x1(Number, Person, Time, Verbo_Accion, Verb_1, Verb_action).


%_____________________________________________
% verb_complement: Translates the complement of the verb phrase (sintagma verbal in spanish), 
%                  as list of words, from english to spanish and the other way around. 
%
% Structure: verb_complement(ESP, ESP_rest, ENG, ENG_rest, Number, Person, Gender)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Gender - grammatical gender of the grammar particle
%_____________________________________________
% verb_complement -> phrase_noun
verb_complement(ESP, ESP_rest, ENG, ENG_rest, Number, _, _):-
    phrase_noun(ESP, ESP_rest, ENG, ENG_rest, Number, _, _).


% verb_complement -> phrase_adverb
verb_complement(ESP, ESP_rest, ENG, ENG_rest, _, _, _):-
    phrase_adverb(ESP, ESP_rest, ENG, ENG_rest).


% verb_complement -> phrase_preposition
verb_complement(ESP, ESP_rest, ENG, ENG_rest, _, _, _):-
    phrase_preposition(ESP, ESP_rest, ENG, ENG_rest).


% verb_complement -> phrase_adjective
verb_complement(ESP, ESP_rest, ENG, ENG_rest, Number, _, Gender):-
    phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Gender, Number).



%_____________________________________________
% phrase_adverb: Translates a adverb phrase (sintagma adverbial in spanish), 
%              as list of words, from english to spanish and the other way around. 
%
% Structure: phrase_adverb(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% phrase_adverb -> adverb_core, phrase_preposition
phrase_adverb(ESP, ESP_rest, ENG, ENG_rest):-
    adverb_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    phrase_preposition(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% phrase_adverb -> adverb_core, phrase_adjective
phrase_adverb(ESP, ESP_rest, ENG, ENG_rest):-
    adverb_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    phrase_adjective(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, _, _).


% phrase_adverb -> adverb_core
phrase_adverb(ESP, ESP_rest, ENG, ENG_rest):-
    adverb_core(ESP, ESP_rest, ENG, ENG_rest).



%_____________________________________________
% adverb_core: Translates the core of a adverb phrase (sintagma adverbial in spanish), 
%              as list of words, from english to spanish and the other way around. 
%
% Structure: adverb_core(ESP, ESP_rest, ENG, ENG_rest)
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
% Structure: phrase_preposition(ESP, ESP_rest, ENG, ENG_rest)
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
% Structure: preposition_complement(ESP, ESP_rest, ENG, ENG_rest)
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



%_____________________________________________
% phrase_adjective: Translates an adjective phrase (sintagma adjectival in spanish), 
%                   as list of words, from english to spanish and the other way around. 
%
% Structure: phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Gender, Number)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%_____________________________________________
% phrase_adjective -> adjective_core
phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Gender, Number):-
    adjective_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Gender, Number),
    phrase_preposition(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% phrase_adjective -> adjective_core
phrase_adjective(ESP, ESP_rest, ENG, ENG_rest, Gender, Number):-
    adjective_core(ESP, ESP_rest, ENG, ENG_rest, Gender, Number).



%_____________________________________________
% adjective_core: Translates the core of an adjective phrase (sintagma adjectival in spanish), 
%                 as list of words, from english to spanish and the other way around. 
%
% Structure: adjective_core(ESP, ESP_rest, ENG, ENG_rest, Gender, Number)
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%_____________________________________________
% adjective_core -> quantifier, adjective
adjective_core([Cuantificador, Adjetivo|ESP_rest], ESP_rest, [Quantifier, Adjective|ENG_rest], ENG_rest, Gender, Number):-
    quantifier(Cuantificador, Quantifier),
    adjective(Gender, Number, Adjetivo, Adjective).


% adjective_core -> adjective
adjective_core([Adjetivo|ESP_rest], ESP_rest, [Adjective|ENG_rest], ENG_rest, Gender, Number):-
    adjective(Gender, Number, Adjetivo, Adjective).



%_____________________________________________
% phrase_exclamation: Translates a exclamation phrase, as list of words, 
%                     from english to spanish and the other way around. 
%
% Structure: phrase_exclamation(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP (implicit as first parameter)- input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% phrase_exclamation -> interjection, exclamation_sign
phrase_exclamation([Interjeccion, '!'|ESP_rest], ESP_rest, [Interjection,'!'|ENG_rest], ENG_rest):-
    interjection(Interjeccion, Interjection).


%_____________________________________________
% question: Translates a question, as list of words, 
%           from english to spanish and the other way around. 
%
% Structure: question(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% question -> question_wh, question_mark
question(ESP, ESP_rest, ENG, ENG_rest):-
    question_wh(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    question_mark(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


% question -> question_yes_no, question_mark
question(ESP, ESP_rest, ENG, ENG_rest):-
    question_yes_no(ESP, ESP_mid_rest, ENG, ENG_mid_rest),
    question_mark(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest).


%_____________________________________________
% question_mark: Matches a question mark in the spanish and english word lists.
%
% Structure: question_mark(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% question_mark -> '?'
question_mark(['?'|ESP_rest], ESP_rest, ['?'|ENG_rest], ENG_rest).



%_____________________________________________
% question: Translates a wh question(with who, where, what etc), as list of words, 
%           from english to spanish and the other way around. 
%
% Structure: question_wh(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% question_wh -> question_wh_3x3
question_wh([Palabra_wh, Verbo, Sujeto|ESP_rest], ESP_rest, [Word_wh, Verb, Subject|ENG_rest], ENG_rest):-
    question_wh_3x3(Palabra_wh, Verbo, Sujeto, Word_wh, Verb, Subject).


% question_wh -> question_wh_3x2
question_wh([Palabra_wh, Verbo|ESP_rest], ESP_rest, [Word_wh, Verb, Subject|ENG_rest], ENG_rest):-
    question_wh_3x2(Palabra_wh, Verbo, Word_wh, Verb, Subject).


%_____________________________________________
% question_yes_no: Translates a yes/no question, as list of words, 
%                  from english to spanish and the other way around. 
%
% Structure: question_yes_no(ESP, ESP_rest, ENG, ENG_rest)
%
% Params: ESP - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG  - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%_____________________________________________
% question_yes_no -> question_core
question_yes_no(ESP, ESP_rest, ENG, ENG_rest):-
    question_core(ESP, ESP_mid_rest, ENG, ENG_mid_rest, Gender, Number, Person, Time, Verb_main, Verbo_principal),
    question_complement(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, Gender, Number, Person, Time, Verb_main, Verbo_principal).


%_____________________________________________
% question_core: Translates the core of a yes/no question, as list of words, 
%                from english to spanish and the other way around. 
%
% Structure: question_core(ESP, ESP_rest, ENG, ENG_rest, Gender, Number, Person, Time, Verb_main, Verbo_principal)
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         Verb_main - question main verb in english, used for checking if it is a verb to be
%         Verbo_principal - question main verb in spanish, used for checking if it is a verb to be
%_____________________________________________
% question_core -> question_core_2x2
question_core([Sujeto, Verbo|ESP_rest], ESP_rest, [Verb, Subject|ENG_rest], ENG_rest, Gender, Number, Person, Time, Verb, Verbo):-
    question_core_2x2(Gender, Number, Person, Time, Sujeto, Verbo, Verb, Subject).


% question_core -> question_core_2x1
question_core([Sujeto|ESP_rest], ESP_rest, [Verb, Subject|ENG_rest], ENG_rest, Gender, Number, Person, Time, Verb, _):-
    question_core_2x1(Gender, Number, Person, Time, Sujeto, Verb, Subject).



%_____________________________________________
% question_complement: Translates the complement of a yes/no question, as list of words, 
%                      from english to spanish and the other way around. 
%
% Structure: question_complement(ESP, ESP_rest, ENG, ENG_rest, Gender, Number, Person, Time, Verb_main, Verbo_principal)
%
% Params: ESP (implicit as first parameter) - input word list in spanish
%         ESP_rest - output word list in spanish, used to traverse the spanish input list
%         ENG (implicit as third parameter) - input word list in english
%         ENG_rest - output word list in english, used to traverse the english input list
%         Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         Main_verb - question main verb, used for checking if it is a verb to be
%         Verbo_principal - question main verb in spanish, used for checking if it is a verb to be
%_____________________________________________
% question_complement -> verb_present_continous, noun_core
question_complement([Verbo|ESP_mid_rest], ESP_rest, [Verb|ENG_mid_rest], ENG_rest, _, Number, Person, present, Verb_main, _):-
    verb_to_be(Verb_main),
    verb_present_continous(Number, Person, Verbo, Verb),
    noun_core(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, _, _, _).


% question_complement -> verb_question_infinitive, noun_core
question_complement([Verbo|ESP_mid_rest], ESP_rest, [Verb|ENG_mid_rest], ENG_rest, _, Number, Person, Time, _, _):-
    verb_question_infinitive(Number, Person, Time, Verbo, Verb),
    noun_core(ESP_mid_rest, ESP_rest, ENG_mid_rest, ENG_rest, _, _, _).


% question_complement -> adjective
question_complement([Adjetivo|ESP_rest], ESP_rest, [Adjective|ENG_rest], ENG_rest, Gender, Number, _, _, Verb_main, Verbo_principal):-
    verb_to_be(Verb_main),
    verb_to_be(Verbo_principal),
    adjective(Gender, Number, Adjetivo, Adjective).

% question_complement -> verb_present_continous
question_complement([Verbo|ESP_rest], ESP_rest, [Verb|ENG_rest], ENG_rest, _, Number, Person, present, Main_verb, _):-
    verb_to_be(Main_verb),
    verb_present_continous(Number, Person, Verbo, Verb).


% question_complement -> verb_question_infinitive
question_complement([Verbo|ESP_rest], ESP_rest, [Verb|ENG_rest], ENG_rest, _, Number, Person, Time, _, _):-
    verb_question_infinitive(Number, Person, Time, Verbo, Verb).



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
determinant(male, singular, 'un', 'a').
determinant(male, plural, 'los', 'the').
determinant(female, singular, 'la', 'the').
determinant(female, plural, 'las', 'the').

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
pronoun(male, singular, third, 'e*l', 'he').
pronoun(_, singular, first, 'yo', 'i').
pronoun(male, singular, third, 'uno', 'one').
pronoun(male, plural, third, 'ellos', 'they').


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
subject(female, singular, 'lingui*stica', 'linguistics'). 
subject(male, singular, 'mono', 'monkey'). 
subject(male, singular, 'estudiante', 'student'). 
subject(male, singular, 'ladro*n', 'thief'). 
subject(male, plural, 'lenguajes', 'languages'). 
subject(female, plural, 'flores', 'flowers'). 
subject(female, singular, 'pista', 'track'). 
subject(female, singular, 'programacio*n', 'programming'). 


%_____________________________________________
% subject_compound: Creates correspondence between a grammar compound subject 
%                   (more than one word subject that is threated as an individual particle) in Spanish and English.
%
% Structure: subject_compound(Gender, Number, Sujeto_1, Adverbio, Sujeto_2, Subject_2, Subject_1)
%
% Params: Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         Sujeto_1 - first subject word in spanish
%         Adverbio - adverb word in spanish
%         Sujeto_2 - second subject word in spanish
%         Subject_2 - second subject word in english
%         Subject_1 - first subject word in english
%_____________________________________________
subject_compound(male, singular, 'lenguaje', 'de', 'programacio*n', 'programming', 'language'). 


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
verb(singular, third, past, 'corrio*', 'ran').
verb(singular, first, present, 'salto', 'jump').
verb(singular, third, present, 'salta', 'jumps').
verb(singular, third, present, 'es', 'is').
verb(plural, third, present, 'son', 'are').


%_____________________________________________
% verb_conjugated_3x3: Creates correspondence between a 3x3 particles translation relationship 
%                      in a conjugated verb in Spanish and English.
%
% Structure: verb_conjugated_3x3(Number, Person, Time, Verbo_1, Verbo_2, Verbo_Accion, Verb_1, Verb_2, Verb_action)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         Verbo_1 - first verb in spanish
%         Verbo_2 - second verb in spanish
%         Verbo_Accion - action verb in spanish
%         Verb_1 - first verb in english
%         Verb_2 - second verb in english
%         Verb_Action - action verb in english
%_____________________________________________
verb_conjugated_3x3(singular, third, past, 'ha', 'estado', 'corriendo', 'has', 'been', 'running').
verb_conjugated_3x3(singular, third, past, 'ha', 'estado', 'programando', 'has', 'been', 'coding').

%_____________________________________________
% verb_conjugated_2x3: Creates correspondence between a 2x3 particles translation relationship 
%                      in a conjugated verb in Spanish and English.
%
% Structure: verb_conjugated_2x3(Number, Person, Time, Verbo_1, Verbo_Accion, Verb_1, Verb_2, Verb_action)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         Verbo_1 - first verb in spanish
%         Verbo_Accion - action verb in spanish
%         Verb_1 - first verb in english
%         Verb_2 - second verb in english
%         Verb_Action - action verb in english
%_____________________________________________
verb_conjugated_2x3(singular, third, future, 'estara*', 'trabajando', 'will', 'be', 'working').
verb_conjugated_2x3(singular, third, future, 'estara*', 'durmiendo', 'will', 'be', 'sleeping').


%_____________________________________________
% verb_conjugated_2x2: Creates correspondence between a 2x2 particles translation relationship 
%                      in a conjugated verb in Spanish and English.
%
% Structure: verb_conjugated_2x2(Number, Person, Time, Verbo_1, Verbo_Accion, Verb_1, Verb_action)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         Verbo_1 - first verb in spanish
%         Verbo_Accion - action verb in spanish
%         Verb_1 - first verb in english
%         Verb_Action - action verb in english
%_____________________________________________
verb_conjugated_2x2(singular, first, present, 'estoy', 'trabajando', 'am', 'working').
verb_conjugated_2x2(singular, third, present, 'esta*', 'corriendo', 'is', 'running').


%_____________________________________________
% verb_conjugated_2x1: Creates correspondence between a 2x1 particles translation relationship 
%                      in a conjugated verb in Spanish and English.
%
% Structure: verb_conjugated_2x1(Number, Person, Time, Verbo_Accion, Verb_1, Verb_action)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         Verbo_Accion - action verb in spanish
%         Verb_1 - first verb in english
%         Verb_Action - action verb in english
%_____________________________________________
verb_conjugated_2x1(plural, third, future, 'correra*n', 'will', 'run').


%_____________________________________________
% verb_exception: Creates correspondence between a grammar exception verb 
%                 (when 2 particles in english correspond to a single word in spanish) in Spanish and English.
%
% Structure: verb(Number, Person, Time, verbo, pronoun, verb)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         verbo - verb word in spanish
%         pronoun - pronoun word in english
%         verb - verb word in english
%_____________________________________________
verb_exception(singular, third, present, 'es', 'it', 'is').


%_____________________________________________
% verb_to_be: Confirms that a verb is a form of the english verb to be.
%
% Structure: verb_to_be(Verb)
%
% Params: Verb - word in english
%_____________________________________________
verb_to_be('is').
verb_to_be('es').
verb_to_be('are').


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
adjective(female, singular, 'lo*gica', 'logical').
adjective(female, plural, 'amarillas', 'yellow').
adjective(male, singular, 'asociado', 'associated').
adjective(_, singular, 'computacional', 'computational').


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
adverb('comunmente', 'commonly').
adverb('tarde', 'late').
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
% punctuation_sign: Indicates a grammar particle as an punctuation_sign. Used for phrase connections.
%
% Structure: punctuation_sign(Puntuaction_sign)
%
% Params: Puntuaction_sign - grammar puntuaction sign used as phrases connector
%_____________________________________________
punctuation_sign('.').
punctuation_sign(',').


%_____________________________________________
% conjunction: Creates correspondence between a grammar interjection in Spanish and English.
%
% Structure: interjection(ESP, ENG)
%
% Params: ESP - word in spanish
%         ENG - word in english
%_____________________________________________
interjection('hola', 'hello').


%_____________________________________________
% question_core_2x2: Creates correspondence between a 2x2 particles translation relationship 
%                    in a yes/no question in Spanish and English.
%
% Structure: question_core_2x2(Gender, Number, Person, Time, Sujeto, Verbo, Verb, Subject)
%
% Params: Sujeto - question subject in spanish
%         Verbo - question verb in spanish
%         Subject - question subject in english
%         Verbo - question verb in english
%         Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%_____________________________________________
question_core_2x2(female, singular, third, present, 'ella', 'esta*', 'is', 'she').
question_core_2x2(male, singular, third, present, 'e*l', 'esta*', 'is', 'he').
question_core_2x2(female, singular, third, present, 'ella', 'es', 'is', 'she').

%_____________________________________________
% question_core_2x1: Creates correspondence between a 2x1 particles translation relationship 
%                    in a yes/no question in Spanish and English.
%
% Structure: question_core_2x1(Gender, Number, Person, Time, Sujeto, Verb, Subject)
%
% Params: Sujeto - question subject in spanish
%         Subject - question subject in english
%         Verbo - question verb in english
%         Gender - grammatical gender of the grammar particle
%         Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%_____________________________________________
question_core_2x1(male, singular, third, past, 'e*l', 'did', 'he').


%_____________________________________________
% question_wh_3x3: Creates correspondence between a 3x3 particles translation relationship 
%                  in a wh question in Spanish and English.
%
% Structure: question_wh_3x3(Palabra_wh, Verbo, Sujeto, Word_wh, Verb, Subject)
%
% Params: Palabra_wh - wh question word in spanish (where, what, etc)
%         Verbo - verb in spanish
%         Sujeto - question subject in spanish
%         Word_wh - wh question word in english (where, what, etc)
%         Verb - verb in english
%         Subject - question subject in english
%_____________________________________________
question_wh_3x3('quie*n', 'es', 'usted', 'who', 'are', 'you').


%_____________________________________________
% question_wh_3x2: Creates correspondence between a 3x2 particles translation relationship 
%                  in a wh question in Spanish and English.
%
% Structure: question_wh_3x2(Palabra_wh, Verbo, Word_wh, Verb, Subject)
%
% Params: Palabra_wh - wh question word in spanish (where, what, etc)
%         Verbo - verb in spanish
%         Word_wh - wh question word in english (where, what, etc)
%         Verb - verb in english
%         Subject - question subject in english
%_____________________________________________
question_wh_3x2('donde', 'esta*s', 'where', 'are', 'you').


%_____________________________________________
% verb: Creates correspondence between a question verb in infinitive in Spanish and English.
%
% Structure: verb_question_infinitive(Number, Person, Time, ESP, ENG)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         Time - grammatical time of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
verb_question_infinitive(singular, third, past,'corrio*', 'run').


%_____________________________________________
% verb: Creates correspondence between a present continous verb in Spanish and English.
%
% Structure: verb_present_continous(Number, Person, ESP, ENG)
%
% Params: Number - grammatical number of the grammar particle
%         Person - grammatical person of the grammar particle
%         ESP - word in spanish
%         ENG - word in english
%_____________________________________________
verb_present_continous(singular, third, 'corriendo', 'running').