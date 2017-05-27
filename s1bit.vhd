library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity d is port(
	sel,cd,clk,clr: in std_logic;
	stop,q,s,mibA,mibB: inout std_logic;
	datoA,datoB: in std_logic_vector (4 downto 0);
	qA,qB: inout std_logic_vector (4 downto 0);--registros
	salida: inout std_logic_vector(4 downto 0);--salida finales
	carry: out std_logic);

	attribute loc: string;
	
	attribute loc of clk: signal is "p4";
	attribute loc of cd: signal is "p115";
	attribute loc of sel: signal is "p116";
	attribute loc of clr: signal is "p114";
	attribute loc of datoA: signal is "p5,p6,p7,p8,p14";
	attribute loc of datoB: signal is "p9,p11,p12,p13,p15";
	attribute loc of qA: signal is "p28,p29,p30,p31,p42";
	attribute loc of qB: signal is "p33,p39,p40,p41,p43";
	attribute loc of salida: signal is "p96,p95,p94,p93,p88";
	attribute loc of carry: signal is "p113";
	attribute loc of stop: signal is "p112";
	
end;

architecture behavioral of d is
begin
	--registro A
	process(clr,clk,sel,qA,qB,datoA)
		begin
		if(clr='0')then
			qA<="00000";
		elsif(clk'event and clk='1') then
		mibA<=qA(0);
			for i in 0 to 4 loop
			case sel is
			when '0'=>qA(i)<=datoA(i);
			when others=>
				if (i=4) then
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
		qB<="00000";
		elsif(clk'event and clk='1') then
		mibB<=qB(0);
			for i in 0 to 4 loop
			case sel is
			when '0'=>qB(i)<=datoB(i);
			when others=>
				if (i=4) then
				qB(i)<=cd;
				else
				qB(i)<=qB(i+1);
				end if;
			end case;
			end loop;
		end if;
	end process;

	--sumador
	process(clr,clk,sel,mibA,mibB)
		begin
	
		if(clr='0')then --if 1
		s<='0';
		q<='0';
		
		elsif(clk'event and clk='1') then
		
		if(sel='0')then
		--controla el que no entre el 1er bit sin llamrlo
		q<='0';
		s<='0';
		else
	
		if(mibA='0' and	mibB='0' and q='0')then
			s<='0';
			q<='0';
		elsif(mibA='0' and mibB='0' and q='1')then
			s<='1';
			q<='0';
		elsif(mibA='1' and mibB='1' and q='0')then
			s<='0';
			q<='1';			
		elsif(mibA='1' and mibB='1' and q='1')then
			s<='1';
			q<='1';
		elsif(mibA='1' and mibB='0' and q='0')then
			s<='1';
			q<='0';
		elsif(mibA='1' and mibB='0' and q='1')then
			s<='0';
			q<='1';
		elsif(mibA='0' and mibB='1' and q='0')then
			s<='1';
			q<='0';
		elsif(mibA='0' and mibB='1' and q='1')then
			s<='0';
			q<='1';		
		end if;
		end if;
		end if;
	end process;

	--registro que muestra resultado
	process(clr,clk,s,q,stop,salida)
		begin
		if(clr='0')then --if 1
		salida<="00000";
		carry<='0';
		elsif(clk'event and clk='1') then
			carry<=q;
			salida(3)<=s;
			for j in 0 to 4 loop
			case stop is
			when '1'=>salida(j)<=salida(j);
					carry<=carry;
			when others=>
				--controlandoel carry			
				if (j=4) then
				salida(j)<=s;			
				else				
				salida(j)<=salida(j+1);
				end if;
			end case;
			end loop;		
	end if;
	end process;
end behavioral;

