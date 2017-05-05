library ieee;
use ieee.std_logic_1164.all;
entity dec is
port(
		f:in std_logic_vector (3 downto 0);
		c:inout std_logic_vector(3 downto 0);
		clk, clr:in std_logic;
		display:inout std_logic_vector(6 downto 0)
	);
	
	--Puertoss
	attribute loc: string;
	attribute loc of clk: signal is "p5";
	attribute loc of clr: signal is "p4";
	attribute loc of c: signal is "p32,p33,p39,p40";
	attribute loc of f: signal is "p28,p29,p30,p31";
	attribute loc of display: signal is "p125,p124,p123,p122,p121,p98,p97";

end dec;
architecture a_dec of dec is

	signal tecla: std_logic_vector (6 downto 0);	     --ABCDEFG
	constant dig0: 		std_logic_vector(6 downto 0):="1111110";
	constant dig1: 		std_logic_vector(6 downto 0):="0110000";
	constant dig2: 		std_logic_vector(6 downto 0):="1101101";
	constant dig3: 		std_logic_vector(6 downto 0):="1111001";
	constant dig4: 		std_logic_vector(6 downto 0):="0110011";
	constant dig5: 		std_logic_vector(6 downto 0):="1011011";
	constant dig6: 		std_logic_vector(6 downto 0):="1011111";
	constant dig7: 		std_logic_vector(6 downto 0):="1110000";
	constant dig8: 		std_logic_vector(6 downto 0):="1111111";
	constant dig9: 		std_logic_vector(6 downto 0):="1110011";
	constant digA: 		std_logic_vector(6 downto 0):="1110110";
	constant digB: 		std_logic_vector(6 downto 0):="0011111";
	constant digC: 		std_logic_vector(6 downto 0):="1001110";
	constant digD: 		std_logic_vector(6 downto 0):="0111100";
	constant digGa: 	std_logic_vector(6 downto 0):="0001001";--=
	constant digAs: 	std_logic_vector(6 downto 0):="0010100";--ll
	constant notecla: 	std_logic_vector(6 downto 0):="0000001";
	begin
		
		process(f,c)
		begin
			case f & c is
				when "0111"&"0111"=>tecla<=dig1;
				when "0111"&"1011"=>tecla<=dig2;
				when "0111"&"1101"=>tecla<=dig3;
				when "0111"&"1110"=>tecla<=digA;
				when "1011"&"0111"=>tecla<=dig4;
				when "1011"&"1011"=>tecla<=dig5;
				when "1011"&"1101"=>tecla<=dig6;
				when "1011"&"1110"=>tecla<=digB;				
				when "1101"&"0111"=>tecla<=dig7;
				when "1101"&"1011"=>tecla<=dig8;
				when "1101"&"1101"=>tecla<=dig9;
				when "1101"&"1110"=>tecla<=digC;
				when "1110"&"0111"=>tecla<=digAs;
				when "1110"&"1011"=>tecla<=dig0;
				when "1110"&"1101"=>tecla<=digGa;
				when "1110"&"1110"=>tecla<=digD;
				when others =>tecla<=notecla;
			end case;
		end process ; -- decodificadorDHs
		
		process(clr,clk)
		begin
			if(clr='0') then
				c<="1110";
			elsif (clk'event and clk='1') then
				c<=to_stdlogicvector(to_bitvector(c)ror 1);
			end if;
		end process ; -- anillo
		
		process(clk,clr,display)
		begin
			if (clr='0') then
				display<=notecla;
			elsif (clk'event and clk='1') then
				if (f="1111") then
					display<=display;
				else
					display<=tecla;
				end if ;
			end if ;
		end process ; -- registro

end a_dec; -- a_teclakdoD
