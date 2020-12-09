with Ada.Text_IO;
use Ada.Text_IO;

procedure Semaforzad is

   Size: Natural := 5;
   task type SemaforZadanie is
		entry Wait;
		entry Free;
	end SemaforZadanie;

	task body SemaforZadanie is
	S: Integer:=Size;
	begin
		loop
            select when S>0 =>
                  accept Wait do
                     Put_Line("Ilosc: "&S'Img); -
                     S:=S-1;
                  end Wait;
            or
                  accept Free;
                  S:=S+1;
            end select;
        end loop;
	end SemaforZadanie;

   	task type User(N: Integer := 1) is
		entry Use;
	end User;

SnZ: SemaforZadanie;

	task body User is
	begin
		accept Use;
		SnZ.Wait;
		Put_Line("Zadanie: "& N'Img & ", korzystam z zasobu");
		delay 1.0;
		Put_Line("Zadanie: "& N'Img &", zwalniam zasob");
		SnZ.Free;
	end User;


U1: User(1);
U2: User(2);
U3: User(3);
begin
	U1.Use;
	U2.Use;
	U3.Use;
end Semaforzad;
