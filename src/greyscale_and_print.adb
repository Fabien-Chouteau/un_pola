with HAL; use HAL;
with HAL.Bitmap; use HAL.Bitmap;
with Interfaces; use Interfaces;
with AdaFruit.Thermal_Printer; use AdaFruit.Thermal_Printer;
with Ravenscar_Time;

package body Greyscale_And_Print is


   TP : TP_Device (OpenMV.Get_Shield_USART, Ravenscar_Time.Get_Delays);
   Is_Initialized : Boolean := False;

   function Grey_Scale (C : Bitmap_Color) return Byte;
   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      TP.Wake;
      TP.Reset;
      Is_Initialized := True;
   end Initialize;

   function Initialized return Boolean is (Is_Initialized);

   ----------------
   -- Grey_Scale --
   ----------------

   function Grey_Scale (C : Bitmap_Color) return Byte is
      R_Lin : constant Float := Float (C.Red) / 255.0;
      G_Lin : constant Float := Float (C.Green) / 255.0;
      B_Lin : constant Float := Float (C.Blue) / 255.0;
   begin
      return Byte ((0.2989 * R_Lin +
                     0.5870 * G_Lin +
                       0.1140 * B_Lin) * 255.0);
   end Grey_Scale;

   ------------------
   -- To_Greyscale --
   ------------------

   procedure To_Greyscale (BM : HAL.Bitmap.Bitmap_Buffer'Class) is
      Grey : Byte;
   begin
      for Row in 0 .. BM.Width loop
         for Column in 0 .. BM.Height loop
            Grey := Grey_Scale (BM.Get_Pixel (Row, Column));
            BM.Set_Pixel (Row, Column, (255, Grey, Grey, Grey));
         end loop;
      end loop;
   end To_Greyscale;

   ---------------
   -- To_Binary --
   ---------------

   procedure To_Binary
     (BM : HAL.Bitmap.Bitmap_Buffer'Class;
      Threshold : HAL.Byte)
   is
   begin
      for Row in 0 .. BM.Width loop
         for Column in 0 .. BM.Height loop
            if Grey_Scale (BM.Get_Pixel (Row, Column)) > Threshold then
               BM.Set_Pixel (Row, Column, Black);
            else
               BM.Set_Pixel (Row, Column, White);
            end if;
         end loop;
      end loop;
   end To_Binary;


   -----------
   -- Print --
   -----------

   procedure Print (Pict : HAL.Bitmap.Bitmap_Buffer'Class) is
   begin
      for Elt of BM loop
         Elt := False;
      end loop;
      for X in 0 .. Pict.Width - 1 loop
         for Y in 0 .. Pict.Height - 1 loop
            case Pict.Get_Pixel (X, Y).Red is
               when 0 .. 31 =>
                  --  -------
                  --  |X|X|X|
                  --  -------
                  --  |X|X|X|
                  --  -------
                  --  |X|X|X|
                  --  -------
                  BM (X * 3 + 2, Y * 3) := True;
                  BM (X * 3, Y * 3 + 2) := True;
                  BM (X * 3, Y * 3) := True;
                  BM (X * 3, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3 + 2) := True;
                  BM (X * 3 + 2, Y * 3 + 1) := True;
                  BM (X * 3 + 1, Y * 3) := True;
                  BM (X * 3 + 1, Y * 3 + 2) := True;
                  BM (X * 3 + 1, Y * 3 + 1) := True;
               when 32 .. 63 =>
                  --  -------
                  --  |X|X|X|
                  --  -------
                  --  |X| |X|
                  --  -------
                  --  |X|X|X|
                  --  -------
                  BM (X * 3 + 2, Y * 3) := True;
                  BM (X * 3, Y * 3 + 2) := True;
                  BM (X * 3, Y * 3) := True;
                  BM (X * 3, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3 + 2) := True;
                  BM (X * 3 + 2, Y * 3 + 1) := True;
                  BM (X * 3 + 1, Y * 3) := True;
                  BM (X * 3 + 1, Y * 3 + 2) := True;
               when 64 .. 95 =>
                  --  -------
                  --  |X| |X|
                  --  -------
                  --  |X| |X|
                  --  -------
                  --  |X| |X|
                  --  -------
                  BM (X * 3 + 2, Y * 3) := True;
                  BM (X * 3, Y * 3 + 2) := True;
                  BM (X * 3, Y * 3) := True;
                  BM (X * 3, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3 + 2) := True;
               when 96 .. 127 =>
                  --  -------
                  --  |X| |X|
                  --  -------
                  --  | |X| |
                  --  -------
                  --  |X| |X|
                  --  -------
                  BM (X * 3 + 1, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3) := True;
                  BM (X * 3, Y * 3 + 2) := True;
                  BM (X * 3, Y * 3) := True;
                  BM (X * 3 + 2, Y * 3 + 2) := True;
               when 128 .. 159 =>
                  --  -------
                  --  | | |X|
                  --  -------
                  --  | |X| |
                  --  -------
                  --  |X| | |
                  --  -------
                  BM (X * 3 + 1, Y * 3 + 1) := True;
                  BM (X * 3 + 2, Y * 3) := True;
                  BM (X * 3, Y * 3 + 2) := True;
               when 160 .. 191 =>
                  --  -------
                  --  | | |X|
                  --  -------
                  --  | | | |
                  --  -------
                  --  |X| | |
                  --  -------
                  BM (X * 3 + 2, Y * 3) := True;
                  BM (X * 3, Y * 3 + 2) := True;
               when 192 .. 223 =>
                  --  -------
                  --  | | | |
                  --  -------
                  --  | |X| |
                  --  -------
                  --  | | | |
                  --  -------
                  BM (X * 3 + 1, Y * 3 + 1) := True;
               when 224 .. 255 =>
                  --  -------
                  --  | | | |
                  --  -------
                  --  | | | |
                  --  -------
                  --  | | | |
                  --  -------
                  null;
            end case;
         end loop;
      end loop;
      TP.Print ("Make with Ada!" & ASCII.LF);
      TP.Print_Bitmap (BM);
      TP.Feed (3);
   end Print;
end Greyscale_And_Print;
