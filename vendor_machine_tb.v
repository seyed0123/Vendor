`include "vendor_machine.v"



module tb_Vendor;




    reg clk = 0;



    reg [1:0] product;
    reg [1:0] coin;
    reg drop_coin;
    reg finish_coin;
    reg drop_product;


    wire motor;
    wire [2:0] LED;


    reg reset;
    

    Vendor uut (
      product,
      coin,
      drop_coin,
      finish_coin,
      drop_product,
      clk,
      reset, 
      motor, 
      LED 
    );


    initial begin

        reset = 1;
        #10 reset = 0;
// test 1: product 1
        product = 2'b00; 
        #10;
        coin = 2'b01; 
        drop_coin = 1;
        #10;
        drop_coin = 0;
        #5;
        drop_coin = 1;
        #10
        drop_coin = 0;

        finish_coin = 1;
        #10;
        finish_coin = 0;

        drop_product = 1;
        #10;
        drop_product = 0;
        #50;
// test 2: product 3 and error case
        product = 3'b11;
        #10

        coin = 2'b11;
        drop_coin = 1;
        #10;
        drop_coin = 0;

        finish_coin = 1;
        #10;
        finish_coin = 0;
        #10;
        finish_coin = 1;
        #10;
        finish_coin = 0;

        coin = 2'b10;
        drop_coin = 1;
        #10;

        finish_coin = 1;
        #10;

        drop_product = 1;  
        #10;
        drop_product = 0;
    
    
        reset = 1;
        #10 reset = 0;
        #50;
// test 3:
        product = 2'b00; // Switching to a valid product immediately
        #10;
        coin = 2'b01; // Providing coins for the new product
        drop_coin = 1;
        #10;
        drop_coin = 0;

        finish_coin = 1;
        #10;
        finish_coin = 0;
        coin = 2'b11; // Providing coins for the new product
        drop_coin = 1;
        #10;
        drop_coin = 0;

        finish_coin = 1;
        #10;
        finish_coin = 0;

        drop_product = 1;  
        #10;
        drop_product = 0;


        reset = 1;
        #10 reset = 0;
        #50;
// test 4:
        product = 2'b01; // Product 1
        #10;
        coin = 2'b00; // Only 10 cents provided
        drop_coin = 1;
        #10;
        drop_coin = 0;
        #5;
        drop_coin = 1;
        #10
        drop_coin = 0;

        finish_coin = 1;
        #10;
        finish_coin = 0;

        drop_product = 1;
        #10;
        drop_product = 0;

    end

    wire [2:0] LED_out;
    wire motor_out;

    always #5 clk = ~clk;
 
    //  initial begin
    //     $monitor("At time %t, product=%b, coin=%b, drop_coin=%b, finish_coin=%b, drop_product=%b, LED=%b, motor=%b", 
    //              $time, product_in, coin_in, drop_coin_in, finish_coin_in, drop_product_in, LED_out, motor_out);
    // end

    assign LED = LED_out;
    assign motor = motor_out;

endmodule
