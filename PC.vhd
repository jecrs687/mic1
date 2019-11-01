-- UNIVERSIDADE FEDERAL DO PIAUÍ
-- PARTE DE CONTROLE DO MIC-1
-- INTEGRANTES: JOSÉ EMANUEL
--------------- ISAAC RAMOS

LIBRARY ieee;
USE ieee.std_logic_1164.all;

----------- Entidade da parte de controle -----------
entity PC is
	Port(
    entrada : in std_logic_vector(15 downto 0) := "0000000000000000";
	saida : out std_logic_vector(15 downto 0) := "0000000000000000");
end PC;
---------------------------------------------------

architecture Parte_Controle of PC is
signal control_clk:std_logic :=  '0';
signal control_MAR_signal:std_logic := '0';
signal control_MBR_signal: std_logic := '0';
signal control_wr: std_logic := '0';
signal control_rd: std_logic := '0';
signal control_enc: std_logic := '0';
signal control_mem_to_mbr: std_logic := '0';
signal control_A0:std_logic := '0'; 
signal saida_MBR: std_logic_vector(15 downto 0) := "0000000000000000"; 
signal saida_C: std_logic_vector(15 downto 0)   := "0000000000000000";
signal control_data: STD_LOGIC_vector(15 downto 0) := "0000000000000000";
signal saida_z: std_logic := '0';
signal saida_n: std_logic := '0';
signal saida_regis_rd: std_logic := '0';
signal saida_regis_wr: std_logic := '0';
signal saida_MAR: std_logic_vector(11 downto 0) := "000000000000";
signal control_sigA: std_logic_vector(3 downto 0) := "0000"; 
signal control_sigB: std_logic_vector(3 downto 0) := "0000"; 
signal control_sigC: std_logic_vector(3 downto 0) := "0000"; 
signal control_sh: std_logic_vector(1 downto 0) := "00";
signal control_alu: std_logic_vector(1 downto 0) := "00";

component PO is
    port (	clk:in std_logic;
		mbr_out : out std_logic_vector(15 downto 0);
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
		mar_signal :in std_logic);
end component;


begin
    x1: PO
    PORT MAP(
	clk=>control_clk,	
	mar_signal => control_MAR_signal,
 	mbr_signal => control_MBR_signal,
	sigA=> control_sigA,
	sigB=> control_sigB,
	sigC=> control_sigC,
	wr=>control_wr,
	rd=>control_rd,
	sh=>control_sh,
	enc=>control_enc,
	mem_to_mbr=>control_mem_to_mbr,
	alu=>control_alu,
	A0=>control_A0,
	mbr_out=>saida_MBR,
	C_out=>saida_C,
	DATA=>control_data,
	z=>saida_z,
	n=>saida_n,
	regis_rd=>saida_regis_rd,
	regis_wr=>saida_regis_wr,
	mar_reg => Saida_MAR
);
process
	begin
		control_clk<='0';
	wait for 100 ps;
		control_clk<='1';
	wait for 100 ps;  
end process;
process 				
	begin
		if (control_clk'event and control_clk='1') then
			--linha 0
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='1';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			wait until (control_clk'event and control_clk='1');
			--linha1
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_mem_to_mbr<='1';
			control_rd<='1';
			control_sigA<="0110";
			control_sigB<="0000";
			control_A0 <= '0';--Amux
			control_alu<="00"; -- soma
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0000";
			wait until (control_clk'event and control_clk='1');
			--linha 2
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '1';--Amux
			control_alu<="10";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0011";
			wait until (control_clk'event and control_clk='1');
			
		case entrada(15 downto 12) is
			when "0000" =>   ----------------------------------------- LODDX
			--linha 6
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '1';
			control_wr<='0';
			control_mem_to_mbr<='1';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="0011";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 7
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_mem_to_mbr<='1';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";

			wait until (control_clk'event and control_clk='1');
			-- linha 8
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '1';--Amux
			control_alu<="10";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0001";
			
			when "0001" => -------------------------------------------------------------------------------------- STODD
			--linha 9
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '1';
			control_MAR_signal<= '1';
			control_wr<='1';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="0011";
			control_A0 <= '0';--Amux
			control_alu<="10";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 10
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='1';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
	
			when "0010" =>---------------------------------------------------------------------------------------------------- ADDD
			--linha 12
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '1';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="0011";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 13
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='1';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 14
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0001";
			control_A0 <= '1';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0001";
			
			when "0011" => ------------------------------------------------------------------------------------ SUBD
			--linha 15
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '1';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="0011";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 16
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='1';
			control_rd<='1';
			control_sigA<="0110";
			control_sigB<="0001";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0001";
			
			wait until (control_clk'event and control_clk='1');
			--linha 17
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '1';--Amux
			control_alu<="11";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="1010";
			
			wait until (control_clk'event and control_clk='1');
			--linha 18
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="1010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0001";
			
			when "0100" => ------------------------------------------------------------------------------------ JPOS
			--linha 21
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="0000";
			control_sigC<="0000";
			control_A0 <= '0';--Amux
			control_alu<="10";
			control_enc<='0';
			control_sh<="00";
			
			wait until (control_clk'event and control_clk='1');
				if(saida_n = '0') then
				--linha 22
				control_data <= "0000"&entrada(11 downto 0);						
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="0011";
				control_sigB<="1000";
				control_sigC<="0000";
				control_A0 <= '0';--Amux
				control_alu<="01";
				control_enc<='1';
				control_sh<="00";
				end if;
			when "0101" => ------------------------------------------------------------------------------------ JZER
			--linha 23
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="0000";
			control_sigC<="0000";
			control_A0 <= '0';--Amux
			control_alu<="10";
			control_enc<='1';
			control_sh<="00";
			wait until (control_clk'event and control_clk='1');
			if(saida_z = '1') then
				--linha 22
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="0011";
				control_sigB<="1000";
				control_sigC<="0000";
				control_A0 <= '0';--Amux
				control_alu<="01";
				control_enc<='1';
				control_sh<="00";
			end if;
			
			when "0110" => ----------------[REVISAR]------------------------------------------------------------ JUMP
			--linha 26
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0011";
			control_sigB<="0101";
			control_sigC<="0000";
			control_A0 <= '0';--Amux
			control_alu<="01";
			control_enc<='1';
			control_sh<="00";

			when "0111" => ------------------------------------------------------------------------------------ LOCO
			--linha 27
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0011";
			control_sigB<="0101";
			control_sigC<="0001";
			control_A0 <= '0';--Amux
			control_alu<="01";
			control_enc<='1';
			control_sh<="00";
			
			
			when "1000" => ------------------------------------------------------------------------------------ LODL
			--linha 31
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0010";
			control_sigB<="0011";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="1010";
			
			wait until (control_clk'event and control_clk='1');
			--linha 32
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '1';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="1010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 7
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='1';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 8
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '1';--Amux
			control_alu<="10";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0001";
			
			when "1001" => ----------------------------------------------------------------------------------- STOL
			--linha 33
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0011";
			control_sigB<="0010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="1010";
			
			wait until (control_clk'event and control_clk='1');
			--linha 34
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='1';
			control_MAR_signal<='1';
			control_wr<='1';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="1010";
			control_A0 <= '0';--Amux
			control_alu<="10";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			----linha 10
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='1';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			when "1010" => ------------------------------------------------------------------------------------- ADDL
			--linha 36
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0011";
			control_sigB<="0010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="1010";
			
			wait until (control_clk'event and control_clk='1');
			--linha 37
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='1';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="1010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			when "1011" => -----------------------------------------------------------------------------------------SUBL
			--linha 38
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0011";
			control_sigB<="0010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="1010";
			
			wait until (control_clk'event and control_clk='1');
			--linha 39
			control_data <= "0000"&entrada(11 downto 0); 
			control_MBR_signal<= '0';
			control_MAR_signal<= '1';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='1';
			control_sigA<="0000";
			control_sigB<="1010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='0';
			control_sigC<="0000";
			
			wait until (control_clk'event and control_clk='1');
			--linha 16
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='1';
			control_rd<='1';
			control_sigA<="0110";
			control_sigB<="0001";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="0001";
			
			wait until (control_clk'event and control_clk='1');
			--linha 17
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0000";
			control_A0 <= '1';--Amux
			control_alu<="11";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="1010";
			
			wait until (control_clk'event and control_clk='1');
			--linha 18
			control_data <= "0000"&entrada(11 downto 0);
			control_MBR_signal<= '0';
			control_MAR_signal<= '0';
			control_wr<='0';
			control_mem_to_mbr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="1010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_sh<="00";--barC
			control_enc<='1';
			control_sigC<="1010"; 
			
			when "1100" => --------------------------------------------------------------------------------------------------------------JNEG
			--linha 42
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="0000";
			control_sigC<="0000";
			control_A0 <= '0';--Amux
			control_alu<="10";
			control_enc<='0';
			control_sh<="00";
			wait until (control_clk'event and control_clk='1');
			if(saida_n = '1') then
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="0011";
				control_sigB<="0100";
				control_sigC<="0000";
				control_A0 <= '0';--Amux
				control_alu<="01";
				control_enc<='1';
				control_sh<="00";
			end if;
			
			when "1101" => ------------------------------------------------------------------------------------------------------------------------------- JNZE
			--linha 44
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0001";
			control_sigB<="0000";
			control_sigC<="0000";
			control_A0 <= '0';--Amux
			control_alu<="10";
			control_enc<='0';
			control_sh<="00";
			
			wait until (control_clk'event and control_clk='1');
			--linha 45
			if(saida_z = '0') then
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="0011";
				control_sigB<="0100";
				control_sigC<="0000";
				control_A0 <= '0';--Amux
				control_alu<="01";
				control_enc<='1';
				control_sh<="00";
			end if;
			
			when "1110" => ----------------------------------------------------------------------------------------------------------------------- CALL
			--linha 47
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0111";
			control_sigB<="0010";
			control_sigC<="0010";
			control_A0 <= '0';--Amux
			control_alu<="00";
			control_enc<='1';
			control_sh<="00";
			
			wait until (control_clk'event and control_clk='1');
			--linha 48
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='1';
			control_MAR_signal<='1';
			control_wr<='1';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0010";
			control_sigC<="0000";
			control_A0 <= '0';--Amux
			control_alu<="10";
			control_enc<='0';
			control_sh<="00";
			
			wait until (control_clk'event and control_clk='1');
			--linha 49
			control_data <= "0000"&entrada(11 downto 0);
			control_mem_to_mbr<='0';
			control_MBR_signal<='0';
			control_MAR_signal<='0';
			control_wr<='0';
			control_rd<='0';
			control_sigA<="0000";
			control_sigB<="0100";
			control_sigC<="0000";
			control_A0 <= '0';--Amux
			control_alu<="01";
			control_enc<='1';
			control_sh<="00";


			case entrada(15 downto 9) is
			when "1111000" =>
				--linha 53
				control_data <= "0000"&entrada(11 downto 0);
				control_MBR_signal<= '0';
				control_MAR_signal<= '1';
				control_wr<='0';
				control_mem_to_mbr<='0';
				control_rd<='1';
				control_sigA<="0000";
				control_sigB<="0010";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";

				wait until (control_clk'event and control_clk='1');
				--linha 54
				control_data <= "0000"&entrada(11 downto 0);
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='0';
				control_mem_to_mbr<='1';
				control_rd<='1';
				control_sigA<="0010";
				control_sigB<="0111";
				control_A0 <= '0';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='1';
				control_sigC<="0010";
				
				wait until (control_clk'event and control_clk='1');
				--linha 55
				control_data <= "0000"&entrada(11 downto 0);
				control_MBR_signal<= '0';
				control_MAR_signal<= '1';
				control_wr<='1';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0000";
				control_sigB<="0010";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				wait until (control_clk'event and control_clk='1');
				--linha 10
				control_data <= "0000"&entrada(11 downto 0); 
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='1';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0000";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				when "1111001" => ------------------------------------------------------------------ POPI
				--linha 56
				control_data <= "0000"&entrada(11 downto 0); 
				control_MBR_signal<= '0';
				control_MAR_signal<= '1';
				control_wr<='0';
				control_mem_to_mbr<='1';
				control_rd<='1';
				control_sigA<="0010";
				control_sigB<="0010";
				control_A0 <= '0';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='1';
				control_sigC<="0010";
				
				wait until (control_clk'event and control_clk='1');
				--linha 57
				control_data <= "0000"&entrada(11 downto 0); 
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='0';
				control_mem_to_mbr<='1';
				control_rd<='1';
				control_sigA<="0000";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				wait until (control_clk'event and control_clk='1');
				--linha 58
				control_data <= "0000"&entrada(11 downto 0);
				control_MBR_signal<= '0';
				control_MAR_signal<= '1';
				control_wr<='1';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0000";
				control_sigB<="0010";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				wait until (control_clk'event and control_clk='1');
				--linha 10
				control_data <= "0000"&entrada(11 downto 0); 
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='1';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0000";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				when "1111010" => ------------------------------------------------------------------------------------ PUSH
				--linha 60
				control_data <= "0000"&entrada(11 downto 0);
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='0';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0010";
				control_sigB<="0111";
				control_A0 <= '0';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='1';
				control_sigC<="0010";
				
				wait until (control_clk'event and control_clk='1');
				--linha 61
				control_data <= "0000"&entrada(11 downto 0);
				control_MBR_signal<= '1';
				control_MAR_signal<= '1';
				control_wr<='1';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0001";
				control_sigB<="0010";
				control_A0 <= '0';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				wait until (control_clk'event and control_clk='1');
				--linha 10<
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='1';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0000";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				when "1111011" => ------------------------------------------------------------------------- POP
				--linha 62<
				control_MBR_signal<= '0';
				control_MAR_signal<= '1';
				control_wr<='0';
				control_mem_to_mbr<='1';
				control_rd<='1';
				control_sigA<="0010";
				control_sigB<="0010";
				control_A0 <= '0';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='1';
				control_sigC<="0010";
				
				wait until (control_clk'event and control_clk='1');
				--linha 63<
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='0';
				control_mem_to_mbr<='1';
				control_rd<='1';
				control_sigA<="0000";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0000";
				
				wait until (control_clk'event and control_clk='1');
				--linha 8
				control_data <= "0000"&entrada(11 downto 0);
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_mem_to_mbr<='1';
				control_rd<='0';
				control_sigA<="0000";
				control_sigB<="0000";
				control_A0 <= '1';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='0';
				control_sigC<="0001";
				
				when "1111100" => -------------------------------------------------------------------------- RETN
				--linha 67
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='1';
				control_MBR_signal<='0';
				control_MAR_signal<='1';
				control_wr<='0';
				control_rd<='1';
				control_sigA<="0110";
				control_sigB<="0010";
				control_sigC<="0010";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_enc<='1';
				control_sh<="00";
				
				wait until (control_clk'event and control_clk='1');
				--linha 68
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='1';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='1';
				control_sigA<="0000";
				control_sigB<="0000";
				control_sigC<="0000";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_enc<='0';
				control_sh<="00";
				
				wait until (control_clk'event and control_clk='1');
				--linha 69
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="0000";
				control_sigB<="0000";
				control_sigC<="0000";
				control_A0 <= '1';--Amux
				control_alu<="10";
				control_enc<='1';
				control_sh<="00";
				
				
				when "1111101" => -------------------------------------------------------------------------- SWAP
				--linha 70<
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='0';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0001";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_sh<="00";--barC
				control_enc<='1';
				control_sigC<="1010";
				
				wait until (control_clk'event and control_clk='1');
				--linha 71<
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='0';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="0010";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='1';
				control_sigC<="0001";
				
				wait until (control_clk'event and control_clk='1');
				--linha 72<
				control_MBR_signal<= '0';
				control_MAR_signal<= '0';
				control_wr<='0';
				control_mem_to_mbr<='0';
				control_rd<='0';
				control_sigA<="1010";
				control_sigB<="0000";
				control_A0 <= '0';--Amux
				control_alu<="10";
				control_sh<="00";--barC
				control_enc<='1';
				control_sigC<="0010";
				
				when "1111110" => ------------------------------------------------------------------------------------------------------------ INSP
				--linha 74
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="0011";
				control_sigB<="0100";
				control_sigC<="1010";
				control_A0 <= '0';--Amux
				control_alu<="01";
				control_enc<='1';
				control_sh<="00";
				
				wait until (control_clk'event and control_clk='1');
				--linha 75
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="1010";
				control_sigB<="0010";
				control_sigC<="0010";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_enc<='1';
				control_sh<="00";
				
				when "1111111" => ------------------------------------------------------------------------------------------------ DESP
				--linha 76
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="0011";
				control_sigB<="0100";
				control_sigC<="1010";
				control_A0 <= '0';--Amux
				control_alu<="01";
				control_enc<='1';
				control_sh<="00";
				
				wait until (control_clk'event and control_clk='1');
				--linha 77
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="1010";
				control_sigB<="0100";
				control_sigC<="1010";
				control_A0 <= '0';--Amux
				control_alu<="11";
				control_enc<='1';
				control_sh<="00";
				
				wait until (control_clk'event and control_clk='1');
				--linha 78
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="1010";
				control_sigB<="0110";
				control_sigC<="1010";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_enc<='1';
				control_sh<="00";
				
				wait until (control_clk'event and control_clk='1');
				--linha 75
				control_data <= "0000"&entrada(11 downto 0);
				control_mem_to_mbr<='0';
				control_MBR_signal<='0';
				control_MAR_signal<='0';
				control_wr<='0';
				control_rd<='0';
				control_sigA<="1010";
				control_sigB<="0010";
				control_sigC<="0010";
				control_A0 <= '0';--Amux
				control_alu<="00";
				control_enc<='1';
				control_sh<="00";
			when others=> NULL;
			end case;	
			when others=> NULL;
		end case;
		else
		control_data <= "0000"&entrada(11 downto 0);
		control_mem_to_mbr<='0';
		control_MBR_signal<='0';
		control_MAR_signal<='0';
		control_wr<='0';
		control_rd<='0';
		control_sigA<="0000";
		control_sigB<="0000";
		control_sigC<="0000";
		control_A0 <= '0';--Amux
		control_alu<="00";
		control_enc<='0';
		control_sh<="00";
		end if;
		wait until (control_clk'event and control_clk='1');
	end process;
end Parte_Controle;
