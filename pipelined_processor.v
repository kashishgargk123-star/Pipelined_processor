`timescale 1ns/1ps

module pipelined_processor (
    input wire clk,
    input wire reset
);

    // =========================================================
    // OPCODES
    // =========================================================
    localparam OP_ADD  = 2'b00;
    localparam OP_SUB  = 2'b01;
    localparam OP_LOAD = 2'b10;

    // =========================================================
    // PROGRAM COUNTER
    // =========================================================
    reg [3:0] pc;

    // =========================================================
    // REGISTER FILE
    // 8 registers, each 8 bits wide
    // =========================================================
    reg [7:0] registers [0:7];

    // =========================================================
    // DATA MEMORY
    // 16 locations, each 8 bits
    // =========================================================
    reg [7:0] data_memory [0:15];

    // =========================================================
    // INSTRUCTION MEMORY
    //
    // Instruction format:
    // [15:14] = opcode
    // [13:11] = destination register
    // [10:8]  = source register 1
    // [7:5]   = source register 2
    // [4:0]   = immediate
    // =========================================================
    reg [15:0] instruction_memory [0:15];

    // =========================================================
    // STAGE 1: IF - INSTRUCTION FETCH
    // =========================================================
    reg [15:0] if_instruction;
    reg [3:0]  if_pc;

    // =========================================================
    // STAGE 2: ID - INSTRUCTION DECODE
    // =========================================================
    reg [1:0]  id_opcode;
    reg [2:0]  id_rd;
    reg [2:0]  id_rs1;
    reg [2:0]  id_rs2;
    reg [4:0]  id_imm;

    reg [7:0]  id_data1;
    reg [7:0]  id_data2;

    // =========================================================
    // STAGE 3: EX - EXECUTE
    // =========================================================
    reg [1:0]  ex_opcode;
    reg [2:0]  ex_rd;
    reg [7:0]  ex_result;

    // =========================================================
    // STAGE 4: WB - WRITE BACK
    // =========================================================
    reg [2:0] wb_rd;
    reg [7:0] wb_result;
    reg        wb_valid;

    integer i;

    // =========================================================
    // INITIALIZE MEMORIES
    // =========================================================
    initial begin

        // Initialize registers
        for (i = 0; i < 8; i = i + 1)
            registers[i] = 8'd0;

        // Initialize data memory
        for (i = 0; i < 16; i = i + 1)
            data_memory[i] = 8'd0;

        // Initialize instruction memory
        for (i = 0; i < 16; i = i + 1)
            instruction_memory[i] = 16'd0;

        // -----------------------------------------------------
        // Initial register values
        // -----------------------------------------------------
        registers[2] = 8'd10;
        registers[3] = 8'd20;

        registers[5] = 8'd30;
        registers[6] = 8'd10;

        registers[7] = 8'd4;

        // -----------------------------------------------------
        // Data memory
        // -----------------------------------------------------
        data_memory[4] = 8'd100;

        // -----------------------------------------------------
        // Instructions
        //
        // ADD R1,R2,R3
        // R1 = R2 + R3 = 10 + 20 = 30
        //
        // SUB R4,R5,R6
        // R4 = R5 - R6 = 30 - 10 = 20
        //
        // LOAD R0,0(R7)
        // R0 = Memory[R7 + 0]
        // R7 = 4
        // Memory[4] = 100
        // -----------------------------------------------------

        instruction_memory[0] =
            {OP_ADD, 3'd1, 3'd2, 3'd3, 5'd0};

        instruction_memory[1] =
            {OP_SUB, 3'd4, 3'd5, 3'd6, 5'd0};

        instruction_memory[2] =
            {OP_LOAD, 3'd0, 3'd7, 3'd0, 5'd0};

    end

    // =========================================================
    // PIPELINE
    // =========================================================
    always @(posedge clk) begin

        if (reset) begin

            pc = 4'd0;

            if_instruction = 16'd0;
            if_pc = 4'd0;

            id_opcode = 2'd0;
            id_rd = 3'd0;
            id_rs1 = 3'd0;
            id_rs2 = 3'd0;
            id_imm = 5'd0;

            id_data1 = 8'd0;
            id_data2 = 8'd0;

            ex_opcode = 2'd0;
            ex_rd = 3'd0;
            ex_result = 8'd0;

            wb_rd = 3'd0;
            wb_result = 8'd0;
            wb_valid = 1'b0;

        end

        else begin

            // =================================================
            // STAGE 4: WRITE BACK
            // =================================================
            if (wb_valid) begin
                registers[wb_rd] <= wb_result;
            end

            wb_rd <= ex_rd;
            wb_result <= ex_result;
            wb_valid <= 1'b1;


            // =================================================
            // STAGE 3: EXECUTE
            // =================================================
            ex_opcode <= id_opcode;
            ex_rd <= id_rd;

            case (id_opcode)

                OP_ADD: begin
                    ex_result <= id_data1 + id_data2;
                end

                OP_SUB: begin
                    ex_result <= id_data1 - id_data2;
                end

                OP_LOAD: begin
                    ex_result <= data_memory[id_data1 + id_imm];
                end

                default: begin
                    ex_result <= 8'd0;
                end

            endcase


            // =================================================
            // STAGE 2: INSTRUCTION DECODE
            // =================================================
            id_opcode <= if_instruction[15:14];
            id_rd     <= if_instruction[13:11];
            id_rs1    <= if_instruction[10:8];
            id_rs2    <= if_instruction[7:5];
            id_imm    <= if_instruction[4:0];

            id_data1 <= registers[if_instruction[10:8]];
            id_data2 <= registers[if_instruction[7:5]];


            // =================================================
            // STAGE 1: INSTRUCTION FETCH
            // =================================================
            if_instruction <= instruction_memory[pc];
            if_pc <= pc;

            pc <= pc + 1'b1;

        end

    end

endmodule