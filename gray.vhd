library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d is port(
	clk,clr,ctrl:in std_logic;
	dato:in std_logic_vector(9 downto 0);
	salida,temp: inout std_logic_vector(9 downto 0));


	attribute loc: string;

	attribute loc of ctrl: signal is "p4";
	attribute loc of clk: signal is "p7";
	attribute loc of clr: signal is "p8";
	attribute loc of dato: signal is "p28,p29,p30,p31,p32,p130,p131,p132,p133,p134";
	attribute loc of salida: signal is "p125,p124,p123,p122,p121,p98,p97,p96,p95,p94";
end;

architecture behavioral of d is
	--variable temp : std_logic_vector (9 downto 0); -- declaracion de variable temporal
	begin
	process(clk,clr)
	begin
	if(clr='0')then--1
	temp<="0000000000";
	elsif(clk' event and clk='1')then
	--ascendente
	if(ctrl='1')then--2
	temp<=temp+1;
	--descendente
	elsif(ctrl='0')then
	temp<=temp-1;
	end if;--2
	end if;--1
	end process;
----------------------
	process(clk,clr)
	begin
	salida(0)<=temp(0);
	salida(9)<=temp(9);
	for i in 1 to 8 loop	
	salida(i)<=(temp(i-1) xor temp(i));
	end loop;
	if(clr='0')then--1
	salida<="0000000000";
	elsif(clk' event and clk='1')then
	salida<=salida;
	end if;
	end process;

end behavioral;

