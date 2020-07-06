
traducir(ESP, ING):-
    oracion(ESP_lista, ING_lista),
    atomic_list_concat(ESP_lista, ' ', ESP),
    atomic_list_concat(ING_lista, ' ', ING).

oracion([Determinante, Sujeto, Adjetivo, Verbo, Preposicion, Determinante_2, Sujeto_2|[]], 
        [Determinant, Adjective, Subject, Verb, Preposition, Determinant_2, Subject_2|[]]):-
    determinante(Genero, Numero, Determinante, Determinant),
    sujeto(Genero, Sujeto, Subject),
    adjetivo(Genero, Numero, Adjetivo, Adjective),
    verbo(Numero, _, _, Verbo, Verb),
    preposicion(Preposicion, Preposition),
    determinante(Genero_2, _, Determinante_2, Determinant_2),
    sujeto(Genero_2, Sujeto_2, Subject_2).


palabra(ESP, ING):- pronombre(_, _, ESP, ING); 
                    determinante(_, _, ESP, ING); 
                    sujeto(_, ESP, ING); 
                    verbo(_, _, _, ESP, ING);
                    adjetivo(_, _, ESP, ING);
                    preposicion(ESP, ING);
                    cuantificador(ESP, ING);
                    adverbio(ESP, ING);
                    conjuncion(ESP, ING);
                    signo_de_puntuacion(ESP, ING). 

pronombre(singular, tercera, 'ella', 'she').

determinante(masculino, singular, 'el', 'the').
determinante(femenino, singular, 'la', 'the').

sujeto(masculino, 'carro', 'car'). 
sujeto(femenino, 'pista', 'track'). 

verbo(singular, tercera, presente, 'compite', 'competes').
verbo(singular, tercera, presente, 'tiene', 'has').

adjetivo(masculino, singular, 'grande', 'big').
adjetivo(masculino, singular, 'azul', 'blue').

preposicion('en', 'in').

cuantificador('un poco', 'a little').

adverbio('pronto', 'soon').

conjuncion('y', 'and').

signo_de_puntuacion('.', '.').

