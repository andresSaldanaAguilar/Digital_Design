library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d is port(
	cd,ci,clk,clr:in std_logic;
	ctrl:in std_logic_vector (2 downto 0);
	dato:in std_logic_vector(9 downto 0);
	salida: inout std_logic_vector(9 downto 0));

	attribute loc: string;
	attribute loc of cd: signal is "p33";
	attribute loc of ci: signal is "p135";
	attribute loc of ctrl: signal is "p4,p5,p6";
	attribute loc of clk: signal is "p7";
	attribute loc of clr: signal is "p8";
	attribute loc of dato: signal is "p28,p29,p30,p31,p32,p130,p131,p132,p133,p134";
	attribute loc of salida: signal is "p125,p124,p123,p122,p121,p98,p97,p96,p95,p94";
end;

architecture behavioral of d is
	begin
	process(clk,clr)
	begin
	if(clr='0')then--1
	salida<="0000000000";
	elsif(clk' event and clk='1')then
	for i in 0 to 9 loop
	--ascendente
	if(ctrl="100")then--2
	salida<=salida+1;
	--descendente
	elsif(ctrl="101")then
	salida<=salida-1;
	--carga dato
	elsif(ctrl="000")then
	salida<=dato;
	--retiene dato
	elsif(ctrl="011")then
	salida<=salida;
	--C.D
	elsif(ctrl="001")then		
	if (i=0) then--3
		salida(i)<=cd;
		else
		salida(i)<=salida(i-1);
		end if;--3
	--C.I
	elsif(ctrl="010")then
	if(i=9) then
		salida(i)<=ci;
		else
		salida(i)<=salida(i+1);
		end if;
	--Rotacion derecha
	elsif(ctrl="110")then
		salida(0)<=salida(1);	
		salida(1)<=salida(2);	
		salida(2)<=salida(3);
		salida(3)<=salida(4);
		salida(4)<=salida(5);
		salida(5)<=salida(6);
		salida(6)<=salida(7);
		salida(7)<=salida(8);
		salida(8)<=salida(9);
		salida(9)<=salida(0);
	--Rotacion Izquierda
	elsif(ctrl="111")then
		salida(8)<=salida(7);	
		salida(7)<=salida(6);	
		salida(6)<=salida(5);
		salida(5)<=salida(4);
		salida(4)<=salida(3);
		salida(3)<=salida(2);
		salida(2)<=salida(1);
		salida(1)<=salida(0);
		salida(0)<=salida(9);
		salida(9)<=salida(8);
	end if;--2
	end loop;
	end if;--1
	end process;
end behavioral;

