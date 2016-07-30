with OpenMV;
with OpenMV.LCD_Shield;
with OpenMV.Sensor;
with OpenMV.Bitmap;

with Greyscale_And_Print; use Greyscale_And_Print;
with Edge_Detect;

with Last_Chance_Handler;
pragma Unreferenced (Last_Chance_Handler);

with STM32.GPIO; use STM32.GPIO;
with STM32.Device; use STM32.Device;
with HAL.Bitmap;

procedure Main is
   Button : GPIO_Point renames OpenMV.Shield_ADC;

   procedure Init_Button;

   procedure Init_Button is
      Conf : GPIO_Port_Configuration;
   begin
      Enable_Clock (Button);

      Conf.Mode        := Mode_In;
      Conf.Output_Type := Push_Pull;
      Conf.Speed       := Speed_100MHz;
      Conf.Resistors   := Pull_Up;

      Configure_IO (Button, Conf);
   end Init_Button;

   Snapshot : constant HAL.Bitmap.Bitmap_Buffer'Class := OpenMV.Bitmap.Allocate;
   Do_Edge : constant Boolean := True;
begin
   Init_Button;

   OpenMV.Initialize_LEDs;
   OpenMV.Set_RGB_LED (OpenMV.Off);

   OpenMV.LCD_Shield.Initialize;
   OpenMV.LCD_Shield.Rotate_Screen_90;

   OpenMV.Sensor.Initialize;
   OpenMV.Initialize_Shield_USART (19_200);

   Greyscale_And_Print.Initialize;

   loop
      if Do_Edge then
         --  Take a snapshot
         OpenMV.Sensor.Snapshot (Snapshot);

         --  Convert it to grayscale
         Greyscale_And_Print.To_Greyscale (Snapshot);

         Edge_Detect.Sobel (Snapshot, OpenMV.LCD_Shield.Get_Bitmap);

      else
         --  Take a snapshot
         OpenMV.Sensor.Snapshot (OpenMV.LCD_Shield.Get_Bitmap);

         --  Convert it to grayscale
         Greyscale_And_Print.To_Greyscale (OpenMV.LCD_Shield.Get_Bitmap,
                                           Apply_Threshol => True);

      end if;

      --  Show it on the screen
      OpenMV.LCD_Shield.Display;

      --  Print it
      if not Button.Set then
         Print (OpenMV.LCD_Shield.Get_Bitmap);
      end if;
   end loop;
end Main;
