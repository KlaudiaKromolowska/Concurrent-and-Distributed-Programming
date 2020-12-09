with Ada.Text_IO;
use Ada.Text_IO;

package body BuforType is

	protected body Bufor is
		entry Insert(Ch: in Typ_El)
			when (Ins mod 10) /= (Dow mod 10) is
			begin
				Bufo(Ins mod 10) := Ch;
				Ins := Ins+1;
		end Insert;

		entry Download(Ch: out Typ_El)
			when (Dow+1 < Ins) is
			begin
				Ch := Bufo(Dow+1 mod 10);
				Dow := Dow+1;
			end Download;
	end Bufor;

end BuforType;
