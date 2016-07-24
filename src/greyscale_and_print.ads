with HAL.Bitmap;
with HAL;
with AdaFruit.Thermal_Printer; use AdaFruit.Thermal_Printer;
with OpenMV.LCD_Shield;

package Greyscale_And_Print is

   procedure Initialize
     with Post => Initialized;

   function Initialized return Boolean;

   procedure To_Greyscale (BM : HAL.Bitmap.Bitmap_Buffer'Class);

   procedure Print (Pict : HAL.Bitmap.Bitmap_Buffer'Class)
     with Pre => Initialized;


   BM : Thermal_Printer_Bitmap (0 .. (OpenMV.LCD_Shield.Width * 3) - 1,
                                0 .. (OpenMV.LCD_Shield.Height * 3) - 1);

end Greyscale_And_Print;
