LIBRARY ieee;
USE ieee.std_logic_1164.all;

----------- Entidade do Testbench -----------
entity testbench_MIC1 is
end testbench_MIC1;
---------------------------------------------------

architecture testbench of testbench_MIC1 is
signal control_clk,control_MAR_signal, control_MBR_signal,control_wr,control_rd,control_enc,control_mem_to_mbr,control_A0:std_logic; 
signal saida_MBR,saida_C,control_data: STD_LOGIC_vector(15 downto 0);
signal saida_z,saida_n,saida_regis_rd,saida_regis_wr:std_logic;
signal saida_MAR:std_logic_vector(11 downto 0);
signal control_sigA, control_sigB, control_sigC: std_logic_vector(3 downto 0);
signal control_sh,control_alu: std_logic_vector(1 downto 0);

component MIC1 is
    port (clk:in std_logic;
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
	MBR_reg=>saida_MBR,
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
	control_clk<='1';
	wait for 100 ps;
	control_clk<='0';
	wait for 100 ps;  
	end process;
	process
	begin
	wait for 200 ps;
	control_data<="0000000000000000";
	control_MBR_signal<='0';
	control_sigA<="0000";
	control_sigC<="0000";
	control_wr<='0';
	control_sh<="00";
	control_enc<='0';
	control_mem_to_mbr<='0';
	control_A0<='0';
	control_alu<="00";	
	control_rd<='1';
	control_sigB<="0000";
	control_MAR_signal<='1';
	wait for 200 ps;
	control_data<="0000000000000000";
	control_MBR_signal<='0';
	control_MAR_signal<='0';
	control_wr<='0';
	control_mem_to_mbr<='0';
	control_rd<='1';
	control_sigA<="0000";
	control_sigB<="0110";
	control_A0 <= '0';
	control_alu<="00";
	control_sh<="00";
	control_enc<='1';
	control_sigC<="0000";
	wait for 200 ps;
	control_data<="0000000000000000";
	control_MBR_signal<='0';
	control_MAR_signal<='0';
	control_sigA<="0000";
	control_sigB<="0000";
	control_wr<='0';
	control_rd<='0';
	control_mem_to_mbr<='0';
	control_A0<='1';
	control_alu<="10";
	control_sh<="00";
	control_sigC<="0011";
	control_enc<='1';
	wait for 200 ps;
	control_data<="0000000000000000";
	control_MBR_signal<='0';
	control_MAR_signal<='0';
	control_wr<='0';
	control_rd<='0';
	control_mem_to_mbr<='0';
	control_sigA<="0011";
	control_sigB<="0011";
	control_A0<='0';
	control_alu<="00";
	control_sh<="01";
	control_enc<='1';
	control_sigC<="0100";
	wait for 200 ps;
	control_data<="0000000000000000";
	control_MBR_signal<='0';
	control_MAR_signal<='0';
	control_sigB<="0000";
	control_wr<='0';
	control_rd<='0';
	control_mem_to_mbr<='0';
	control_sigA<="0011";
	control_A0<='0';
	control_alu<="10";
	control_sh<="01";
	control_enc<='1';
	control_sigC<="0100";
	wait for 200 ps;
	
    end process;
end testbench;
--control_data<="0000000000000000";control_MBR_signal<='0';control_MAR_signal<='0';control_sigA<="0000";control_sigB<="0000";control_sigC<="0000";control_wr<='0';control_rd<='0'control_sh<="00";control_enc<='0';control_mem_to_mbr<='0';control_A0<='0';control_alu<="00";
