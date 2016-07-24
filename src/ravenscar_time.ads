with HAL.Time;

package Ravenscar_Time is
   type Ravenscar_Delay is new HAL.Time.Delays with private;

   overriding
   procedure Delay_Microseconds (This : in out Ravenscar_Delay;
                                 Us : Integer);

   overriding
   procedure Delay_Milliseconds (This : in out Ravenscar_Delay;
                                 Ms : Integer);

   overriding
   procedure Delay_Seconds      (This : in out Ravenscar_Delay;
                                 S  : Integer);

   function Get_Delays return not null HAL.Time.Delays_Ref;
private
   type Ravenscar_Delay is new HAL.Time.Delays with null record;
end Ravenscar_Time;
