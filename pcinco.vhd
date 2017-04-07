library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dec is

port( 
	CLK,CLR: in std_logic;
	CTRL:in std_logic_vector (1 downto 0);
	E: in std_logic_vector (3 downto 0);
	DISPLAY: inout std_logic_vector (6 downto 0));

	--Puertos 
	attribute loc: string;
	attribute loc of CLK: signal is "p4";
	attribute loc of CLR: signal is "p5";
	attribute loc of CTRL: signal is "p6,p7";
	attribute loc of E: signal is "p28,p29,p30,p31";
	attribute loc of DISPLAY: signal is "p125,p124,p123,p122,p98,p97,p96";

end;

architecture a_dec of dec is	             --ABCDEFG
constant DIG0: std_logic_vector (6 downto 0):="1111110";--0
constant DIG1: std_logic_vector (6 downto 0):="0110000";--1
constant DIG2: std_logic_vector (6 downto 0):="1101101";--2
constant DIG3: std_logic_vector (6 downto 0):="1111001";--3
constant DIG4: std_logic_vector (6 downto 0):="0110011";--4
constant DIG5: std_logic_vector (6 downto 0):="1011011";--5
constant DIG6: std_logic_vector (6 downto 0):="1011111";--6
constant DIG7: std_logic_vector (6 downto 0):="1110000";--7
constant DIG8: std_logic_vector (6 downto 0):="1111111";--8
constant DIG9: std_logic_vector (6 downto 0):="1111011";--9
constant DIGERROR: std_logic_vector (6 downto 0):="1001111";
	begin
	process(CLK,CLR,CTRL,DISPLAY,E)
	begin
	
	if(CLR='0')then
		DISPLAY<=DIG0;
	elsif(CLK'EVENT and CLK='1') then
		case CTRL is
		when "10" =>
			case DISPLAY is
			when DIG0 => DISPLAY <= DIG1;
			when DIG1 => DISPLAY <= DIG2;
			when DIG2 => DISPLAY <= DIG3;
			when DIG3 => DISPLAY <= DIG4;
			when DIG4 => DISPLAY <= DIG5;
			when DIG5 => DISPLAY <= DIG6;
			when DIG6 => DISPLAY <= DIG7;
			when DIG7 => DISPLAY <= DIG8;
			when DIG8 => DISPLAY <= DIG9;
			when DIG9 => DISPLAY <= DIG0;
			when others => DISPLAY <= DIGERROR;
			end case;
		when "01" =>
			case DISPLAY is
			when DIG9 => DISPLAY <= DIG8;
			when DIG8 => DISPLAY <= DIG7;
			when DIG7 => DISPLAY <= DIG6;
			when DIG6 => DISPLAY <= DIG5;
			when DIG5 => DISPLAY <= DIG4;
			when DIG4 => DISPLAY <= DIG3;
			when DIG3 => DISPLAY <= DIG2;
			when DIG2 => DISPLAY <= DIG1;
			when DIG1 => DISPLAY <= DIG0;
			when DIG0 => DISPLAY <= DIG9;
			when others => DISPLAY <= DIGERROR;
			end case;
		when "11" => DISPLAY <= DISPLAY;
		when others => case E is
			when "0000" => DISPLAY <= DIG0;
			when "0001" => DISPLAY <= DIG1;
			when "0010" => DISPLAY <= DIG2;
			when "0011" => DISPLAY <= DIG3;
			when "0100" => DISPLAY <= DIG4;
			when "0101" => DISPLAY <= DIG5;
			when "0110" => DISPLAY <= DIG6;
			when "0111" => DISPLAY <= DIG7;
			when "1000" => DISPLAY <= DIG8;
			when "1001" => DISPLAY <= DIG9;
			when others => DISPLAY <= DIGERROR;
			end case;
		end case;
		end if;
		end process;
end a_dec;
