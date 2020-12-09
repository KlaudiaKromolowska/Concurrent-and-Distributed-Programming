%  Anton Bohatiuk, Klaudia Kromołowska
-module(lab42).
-compile([export_all]).

% dodatkowe funkcje
% zwykle laczenie list, od el najwiekszych, do najmniejszych
merge([],[]) -> [];
merge([],Y) -> Y;
merge(X,[]) -> X;
merge([H|T],[H1|T1]) when H<H1 -> [H]++merge(T,[H1|T1]);
merge([H|T],[H1|T1]) -> [H1]++merge([H|T],T1).

% rozdzielamy liste na pojedyncze znaki
split(L) -> split(L, L, []).
split([], A, B) -> {reverse(B), A};
split([_], A, B) -> {reverse(B), A};
split([_,_|X], [H|T], Wynik) ->
    split(X, T, [H | Wynik]).

% odwracanie listy
reverse([])->[];
reverse(L) -> reverse(L, []).
reverse([H|T], L) -> reverse(T, [H] ++ L);
reverse([], L) -> L.


% sortowanie sekwencyjne, prosty merge sort - dzieli liste na pojedyncze elementy i laczy w odpowiedniej kolejnosci
sort1([]) -> []; % jezeli pusta lista
sort1([A]) -> [A]; %jezeli jednoelementowa
sort1(L) ->
	{Le,Pr} = split(L),
	merge(sort1(Le),sort1(Pr)).

% sortowanie wspolbiezne
received(X) -> 
	receive
		{X, L} -> L
	end.

sort2(L) ->
	X = spawn(lab42, sort2, [self(), L]),
    received(X).
sort2(X,L) when length(L) <100 -> X!{self(), sort1(L)}; %jezeli mniej niz 100 el, to sortujemy 1 sposobem
sort2(X, L) ->
	{Le, Pr} = split(L), % dzielimy na dwie czesci
    X1 = spawn(lab42, sort2, [self(), Le]), %dzielimy na procesy dla lewej i prawej podlisty
    X2 = spawn(lab42, sort2, [self(), Pr]),
    L1 = received(X1),
    L2 = received(X2),
    X!{self(), merge(L1,L2)}. %wysyla rodzicowi zmergowana liste
    


%-----------------------------PODSTAWOWA CZESC SORTOWANIA Z PLIKU
get_mstimestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega*1000000 + Sec)*1000 + round(Micro/1000).
sorts(L) -> 
  sort1(L).
sortw(L) -> 
  sort2(L).
gensort() ->
 L=[rand:uniform(5000)+100 || _ <- lists:seq(1, 23000)],	
 Lw=L,
 %io:format("Tablica: ~p",[L]),
 io:format("~nLiczba elementow = ~p ~n~n",[length(L)]),
 io:format("Sortuje sekwencyjnie~n"),	
 TS1=get_mstimestamp(),
 sorts(L),
 DS=get_mstimestamp()-TS1,
 %io:format("~p~n",[sorts(L)]),	
 io:format("Czas sortowania ~p [ms]~n~n",[DS]),
 io:format("Sortuje wspolbieznie~n"),	
 TS2=get_mstimestamp(),
 sortw(Lw),
 DS2=get_mstimestamp()-TS2,
 %io:format("~p~n",[sortw(Lw)]),
 io:format("Czas sortowania ~p [ms]~n",[DS2]).
 