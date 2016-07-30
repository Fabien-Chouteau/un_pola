with HAL; use HAL;
with Interfaces; use Interfaces;
with Ada.Numerics.Generic_Elementary_Functions;
with Greyscale_And_Print; use Greyscale_And_Print;

package body Edge_Detect is

   package Float_Funcs is new
     Ada.Numerics.Generic_Elementary_Functions (Float);
   use Float_Funcs;

   -----------
   -- Sobel --
   -----------

   procedure Sobel (Input  : HAL.Bitmap.Bitmap_Buffer'Class;
                    Output : HAL.Bitmap.Bitmap_Buffer'Class) is

      subtype Grad_Type is Float;

      Kernel_H : constant array (-1 .. 1, -1 .. 1) of Float :=
        ((-1.0, 0.0, 1.0),
         (-2.0, 0.0, 2.0),
         (-1.0, 0.0, 1.0));
      Kernel_V : constant array (-1 .. 1, -1 .. 1) of Float :=
        ((-1.0, 0.0, 1.0),
         (-2.0, 0.0, 2.0),
         (-1.0, 0.0, 1.0));

      Val_H, Val_V, Gradient, Min, Max : Grad_Type;
      Pix : Byte;
   begin
      Min := Grad_Type'Last;
      Max := Grad_Type'First;

      for X in 1 .. Input.Width - 2 loop
         for Y in 1 .. Input.Height - 2 loop
            Val_V := 0.0;
            Val_H := 0.0;
            for KX in Kernel_V'Range (1) loop
               for KY in Kernel_V'Range (2) loop
                  Pix := Input.Get_Pixel (X + KX, Y + KY).Red;
                  Val_V := Val_V + Grad_Type (Pix) * Kernel_V (KX, KY);
                  Val_H := Val_H + Grad_Type (Pix) * Kernel_H (KX, KY);
               end loop;
            end loop;

            Gradient := (abs Val_V) + abs (Val_H);
            Min := Grad_Type'Min (Min, Gradient);
            Max := Grad_Type'Max (Max, Gradient);
         end loop;
      end loop;

      for X in 1 .. Input.Width - 2 loop
         for Y in 1 .. Input.Height - 2 loop
            Val_V := 0.0;
            Val_H := 0.0;
            for KX in Kernel_V'Range (1) loop
               for KY in Kernel_V'Range (2) loop
                  Pix := Input.Get_Pixel (X + KX, Y + KY).Red;
                  Val_V := Val_V + Grad_Type (Pix) * Kernel_V (KX, KY);
                  Val_H := Val_V + Grad_Type (Pix) * Kernel_H (KX, KY);
               end loop;
            end loop;

            Gradient := (abs Val_V) + abs (Val_H);

            Gradient := (Gradient - Min) / (Max - Min);

            --  Gradient := (1.0 - Gradient);

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

--              if Gradient < 0.5 then
--                 Pix := 255;
--              else
--                 Pix := 0;
--              end if;

            Output.Set_Pixel (X, Y, (Alpha => 255, others => Pix));
         end loop;
      end loop;
   end Sobel;

end Edge_Detect;
