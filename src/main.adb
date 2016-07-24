with Ada.Real_Time; use Ada.Real_Time;
with OpenMV;
with OpenMV.LCD_Shield;
with OpenMV.Sensor;
with Greyscale_And_Print; use Greyscale_And_Print;

with Last_Chance_Handler;
pragma Unreferenced (Last_Chance_Handler);

procedure Main is
begin
   OpenMV.Initialize_LEDs;
   OpenMV.Set_RGB_LED (OpenMV.Off);
   OpenMV.LCD_Shield.Initialize;
   OpenMV.Sensor.Initialize;
   OpenMV.Initialize_Shield_USART (19_200);
   Greyscale_And_Print.Initialize;

   --  Take a snapshot
   OpenMV.Sensor.Snapshot (OpenMV.LCD_Shield.Get_Bitmap);

   --  Convert it to grayscale
   Greyscale_And_Print.To_Greyscale (OpenMV.LCD_Shield.Get_Bitmap);

   --  Show it on the screen
   OpenMV.LCD_Shield.Display;

   --  Print it
   Print (OpenMV.LCD_Shield.Get_Bitmap);

   delay until Time_Last;
end Main;
