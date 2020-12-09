-module(lab5).
-compile([export_all]).

%wstawianie elementu do drzewa 
insert(N, {node, Val, Left, Right}) ->
			if N < Val ->
				{node, Val, insert(N, Left), Right};
			true ->
				{node, Val, Left, insert(N, Right)}
			end;
insert(N, {null}) ->
			{node, N, {null}, {null}}.
			
%generacja losowego drzewa
genRandomTree(0,  Tree) -> Tree;
genRandomTree(Size,  Tree) -> genRandomTree(Size-1,  insert(rand:uniform(1000),  Tree)).
genRandomTree(Size) -> genRandomTree(Size, {null}).

%generacja drzewa z listy
treeFromList(List) -> lists:foldl(fun(N, Tree) -> insert(N, Tree) end,  {null},  List).

%zwiniecie drzewa do listy - 3 metody
treeToList1({null}) -> [];
treeToList1({node, Val, Left, Right}) ->
			lists:append([treeToList1(Left), [Val], treeToList1(Right)]).
treeToList2({null}) -> [];	
treeToList2({node, Val, Left, Right}) ->
			lists:append([treeToList2(Left), treeToList2(Right), [Val]]).
treeToList3({null}) -> [];
treeToList3({node, Val, Left, Right}) ->
			lists:append([[Val], treeToList3(Left), treeToList3(Right)]).
			
%szukanie elementu w drzewie
searchTree1({null}, _N) -> false;
searchTree1({node, N, _L, _R}, N) -> true;
searchTree1({node, Val, Left, Right}, N) ->
	if 
		N < Val -> searchTree1(Left, N);
		true -> searchTree1(Right, N)
	end.
searchTree2(Tree, N) -> catch searchTree2_(Tree, N).
searchTree2_({null}, _N) -> throw(false);
searchTree2_({node, N, _L, _R}, N) -> throw(true);
searchTree2_({node, Val, Left, Right}, N) ->
	if 
		N < Val -> searchTree1(Left, N);
		true -> searchTree1(Right, N)
	end.
	
	
	
	
