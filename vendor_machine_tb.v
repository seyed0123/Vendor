`include "vendor_machine.v"


// Testbench for the Vendor module
module tb_Vendor;



    // Clock generation
    reg clk = 0;


    // Inputs for testing
    reg [1:0] product;
    reg [1:0] coin;
    reg drop_coin;
    reg finish_coin;
    reg drop_product;

    // Outputs for monitoring
    wire motor;
    wire [2:0] LED;

    // Declare reset as a reg
    reg reset;
    
        // Instantiate the Vendor module
    Vendor uut (
      product,
      coin,
      drop_coin,
      finish_coin,
      drop_product,
      clk,
      reset, // Connect reset here
      motor, // Connect motor here
      LED // Connect LED here
    );

    // Initialize inputs
    initial begin
        // Reset the module
        reset = 1;
        #10 reset = 0;

        // Select product
        product = 2'b00; // Example product selection
        #10;

        // Insert coin
        coin = 2'b01; // Example coin insertion
        drop_coin = 1;
        #10;
        drop_coin = 0;
        #5;
        drop_coin = 1;
        #10
        // Press finish
        finish_coin = 1;
        #10;
    
        // Drop product
        drop_product = 1;
        #10;

    end

    always #5 clk = ~clk;
 

endmodule
