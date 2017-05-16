library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d is port(
	sel,cd,clk,clr: in std_logic;
	d,q,s: inout std_logic;
	datoA,datoB: in std_logic_vector (3 downto 0);
	qA,qB: inout std_logic_vector (3 downto 0);--registros
	salida: out std_logic_vector(3 downto 0);--salida finales
	carry: out std_logic);

	attribute loc: string;
	
	attribute loc of clk: signal is "p4";
	attribute loc of cd: signal is "p115";
	attribute loc of sel: signal is "p116";
	attribute loc of clr: signal is "p114";
	attribute loc of datoA: signal is "p5,p6,p7,p8";
	attribute loc of datoB: signal is "p9,p11,p12,p13";
	attribute loc of qA: signal is "p28,p29,p30,p31";
	attribute loc of qB: signal is "p33,p39,p40,p41S";
	attribute loc of salida: signal is "p96,p95,p94,p93";
	attribute loc of carry: signal is "p113";
	
end;

architecture behavioral of d is
signal contador:integer range 0 to 4;
begin
	--registro A
	process(clr,clk,sel,qA,qB,datoA)
		begin
		if(clr='0')then
			qA<="0000";
		elsif(clk'event and clk='1') then
			for i in 0 to 3 loop
			case sel is
			when '0'=>qA(i)<=datoA(i);
			when others=>
				if (i=3) then
				qA(i)<=cd;
				else
				qA(i)<=qA(i+1);
				end if;
			end case;
			end loop;
		end if;
	end process;

	--registro B
	process(clr,clk,sel,qA,qB,datoB)
		begin
		if(clr='0')then --if 1
		qB<="0000";
		elsif(clk'event and clk='1') then
		for i in 0 to 3 loop
		case sel is
		when '0'=>qB(i)<=datoB(i);
		when others=>
			if (i=3) then
			qB(i)<=cd;
			else
			qB(i)<=qB(i+1);
			end if;
		end case;
		end loop;
		end if;
	end process;

	--sumador
	process(clr,clk,sel,qA,qB)
		begin

		if(clr='0')then --if 1
		s<='0';
		q<='0';
		elsif(clk'event and clk='1') then

		--Ecuaciones
		d<=(qA(0) and qB(0)) or (qA(0) and q) or (qB(0) and q);
		s<=qA(0) xor qB(0) xor q;

			--Logica de el ff
			if (d='0') then
			q<=q;
			else
			q<=not(q);
			end if;
			--fin ff			
		end if;
	end process;

	--registro que muestra resultado
	process(clr,clk,sel,s,q,contador)
  		
		begin
		if(clr='0')then --if 1
		salida<="0000";
		carry<='0';
		elsif(clk'event and clk='1') then
			salida(contador)<=s;
			contador<=contador+1;
			carry<=q;	
		end if;
	end process;

end behavioral;

