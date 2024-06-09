
module Vendor(
    input [1:0] product,
    input [1:0] coin,
    input drop_coin,
    input reg finish_coin,
    input reg drop_product,
    input clk,
    input reset,
    output reg motor,
    output reg [2:0] LED
);

reg [2:0] state = 3'b000;
reg [1:0] cur_product;
reg [8:0] money = 0;
reg [2:0] next_state;

always @(reset)begin
  state = 3'b000;
  next_state = 3'b000;
  LED = 0;
  motor = 0;
  money = 0;
  cur_product = 0;  
end

always @(next_state) begin
  state = next_state;
end

always @(product) begin
    if (state == 3'b000) begin
        cur_product <= product;
        next_state <= 3'b001;
        LED <= 1;
        motor <= 0;
    end
end
always @(posedge finish_coin) begin
    if (state == 3'b001) begin
        if (finish_coin == 1) begin
            next_state <= 3'b010;
            LED = 2;
            motor = 0;
        end
    end
end
always @(posedge drop_coin) begin
    if (state == 3'b001) begin
        if (drop_coin == 1) begin
            if (coin == 0) begin
                money = money + 10;
            end else if (coin == 1) begin
                money = money + 20;
            end else if (coin == 3) begin
                money = money + 50;
            end else begin
                money = money + 100;
            end
            LED = 1;
            motor = 0;
        end
    end
end

always @(state) begin
    if (state == 3'b010) begin
        if ((cur_product == 0 && money >= 10) || (cur_product == 1 && money >= 50) || (cur_product == 2 && money >= 100) || (cur_product == 3 && money >= 150)) begin
            if(cur_product==0) money = money - 10;
            else if(cur_product==1) money = money-50;
            else if(cur_product==2) money = money-100;
            else if(cur_product==3) money = money-150;
        
            next_state <= 3'b011;
            motor = 1;
            LED = 3;
            
        end else begin
            next_state = 3'b100;
        end
    end else if (state == 3'b100) begin
        LED = 1;
        next_state <= 3'b001;
        # 10;
    end
end

always @(posedge drop_product) begin
    if (state == 3'b011) begin
        next_state <= 3'b000;
        motor = 0;
        LED = 0;
        cur_product = 0; 
    end
end
endmodule

