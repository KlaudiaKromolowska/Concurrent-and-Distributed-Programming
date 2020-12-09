-- Klaudia Kromolowska -- 
-- BOFOR CHRONIONY, PRODUCENT, KONSUMENT
with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is
   type Tablica is array(Integer range <>) of Character; -- tworzymy Buferor

   protected Bufer is -- Bufor na typie chroninym 
      entry prodElement (C: in Character); -- jezeli chcemy pobtac element
      entry konsElement (C: out Character); -- jezeli chcemy skonsumwoac elemnt
   private
      R: Integer :=3; -- Rozmiar
      T: Tablica(1..3);
      S: Integer := 0; -- suma elementow
      Pk: Integer :=1; -- miejsce z ktorego konsumujemy element
      Pp: Integer := 1; -- miejsce w ktorym produkujemy element
   end Bufer;
   
   protected body Bufer is
      entry prodElement(C : in Character) 
        when S < R is --jeeli il elementow mniejsza niz rozmiar
      begin
         T(Pp) := C; -- produkujemy znak w odpowiednim miejscu tablicy
         S := S + 1; -- zwiekszamy ilosc elementow o 1
         Put_Line("Ilosc elementow: " & S'Img);         
         Pp := (Pp + 1) mod 10; -- zeby nie przepelniac bufora
      end prodElement;
      entry konsElement(C : out Character)
        when S >= 0 is -- jezeli il. elementow jest wieksza od 0
      begin
         C := T(Pk); -- wyznaczamy znak do skonsumowania z odpowiedniego mimejsca        
         S := S - 1; --zmiejszamy ilosc aktywnych elementow
         Put_Line("Ilosc elementow: " & S'Img); 
         Pk := (Pk + 1) mod 10; -- zeby nie przepelnic bufora
      end konsElement;
   end Bufer;

   task Producent;
   task Konsument;

   task body Producent is
      Char : Character := 'x';
   begin
      for i in Integer range 1..6 loop -- 6 = 2x3 miejsca w buforze
         Put_Line("Podukcja: " & Char);
         Bufer.prodElement(Char); -- produkujemy znaki
         Put_Line("Wyprodukowalem");
      end loop;
   end Producent;

   task body Konsument is
      Char : Character := ' ';
   begin
      for i in Integer range 1..6 loop
         Put_Line("Konsumowanie.");
         Bufer.konsElement(Char); -- konsymujemt znaki
         Put_Line("Skonsumwalem: " & Char);
         delay 1.0;
        end loop;
   end Konsument;
   
begin
   Put_Line("Uruchamianie.");
end Main;
