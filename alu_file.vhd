library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is port(
	--A,B,C,EB: inout std_logic_vector(3 downto 0);
	ctrl,clk,clr: in std_logic);
	
end;

architecture a_alu of alu is
begin
	process(ctrl,clk,clr)
		--variables 
		variable A,B,C,EB,jk,S: std_logic_vector(3 downto 0);
		begin
		
		--if(clr='0') then
		--	q:="0000000000";
		--elsif(clk'EVENT AND clk='1') then
		

		-------------------------------------MUX
		for i in 0 to 3 loop
		if(ctrl='0')then
		EB(i):=B(i);
		else
		EB(i):=(not B(i));
		end if;
		end loop;
		--------------------------------------ECUACIONES
		for i in 0 to 3 loop
		S(i):=A(i) xor B(i) xor C(i); --ci esta bien??
		C(i):=(A(i) and B(i))or(A(i) and C(i))or(B(i) and C(i));
		end loop;
		--------------------------------------FF's
		for i in 0 to 3 loop
			if (jk(i)='0') then
			S(i):=S(i);
			else
			S(i):=not(S(i));
			end if;
		end loop;
	
		
	end process;
end a_alu;

