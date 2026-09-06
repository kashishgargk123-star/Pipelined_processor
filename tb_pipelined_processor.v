`timescale 1ns/1ps

module tb_pipelined_processor;

    reg clk;
    reg reset;

    // Instantiate processor
    pipelined_processor uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin  
        $dumpfile("processor.vcd");
$dumpvars(0, tb_pipelined_processor);

        // Initial values
        clk = 0;
        reset = 1;

        // Reset processor
        #10;
        reset = 0;

        // Allow pipeline to execute
        #100;

        // Display final register values
        $display("====================================");
        $display("      PIPELINED PROCESSOR RESULT     ");
        $display("====================================");

        $display("R0 = %d", uut.registers[0]);
        $display("R1 = %d", uut.registers[1]);
        $display("R4 = %d", uut.registers[4]);

        $display("====================================");

        $finish;

    end

endmodule