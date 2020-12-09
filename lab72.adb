-- KLaudia Kromolowska --
with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

	Rozmiar: Natural := 5;  -- ustalamy ile sie miesci 

	task type SemaforNaZadaniu is	-- tworzymy semafor na zadaniu
		entry Czekaj;
		entry Zwolniono;
	end SemaforNaZadaniu;
	task type Uzytkownik(N: Integer := 1) is -- tworzymy uzytkownika
		entry Uzywaj;
	end Uzytkownik;
	
	task body SemaforNaZadaniu is  -- cialo zadania z semaforem
	R: Integer:=Rozmiar; -- podajemy rozmiar miesc
	begin
		loop
            select when R>0 => --dopoki jest miejsce
                  accept Czekaj do 
                     Put_Line("Ilosc: "&R'Img); --odliczamy ilosc semaforow
                     R:=R-1; -- zmiejsamy ilosc o jeden
                  end Czekaj;
            or
                  accept Zwolniono; -- jezeli jakies miejsce zwolnino
                  R:=R+1; -- zwiekszamy ilosc miejsc o 1
            end select;
        end loop;
	end SemaforNaZadaniu;
	
ZadanieS: SemaforNaZadaniu; -- tworzymy obiekt
	
	task body Uzytkownik is -- cialo tasku "uzytkownik"
	begin
		accept Uzywaj; -- po otrzymaniu komendy
		ZadanieS.Czekaj; -- wywolujemy funkcje sprawdzajaca miejsca
		Put_Line("Zadanie "& N'Img & ", korzystam z zasobu"); -- uruchamiamy uzycie semafora
		delay 1.0; -- opoznienie o 1ms
		Put_Line("Zadanie "& N'Img &", zwalniam zasob"); -- zakonczenie dzialania semafora
		ZadanieS.Zwolniono; -- informacja o zwolnieniu miejsca
	end Uzytkownik;

-- PROBY ZROBIENIA TABLICY U ZAMIAST LISTY ZAKONCZONE NIEPOWODZENIEM
--U: array ("U1", "U2", "U3") of String; 
--type Tablica is array(1..10) of Uzytkownik;

--for I in Tablica'Range loop
--     Tablica(I) := User(I);
--end loop
      

U1: Uzytkownik(1);
U2: Uzytkownik(2);
U3: Uzytkownik(3);
U4: Uzytkownik(4);
U5: Uzytkownik(5);
U6: Uzytkownik(6);
U7: Uzytkownik(7);
U8: Uzytkownik(8);
U9: Uzytkownik(9);
U10:Uzytkownik(10);
begin
	U1.Uzywaj;
	U2.Uzywaj;
	U3.Uzywaj;
	U4.Uzywaj;
	U5.Uzywaj;
	U6.Uzywaj;
	U7.Uzywaj;
	U8.Uzywaj;
	U9.Uzywaj;
	U10.Uzywaj;
end Main;