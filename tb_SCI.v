`timescale 1ns/1ps
module tb_SCI;

    reg clk, reset;
    // a small reg to hold the decoded name
    reg [8*8:1] instr_str;

    // -- Function to map opcode/funct → mnemonic --
    always @(*) begin
        case (uut.instruction[31:26])
            6'h00:  // R-type: look at funct
                case (uut.instruction[5:0])
                    6'h20: instr_str = "ADD";
                    6'h22: instr_str = "SUB";
                    6'h24: instr_str = "AND";
                    6'h25: instr_str = "OR";
                    6'h2A: instr_str = "SLT";
                    6'h02: instr_str = "SRL";
                    default: instr_str = "R-UNK";
                endcase
            6'h23: instr_str = "LW";
            6'h2B: instr_str = "SW";
            6'h04: instr_str = "BEQ";
            6'h05: instr_str = "BNE";
            6'h02: instr_str = "J";
            6'h03: instr_str = "JAL";
            6'h0B: instr_str = "SLTIU";
            6'h25: instr_str = "LHU";
            default: instr_str = "UNK";
        endcase
    end

    // -- Top-level DUT --
    SCI uut (
        .clk (clk),
        .reset (reset)
    );

    // -- Clock: 10 ns period --
    initial clk = 0;
    always  #5 clk = ~clk;

    // -- Load memories BEFORE releasing reset --
    initial begin
        $readmemh("C:/Users/manan/CA_Project/CA_Project.sim/sim_1/behav/data.hex", uut.DMEM.mem);
        $readmemh("C:/Users/manan/CA_Project/CA_Project.sim/sim_1/behav/inst.hex", uut.imem.mem);
    end

    // -- Main sequence --
    initial begin
        $display("\n=== Single-Cycle MIPS full-ISA smoke-test ===");
        reset = 1;  #20;
        reset = 0;
        #400;
        $display("=== finished ===");
        $finish;
    end

    // -- Per-cycle trace with mnemonic --
    always @(posedge clk) begin
        $display("T=%3t  PC=%h  INST=%h (%s)  ALU=%h  Z=%b | ",
                 $time,
                 uut.pc_curr,
                 uut.instruction,
                 instr_str,
                 uut.ALU.res,
                 uut.ALU.zero
        );
        $display("   $t0=%h $t1=%h $t2=%h $t3=%h $t4=%h $t5=%h $t6=%h $t7=%h",
                 uut.RegFile.regfile[8],
                 uut.RegFile.regfile[9],
                 uut.RegFile.regfile[10],
                 uut.RegFile.regfile[11],
                 uut.RegFile.regfile[12],
                 uut.RegFile.regfile[13],
                 uut.RegFile.regfile[14],
                 uut.RegFile.regfile[15]
        );
        $display("   $s0=%h $s1=%h $s2=%h $s3=%h | $ra=%h",
                 uut.RegFile.regfile[16],
                 uut.RegFile.regfile[17],
                 uut.RegFile.regfile[18],
                 uut.RegFile.regfile[19],
                 uut.RegFile.regfile[31]
        );
        $display("   Mem[0]=%h Mem[1]=%h Mem[2]=%h\n",
                 uut.DMEM.mem[0],
                 uut.DMEM.mem[1],
                 uut.DMEM.mem[2]
        );
    end

endmodule
