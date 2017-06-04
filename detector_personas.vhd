library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dp is port(
	clk: in std_logic;
	X:in std_logic_vector(1 downto 0);
	salida: inout std_logic_vector(7 downto 0));
	-- Displays es de 8 bits, 4 por cada display, ya que solo es hasta el 99
	displays: out STD_LOGIC_VECTOR(7 downto 0)

	attribute loc: string;
	
	attribute loc of clk: signal is "p4";
	attribute loc of X: signal is "p96,p95";

	--attribute loc of displays: signal is "p125,p124,p123,p122,p121,p98,p97";
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
------------------------------------

		--Proceso que convierte de binario a bcd
		convertidor: process(salida)
		--Variable auxiliar que nos sirve para hacer corrimientos más fáciles
		variable aux: STD_LOGIC_VECTOR(15 downto 0);
		begin
			--Inicializamos todos los datos en cero.
			aux := (others => '0');
			--Cargamos los datos por primera vez.
			aux(7 downto 0) := salida;
			--Por cada bit habrá que hacer un corrimiento a la izquierda
			--Eso determina las repeticiones del for, en este caso 7
			for i in 0 to 7 loop
				--Unidades (4 bits).
				--Si las Unidades son mayores a 4 entonces les sumamos 3
				if aux(11 downto 8) > 4 then
					aux(11 downto 8) := aux(11 downto 8) + 3;
				end if;
				--Decenas (4 bits).
				--Si las decenas son mayores a 4 entonces les sumamos 3
				if aux(15 downto 12) > 4 then
					aux(15 downto 12) := aux(15 downto 12) + 3;
				end if;
				--Corrimiento a la izquierda al estilo Andrés, podriamos intentar con un ROL o SLR haber que pasa
				aux(15 downto 1) := aux(14 downto 0);
		end loop;
		--Pasando datos de variable aux a la correspondiente salida.
		displays <= aux(15 downto 8);
	end process convertidor;
	end a_dp;

