module FULL_ADDER (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    xor(sum, a, b, cin);
    wire w1, w2, w3;
    and(w1, a, b);
    and(w2, a, cin);
    and(w3, b, cin);
    or(cout, w1, w2, w3);
endmodule

module ADD_64 (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Sum,
    output Cout
);
    wire [64:0] Carry;
    assign Carry[0] = 1'b0;

    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : adder_loop
            FULL_ADDER fa (
                .a(A[i]),
                .b(B[i]),
                .cin(Carry[i]),
                .sum(Sum[i]),
                .cout(Carry[i+1])
            );
        end
    endgenerate
    assign Cout = Carry[64];
endmodule

module SUB_64 (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Diff,
    output Cout
);
    wire [63:0] B_comp = ~B;
    wire [63:0] B_twos_comp;
    wire Cout_temp;

    ADD_64 add1 (
        .A(B_comp),
        .B(64'd1),
        .Sum(B_twos_comp),
        .Cout(Cout_temp)
    );

    ADD_64 add2 (
        .A(A),
        .B(B_twos_comp),
        .Sum(Diff),
        .Cout(Cout)
    );
endmodule

module AND_64 (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Y
);
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : and_loop
            and u_and(Y[i], A[i], B[i]);
        end
    endgenerate
endmodule

module OR_64 (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Y
);
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : or_loop
            or u_or(Y[i], A[i], B[i]);
        end
    endgenerate
endmodule

module XOR_64 (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Y
);
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : xor_loop
            xor u_xor(Y[i], A[i], B[i]);
        end
    endgenerate
endmodule

module SLL_64 (
    input [63:0] rs1,
    input [4:0] shamt,
    output [63:0] rd
);
    wire [63:0] stage0, stage1, stage2, stage3, stage4;
    assign stage0 = shamt[0] ? {rs1[62:0], 1'b0} : rs1;
    assign stage1 = shamt[1] ? {stage0[61:0], 2'b0} : stage0;
    assign stage2 = shamt[2] ? {stage1[59:0], 4'b0} : stage1;
    assign stage3 = shamt[3] ? {stage2[55:0], 8'b0} : stage2;
    assign stage4 = shamt[4] ? {stage3[47:0], 16'b0} : stage3;
    assign rd = stage4;
endmodule

module SRL_64 (
    input [63:0] rs1,
    input [4:0] shamt,
    output [63:0] rd
);
    wire [63:0] stage0, stage1, stage2, stage3, stage4;
    assign stage0 = shamt[0] ? {1'b0, rs1[63:1]} : rs1;
    assign stage1 = shamt[1] ? {2'b0, stage0[63:2]} : stage0;
    assign stage2 = shamt[2] ? {4'b0, stage1[63:4]} : stage1;
    assign stage3 = shamt[3] ? {8'b0, stage2[63:8]} : stage2;
    assign stage4 = shamt[4] ? {16'b0, stage3[63:16]} : stage3;
    assign rd = stage4;
endmodule

module SRA_64 (
    input [63:0] rs1,
    input [4:0] shamt,
    output [63:0] rd
);
    wire sign = rs1[63];
    wire [63:0] stage0, stage1, stage2, stage3, stage4;
    assign stage0 = shamt[0] ? {sign, rs1[63:1]} : rs1;
    assign stage1 = shamt[1] ? {{2{sign}}, stage0[63:2]} : stage0;
    assign stage2 = shamt[2] ? {{4{sign}}, stage1[63:4]} : stage1;
    assign stage3 = shamt[3] ? {{8{sign}}, stage2[63:8]} : stage2;
    assign stage4 = shamt[4] ? {{16{sign}}, stage3[63:16]} : stage3;
    assign rd = stage4;
endmodule

module SLT_64 (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Result
);
    wire [63:0] Diff;
    SUB_64 sub (.A(A), .B(B), .Diff(Diff), .Cout());
    assign Result = {63'b0, Diff[63]};
endmodule

module SLTU_64 (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Result
);
    wire [63:0] Diff;
    wire Cout;
    SUB_64 sub (.A(A), .B(B), .Diff(Diff), .Cout(Cout));
    assign Result = {63'b0, ~Cout};
endmodule

module ALU (
    input [2:0] funct3,
    input [6:0] funct7,
    input [63:0] rs1,
    input [63:0] rs2,
    output [63:0] rd
);

    wire add_sel = (funct3 == 3'b000) & (funct7 == 7'b0000000);
    wire sub_sel = (funct3 == 3'b000) & (funct7 == 7'b0100000);
    wire sll_sel = (funct3 == 3'b001) & (funct7 == 7'b0000000);
    wire slt_sel = (funct3 == 3'b010) & (funct7 == 7'b0000000);
    wire sltu_sel = (funct3 == 3'b011) & (funct7 == 7'b0000000);
    wire xor_sel = (funct3 == 3'b100) & (funct7 == 7'b0000000);
    wire srl_sel = (funct3 == 3'b101) & (funct7 == 7'b0000000);
    wire sra_sel = (funct3 == 3'b101) & (funct7 == 7'b0100000);
    wire or_sel = (funct3 == 3'b110) & (funct7 == 7'b0000000);
    wire and_sel = (funct3 == 3'b111) & (funct7 == 7'b0000000);

    // Operation Results
    wire [63:0] add_res, sub_res, sll_res, slt_res, sltu_res, xor_res, srl_res, sra_res, or_res, and_res;

    ADD_64 add (.A(rs1), .B(rs2), .Sum(add_res), .Cout());
    SUB_64 sub (.A(rs1), .B(rs2), .Diff(sub_res), .Cout());
    SLL_64 sll (.rs1(rs1), .shamt(rs2[4:0]), .rd(sll_res));
    SLT_64 slt (.A(rs1), .B(rs2), .Result(slt_res));
    SLTU_64 sltu (.A(rs1), .B(rs2), .Result(sltu_res));
    XOR_64 xor_op (.A(rs1), .B(rs2), .Y(xor_res));
    SRL_64 srl (.rs1(rs1), .shamt(rs2[4:0]), .rd(srl_res));
    SRA_64 sra (.rs1(rs1), .shamt(rs2[4:0]), .rd(sra_res));
    OR_64 or_op (.A(rs1), .B(rs2), .Y(or_res));
    AND_64 and_op (.A(rs1), .B(rs2), .Y(and_res));

    // Output Multiplexing
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : mux
            wire add_bit, sub_bit, sll_bit, slt_bit, sltu_bit, xor_bit, srl_bit, sra_bit, or_bit, and_bit;
            and (add_bit, add_res[i], add_sel);
            and (sub_bit, sub_res[i], sub_sel);
            and (sll_bit, sll_res[i], sll_sel);
            and (slt_bit, slt_res[i], slt_sel);
            and (sltu_bit, sltu_res[i], sltu_sel);
            and (xor_bit, xor_res[i], xor_sel);
            and (srl_bit, srl_res[i], srl_sel);
            and (sra_bit, sra_res[i], sra_sel);
            and (or_bit, or_res[i], or_sel);
            and (and_bit, and_res[i], and_sel);
            or (rd[i], add_bit, sub_bit, sll_bit, slt_bit, sltu_bit, xor_bit, srl_bit, sra_bit, or_bit, and_bit);
        end
    endgenerate
endmodule