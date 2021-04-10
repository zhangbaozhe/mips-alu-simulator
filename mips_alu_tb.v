module test;

reg [31:0]          ins, regA, regB;
wire [2:0]          flag;
wire [31:0]         result;

reg [31:0]          ins_data[0:134];
reg [31:0]          regA_data[0:134];
reg [31:0]          regB_data[0:134];
    mips_alu ALU (ins, regA, regB, result, flag);

initial begin 
    $readmemh("INS_DATA", ins_data);
    $readmemh("REGA_DATA", regA_data);
    $readmemh("REGB_DATA", regB_data);
    $display("Please widen the terminal window for better looking experience ;)");
    $display("Notice: in this project the register code are set as follows: ");
    $display("Reg Code\tReg Name");
    $display("00000   \tRegA    ");
    $display("00001   \tRegB    ");
    $display("Simulation is running ...");


    for (integer i = 0; i < 135; i++) begin 
        ins = ins_data[i];
        regA = regA_data[i];
        regB = regB_data[i];
        #20;
        $display("%d. INS(b): %b, REGA(h): %h, REGB(h): %h, RESULT(h): %h, FLAG(b): %b", 
                 i+1, ins, regA, regB, result, flag);
    end
    #10;
    $display("The end.\nHave a good day ;)");
    $finish;
end

endmodule
