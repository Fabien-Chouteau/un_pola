with HAL; use HAL;
with Interfaces; use Interfaces;
with Ada.Numerics.Generic_Elementary_Functions;
with Greyscale_And_Print; use Greyscale_And_Print;

package body Edge_Detect is

   package Float_Funcs is new
     Ada.Numerics.Generic_Elementary_Functions (Float);
   use Float_Funcs;

   subtype Grad_Type is Float;

   type Grad_Matrix is array (Integer range  <>, Integer range <>) of
     Grad_Type;

   Temp_Grad : Grad_Matrix (1 .. OpenMV.LCD_Shield.Width - 2,
                            1 .. OpenMV.LCD_Shield.Height - 2);

   -----------
   -- Sobel --
   -----------

   procedure Sobel (BM : HAL.Bitmap.Bitmap_Buffer'Class) is


      Kernel : constant array (-1 .. 1, -1 .. 1) of Grad_Type :=
        ((-1.0,  -1.0, -1.0),
         (-1.0,  10.0, -1.0),
         (-1.0,  -1.0, -1.0));

      Val, Gradient, Min, Max : Grad_Type;
      Pix : Byte;


   begin
      Min := Grad_Type'Last;
      Max := Grad_Type'First;

      for X in Temp_Grad'Range (1) loop
         for Y in Temp_Grad'Range (2) loop
            Val := 0.0;
            for KX in Kernel'Range (1) loop
               for KY in Kernel'Range (2) loop
                  Pix := BM.Get_Pixel (X + KX, Y + KY).Red;
                  Val := Val + Grad_Type (Pix) * Kernel (KX, KY);
               end loop;
            end loop;

            Gradient := abs Val;
            Temp_Grad (X, Y) := Gradient;
            Min := Grad_Type'Min (Min, Gradient);
            Max := Grad_Type'Max (Max, Gradient);
         end loop;
      end loop;

      for X in Temp_Grad'Range (1) loop
         for Y in Temp_Grad'Range (2) loop
            Gradient := Temp_Grad (X, Y);

            Gradient := (Gradient - Min) / (Max - Min);

            Gradient := (1.0 - Gradient);

            Gradient := Gradient * 255.0;

            if Gradient < Grad_Type (Byte'First) then
               Pix := Byte'First;
            elsif Gradient > Grad_Type (Byte'Last) then
               Pix := Byte'Last;
            else
               Pix := Byte (Gradient);
               if Pix < Threshold_1 then
                  Pix := Threshold_1 - 1;
               elsif Pix < Threshold_2 then
                  Pix := Threshold_2 - 1;
               elsif Pix < Threshold_3 then
                  Pix := Threshold_3 - 1;
               elsif Pix < Threshold_4 then
                  Pix := Threshold_4 - 1;
               elsif Pix < Threshold_5 then
                  Pix := Threshold_5 - 1;
               elsif Pix < Threshold_6 then
                  Pix := Threshold_6 - 1;
               elsif Pix < Threshold_7 then
                  Pix := Threshold_7 - 1;
               elsif Pix < Threshold_8 then
                  Pix := Threshold_8 - 1;
               elsif Pix < Threshold_9 then
                  Pix := Threshold_9 - 1;
               else
                  Pix := Byte'Last;
               end if;
            end if;

--              if Gradient < 0.25 then
--                 Pix := 255;
--              else
--                 Pix := 0;
--              end if;

            BM.Set_Pixel (X, Y, (Alpha => 255, others => Pix));
         end loop;
      end loop;
   end Sobel;

end Edge_Detect;
