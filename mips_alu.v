/*
 * -----------------------------------------------------
 * File Name:       mips_alu.v
 * Authour:         Zhang Baozhe
 * ID:              119010421
 * Date:            April 8, 2021
 * -----------------------------------------------------
 */

module mips_alu(ins, regA, regB, result, flag);
/*
 * This is the mips ALU module. 
 * -----------------------------------------------------
 * Parameters:
 * ins:             wire: the 32-bit binary instruction
 * regA:            wire: the content (32 bits) of the rs register
 * regB:            wire: the content (32 bits) of the rt register
 * result:          reg:  the computing result (32 bits) of the ALU
 * flag:            reg:  3-bit reg (zero flag, negative flag, and overflow flag)
 * -----------------------------------------------------
 * Others:
 * 00000 -> regA
 * 00001 -> regB
 */

input wire [31:0]   ins, regA, regB;
output reg [31:0]   result;
output reg [2:0]    flag;


reg [31:0]          rs, rt;
reg [31:26]         opcode;
reg [5:0]           funct;
reg [10:6]          shamt;

parameter [31:0] zero = 32'h0000_0000;


always @(ins, regA, regB) begin
    opcode = ins[31:26];
    funct  = ins[5:0];
    shamt  = ins[10:6];

    /* Set value for rs and rt */ 
    if (ins[25:21] == 5'b00000) begin
        rs = regA;
        rt = regB;
    end
    else begin
        rs = regB;
        rt = regA;
    end

    
    case (opcode)
        6'b000000: begin
            case (funct)
                /* add */ 
                6'd32: begin
                    $display("ADD");
                    flag[1] = 0;
                    result = $signed(rs + rt);
                    if (result[31] != rs[31] && 
                        result[31] != rt[31])
                        flag[0] = 1;
                    else 
                        flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* addu */
                6'd33: begin
                    $display("ADDU");
                    flag[1] = 0;
                    result = rs + rt;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* sub */
                6'd34: begin
                    $display("SUB");
                    flag[1] = 0;
                    result = $signed(rs - rt);
                    if (result[31] != rs[31] && 
                        result[31] != rt[31])
                        flag[0] = 1;
                    else 
                        flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* subu */
                6'd35: begin
                    $display("SUBU");
                    flag[1] = 0;
                    result = rs - rt;
                    flag[0] = 0;
                    flag[2] = (result == zero); 
                end

                /* and */
                6'd36: begin
                    $display("AND");
                    flag[1] = 0;
                    result = rs & rt;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* or */
                6'd37: begin
                    $display("OR");
                    flag[1] = 0;
                    result = rs | rt;
                    flag[0] = 0;
                    flag[2] = (result == zero); 
                end

                /* xor */ 
                6'd38: begin
                    $display("XOR");
                    flag[1] = 0;
                    result = rs ^ rt;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* nor */
                6'd39: begin
                    $display("NOR");
                    flag[1] = 0;
                    result = ~(rs | rt);
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* slt */
                6'd42: begin
                    $display("SLT");
                    if ($signed(rs) < $signed(rt)) begin
                        result = 32'd1;
                        flag[1] = 1;
                    end
                    else begin
                        result = 32'd0;
                        flag[1] = 0;
                    end
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* sltu */
                6'd43: begin
                    $display("SLTU");
                    if (rs < rt) begin
                        result = 32'd1;
                        flag[1] = 1;
                    end
                    else begin
                        result = 32'd0;
                        flag[1] = 0;
                    end
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* sll */
                6'd00: begin
                    $display("SLL");
                    flag[1] = 0;
                    result = rt << shamt;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* srl */
                6'd02: begin
                    $display("SRL");
                    flag[1] = 0;
                    result = rt >> shamt;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* sra */
                6'd03: begin
                    $display("SRA");
                    flag[1] = 0;
                    result = rt >>> shamt;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* sllv */
                6'd04: begin
                    $display("SLLV");
                    flag[1] = 0;
                    result = rt << rs;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* srlv */
                6'd06: begin
                    $display("SRLV");
                    flag[1] = 0;
                    result = rt >> rs;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                /* srav */
                6'd07: begin
                    $display("SRAV");
                    flag[1] = 0;
                    result = rt >>> rs;
                    flag[0] = 0;
                    flag[2] = (result == zero);
                end

                default: begin
                    result = 32'hxxxx_xxxx;
                    flag = 3'bxxx;
                end
            endcase
        end

        /* addi */
        6'd08: begin
            $display("ADDI");
            flag[1] = 0;
            result = $signed(rs + rt);
            if (result[31] != rs[31] && 
                result[31] != rt[31])
                flag[0] = 1;
            else 
                flag[0] = 0;
            flag[2] = (result == zero);
        end

        /* addiu */
        6'd09: begin
            $display("ADDIU");
            flag[1] = 0;
            result = rs + rt;
            flag[0] = 0;
            flag[2] = (result == zero);
        end

        /* slti */
        6'd10: begin
            $display("SLTI");
            if ($signed(rs) < $signed(rt)) begin
                result = 32'd1;
                flag[1] = 1;
            end
            else begin
                result = 32'd0;
                flag[1] = 0;
            end
            flag[0] = 0;
            flag[2] = (result == zero);
        end

        /* sltiu */
        6'd11: begin
            $display("SLTIU");
            if (rs < rt) begin
                result = 32'd1;
                flag[1] = 1;
            end
            else begin
                result = 32'd0;
                flag[1] = 0;
            end
            flag[0] = 0;
            flag[2] = (result == zero);
        end

        /* andi */
        6'd12: begin
            $display("ADDI");
            flag[1] = 0;
            result = rs & rt;
            flag[0] = 0;
            flag[2] = (result == zero);
        end

        /* ori */
        6'd13: begin
            $display("ORI");
            flag[1] = 0;
            result = rs | rt;
            flag[0] = 0;
            flag[2] = (result == zero);
        end

        /* xori */
        6'd14: begin
            $display("XORI");
            flag[1] = 0;
            result = rs ^ rt;
            flag[0] = 0;
            flag[2] = (result == zero);
        end

        /* lw */
        6'd35: begin
            $display("LW");
            flag = 3'b000;
            result = rs + rt;
        end

        /* sw */
        6'd43: begin
            $display("SW");
            flag = 3'b000;
            result = rs + rt;
        end

        /* beq */
        6'd04: begin
            $display("BEQ");
            flag[1] = 0;
            flag[0] = 0;
            flag[2] = (rs == rt);
            result = 32'hxxxx_xxxx;
        end

        /* bne */
        6'd05: begin
            $display("BNE");
            flag[1] = 0;
            flag[0] = 0;
            flag[2] = (rs != rt);
            result = 32'hxxxx_xxxx;
        end
        
        default: begin
            $display("NO INPUT INSTRUCTION!\nPLEASE TRY AGAIN!");
            result = 32'hxxxx_xxxx;
            flag = 3'bxxx;
        end

    endcase


end
endmodule


