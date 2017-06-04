library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dp is port(
	clk: in std_logic;
	X:in std_logic_vector(1 downto 0);
	salida: inout std_logic_vector(7 downto 0));

	attribute loc: string;
	
	attribute loc of clk: signal is "p4";
	attribute loc of X: signal is "p96,p95";

	--attribute loc of display: signal is "p125,p124,p123,p122,p121,p98,p97";
	attribute loc of salida: signal is "p88,p87,p86,p85,p84,p83,p81,p80";	
end;

architecture a_dp of dp is
	type estados is(A,B,C,D,E);
	signal edo_presente,edo_futuro:estados;	
	begin
		process(edo_presente,X)
			begin
			case edo_presente is
			
			-------------------------------------caso base
			when A=>salida<=salida;	
			if(X="10")then
			edo_futuro<=D;
			elsif(X="01")then --es necesario especificar el estado de X y Y?
			edo_futuro<=B;
			else
			edo_futuro<=A;
			end if;

			-------------------------------------alguien entra
			when B=>	
			if(X="10")then
			edo_futuro<=C;
			else 
			salida<=salida;
			edo_futuro<=B;
			end if;
			
			when C=>if(X="11")then
			salida<=salida+"00000001"; --XD	
			edo_futuro<=A;
			else 
			salida<=salida;	
			edo_futuro<=C;
			end if;

			-------------------------------------alguien sale
			when D=>salida<=salida;
			if(X="01")then
			edo_futuro<=E;
			else --mando al edo inicial?
			edo_futuro<=D;
			end if;

			when E=>if(X="11")then
			salida<=salida-"00000001"; --XD	
			edo_futuro<=A;
			else 
			salida<=salida;	
			edo_futuro<=E;
			end if;
			end case;
	
		end process;
	
		process(clk,edo_presente,edo_futuro)
			begin

			if(clk'event and clk='1') then
				edo_presente<=edo_futuro;			
			end if;
		end process;
	end a_dp;

