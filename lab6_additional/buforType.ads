generic
	Size: Natural;
   type Typ_El is digits <>;

package BuforType is
	type TableOfType is array(Integer range 1..Size) of Typ_El;

   protected Bufor is
      entry Insert(Ch: in Typ_El);
      entry Download(Ch: out Typ_El);
   private
      Bufo: TableOfType;
      Ins: Integer := 1;
      Dow: Integer := 0;
   end Bufor;
end BuforType;
