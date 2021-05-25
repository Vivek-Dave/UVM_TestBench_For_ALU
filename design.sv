// 8 bit alu design 
// input   : in1 and in2 both 8 bits
// input   : cin is of 1 bit
// input   : s is of 4 bits
// input   : m is of 1 bit

// output : out is of 8 bits
// output : cout is of 1 bit
// output : aeb of 1 bit
// output : g and p for look ahead carry

module alu(
           input [7:0] in1,
           input [7:0] in2,
           input cin,
           input [3:0] s,
           input m,
           output reg [7:0] out,
           output aeb,
           output cout
           );
  
  assign cout=(in1[7]==1'b1 && in2[7]==1'b1)?1:0;  // change here for actual carry_out operation 
    assign aeb=(in1==in2);

    always@(*) begin
        if(m==1) begin  // perform logical operation
            case(s)
                4'b0000: begin out=~in1;        end
                4'b0001: begin out=~(in1|in2);  end
                4'b0010: begin out=(~in1)&in2;  end
                4'b0011: begin out=0;           end

                4'b0100: begin out=~(in1&in2);  end
                4'b0101: begin out=~(in2);      end
                4'b0110: begin out=(in1^in2);   end
                4'b0111: begin out=in1&(~in2);  end

                4'b1000: begin out=(~in1)|in2;  end
                4'b1001: begin out=~(in1^in2);  end
                4'b1010: begin out=in2;         end
                4'b1011: begin out=(in1&in2);   end

                4'b1100: begin out=1;           end
                4'b1101: begin out=in1|(~in2);  end
                4'b1110: begin out=(in1|in2);   end
                4'b1111: begin out=in1;         end
            endcase
        end
        else begin  // perform arithmetic operation 
            if(cin==1) begin  // with carry 
                case(s)
                    4'b0000: begin out= in1;                    end
                    4'b0001: begin out= in1|in2;                end
                    4'b0010: begin out= (~in1)|in2;             end
                    4'b0011: begin out= 8'b1111_1111;           end

                    4'b0100: begin out= in1+(in1&(~in2));       end
                    4'b0101: begin out= (in1|in2)+(in1&(~in2)); end
                    4'b0110: begin out= in1-in2-1;              end
                    4'b0111: begin out= (in1&(~in2))-1;         end

                    4'b1000: begin out=in1+(in1&in2);           end
                    4'b1001: begin out=in1+in2;                 end
                    4'b1010: begin out=(in1|(~in2))+(in1&in2);  end
                    4'b1011: begin out=(in1&in2)-1;             end

                    4'b1100: begin out=in1+(~in1);              end
                    4'b1101: begin out=(in1|in2)+in1;           end
                    4'b1110: begin out=(in1|(~in2))+in1;        end
                    4'b1111: begin out=in1-1;                   end
                endcase
            end
            else begin        // without carry
                case(s)
                    4'b0000: begin out= in1+1;                      end
                    4'b0001: begin out= (in1|in2)+1;                end
                    4'b0010: begin out= ((~in1)|in2)+1;             end
                    4'b0011: begin out= 0;                          end

                    4'b0100: begin out= (in1+(in1&(~in2)))+1;       end
                    4'b0101: begin out= ((in1|in2)+(in1&(~in2)))+1; end
                    4'b0110: begin out= in1-in2;                    end
                    4'b0111: begin out= (in1&(~in2));               end

                    4'b1000: begin out=(in1+(in1&in2))+1;           end
                    4'b1001: begin out=in1+in2+1;                   end
                    4'b1010: begin out=(in1|(~in2))+(in1&in2)+1;    end
                    4'b1011: begin out=(in1&in2);                   end

                    4'b1100: begin out=in1+(~in1)+1;                end
                    4'b1101: begin out=(in1|in2)+in1+1;             end
                    4'b1110: begin out=(in1|(~in2))+in1+1;          end
                    4'b1111: begin out=in1;                         end
                endcase
            end
        end
    end

endmodule
