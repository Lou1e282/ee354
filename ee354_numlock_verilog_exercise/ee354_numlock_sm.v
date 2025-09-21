//////////////////////////////////////////////////////////////////////////////////
// Author:			Brandon Franzke, Gandhi Puvvada, Bilal Zafar
// Create Date:   	02/13/2008, 
// Revised: Gandhi 2/6/2012 replaced `define with localparam
// File Name:		ee354_detour_sm.v 
// Description: 
//
//
// Revision: 		1.1
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ee354_detour_sm(Clk, reset, q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get, q_G101, q_G1011get, q_G1011, q_Opening, q_Bad);

	/*  INPUTS */
	// Clock & Reset
	input		Clk, reset;
	input 	    u, z;
    input       timeout; 
	
	/*  OUTPUTS */
	// store current state
	output q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get, q_G101, q_G1011get, q_G1011, q_Opening, q_Bad;
	reg [6:0] state;	
	
	assign {q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get, q_G101, q_G1011get, q_G1011, q_Opening, q_Bad} = state;
		
	// lets make accessing the state information easier within the state machine code
	// each line aliases the approriate state bits and sets up a 1-hot code
	localparam
	    	QI_NUM        = 11'b00000000001,  // state 0
            QG1GET_NUM    = 11'b00000000010,  // state 1
            QG1_NUM       = 11'b00000000100,  // state 2
            QG10GET_NUM   = 11'b00000001000,  // state 3
            QG10_NUM      = 11'b00000010000,  // state 4
            QG101GET_NUM  = 11'b00000100000,  // state 5
            QG101_NUM     = 11'b00001000000,  // state 6
            QG1011GET_NUM = 11'b00010000000,  // state 7
            QG1011_NUM    = 11'b00100000000,  // state 8
            QOPENING_NUM  = 11'b01000000000,  // state 9
            QBAD_NUM      = 11'b10000000000;  // state 10


	output Unlock, Error;	
	

	// NSL AND SM
	always @ (posedge Clk, posedge reset)
	begin
		if(reset)
			state <= QI;
		else 
		begin
			case(state)
				QI:
					// dont worry about async reset here because 'if' statement considers this first
					if(uz == 2'b10)
						// QI
						state <= QG1GET; 
					else
						// switch right
						state <= QI;
				// these are pretty boring, just unconditionals    
                QG1GET:
                    if(u == 1'b1)
                        state <= QG1; 
                    else if() 
                        state <= QG1GET; 

                QG1: 
                    if(uz == 2'b01)
                        state <= QG10GET; 
                    else if(uz == 00)
                        state <= QG1; 
                    else
                        state <= QBAD; 

                QG10GET:
                    if(z == 1'b0)
                        state <= QG10; 
                    else
                        state <= QG10GET;     
                QG10:
                    if(uz == 2'b10)
                        state <= QG101GET; 
                    else if( uz == 2'b00)     
                        state <= QG10; 
                    else 
                        state <= QBAd;

                QG101GET:
                    if(u == 1'b0)
                        state <= QG101;
                    else
                        state <= QG101GET;  

                QG101:
                    if(uz == 2'b10)
                        state <= QG1011GET;
                    else if(u == 1'b1)
                        state <= QG1011;
                    else 
                        state <= QBAD; 

                QG1011GET: 
                    if(u == 1'b0)
                        state <= QG1011;
                    else
                        state <= QG1011GET;  
                QG1011:
                    state <= QOPENING; 

                QOPENING:
                    if(timeout == 1'b1)
                        state <= QI; 

                    else
                        state <= QOPENING;  
                QBAD:
                    if(uz == 2'b00)
                        state <= Q1; 

                    else
                        state <= QBAD; 

				default:	state <= UNK;
			endcase
		end
	end
	
	// OFL

    assign Unlock = q_Opening;   // high when correct code entered
    assign Error  = q_Bad;       // high when code is wrong

endmodule
