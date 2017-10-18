with OpenMV;
with OpenMV.LCD_Shield;
with OpenMV.Sensor;

with Greyscale_And_Print; use Greyscale_And_Print;
--  with Edge_Detect;

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

   type Mode_Type is (Live, Preview, Print);
   Mode : Mode_Type := Live;
begin
   Init_Button;

   OpenMV.Initialize_LEDs;
   OpenMV.Set_RGB_LED (OpenMV.Off);

   OpenMV.LCD_Shield.Initialize;
   OpenMV.LCD_Shield.Rotate_Screen_180;

   OpenMV.Sensor.Initialize;
   OpenMV.Initialize_Shield_USART (19_200);

   Greyscale_And_Print.Initialize;

   loop
      case Mode is
         when Live =>
            --  Take a snapshot
            OpenMV.Sensor.Snapshot (OpenMV.LCD_Shield.Bitmap);


            if Mode_Button.Set then
               --  Convert it to grayscale with threshold
               Greyscale_And_Print.To_Greyscale (OpenMV.LCD_Shield.Bitmap.all,
                                                 Apply_Threshol => True);
            end if;

            --  Show it on the screen
            OpenMV.LCD_Shield.Display;

            --  If the button is pressed we go in preview mode
            if not Trigger_Button.Set then
               Mode := Preview;
            end if;

         when Preview =>

            --  Just keep the image on the screen and wait for the button to be
            --  released.
            if Trigger_Button.Set then
               Mode := Print;
            end if;

         when Print =>

            --  The button was released so we print the image
            if Mode_Button.Set then
               Print_With_Grayscale (OpenMV.LCD_Shield.Bitmap.all);
            else
               Print_With_Dithering (OpenMV.LCD_Shield.Bitmap.all);
            end if;

            Mode := Live;
      end case;
   end loop;
end Main;
