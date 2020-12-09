with Ada.Text_IO;
use Ada.Text_IO;

procedure SemaforProt is
	Size: Natural := 5;

	protected SemaforChroniony is
		entry Wait;
		procedure Free;
		private
			S: Integer := Size;
   end SemaforChroniony;

	protected body SemaforChroniony is
		entry Wait
			when S > 0 is
			begin
				S := S-1;
		end Wait;
		procedure Free is
		begin
			S := S+1;
		end Free;
	end SemaforChroniony;

	task type User(N: Integer := 1) is
		entry Use;
	end User;

	task body User is
	begin
		accept Use;
		SemaforChroniony.Wait;
		Put_Line("Zadanie: "& N'Img & ", korzystam z zasobu");
		delay 1.0;
		Put_Line("Zadanie: "& N'Img &", zwalniam zasob");
       SemaforChroniony.Free;
	end User;


U1: User(1);
U2: User(2);
U3: User(3);
begin
	U1.Use;
	U2.Use;
	U3.Use;
end Semaforprot;
