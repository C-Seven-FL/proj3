----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:10:52 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    port (
    CLK100MHZ : in    std_logic;
    SW        : in    std_logic_vector(12 downto 0);
    BTNC      : in    std_logic;
    
    RXIN : out std_logic;
    TXOUT : in std_logic;
    
     ARR : out std_logic_vector(7 downto 0)
    -- LED       : out   std_logic_vector(15 downto 0) -- Bit reciever LED-information
    );
end UART;

architecture Behavioral of UART is

begin

    reciever : entity work.Nex_Reciever
        port map(
            clk => CLK100MHZ,
            rst => BTNC,
            rx_tx_switch => SW(0),
            start_bit => SW(1),
            data_in_sw => SW(9 downto 2),
            baud_switches => SW(12 downto 10),
            
            byte_out => RXIN
            );
    
    
    transmitter : entity work.Nex_Transmitter
        port map(
            clk => CLK100MHZ,
            rst => BTNC,
            rx_tx_switch => SW(0),
            baud_switches => SW(12 downto 10),
            data_bit => TXOUT,
             led_bytes => ARR
            );
end Behavioral;
