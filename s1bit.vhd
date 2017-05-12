library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d is port(
	sel,cd,clk,clr: in std_logic;
	datoA,datoB: in std_logic_vector (3 downto 0);
	qA,qB: inout std_logic_vector (3 downto 0));

end;

architecture behavioral of d is
begin
	--registro A
	process(clr,clk,sel)
		begin
		if(clr='0')then --if 1
		qA<="0000";
		elsif(clk'event and clk='1') then
		for i in 0 to 3 loop
		case sel is
		--when "00"=>qA(i)<=qA(i);
		when '0'=>qA(i)<=datoA(i);
		when others=>
			if (i=0) then
			qA(i)<=cd;
			else
			qA(i)<=qA(i-1);
			end if;
		end case;
		end loop;
		end if;
	end process;

	--registro B
	process(clr,clk,sel)
		begin
		if(clr='0')then --if 1
		qB<="0000";
		elsif(clk'event and clk='1') then
		for i in 0 to 3 loop
		case sel is
		--when "00"=>qB(i)<=qB(i);
		when '0'=>qB(i)<=datoB(i);
		when others=>
			if (i=0) then
			qB(i)<=cd;
			else
			qB(i)<=qB(i-1);
			end if;
		end case;
		end loop;
		end if;
	end process;

	--sumador
	process(clr,clk,sel)
		variable s,d,qt: std_logic_vector(3 downto 0);
		begin
		if(clr='0')then --if 1
		qB<="0000";
		elsif(clk'event and clk='1') then
		
		--Ecuaciones
		d:=(qA and qB) or (qA and qt)
			
		
	

end behavioral;

--qt?? varible??
--como conecto a los registros con el sumador?
