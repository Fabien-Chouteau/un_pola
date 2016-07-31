with HAL.Bitmap;
with OpenMV.LCD_Shield;

package Edge_Detect is
   procedure Sobel (BM  : HAL.Bitmap.Bitmap_Buffer'Class)
     with Pre =>
         BM.Width = OpenMV.LCD_Shield.Width
       and
         BM.Height = OpenMV.LCD_Shield.Height;
end Edge_Detect;
