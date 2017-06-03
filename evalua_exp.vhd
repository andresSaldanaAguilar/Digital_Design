library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d is port(
	cd,clk,clr,ctrl:in std_logic;
	display: out std_logic_vector(6 downto 0);
	dato: in std_logic_vector(7 downto 0);
	E: inout std_logic;
	datosal: out std_logic_vector(7 downto 0)
	);

	attribute loc: string;
	
	attribute loc of clk: signal is "p4";
	attribute loc of cd: signal is "p115";
	attribute loc of ctrl: signal is "p116";
	attribute loc of clr: signal is "p114";
	attribute loc of dato: signal is "p5,p6,p7,p8,p9,p11,p12,p13";
	attribute loc of display: signal is "p125,p124,p123,p122,p121,p98,p97";
	attribute loc of datosal: signal is "p28,p29,p30,p31,p33,p39,p40,p41";	

end;

architecture behavioral of d is
		            			     --ABCDEFG
	constant Edsp: std_logic_vector (6 downto 0):="0110000";--E
	constant Cdsp: std_logic_vector (6 downto 0):="0110001";--C
	type estados is(A,B,C,D,F);
	signal edo_presente,edo_futuro:estados;
	begin
	

	process(clk,ctrl,dato,clr)
	begin
	if(clr='0')then
	datosal<="00000000";
	elsif(clk'event and clk='1')then
		for i in 0 to 7 loop
			case ctrl is
			when '0'=>datosal(i)<=dato(i);
			when others=>
				if (i=0) then
				datosal(i)<=cd;
				else
				datosal(i)<=datosal(i-1);
				end if;
			end case;
			end loop;
		E<=datosal(7);		
	end if;		
	end process;


	process(edo_presente,E)
	begin
		case edo_presente is

		when A=>display<=Edsp;	
			if(E='0')then
			edo_futuro<=A;
			else 
			edo_futuro<=B;
			end if;

		when B=>display<=Edsp;
			if(E='0')then
			edo_futuro<=C;
			else 
			edo_futuro<=B;
			end if;
		
		when C=>display<=Edsp;
			if(E='0')then
			edo_futuro<=A;
			else 
			edo_futuro<=D;
			end if;
		

		when D=>if(E='0')then
			display<=Edsp;
			edo_futuro<=C;
			else 
			display<=Cdsp;
			edo_futuro<=F;
			end if;

		when F=>display<=Edsp;
			if(E='0')then
			edo_futuro<=A;
			else 
			edo_futuro<=B;
			end if;

		--when others=>display<=display;
		end case;
		end process;

		process(clr,clk,edo_presente,edo_futuro)
		begin
			--if(clr='0')then
			--display<="1111111";
			if(clk'event and clk='1')then
			edo_presente<=edo_futuro;
			end if;
		end process;
	
end behavioral;

