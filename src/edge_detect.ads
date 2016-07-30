with HAL.Bitmap;

package Edge_Detect is
   procedure Sobel (Input  : HAL.Bitmap.Bitmap_Buffer'Class;
                    Output : HAL.Bitmap.Bitmap_Buffer'Class)
     with Pre =>
         Input.Width = Output.Width
       and
         Input.Height = Output.Height;
end Edge_Detect;
