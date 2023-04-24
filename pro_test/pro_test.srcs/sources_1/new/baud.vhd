-- This block uses code from clock_enable as a pulse generator for other blocks (RX/TX).
-- It sends out a pulse every //baud_gen// clock pulses. 

-- Example: baud_gen = 4800 ? p_clk_enable rises sig_cnt every cycle until sig_cnt >= baud_gen - 1
-- Then it sends out a pulse that is one clock long and resets sig_cnt to 0. 
-- That output pulse is fed into RX/TX blocks and tells those blocks to receive/transmit.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- Package for arithmetic operations

entity baud is

    Port ( clk : in STD_LOGIC; --! Main clock
           rst : in STD_LOGIC; --! High-active synchronous reset
           baud_sw : in STD_LOGIC_VECTOR(2 downto 0);
           clk_baud : out STD_LOGIC --Output baud clock for RX/TX, using code from clock_enable
           );
end baud;

architecture behavioral of baud is
   --Local signal for storing baud rate
  signal baud_gen : integer;
   -- Local counter
  signal sig_cnt : natural;
  
begin

    baud_solve : process(clk) is
    begin
        if rising_edge(clk) then              -- Synchronous process  
                case baud_sw is
                    when "000" =>
                        baud_gen <= 20833;
                    when "001" =>
                        baud_gen <= 10417;
                    when "010" =>
                        baud_gen <= 6944;
                    when "011" =>
                        baud_gen <= 5208;
                    when "100" =>
                        baud_gen <= 3472;
                    when "101" =>
                        baud_gen <= 2604;
                    when "110" =>
                        baud_gen <= 1736;
                    when "111" =>
                        baud_gen <= 868;
                    when others =>
                        baud_gen <= 20833; 
                    end case;
        end if;
     end process baud_solve;
     
  --------------------------------------------------------
  -- 1. process dava 100M signalu za sekundu 
  -- 2. slo?ka, ktera nabiha a ma velikost v zavislosti od baud_sw
  -- 3. kdy? dosahneme vysledn? hodnoty, po?le se signal na rx/tx a slo?ka p?ejde na 0
  -- 3.1 kdy? zm?nime n?co v baud_gen, tak slo?ka p?jde na 0

  --------------------------------------------------------
  -- p_clk_enable:
  -- Generate clock enable signal. By default, enable signal
  -- is low and generated pulse is always one clock long.
  --------------------------------------------------------
  p_clk_enable : process (clk) is
  begin

    if rising_edge(clk) then              -- Synchronous process
       if (rst = '1') then                 -- High-active reset
         sig_cnt     <= 0;                 -- Clear local counter
         clk_baud    <= '0';               -- Set output to low

      -- Test number of clock periods
      elsif (sig_cnt >= (baud_gen - 1)) then
        sig_cnt <= 0;                     -- Clear local counter
        clk_baud      <= '1';             -- Generate clock enable pulse
      else
        sig_cnt <= sig_cnt + 1;
        clk_baud      <= '0';
      end if;
    end if;

  end process p_clk_enable;
  
end Behavioral;