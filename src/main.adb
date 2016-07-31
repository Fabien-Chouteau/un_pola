with OpenMV;
with OpenMV.LCD_Shield;
with OpenMV.Sensor;

with Greyscale_And_Print; use Greyscale_And_Print;
with Edge_Detect;

with Last_Chance_Handler;
pragma Unreferenced (Last_Chance_Handler);

with STM32.GPIO; use STM32.GPIO;
with STM32.Device; use STM32.Device;

procedure Main is

   Trigger_Button : GPIO_Point renames OpenMV.Shield_ADC;
   Mode_Button : GPIO_Point renames OpenMV.Shield_SWC;

   procedure Init_Button;

   procedure Init_Button is
      Conf : GPIO_Port_Configuration;
   begin
      Enable_Clock (Trigger_Button);
      Enable_Clock (Mode_Button);

      Conf.Mode        := Mode_In;
      Conf.Output_Type := Push_Pull;
      Conf.Speed       := Speed_100MHz;
      Conf.Resistors   := Pull_Up;

      Configure_IO (Trigger_Button, Conf);
      Configure_IO (Mode_Button, Conf);
   end Init_Button;
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
      --  Take a snapshot
      OpenMV.Sensor.Snapshot (OpenMV.LCD_Shield.Get_Bitmap);


      if not Mode_Button.Set then
         --  Convert it to grayscale
         Greyscale_And_Print.To_Greyscale (OpenMV.LCD_Shield.Get_Bitmap);

         Edge_Detect.Sobel (OpenMV.LCD_Shield.Get_Bitmap);
      else
         --  Convert it to grayscale with threshold
         Greyscale_And_Print.To_Greyscale (OpenMV.LCD_Shield.Get_Bitmap,
                                           Apply_Threshol => True);
      end if;

      --  Show it on the screen
      OpenMV.LCD_Shield.Display;

      --  Print it
      if not Trigger_Button.Set then
         Print (OpenMV.LCD_Shield.Get_Bitmap);
      end if;
   end loop;
end Main;
