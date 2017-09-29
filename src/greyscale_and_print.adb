with HAL; use HAL;
with HAL.Bitmap; use HAL.Bitmap;
with AdaFruit.Thermal_Printer; use AdaFruit.Thermal_Printer;
with OpenMV.LCD_Shield; use OpenMV.LCD_Shield;
with Ravenscar_Time;

package body Greyscale_And_Print is


   TP : TP_Device (OpenMV.Get_Shield_USART, Ravenscar_Time.Delays);
   Is_Initialized : Boolean := False;
   BM : Thermal_Printer_Bitmap (0 .. (OpenMV.LCD_Shield.Width * 3) - 1,
                                0 .. (OpenMV.LCD_Shield.Height * 3) - 1);

   function Grey_Scale (C : Bitmap_Color) return UInt8;

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

   function Grey_Scale (C : Bitmap_Color) return UInt8 is
      R_Lin : constant Float := Float (C.Red) / 255.0;
      G_Lin : constant Float := Float (C.Green) / 255.0;
      B_Lin : constant Float := Float (C.Blue) / 255.0;
   begin
      return UInt8 ((0.2989 * R_Lin +
                     0.5870 * G_Lin +
                       0.1140 * B_Lin) * 255.0);
   end Grey_Scale;

   ------------------
   -- To_Greyscale --
   ------------------

   procedure To_Greyscale (BM             : in out HAL.Bitmap.Bitmap_Buffer'Class;
                           Apply_Threshol : Boolean := False) is
      Grey : UInt8;
   begin
      for Row in 0 .. BM.Width loop
         for Column in 0 .. BM.Height loop
            Grey := Grey_Scale (BM.Pixel ((Row, Column)));
            if Apply_Threshol then
               if Grey < Threshold_1 then
                  Grey := Threshold_1 - 1;
               elsif Grey < Threshold_2 then
                  Grey := Threshold_2 - 1;
               elsif Grey < Threshold_3 then
                  Grey := Threshold_3 - 1;
               elsif Grey < Threshold_4 then
                  Grey := Threshold_4 - 1;
               elsif Grey < Threshold_5 then
                  Grey := Threshold_5 - 1;
               elsif Grey < Threshold_6 then
                  Grey := Threshold_6 - 1;
               elsif Grey < Threshold_7 then
                  Grey := Threshold_7 - 1;
               elsif Grey < Threshold_8 then
                  Grey := Threshold_8 - 1;
               elsif Grey < Threshold_9 then
                  Grey := Threshold_9 - 1;
               else
                  Grey := UInt8'Last;
               end if;
            end if;

            BM.Set_Pixel ((Row, Column), (255, Grey, Grey, Grey));
         end loop;
      end loop;
   end To_Greyscale;

   -----------
   -- Print --
   -----------

   procedure Print (Pict : HAL.Bitmap.Bitmap_Buffer'Class) is
      Grey : UInt8;
   begin
      for Elt of BM loop
         Elt := False;
      end loop;
      for X in 0 .. Pict.Width - 1 loop
         for Y in 0 .. Pict.Height - 1 loop
            Grey := Pict.Pixel ((X, Y)).Red;
            if Grey < Threshold_1 then
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
            elsif Grey < Threshold_2 then
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
            elsif Grey < Threshold_3 then
               --  -------
               --  | |X|X|
               --  -------
               --  |X|X|X|
               --  -------
               --  |X|X| |
               --  -------
               BM (X * 3 + 2, Y * 3) := True;
               BM (X * 3, Y * 3 + 2) := True;
               BM (X * 3 + 1, Y * 3) := True;
               BM (X * 3, Y * 3 + 1) := True;
               BM (X * 3 + 2, Y * 3 + 1) := True;
               BM (X * 3 + 1, Y * 3 + 2) := True;
               BM (X * 3 + 1, Y * 3 + 1) := True;
            elsif Grey < Threshold_4 then
               --  -------
               --  | |X|X|
               --  -------
               --  |X| |X|
               --  -------
               --  |X|X| |
               --  -------
               BM (X * 3 + 2, Y * 3) := True;
               BM (X * 3, Y * 3 + 2) := True;
               BM (X * 3 + 1, Y * 3) := True;
               BM (X * 3, Y * 3 + 1) := True;
               BM (X * 3 + 2, Y * 3 + 1) := True;
               BM (X * 3 + 1, Y * 3 + 2) := True;
            elsif Grey < Threshold_5 then
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
            elsif Grey < Threshold_6 then
               --  -------
               --  |X| |X|
               --  -------
               --  | | | |
               --  -------
               --  |X| |X|
               --  -------
               BM (X * 3 + 1, Y * 3 + 1) := True;
               BM (X * 3 + 2, Y * 3) := True;
               BM (X * 3, Y * 3 + 2) := True;
               BM (X * 3, Y * 3) := True;
            elsif Grey < Threshold_7 then
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
            elsif Grey < Threshold_8 then
               --  -------
               --  | | |X|
               --  -------
               --  | | | |
               --  -------
               --  |X| | |
               --  -------
               BM (X * 3 + 2, Y * 3) := True;
               BM (X * 3, Y * 3 + 2) := True;
            elsif Grey < Threshold_9 then
               --  -------
               --  | | | |
               --  -------
               --  | |X| |
               --  -------
               --  | | | |
                  --  -------
               BM (X * 3 + 1, Y * 3 + 1) := True;
            else
               --  -------
               --  | | | |
               --  -------
               --  | | | |
               --  -------
               --  | | | |
               --  -------
               null;
            end if;
         end loop;
      end loop;
      TP.Print ("Make with Ada!" & ASCII.LF);
      TP.Print_Bitmap (BM);
      TP.Feed (3);
   end Print;
end Greyscale_And_Print;
