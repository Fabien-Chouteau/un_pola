with Ada.Real_Time; use Ada.Real_Time;

package body Ravenscar_Time is

   Delays : aliased Ravenscar_Delay;

   ------------------------
   -- Delay_Microseconds --
   ------------------------

   overriding
   procedure Delay_Microseconds
     (This : in out Ravenscar_Delay;
      Us : Integer)
   is
      pragma Unreferenced (This);
   begin
      delay until Clock + Microseconds (Us);
   end Delay_Microseconds;

   ------------------------
   -- Delay_Milliseconds --
   ------------------------

   overriding
   procedure Delay_Milliseconds
     (This : in out Ravenscar_Delay;
      Ms : Integer)
   is
      pragma Unreferenced (This);
   begin
      delay until Clock + Milliseconds (Ms);
   end Delay_Milliseconds;

   -------------------
   -- Delay_Seconds --
   -------------------

   overriding
   procedure Delay_Seconds
     (This : in out Ravenscar_Delay;
      S  : Integer)
   is
      pragma Unreferenced (This);
   begin
      delay until Clock + Seconds (S);
   end Delay_Seconds;

   ----------------
   -- Get_Delays --
   ----------------

   function Get_Delays return not null HAL.Time.Delays_Ref is (Delays'Access);

end Ravenscar_Time;
