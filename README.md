# Vendor machine

## state diagram
![diagram](shot\diagram.png)
at first machine resets and starts at  `choose product` state.
when the product signal is changed, it goes to  `insert coin` stateand when the `drop_coin` signal is changed from 0 to 1, the machine sees the inserted coin and adds the amount of the coin to the user's money. When the `check` signal changes from 0 to 1 then the goes to the `evaluation` state and compares the user money and product price. if the money of the user is greater than the price of the product it subtracts the price from the money of the user so the user can use the money that remains in the next purchase, and the machine goes to  `deliver` state and otherwise goes to  `error` state after seeing the posedge check goes to  `insert coin` state and wait for the user to insert more coin to machine. in `deliver` state  it turns the motor on until the `drop_product` signal changes from 1 to 0, and then turns the motor off and goes to  `choose product` state and ready for another operation.

## output table and transition table
| current state  | state code | LED | motor | next state             |
|----------------|------------|-----|-------|------------------------|
| choose product | 0          | 0   | 0     | insert coin            |
| insert coin    | 001        | 1   | 0     | evaluate , insert coin |
| evaluate       | 010        | 2   | 0     | error , deliver        |
| error          | 100        | 100 | 0     | insert coin            |
| deliver        | 011        | 011 | 1     | choose prouct          |

## implementation
```verilog
module Vendor(
    input [1:0] product,
    input [1:0] coin,
    input drop_coin,
    input reg check,
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
```

### inputs:
1. two bit product: shows the product the user choosed
2. two bit coin: shows the coin the user choosed
3. drop_coin: when coin inserted to the machine it becomes 1 for a short time and then becomes 0
4. check: when the user press check button it becomes 1 for a short time and then becomes 0
5. drop_product:when The product falls out of the machine becomes 1 for a short time and then becomes 0
6. clk
7. reset: when 1 resets the machine to state `choose product`

### outputs:
1. LED: shows the monitor situation
2. motor: shows the motor situation

### registers:
1. three bit state: shows the current state of the machine
2. two bit current product: shows the current product that the user selected.
3. eigth bit money: shows the amount of coin that the user inserted to the machine
4. three bit next state: shows the next state of the machine should goes to it.

## price of product and coins
| product 	| price 	|
|---------	|-------	|
| 0       	| 10    	|
| 1       	| 50    	|
| 2       	| 100   	|
| 3       	| 150   	|

| coin 	| price 	|
|------	|-------	|
| 0    	| 10    	|
| 1    	| 20    	|
| 2    	| 50    	|
| 3    	| 100   	|


### description:
it was used Behavioral coding style. This code has some always block and each of them sensetive with a different signal and do a certain job.for example:
```verilog
always @(posedge drop_product) begin
    if (state == 3'b011) begin
        next_state <= 3'b000;
        motor = 0;
        LED = 0;
        cur_product = 0; 
    end
```
in this always block in check if machine is in state `deliver` and `drop_product` signal changes from 0 to 1 it turns the motor off and the LED to 0 and reset the `cur_product` and put `next_state` to 0.


## Test:
### test 1:
![test 1 image](shot/test1.png)