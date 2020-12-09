
-module(lab4).
-author("Anton Bohatiuk & Klaudia Kromolowska").




-compile([export_all]).

%%%%%%%%%%%
% dodatkowe funkcje
merge([],[]) -> [];
merge([],Y) -> Y;
merge(X,[]) -> X;
merge([H|T],[H1|T1]) when H<H1 -> [H]++merge(T,[H1|T1]);
merge([H|T],[H1|T1]) -> [H1]++merge([H|T],T1).

	
split(L) -> split(L, L, []).
split([], A, B) -> {reverse(B), A};
split([_], A, B) -> {reverse(B), A};
split([_,_|X], [H|T], Wynik) ->
    split(X, T, [H | Wynik]).

reverse([])->[];
reverse(L) -> reverse(L, []).
reverse([H|T], L) -> reverse(T, [H] ++ L);
reverse([], L) -> L.


% sortowanie sekwencyjne
sort1([]) -> [];
sort1([A]) -> [A];
sort1(L) ->
  {Le,Pr} = split(L),
  merge(sort1(Le),sort1(Pr)).

%%%%%%%%%%%

% funkcja generuje liste liczb losowych o dlugosci L i zakresie 100
generate(L) ->
  [rand:uniform(100) || _ <- lists:seq(1, L)]. % funkcja pomocnicza do generowania list

% Acc - ilosc list ktora dziala tez jako licznik by wiedziec kioedy skonczyc generowanie list, L - dlugosc list
% p1 dziala jako producent, generuje wskazana liczbe list i wysyla do posredniego procesu p2
p1(P2Pid, L, Acc) when Acc > 1 ->
  P2Pid ! {self(), generate(L)},
  p1(P2Pid, L, Acc - 1);
p1(P2Pid, L, Acc) when Acc =< 1 ->
  P2Pid ! {self(), generate(L)},
  P2Pid ! koniec.  % w tym momencie jzu nei zapetlamy sie bo licznik wynosi 1 i juz wyslalismy ostatnio liste do sortowania

% proces p2 jest posrednim, sortuje liste i wysyla do p3
p2(P3Pid) ->
  receive
    {_, L} ->
      P3Pid ! {self(), sort1(L)},
      p2(P3Pid); % poki otrzymujemy listy zapetlamy sie
    koniec ->
      P3Pid ! koniec, ok % po prostu propagujemy komunikat do p3
  end.

% p3 sortuje liste i zapetla sie, chyba ze otrzymalismy komuniakt o koncu :)
p3() ->
  receive
    {_, L} ->
      io:fwrite("p3 otrzymal liste: ~w~n", [L]),
      p3(); % poki otrzymujemy listy zapetlamy sie
    koniec -> io:fwrite("Otrzymano komunikat o koncu dzialania"), ok
  end.

main() ->
  spawn(lab4, p1, [spawn(lab4, p2, [spawn(lab4, p3, [])]), 10, 5]).

