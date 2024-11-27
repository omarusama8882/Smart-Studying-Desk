LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Desk is 
port(clk,ir,ldr:in std_logic; servo,led:out std_logic);
end Desk;
architecture arch of Desk is
constant clk_hz : real := 1.0e7;
constant clk_period : time := 1 sec / clk_hz;
  
constant pulse_hz : real := 50.0;
constant pulse_period : time := 1 sec / pulse_hz;
constant min_pulse_us : real := 1000.0;
constant max_pulse_us : real := 2000.0;
constant step_count : positive := 5;
signal clk_counter: integer range 0 to 1000000000:=0;
signal clk_counter2:integer range 0 to 100000000:=0;
signal stay_time: integer range 0 to 100:=0;
signal ir_prev: std_logic:='1';
signal open_drawer:std_logic:='0';
signal display:std_logic:='0';
signal angle:integer range 0 to 180:=0;
signal drawer_opened: std_logic:='0';
signal clkcount:integer range 0 to 1000000000:=0;

begin
process(clk) begin

if clk'event and clk='1' then
if open_drawer='1' then 
clkcount<=clkcount+1;
if clkcount=100000000 then
clkcount<=0;
open_drawer<='0';
angle<=0;
end if;
elsif ir='0' and ir_prev='1' then
ir_prev<='0';
angle<=180;
open_drawer<='1';
end if;
end if;
end process; 
StageServo: ENTITY work.servo(rtl)
    GENERIC MAP (
        clk_hz, pulse_hz, min_pulse_us, max_pulse_us, step_count
    )
    PORT MAP (
        clk, '0', angle, servo
    );


end arch;


