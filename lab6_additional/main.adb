with Ada.Text_IO, Ada.Numerics.Float_Random, BuforType;
use Ada.Text_IO, Ada.Numerics.Float_Random;

procedure main is

	package packageBuf is new BuforType(10,Float);

	task type Producer is
      entry Open;
      entry Close;
	end Producer;

   task type Consumer is
		entry Open;
		entry Close;
   end Consumer;

	task body Producer is
		G: Generator;
		N: Float;
	begin
		accept Open;
      loop
         select
				accept Close;
				Put_Line("Exit program");
				exit;
		  else
				Reset(G);
				N := Random(G);
				Put_Line("Insert: " & N'Img);
				packageBuf.Bufor.Insert(N);
              delay 1.0;
         end select;
		end loop;
	end Producer;

	task body Consumer is
		N: Float;
	begin
		accept Open;
		loop
			select
				accept Close;
				Put_Line("Exit program");
				exit;
			else
				packageBuf.Bufor.Download(N);
              Put_Line("Download: " & N'Img);
              delay 0.5;
			end select;
		end loop;
	end Consumer;
P: Producer;
C: Consumer;
begin
	P.Open;
	delay 2.0;
	C.Open;
	delay 10.0;
   C.Close;
   P.Close;
end main;
