LIBRARY ieee;
USE ieee.std_logic_1164.all;

----------- Entidade do Testbench -----------
entity testbench_MIC1 is
end testbench_MIC1;
---------------------------------------------------

architecture testbench of testbench_MIC1 is
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

component MIC1 is
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
    x1: MIC1
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
		control_data<="0000000000000111";
		control_MBR_signal<='0';
		control_MAR_signal<='0';
		control_sigA<="0000";
		control_sigB<="0000";
		control_sigC<="0000";
		control_wr<='0';
		control_rd<='0';
		control_sh<="00";--barC
		control_enc<='0';
		control_mem_to_mbr<='1';
		control_A0<='0';--Amux
		control_alu<="10";
	wait for 200 ps;
		control_MBR_signal<='0';
		control_sigA<="0000";
		control_sigC<="0000";
		control_wr<='0';
		control_sh<="00";--barC
		control_enc<='1';
		control_mem_to_mbr<='0';
		control_A0<='1';--Amux
		control_alu<="10";	
		control_rd<='0';
		control_sigB<="0000";
		control_MAR_signal<='0';
	wait for 200 ps;
		control_MBR_signal<='0';
		control_MAR_signal<='0';
		control_wr<='0';
		control_mem_to_mbr<='0';
		control_rd<='0';
		control_sigA<="0000";
		control_sigB<="0000";
		control_A0 <= '0';--Amux
		control_alu<="10";
		control_sh<="00";--barC
		control_enc<='0';
		control_sigC<="0000";
	end process;
	process
    begin
			control_clk<='1';
		wait for 100 ps;
			control_clk<='0';
		wait for 100 ps;  
	end process;
end testbench;
