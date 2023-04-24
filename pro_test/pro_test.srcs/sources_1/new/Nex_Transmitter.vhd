----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2023 20:19:31
-- Design Name: 
-- Module Name: Nex_Transmitter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nex_Transmitter is
  Port (
        clk : in std_logic;
        rst : in std_logic;
        
        data_bit : in std_logic;
        
        -- led_bytes : out std_logic_vector(7 downto 0);
        
        rx_tx_switch : in std_logic;
       
        baud_switches : in STD_LOGIC_VECTOR (2 downto 0)
  
   );
end Nex_Transmitter;

architecture Behavioral of Nex_Transmitter is

    signal d_byte : std_logic_vector(7 downto 0);
    signal parity : std_logic;
    
    signal clk_bits : natural := 0;
    
    signal sig_baud_enable : std_logic;
    
    signal data_busy : std_logic := '0';
    
    signal end_bit : std_logic := '0';

begin

    baud_en0 : entity work.baud
        port map (
            clk => clk,
            rst => rst,
            clk_baud => sig_baud_enable,
            baud_sw => baud_switches
            );


    transmitter : process(data_bit) is
    begin
                if (rx_tx_switch = '0') then
                
                    if (data_busy = '0') then
                    
                        if (data_bit = '0') then
                            data_busy <= '1';
                            clk_bits <= 0;
                            
                        end if;
                    elsif (data_busy = '1' and clk_bits < 10) then
                        if (clk_bits < 8) then
                            d_byte(clk_bits) <= data_bit;
                        elsif (clk_bits = 8) then
                            parity <= d_byte(0) xor d_byte(1) xor d_byte(2) xor d_byte(3) xor d_byte(4) xor d_byte(5) xor d_byte(6) xor d_byte(7);
                        elsif (clk_bits = 9) then
                            end_bit <= '1';
                        end if;
                        
                        clk_bits <= clk_bits + 1;
                        
                    end if;
                else
                    clk_bits <= 0;
                    d_byte <= "00000000";
                    data_busy <= '0';
                    end_bit <= '0';
                end if;
                
     end process transmitter;
                    

end Behavioral;
