LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Desk is 
port(clk,ir,ldr:in std_logic; servo,led:out std_logic; bcd1,bcd2,bcd3:out std_logic_vector(6 downto 0));
end Desk;
architecture arch of Desk is
constant clk_hz : real := 1.0e6;
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
signal angle:integer range 0 to 180;
signal drawer_opened: std_logic:='0';
signal clkcount:integer range 0 to 1000000:=0;
begin
process(clk) begin

if clk'event and clk='1' then
if drawer_opened='1' then
clk_counter2<=clk_counter2+1;
if clk_counter>= 10000000 then
stay_time<=stay_time+1;
clk_counter2<=0;
end if;
clkcount<=clkcount+1;
if clkcount>1000 then
if ir='1' then
drawer_opened<='0';
led<='0';
ir_prev<='1';
end if;
end if;
--end if;
elsif ir='0' and ir_prev='1' then
ir_prev<='0';
open_drawer<='1';
angle<=180;
if ldr='0' then
led<='1';
end if;
end if;
if open_drawer='1' then
clk_counter<=clk_counter+1;
if clk_counter>=100000000 then
open_drawer<='0';
clk_counter<=0;
drawer_opened<='1';
stay_time<=10;
angle<=0;
end if;

end if;
end if;
--end if;
end process; 
StageServo: ENTITY work.servo(rtl)
    GENERIC MAP (
        clk_hz, pulse_hz, min_pulse_us, max_pulse_us, step_count
    )
    PORT MAP (
        clk, '0', angle, servo
    );


end arch;


