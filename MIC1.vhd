library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MIC1 is
	port (
		MBR_reg : out std_logic_vector(15 downto 0);
		MAR_reg : inout std_logic_vector(11 downto 0);
		MBR : in std_logic;
		MAR : in std_logic;
		sigA: in std_logic_vector(3 dowto 0);
		sigB: in std_logic_vector(3 dowto 0);
		sigC: in std_logic_vector(3 dowto 0);
		RD: in std_logic;
		WR: in std_logic;
		rd : out std_logic;
		wr : out std_logic;
		AMUX: in std_logic;
		SH: in std_logic;
		ENC: in std_logic;
		MAR: in std_logic;
		MEM_TO_MBR: in std_logic;
		DATA: in std_logic_vector(15 downto 0);
		z: out std_logic;
		n: out std_logic;
		c: out std_logic_vector(15 downto 0);
		alu: in std_logic
		
	);
end MIC1;

architecture mic of MIC1 is
signal  barA, barB, barC : std_logic_vector(15 downto 0);
signal  ULAresult : std_logic_vector(15 downto 0);
signal	A0 : std_logic;
signal	op2 : std_logic;
signal	PC, AC, SP, IR, TIR, AMASK, SMASK, a, b, c, d, e, f : std_logic_vector(15 downto 0);
signal	saidaAmux : std_logic;
signal  register_RD : std_logic;
signal register_WR : std_logic;

begin
	
	--RD é a entrada para o mic, o register_RD é um sinal interno que funciona como um registrador que logo após o rising_edge ele repassa 
	--seu valor interno para rd que é um sinal de sainda
	process(clk)
		if(rising_edge(clk)) then
			register_RD <= RD;
		end if;
		if(rising_edge(clk)) then 
			rd <= register_RD;
		end if;
	end process
	--WR é a entrada para o mic, o register_WR é um sinal interno que funciona como um registrador que logo após o rising_edge ele repassa 
	--seu valor interno para wr que é um sinal de sainda
	process(clk)
		if(rising_edge(clk)) then
			register_WR<=WR;
		end if;
		if(rising_edge(clk)) then 
			wr <= register_WR;
		end if;
	end process
	
        --case que controla a entrada do barramento A
	case sigA is
		when "0000" => barA <= PC;
		when "0001" => barA <= AC;
		when "0010" => barA <= SP;
		when "0011" => barA <= IR;
		when "0100" => barA <= TIR;
		when "0101" => barA <= 0;
		when "0110" => barA <= 1;
		when "0111" => barA <= -1;
		when "1000" => barA <= AMASK;
		when "1001" => barA <= SMASK;
		when "1010" => barA <= A;
		when "1011" => barA <= B;
		when "1100" => barA <= C;
		when "1101" => barA <= D;
		when "1110" => barA <= E;
		when others => barA <= F;
	end case;

		
		
	--case que controla a entrada do barramento b
	case sigB is
		when "0000" => barB <= PC;
		when "0001" => barB <= AC;
		when "0010" => barB <= SP;
		when "0011" => barB <= IR;
		when "0100" => barB <= TIR;
		when "0101" => barB <= 0;
		when "0110" => barB <= 1;
		when "0111" => barB <= -1;
		when "1000" => barB <= AMASK;
		when "1001" => barB <= SMASK;
		when "1010" => barB <= A;
		when "1011" => barB <= B;
		when "1100" => barB <= C;
		when "1101" => barB <= D;
		when "1110" => barB <= E;
		when others => barB <= F;
	end case;

	
	case A0 is -- AMUX
		when '0' => amux <= A;
		when '1' => amux <= MBR;
	end case;	
		
	--PROCESS QUE CONTROLA O BARRAMENTO C PASSAR OU NÃO DADOS PARA OS REGISTRADORES
	process(clk)
		if(rising_edge(clk)AND ENC='1') then
			case sigC is
				when "0000" =>  PC   <=barC;
				when "0001" =>  AC   <=barC;
				when "0010" =>  SP   <=barC;
				when "0011" =>  IR   <=barC;
				when "0100" =>  TIR  <=barC;
				when "0101" =>   0   <=barC;
				when "0110" =>   1   <=barC;
				when "0111" =>  -1   <=barC;
				when "1000" => AMASK <=barC;
				when "1001" => SMASK <=barC;
				when "1010" =>   A   <=barC;
				when "1011" =>   B   <=barC;
				when "1100" =>   C   <=barC;
				when "1101" =>   D   <=barC;
				when "1110" =>   E   <=barC;
				when others =>   F   <=barC;
			end case;
		else
			enc<=enc;
			sigC<=sigC;
		end if;
	end process;
				
	process(clk)
		if (rising_edge(clk)) then
			if (MAR ='1') then
				MAR_reg <= barB;
			end if;
		end if
	end process;
		
	case alu is
		when "00" => ULAresult <= amux + B;
		when "01" => ULAresult <= amux and B;
		when "10" => ULAresult <= amux;
		when others => ULAresult <= not amux;
		
			if (ULAresult < "0000000000000000") then
				Z <= '1';
				
			elsif (ULAresult(15) = '1') then
				N <= '1';
		end if;	
	end case;
	
	case SH is
		when "00" => barC <= ULAresult;
		when "01" => barC <= '0' & ULAresult(15 downto 1); --desloca 1bit para a esquerda 
		when "10" => barC <= '0' & ULAresult(14 downto 0); --desloca 1bit para a direita
		when "11" => NULL;
	end case;

	process(clk)
		begin
			if(WR = '1') then
				MBR <= barC;
			end if;
		end process;
end mic;
	
	
