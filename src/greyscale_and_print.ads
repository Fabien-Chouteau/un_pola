with HAL.Bitmap;
with HAL;

package Greyscale_And_Print is

   procedure Initialize
     with Post => Initialized;

   function Initialized return Boolean;

   procedure To_Greyscale (BM : HAL.Bitmap.Bitmap_Buffer'Class);

   procedure Print (Pict : HAL.Bitmap.Bitmap_Buffer'Class)
     with Pre => Initialized;

   Threshold_1 : constant := 32;
   Threshold_2 : constant := 64;
   Threshold_3 : constant := 96;
   Threshold_4 : constant := 128;
   Threshold_5 : constant := 160;
   Threshold_6 : constant := 192;
   Threshold_7 : constant := 224;
end Greyscale_And_Print;
