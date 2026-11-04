:- use_module(library(readutil)).
:- dynamic letters/1.

start :-
    retractall(letters(_)),
    assertz(letters([a,b,c])),
    writeln('Hi, This is the Name Game.'),
    writeln('You will be given a set of English letters in which you will add, delete or move to create your name.'),
    menu.

menu :-
    nl,
    writeln('Choose from the following:'),
    writeln('1- Display the current set of letters'),
    writeln('2- Add a letter'),
    writeln('3- Add a letter at the top'),
    writeln('4- Add a letter at the bottom'),
    writeln('5- Delete a letter'),
    writeln('6- Delete all letters'),
    writeln('7- Exit'),
    write('Enter your choice... '),
    read_line_to_string(user_input, Raw),
    normalize_space(string(Choice), Raw),
    ( Choice = "7" -> writeln('Goodbye!')
    ; process(Choice), menu
    ).

process("1") :-
    letters(L),
    format('Current letters: ~w~n', [L]).
process("2") :-
    get_letter(Letter),
    letters(L),
    append(L, [Letter], Updated),
    update_letters(Updated).
process("3") :-
    get_letter(Letter),
    letters(L),
    ( select(Letter, L, Rest) -> true ; Rest = L ),
    update_letters([Letter|Rest]).
process("4") :-
    get_letter(Letter),
    letters(L),
    ( select(Letter, L, Rest) -> true ; Rest = L ),
    append(Rest, [Letter], Updated),
    update_letters(Updated).
process("5") :-
    get_letter(Letter),
    letters(L),
    ( select(Letter, L, Updated) -> update_letters(Updated)
    ; writeln('Letter not found.')
    ).
process("6") :-
    update_letters([]).
process(_) :-
    writeln('Invalid choice.').

get_letter(Letter) :-
    repeat,
    write('Enter a letter: '),
    read_line_to_string(user_input, Raw),
    normalize_space(string(Text), Raw),
    ( string_length(Text, 1),
      string_lower(Text, Lower),
      string_chars(Lower, [Character]),
      char_type(Character, alpha)
    -> atom_string(Letter, Lower), !
    ; writeln('Please enter one letter.'), fail
    ).

update_letters(L) :-
    retractall(letters(_)),
    assertz(letters(L)),
    format('Current letters: ~w~n', [L]).
