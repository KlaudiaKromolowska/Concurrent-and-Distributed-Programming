-- Klaudia Kromolowska & Anton Bohatiuk

with  Ada.Text_IO, Ada.Streams, Ada.Text_IO.Text_Streams, Ada.Numerics.Float_Random, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_Io, Ada.Characters.Latin_1;
use Ada.Text_IO, Ada.Streams, Ada.Text_IO.Text_Streams, Ada.Strings.Unbounded, Ada.Text_IO.Unbounded_Io, Ada.Characters.Latin_1;

procedure main is
  Plik         : File_Type;
  Nazwa        : String := "textrt.txt";
  Strumien     : Stream_Access;

  type Macierz is array(Integer range <>, Integer range <>) of Float;

  procedure Read (S : access Root_Stream_Type'Class; NTab : out Macierz);
  procedure Write (S : access Root_Stream_Type'Class; NTab : in Macierz);
  for Macierz'Read use Read;
  for Macierz'Write use Write;

  procedure Read (S : access Root_Stream_Type'Class; NTab : out Macierz) is
  begin
      for E in NTab'Range(1) loop
         for F in NTab'Range(2) loop
            Float'Read(S, NTab(E,F));
         end loop;
    end loop;
  end Read;

  procedure Write (S : access Root_Stream_Type'Class; NTab : in Macierz) is
  begin
      for E in NTab'Range(1) loop
         for F in NTab'Range(2) loop
            Float'Write(S,NTab(E,F));
         end loop;
    end loop;
  end Write;

   --wyswietlanie tablicy
   function Wyswietlanie(NTab: Macierz) return String is
      N: Unbounded_String := To_Unbounded_String(""); -- string, ktory bedzie nieograniczonym ciagiem znakow
   begin
      for E in NTab'Range(1) loop
         for F in NTab'Range(2) loop
            Append(N, NTab(E,F)'Img); --dodajemy na koncu listy kolejny numer z tablicy
         end loop;
         Append(N, LF); -- dodajemy koniec linii
      end loop;
      return Ada.Strings.Unbounded.To_String(N);
   end Wyswietlanie;

  G : Ada.Numerics.Float_Random.Generator;
  M : Macierz(0..3, 0..3);


begin
   -- tworzymy tablice generujac losowe liczby rzeczywiste (nadano zakres 0-100)
  Ada.Numerics.Float_Random.Reset(G);
  for E in M'Range(1) loop
    for F in M'Range(2) loop
        M(E,F) := Ada.Numerics.Float_Random.Random(G)*100.0;
    end loop;
  end loop;

  Ada.Text_IO.Put_Line("* Zapis do pliku -> " & Nazwa);
  Create(Plik, Out_File, Nazwa);
  Strumien := Stream(Plik);
  Ada.Text_IO.Put_Line("* Zapisuje tablice : "& LF & Wyswietlanie(M) );
  Macierz'Output(Strumien, M);
  Close(Plik);
  -- zerowanie
  for E in M'Range(1) loop
         for F in M'Range(2) loop
            M(E, F) := 0.0;
         end loop;
   end loop;
  -- odczyt z pliku
  Ada.Text_IO.Put_Line("* Odczyt z pliku <- " & Nazwa);
  Open(Plik, In_File, Nazwa);
  Strumien := Stream(Plik);
  M := Macierz'Input(Strumien);
  Ada.Text_IO.Put_Line("* Odczytalem tablice : " & LF & Wyswietlanie(M) );
  Close(Plik);
  Ada.Text_IO.Put_Line("* Koniec");
end main;
