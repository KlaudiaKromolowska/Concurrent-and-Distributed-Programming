with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Numerics.Float_Random;

procedure Main is
   type Float_array is array (Positive range <>) of Float;

   Gen : Generator; -- generator liczb losowych
   Looping : Boolean := True; -- zmienna uzyta do kontrolowania petli wyliczajacej
   GenPoint : Float_array(1..2) := (others => 0.0); -- wygenerowany punkt
   PrevPoint : Float_array(1..2) := (others => 0.0); -- punkt poprzednio wygenerowany (domyslnie (0,0))
   NextPoint : Float_array(1..2) := (others => 0.0); -- odebrany punkt
   Origin : Float_array(1..2) := (others => 0.0); -- poczatek ukladu wspolrzednych

   -- procedura wypisujaca tablice - w celach sprawdzania jej poprawnosci
   procedure PutTab(T1 : in out Float_array) is
   begin
      for  I in T1'Range loop
         Put_Line("Tab(" & I'Img & ") =" & T1(I)'Img);
      end loop;
   end PutTab;

   -- funkcja wyliczajaca odleglosc punktu P1 od P2
   function Distance(P1 : in out Float_array; P2 : in out Float_array) return Float is
   begin
      return Ada.Numerics.Elementary_Functions.Sqrt((P1(1) - P2(1))**2 + (P1(2) - P2(2))**2);
   end Distance;

   -- zadanie wyliczajace dystanse
   task Calculate is
      entry ReceivePoint (Point: in out Float_array); -- odbieranie punktu
      entry Finish; -- odbieranie instrukcji zakonczenia dzialania
   end Calculate;

   -- zadanie generujace punkty
   task Generate is
      entry GetN (N : Integer); -- odbieranie N - ilosci punktow do wygenerowania
      entry Ready; -- odbieranie instrukcji o gotowosci do odbioru punktu
   end Generate;

   -- zadanie wyliczajace dystanse
   task body Calculate is
   begin
      while Looping loop -- dopoki nie otrzymano wiadomosci o koncu
         select -- gdy zostanie odebrany punkt lub Finish
            -- po odebraniu punktu
            accept ReceivePoint (Point: in out Float_array) do
               PrevPoint := NextPoint; -- przypisanie poprzednio odebranego punktu
               Put_Line ("Received");
               PutTab(Point); -- wypisanie otrzymanego punktu
               NextPoint := Point; -- przypisanie odebranego punktu
               -- wyliczenie i wypisanie dystansow
               Put_Line("Distance to origin: " & Distance(NextPoint, Origin)'Img);
               Put_Line("Distance to previous point: " & Distance(NextPoint, PrevPoint)'Img);
            end ReceivePoint;
            Generate.Ready; -- wyslanie "wiadomosci" o gotowosci do odbioru
         or
            accept Finish do -- zakonczenie petli
               Looping := False;
            end Finish;
         end select;
      end loop;
   end Calculate;

   -- zadanie generujace punkty
   task body Generate is
   begin
      -- po odebraniu ilosci punktow
      accept GetN (N : Integer) do
         for I in 1..N loop  -- wygenerowanie N punktow
            Put_Line ("-------Sending");
            GenPoint := (others => Random(Gen)); -- wygenerowanie punktu
            Calculate.ReceivePoint(GenPoint); -- wyslanie punktu
            accept Ready;
         end loop;
         -- po wygenerowaniu N punktow wysylamy "wiadomosc" o koncu
         Calculate.Finish;
      end GetN;
   end Generate;

begin
   Generate.GetN(3);
   Put_Line("Finished");
end;

