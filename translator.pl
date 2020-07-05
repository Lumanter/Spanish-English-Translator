
% input debe ir entre paréntesis sencillos
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

sujeto(masculino, 'carro', 'car'). 

verbo(singular, tercera, presente, 'tiene', 'has').

adjetivo(masculino, singular, 'azul', 'blue').

preposicion('en', 'in').

cuantificador('un poco', 'a little').

adverbio('pronto', 'soon').

conjuncion('y', 'and').

signo_de_puntuacion('.', '.').

