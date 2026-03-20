`timescale 1ns / 1ps





module tb_type();
    logic clk, rst;

    // TOP 모듈 인스턴스화 (이름: RV32I_top)
    RV32I_top dut (
        .clk(clk),
        .rst(rst)
    );

    // 10ns 주기 클럭 생성
    always #5 clk = ~clk;

    initial begin
        // 1. 초기화 세션
        clk = 0;
        rst = 1;      // 리셋 활성화
        #10 rst = 0;  // 10ns 후 리셋 해제

        // --- R-type 검증: x3 = x1 (연산) x2 ---
        // 기본 설정: register_file 초기값에 의해 x1=1, x2=2인 상태 가정 

        // (1) ADD: x3 = x1 + x2 (Opcode: 33, funct3: 0, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[0] = 32'h002081b3; #10;

        // (2) SUB: x3 = x1 - x2 (Opcode: 33, funct3: 0, funct7: 20)
        dut.U_INSTRUCTION_MEM.rom[1] = 32'h402081b3; #10;

        // (3) SLL: x3 = x1 << x2 (Opcode: 33, funct3: 1, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[2] = 32'h002091b3; #10;

        // (4) SLT: x3 = (x1 < x2) ? 1 : 0 (Opcode: 33, funct3: 2, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[3] = 32'h0020a1b3; #10;

        // (5) SLTU: x3 = (x1 < x2 unsigned) ? 1 : 0 (Opcode: 33, funct3: 3, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[4] = 32'h0020b1b3; #10;

        // (6) XOR: x3 = x1 ^ x2 (Opcode: 33, funct3: 4, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[5] = 32'h0020c1b3; #10;

        // (7) SRL: x3 = x1 >> x2 (Opcode: 33, funct3: 5, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[6] = 32'h0020d1b3; #10;

        // (8) SRA: x3 = x1 >>> x2 (Opcode: 33, funct3: 5, funct7: 20)
        dut.U_INSTRUCTION_MEM.rom[7] = 32'h4020d1b3; #10;

        // (9) OR: x3 = x1 | x2 (Opcode: 33, funct3: 6, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[8] = 32'h0020e1b3; #10;

        // (10) AND: x3 = x1 & x2 (Opcode: 33, funct3: 7, funct7: 00)
        dut.U_INSTRUCTION_MEM.rom[9] = 32'h0020f1b3; #10;

        $stop;
    end
endmodule