`timescale 1ns/1ps

module alu_one_tb;

    // Inputs
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [63:0] rs1;
    reg [63:0] rs2;

    // Outputs
    wire [63:0] rd;

    // Instantiate the ALU module
      ALU uut (
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );

    // Testbench logic
    initial begin
        // Open a file to write the test results
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_one_tb);

        // Test ADD operation
        funct3 = 3'b000; funct7 = 7'b0000000;
        rs1 = 64'b1000000000000000000000000000000000000000000000000000000000000001; // rs1 = 1
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000000001; // rs2 = 2
        #10;
        $display("ADD: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test SUB operation
        funct3 = 3'b000; funct7 = 7'b0100000;
        rs1 = 64'b0000000000000000000000000000000000000000000000000000000000000001; // rs1 = 5
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000000101; // rs2 = 3
        #10;
        $display("SUB: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test AND operation
        funct3 = 3'b111; funct7 = 7'b0000000;
        rs1 = 64'b0000000000000000000000000000000000000000000000000000000011111111; // rs1 = 255
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000011110000; // rs2 = 240
        #10;
        $display("AND: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test OR operation
        funct3 = 3'b110; funct7 = 7'b0000000;
        rs1 = 64'b0000000000000000000000000000000000000000000000000000000011110000; // rs1 = 240
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000001111; // rs2 = 15
        #10;
        $display("OR: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test XOR operation
        funct3 = 3'b100; funct7 = 7'b0000000;
        rs1 = 64'b0000000000000000000000000000000000000000000000000000000011111111; // rs1 = 255
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000011110000; // rs2 = 240
        #10;
        $display("XOR: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test SLL operation
        funct3 = 3'b001; funct7 = 7'b0000000;
        rs1 = 64'b0001000000000000000000000000000000000000000000000000000000000000; // rs1 = 1
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000000100; // rs2 = 4 (shift left by 4)
        #10;
        $display("SLL: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test SRL operation
        funct3 = 3'b101; funct7 = 7'b0000000;
        rs1 = 64'b0000000000000000000000000000000000000000000000000000000000000010; // rs1 = 16
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000000010; // rs2 = 2 (shift right by 2)
        #10;
        $display("SRL: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test SRA operation
        funct3 = 3'b101; funct7 = 7'b0100000;
        rs1 = 64'b1111111111111111111111111111111111111111111111111111111111111111; // rs1 = -1 (in 2's complement)
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000000100; // rs2 = 4 (arithmetic shift right by 4)
        #10;
        $display("SRA: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test SLT operation (signed comparison)
        funct3 = 3'b010; funct7 = 7'b0000000;
        rs1 = 64'b0111111111111111111111111111111111111111111111111111111111111111; // rs1 = -1 (signed)
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000000001; // rs2 = 1 (signed)
        #10;
        $display("SLT: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // Test SLTU operation (unsigned comparison)
        funct3 = 3'b011; funct7 = 7'b0000000;
        rs1 = 64'b1111111111111111111111111111111111111111111111111111111111111111; // rs1 = 2^64 - 1 (unsigned)
        rs2 = 64'b0000000000000000000000000000000000000000000000000000000000000001; // rs2 = 1 (unsigned)
        #10;
        $display("SLTU: rs1 = %b, rs2 = %b, rd = %b", rs1, rs2, rd);

        // End simulation
        $finish;
    end

endmodule