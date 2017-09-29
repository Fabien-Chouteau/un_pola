with HAL.Bitmap;
with HAL;

package Greyscale_And_Print is

   procedure Initialize
     with Post => Initialized;

   function Initialized return Boolean;

   procedure To_Greyscale (BM             : in out HAL.Bitmap.Bitmap_Buffer'Class;
                           Apply_Threshol : Boolean := False);

   procedure Print (Pict : HAL.Bitmap.Bitmap_Buffer'Class)
     with Pre => Initialized;

   Threshold_1 : constant := 25;
   Threshold_2 : constant := 50;
   Threshold_3 : constant := 75;
   Threshold_4 : constant := 100;
   Threshold_5 : constant := 125;
   Threshold_6 : constant := 150;
   Threshold_7 : constant := 175;
   Threshold_8 : constant := 200;
   Threshold_9 : constant := 225;
end Greyscale_And_Print;
