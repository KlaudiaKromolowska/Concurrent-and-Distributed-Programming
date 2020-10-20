-- lab0.adb
-- komentarz do konca linii

-- wykorzystany pakiet
with Ada.Text_IO;
use Ada.Text_IO;

-- procedura glowna - dowolna nazwa
procedure Lab0 is

-- czesc deklaracyjna

  -- funkcja - forma pelna
  function Max2(A1, A2 : in Float ) return Float is
  begin
    if A1 > A2 then return A1;
    else return A2;
    end if;
  end Max2;

  -- funkcja "wyrazeniowa"
  -- forma uproszczona funkcji
  -- jej trescia jest tylko wyrazenie w nawiasie

  function Add(A1, A2 : Float) return Float is
    (A1 + A2);

  function Max(A1, A2 : in Float ) return Float is
    (if A1 > A2 then A1 else A2);

   function Avg(A1,A2 : in Float) return Float is
     ((A1+A2)/2.0);

   function Silnia(N : Natural) return Natural is
     (if N=0 then 1 else N*Silnia(N-1));

  -- Fibonacci
  function Fibo(N : Natural) return Natural is
    (if N = 0 then 1 elsif N in 1|2 then  1 else Fibo(N-1) + Fibo(N-2) );

    -- procedura
    -- zparametryzowany ciag instrukcji
  procedure Print_Fibo(N: Integer) is
  begin
    if N <1 or N>46 then raise Constraint_Error;
    end if;
    Put_Line("Ciag Fibonacciego dla N= " & N'Img);
    for I in 1..N loop
      Put( Fibo(I)'Img & " " );
    end loop;
    New_Line;
  end Print_Fibo;

-- ponizej tresc procesury glownej
begin
  Put_Line("Suma = " & Add(3.0, 4.0)'Img );
  Put_Line( "Max =" & Max(6.7, 8.9)'Img);
  Put_Line( "Max2 =" & Max2(6.7, 8.9)'Img);
  Put_Line("Srednia = " & Avg(3.0, 4.0)'Img );
  Put_Line("Silnia dla N = 5 wynosi " & Silnia(5)'Img );
  Print_Fibo(12);
end Lab0;
