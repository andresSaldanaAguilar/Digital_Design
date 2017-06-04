library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dp is port(
	clk: in std_logic;
	X:in std_logic_vector(1 downto 0);
	-- unidades
	unidades: out STD_LOGIC_VECTOR(3 downto 0);
	-- decenas
	decenas: out STD_LOGIC_VECTOR(3 downto 0);
	-- display unidades
	displayu: out STD_LOGIC_VECTOR(6 downto 0);
	-- display decenas
	displayd: out STD_LOGIC_VECTOR(6 downto 0);
	-- salidas a transistores
	trans1,trans2: inout std_logic;
	salida: inout std_logic_vector(7 downto 0));
	

	attribute loc: string;
	
	attribute loc of clk: signal is "p4";
	attribute loc of X: signal is "p96,p95";

	--attribute loc of displays: signal is "p125,p124,p123,p122,p121,p98,p97";
	attribute loc of salida: signal is "p88,p87,p86,p85,p84,p83,p81,p80";	
end;

architecture a_dp of dp is
	--Constantes para los displays
	constant DIG0: std_logic_vector (6 downto 0):="0000001";--0
	constant DIG1: std_logic_vector (6 downto 0):="1001111";--1
	constant DIG2: std_logic_vector (6 downto 0):="0010010";--2
	constant DIG3: std_logic_vector (6 downto 0):="0000110";--3
	constant DIG4: std_logic_vector (6 downto 0):="1001100";--4
	constant DIG5: std_logic_vector (6 downto 0):="0100100";--5
	constant DIG6: std_logic_vector (6 downto 0):="0100000";--6
	constant DIG7: std_logic_vector (6 downto 0):="0001111";--7
	constant DIG8: std_logic_vector (6 downto 0):="0000000";--8
	constant DIG9: std_logic_vector (6 downto 0):="0000100";--9
	constant DIGERROR: std_logic_vector (6 downto 0):="0110000";

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
		decenas <= aux(15 downto 12);
		unidades <= aux(11 downto 8);
	end process convertidor;

	--Proceso para que se prendan los displays
	pren_dis:process(unidades,decenas)
	begin
		--Primer transistor para unidades
		if (unidades=="0000") then
			--Si no hay unidades no prendemos ese display
			trans1<='0';
		else
			trans1<='1';
		end if;
		-- Segundo transistor para decenas
		if decenas=="0000" then
			--Si no hay decenas entonces no prendemos ese display
			trans2<='0';
		else 
			trans2<='1';
		end if;
		--Cases para cada display
		case unidades is
			when "0000"=>displayu<=DIG0;
			when "0001"=>displayu<=DIG1;
			when "0010"=>displayu<=DIG2;
			when "0011"=>displayu<=DIG3;
			when "0100"=>displayu<=DIG4;
			when "0101"=>displayu<=DIG5;
			when "0110"=>displayu<=DIG6;
			when "0111"=>displayu<=DIG7;
			when "1000"=>displayu<=DIG8;
			when "1001"=>displayu<=DIG9;
			when others =>displayu<=DIGERROR;
		end case;
		case decenas is
			when "0000"=>displayd<=DIG0;
			when "0001"=>displayd<=DIG1;
			when "0010"=>displayd<=DIG2;
			when "0011"=>displayd<=DIG3;
			when "0100"=>displayd<=DIG4;
			when "0101"=>displayd<=DIG5;
			when "0110"=>displayd<=DIG6;
			when "0111"=>displayd<=DIG7;
			when "1000"=>displayd<=DIG8;
			when "1001"=>displayd<=DIG9;
			when others =>displayd<=DIGERROR;
		end case ;
	end process pren_dis;
end a_dp;

