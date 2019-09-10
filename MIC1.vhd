library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MIC1 is
	port (	
		clk:in std_logic;
		MBR_reg : inout std_logic_vector(15 downto 0);
		MAR_reg : out std_logic_vector(11 downto 0);
		sigA : in std_logic_vector(3 downto 0);
		sigB : in std_logic_vector(3 downto 0);
		sigC : in std_logic_vector(3 downto 0);
		RD : in std_logic;
		WR : in std_logic;
		A0 : in std_logic; 
		regis_rd : out std_logic; 
		regis_wr : out std_logic; 
		SH : in std_logic_vector(1 downto 0);
		ENC : in std_logic;
		mem_to_mbr : in std_logic;   -- memoria para mbr
		DATA: in std_logic_vector(15 downto 0); -- De onde vem DATA?
		z : out std_logic;
		n : out std_logic;
		C_out : out std_logic_vector(15 downto 0); -- nao implementado ainda, o que fazer?
		alu : in std_logic_vector(1 downto 0);
  		mbr_signal :in std_logic;
		mar_signal :in std_logic
	);
end MIC1;

architecture mic of MIC1 is
signal  barA, barB, barC : std_logic_vector(15 downto 0);
signal  ULAresult : std_logic_vector(15 downto 0);
signal	op2 : std_logic;
signal	PC, AC, SP, IR, TIR, AMASK, SMASK, a, b, c, d, e, f,zero,um,menos_um,saidaAmux : std_logic_vector(15 downto 0);
signal  register_RD : std_logic;

signal  register_WR : std_logic;

begin
	C_out<=barC;
	zero <= "0000000000000000";
	um <= "0000000000000001";
	menos_um <= "1111111111111111";
	AMASK <= "0000111111111111";
	SMASK <= "0000000011111111";
		
	--RD é a entrada para o mic, o register_RD é um sinal interno que funciona como um registrador que logo após o rising_edge ele repassa 
	--seu valor interno para rd que é um sinal de sainda
-----------------------------------------------------------------------------------------------------------------
	process(clk)
		begin
		if(rising_edge(clk)) then
			register_RD <= RD;
		else
			register_RD<= register_RD;
		end if;
	end process;
	--WR é a entrada para o mic, o register_WR é um sinal interno que funciona como um registrador que logo após o rising_edge ele repassa 
	--seu valor interno para wr que é um sinal de sainda
-----------------------------------------------------------------------------------------------------------------
	process(clk)
		begin
		if(rising_edge(clk)) then
			register_WR<=WR;
			else
			register_WR<=register_WR; 
		end if;
	end process;
-----------------------------------------------------------------------------------------------------------------
	
with alu select
ULAresult <=saidaAmux  + B when "00",
saidaAmux and B when "01",
saidaAmux when "10",
not saidaAmux when others;
-----------------------------------------------------------------------------------------------------------------
with A0 select -- AMUX
saidaAmux <= barA when '0',
MBR_reg when '1',
saidaAmux when others;  
-----------------------------------------------------------------------------------------------------------------
with SH select
barC <= ULAresult when "00",
ULAresult(14 downto 0)&'0' when "01", --desloca 1bit para a direita 
'0' & ULAresult(15 downto 1) when "10", --desloca 1bit para a esquerda
barC when others;
-----------------------------------------------------------------------------------------------------------------	
        --case que controla a entrada do barramento A
	with sigA select
		barA <= PC when "0000",
		AC when "0001",
		SP when "0010" ,
		IR when "0011",
		TIR when "0100",
		zero when "0101",
		um when "0110",
		menos_um when "0111",
		AMASK when "1000",
		SMASK when "1001",
		A when "1010" ,
		B when "1011" ,
		C when "1100" ,
		D when "1101" ,
		E when "1110" ,
		F when others;
-----------------------------------------------------------------------------------------------------------------
	--case que controla a entrada do barramento b
	with sigB select
	barB <= PC when "0000",
		AC when "0001",
		SP when "0010" ,
		IR when "0011",
		TIR when "0100",
		zero when "0101",
		um when "0110",
		menos_um when "0111",
		AMASK when "1000",
		SMASK when "1001",
		A when "1010" ,
		B when "1011" ,
		C when "1100" ,
		D when "1101" ,
		E when "1110" ,
		F when others;

	--PROCESS QUE CONTROLA O BARRAMENTO C PASSAR OU NÃO DADOS PARA OS REGISTRADORES
-----------------------------------------------------------------------------------------------------------------	
	process(clk)
		begin
		if(clk'event and clk='1' AND ENC='1') then
			case sigC is
				when "0000" =>  PC   <= barC;
				when "0001" =>  AC   <= barC;
				when "0010" =>  SP   <= barC;
				when "0011" =>  IR   <= barC;
				when "0100" =>  TIR  <= barC;
				when "1010" =>   A   <=barC;
				when "1011" =>   B   <=barC;
				when "1100" =>   C   <=barC;
				when "1101" =>   D   <=barC;
				when "1110" =>   E   <=barC;
				when "1111" =>   F   <=barC;
			when others => NULL;  
			end case;
		end if;
	end process;
-----------------------------------------------------------------------------------------------------------------				
	process(clk)
		begin
		if (rising_edge(clk) and MAR_signal='1') then
				MAR_reg <= barB(11 downto 0);
		end if;
	end process;  
-----------------------------------------------------------------------------------------------------------------	 
with ULAresult select
	z<= '1' when "0000000000000000",
	'0' when others;
with ULAresult(15) select
		N<= '1' when '1', 
	'0' when others;

-----------------------------------------------------------------------------------------------------------------
	process(clk)
		begin
		if (rising_edge(clk)) then 
			if(mbr_signal = '1' and mem_to_mbr ='0') then 
				MBR_reg <= barC;
		elsif(MBR_signal ='1' and mem_to_mbr ='1') then 
			MBR_reg <= DATA;
			else 
		MBR_reg <= MBR_reg;
		end if;
		end if;
	end process;
-----------------------------------------------------------------------------------------------------------------
end mic;
