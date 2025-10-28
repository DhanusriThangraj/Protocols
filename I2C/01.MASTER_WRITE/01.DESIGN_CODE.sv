// Code your design here
module i2c_master(
  input clk,
  input reset,
  input [6:0]addr,
  input [7:0]reg_addr,
  input [7:0]data,
  input go,
  inout sda,
  inout scl
  );
  
  reg [1:0] count;
  reg [3:0] add_count;
  reg i2c_clk;
  reg sda_out;
  reg sda_en;
  reg [3:0] state, next_state;
  reg [7:0]reg_buf;
  reg [7:0]addr_buf;
  reg [7:0]data_buf;

  
  
  always @ (posedge clk)begin
    if(reset)begin
      i2c_clk<=0;
      count<=0;
    end
    else begin
      if (count==3)begin
        i2c_clk<=~i2c_clk;
        count<=0;
      end
      else
        count<=count+1;
    end
    
  end
  
  assign sda=sda_en?sda_out:1'bz;
   assign scl=i2c_clk;

  parameter[3:0] idle=              0,
                 start=             1,
                 slave_address=     2,
                 ack_1=				3,
                 reg_address=		4,
                 ack_2=				5,
                 data_phase=	    6,
                 ack_3=				7,
                 stop=				8;
  
  

  always @(posedge i2c_clk)begin
    if(reset)begin
       state<=idle;
    end
    else
      state<=next_state;
  end
  
  
  always @(*)begin
    case(state)
      idle:next_state=go?start:idle;
      
      start:next_state=slave_address;
      
      slave_address: if(add_count==7)
                          next_state=ack_1;
                      else
                        next_state=slave_address;
      
      ack_1: next_state=(sda==0)?reg_address:stop;
      
      reg_address: if(add_count==7)
                      next_state=ack_2;
                   else
                     next_state=reg_address;
      
      ack_2: next_state=(sda==0)?data_phase:stop;      
      
      data_phase: if(add_count==7)
                          next_state=ack_3;
                      else
                        next_state=data_phase;
      
      ack_3: if(sda==0)
              next_state=stop;
      
      stop: next_state=idle;
      
      default:next_state=idle;
    endcase
    
  end
  

 always @(posedge i2c_clk or posedge reset) begin
       
    if (reset) begin
      sda_en <= 1;
      sda_out <= 1;
      add_count <= 0;

      addr_buf <= 8'd0;
    end else begin
      
      case (state)
        idle: begin
          sda_en <= 1;   
          sda_out <= 1;
          add_count <= 0;
        end

        start: begin
          sda_en   <= 1;
          sda_out  <= 0;  // START: SDA low while SCL high
          addr_buf <= {addr, 1'b0};  // Write mode
          reg_buf  <= reg_addr;
          data_buf <= data;
          add_count <= 0;
          
        end

        slave_address: begin
          sda_en <= 1;
          sda_out <= addr_buf[7 - add_count];
          add_count <= add_count + 1;
        end

        ack_1: begin
          sda_en <= 0;  // release SDA to read ACK
          add_count <= 0;
        end

        reg_address: begin
          sda_en <= 1;
          sda_out <=  reg_buf[7 - add_count] ;
          add_count <= add_count + 1;
        end

        ack_2: begin
          sda_en <= 0;  // release SDA for ACK
          add_count <= 0;
        end

        data_phase: begin
          sda_en <= 1;
          sda_out <= data_buf[7 - add_count];
          add_count <= add_count + 1;
        end

        ack_3: begin
          sda_en <= 0;
          add_count <= 0;
          
        end

        stop: begin
          sda_en <= 1;
          sda_out <= 1;  // stop condition
        end

      endcase
    end
  end

endmodule
