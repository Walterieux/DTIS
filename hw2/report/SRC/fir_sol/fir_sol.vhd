library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.array_t.all;

entity fir_sol is
    Port ( 
        Reset : in  STD_LOGIC;
        Clk : in  STD_LOGIC;
        Input : in array32_t(0 to 9); -- This data type is defined in components/array_t.vhd
        Output : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end fir_sol;

architecture Behavioral of fir_sol is
    -- These are the only components you can use. Note that you do not have to use them all.
    -- You can look up their implementation in components/*.vhd
    component adder 
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component reg 
    Port ( Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Load : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
    end component;

    component mul32_32 
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           O : out  STD_LOGIC_VECTOR (31 downto 0));
    end component;

    signal mout : array32_t(0 to 4);
    signal level1_res : array32_t(0 to 4);
    signal level2_res : array32_t(0 to 12);
    signal level3_res : array32_t(0 to 6);
    signal level4_res : array32_t(0 to 3);
    signal level5_res : array32_t(0 to 1);

begin
    -- Your code should start here
    -- IMPORTANT: This is the only VHDL file you can change

    ---------------------------------------------------------------------------
    -- LEVEL 1
    ---------------------------------------------------------------------------
    -- add input that share the same multuplication factor
    f1: for i in 0 to 4 generate
        add0: adder port map (
            A => Input(i),
            B => Input(9 - i),
            O => level1_res(i)
        );
    end generate f1;

    ---------------------------------------------------------------------------
    -- LEVEL 2
    ---------------------------------------------------------------------------
    -- 19 = 1<<4 + 1<<1 + 1
    level2_res(0) <= level1_res(0)(27 DOWNTO 0) & "0000";
    level2_res(1) <= level1_res(0)(30 DOWNTO 0) & '0';

    -- 390 = 1<<8 + 1<<7 + 1<<2 + 1<<1
    level2_res(2) <= level1_res(1)(23 DOWNTO 0) & "00000000";
    level2_res(3) <= level1_res(1)(24 DOWNTO 0) & "0000000";
    level2_res(4) <= level1_res(1)(29 DOWNTO 0) & "00";
    level2_res(5) <= level1_res(1)(30 DOWNTO 0) & '0';

    -- 864 = 1<<9 + 1<<8 + 1<<6 + 1<<5
    level2_res(6) <= level1_res(2)(22 DOWNTO 0) & "000000000";
    level2_res(7) <= level1_res(2)(23 DOWNTO 0) & "00000000";
    level2_res(8) <= level1_res(2)(25 DOWNTO 0) & "000000";
    level2_res(9) <= level1_res(2)(26 DOWNTO 0) & "00000";

    -- 3072 = 1<<11 + 1<<10
    level2_res(10) <= level1_res(3)(20 DOWNTO 0) & "00000000000";
    level2_res(11) <= level1_res(3)(21 DOWNTO 0) & "0000000000";

    -- 9 = 1<<3 + 1
    level2_res(12) <= level1_res(4)(28 DOWNTO 0) & "000";

    ---------------------------------------------------------------------------
    -- LEVEL 3
    ---------------------------------------------------------------------------
    add19_1: adder port map (
        A => level2_res(0),
        B => level2_res(1),
        O => level3_res(0)
    );

    add390_1: adder port map (
        A => level2_res(2),
        B => level2_res(3),
        O => level3_res(1)
    );

    add390_2: adder port map (
        A => level2_res(4),
        B => level2_res(5),
        O => level3_res(2)
    );

    add864_1: adder port map (
        A => level2_res(6),
        B => level2_res(7),
        O => level3_res(3)
    );

    add864_2: adder port map (
        A => level2_res(8),
        B => level2_res(9),
        O => level3_res(4)
    );

    add3072_1: adder port map (
        A => level2_res(10),
        B => level2_res(11),
        O => level3_res(5)
    );

    add9_1: adder port map (
        A => level1_res(4),
        B => level2_res(12),
        O => level3_res(6)
    );

    ---------------------------------------------------------------------------
    -- LEVEL 4
    ---------------------------------------------------------------------------
    add19_2: adder port map (
        A => level3_res(0),
        B => level1_res(0),
        O => level4_res(0)
    );

    add390_3: adder port map (
        A => level3_res(1),
        B => level3_res(2),
        O => level4_res(1)
    );

    add864_3: adder port map (
        A => level3_res(3),
        B => level3_res(4),
        O => level4_res(2)
    );

    add3072_9: adder port map (
        A => level3_res(5),
        B => level3_res(6),
        O => level4_res(3)
    );

    ---------------------------------------------------------------------------
    -- LEVEL 5
    ---------------------------------------------------------------------------
    add_level5_1: adder port map (
        A => level4_res(0),
        B => level4_res(1),
        O => level5_res(0)
    );

    add_level5_2: adder port map (
        A => level4_res(2),
        B => level4_res(3),
        O => level5_res(1)
    );

    ---------------------------------------------------------------------------
    -- LEVEL 6
    ---------------------------------------------------------------------------
    add_level6: adder port map (
        A => level5_res(0),
        B => level5_res(1),
        O => Output
    );

end Behavioral;

