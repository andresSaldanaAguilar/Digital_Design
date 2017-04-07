library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity contador is

port( 
	control: in std_logic;
	CLK,CLR: in std_logic;
	outputq: out std_logic_vector (9 downto 0));
	--Usar bits, para hacer una converción de std_logic a un bit 													
	
	--Puertos 
	attribute loc: string;
	attribute loc of control: signal is "p4";
	attribute loc of CLK: signal is "p5";
	attribute loc of CLR: signal is "p6";
	attribute loc of outputq: signal is "p125,p124,p123,p122,p121,p98,p97,p96,p95,p94";


end;

architecture a_contador of contador is
begin
	process(control,CLR,CLK)
	variable q,jk: std_logic_vector(9 downto 0);
	begin																
	-------------------------------------------------ff1
		if(CLR='0') then
			q:="0000000000";
		elsif(CLK'EVENT AND CLK='1') then
			
			--Ecuaciones

			jk(9):=(control and not(q(8)) and not(q(7)) and not(q(6)) and not(q(5)) and not(q(4)) and not(q(3)) and not(q(2)) and not(q(1)) and not(q(0))) or (not (control) and q(8) and q(7) and q(6) and q(5) and q(4) and q(3) and q(2) and q(1) and q(0));
			jk(8):=(control and not(q(7)) and not(q(6)) and not(q(5)) and not(q(4)) and not(q(3)) and not(q(2)) and not(q(1)) and not(q(0))) or (not (control) and q(7) and q(6) and q(5) and q(4) and q(3) and q(2) and q(1) and q(0));
			jk(7):=(control and not(q(6)) and not(q(5)) and not(q(4)) and not(q(3)) and not(q(2)) and not(q(1)) and not(q(0))) or (not (control) and q(6) and q(5) and q(4) and q(3) and q(2) and q(1) and q(0));			
			jk(6):=(control and not(q(5)) and not(q(4)) and not(q(3)) and not(q(2)) and not(q(1)) and not(q(0))) or (not (control) and q(5) and q(4) and q(3) and q(2) and q(1) and q(0));
			jk(5):=(control and not(q(4)) and not(q(3)) and not(q(2)) and not(q(1) and not q(0))) or (not (control) and q(4) and q(3) and q(2) and q(1) and q(0));
			jk(4):=(control and not(q(3)) and not(q(2)) and not(q(1)) and not(q(0))) or (not (control) and q(3) and q(2) and q(1) and q(0));
			jk(3):=(control and not(q(2)) and not(q(1)) and not(q(0))) or (not (control) and q(2) and q(1) and q(0));
			jk(2):=(control and not(q(1)) and not(q(0))) or (not (control) and q(1) and q(0));
			jk(1):=(control xor q(0));
			jk(0):='1';
			
			--Logica de el ff(son 3 en total)

			for i in 0 to 9 loop
				if (jk(i)='0') then
					q(i):=q(i);
				else
					q(i):=not(q(i));
				end if;
			end loop;
			outputq<=q; 
		end if;
	end process;
end a_contador;--
