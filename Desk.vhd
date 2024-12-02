LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Desk is 
port(clk,ir,ldr:in std_logic; servo,led:out std_logic; leds1,leds2: out std_logic_vector(0 to 6));
end Desk;
architecture arch of Desk is
constant clk_hz : real := 1.0e7;
constant clk_period : time := 1 sec / clk_hz;
signal ledval:std_logic:='0';
constant pulse_hz : real := 50.0;
constant pulse_period : time := 1 sec / pulse_hz;
constant min_pulse_us : real := 1000.0;
constant max_pulse_us : real := 2000.0;
constant step_count : positive := 5;
signal clk_counter: integer range 0 to 1000000000:=0;
signal clk_counter2:integer range 0 to 100000000:=0;
signal stay_time1: integer range 0 to 9:=0;
signal stay_time2: integer range 0 to 9:=0;
signal ir_prev: std_logic:='1';
signal open_drawer:std_logic:='0';
signal display:std_logic:='0';
signal angle:integer range 0 to 180:=0;
signal drawer_opened: std_logic:='0';
signal clkcount:integer range 0 to 1000000000:=0;
signal finish:std_logic:='0';
signal started:std_logic:='0';
signal prevrun:std_logic:='0';
begin
led<=ledval;
process(clk) begin

if clk'event and clk='1' then
if started='1' then
clk_counter<=clk_counter+1;
if clk_counter=10000000 then
clk_counter<=0;
if stay_time1=9 then 
stay_time1<=0;
stay_time2<=stay_time2+1;
else
stay_time1<=stay_time1+1;

end if;
end if;
end if;
if finish='1' then
clkcount<=clkcount+1;
if clkcount=10000000 then
finish<='0';
clkcount<=0;
end if;
elsif drawer_opened='1' then
if ir='1' then 
ir_prev<='1';
drawer_opened<='0';
finish<='1';
ledval<='0';
clkcount<=0;
started<='0';


end if;
elsif open_drawer='1' then 
clkcount<=clkcount+1;
if clkcount=100000000 then
clkcount<=0;
--stay_time<=10;
open_drawer<='0';
drawer_opened<='1';
angle<=0;
end if;
elsif ir='0' and ir_prev='1' then
started<='1';
if prevrun='1' then
stay_time1<=0;
stay_time2<=0;
else
prevrun<='1';
end if;
if ldr='1' then
ledval<='1';
end if;
ir_prev<='0';
angle<=180;
open_drawer<='1';
end if;
end if;
end process; 
process(stay_time1)
begin
CASE stay_time1 IS
                WHEN 0 =>
                     leds1<= "0000001";
                WHEN 1 =>
                    leds1 <= "1001111";
                WHEN 2 =>
                    leds1 <= "0010010";
                WHEN 3 =>
                    leds1 <= "0000110";
                WHEN 4 =>
                    leds1 <= "1001100";
                WHEN 5 =>
                    leds1 <= "0100100";
                WHEN 6 =>
                    leds1 <= "0100000";
                WHEN 7 =>
                    leds1 <= "0001111";
                WHEN 8 =>
                    leds1 <= "0000000";
                WHEN 9 =>
                    leds1 <= "0000100";
                WHEN OTHERS =>
                    leds1 <= "1111111";
            END CASE;


end process;
process(stay_time2)
begin
CASE stay_time2 IS
                WHEN 0 =>
                     leds2<= "0000001";
                WHEN 1 =>
                    leds2 <= "1001111";
                WHEN 2 =>
                    leds2 <= "0010010";
                WHEN 3 =>
                    leds2 <= "0000110";
                WHEN 4 =>
                    leds2 <= "1001100";
                WHEN 5 =>
                    leds2 <= "0100100";
                WHEN 6 =>
                    leds2 <= "0100000";
                WHEN 7 =>
                    leds2 <= "0001111";
                WHEN 8 =>
                    leds2 <= "0000000";
                WHEN 9 =>
                    leds2 <= "0000100";
                WHEN OTHERS =>
                    leds2 <= "1111111";
            END CASE;


end process;
StageServo: ENTITY work.servo(rtl)
    GENERIC MAP (
        clk_hz, pulse_hz, min_pulse_us, max_pulse_us, step_count
    )
    PORT MAP (
        clk, '0', angle, servo
    );


end arch;


