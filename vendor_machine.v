module Vendor(
    input [1:0] product,
    input [1:0] coin,
    input drop_coin,
    input reg finish_coin,
    input reg drop_product,
    output reg motor,
    output reg [2:0] LED
);

reg [2:0] state = 3'b000;
reg [2:0] cur_product;
reg [10:0] money = 0;

always @(product) begin
    if (state == 3'b000) begin
        cur_product <= product;
        state <= 3'b001;
        LED = 0;
        motor = 0;
    end
end

always @(drop_coin or finish_coin) begin
    if (state == 3'b001) begin
        if (finish_coin == 1) begin
            state = 3'b010;
        end
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
        if ((cur_product == 0 && money > 20) || (cur_product == 1 && money > 50) || (cur_product == 2 && money > 100) || (cur_product == 3 && money > 150)) begin
            state = 3'b011;
            motor = 1;
            LED = 2;
        end else begin
            state = 3'b100;
        end
    end else if (state == 3'b100) begin
        # 100;
        LED = 3;
        state = 3'b000;
    end
end

always @(drop_product) begin
    if (state == 3'b011) begin
        if (drop_product == 1) begin
            state = 3'b000;
            motor = 0;
            LED = 0;
        end
    end
end
endmodule

