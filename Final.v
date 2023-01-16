module Final(output reg [7:0] data_r, data_g, data_b, output reg[3:0] COMM, input CLK,input reg left,right,put);

	reg red [0:7][0:7]; //black
			
	reg blue [0:7][0:7]; //white
														 
	reg green [0:7][0:7];
			
	reg [0:1] data [0:7][0:7];
	
	reg [2:0] cnt;
	reg player;
	
	reg left_d,right_d,put_d,putdone;
	
	integer prow,pcol,frow,fcol,g_counter,count;
	reg yes;
	
	divfreq F0(CLK, CLK_div);
	divfreq2 F1(CLK, CLK_div2);
	initial
		begin
			g_counter = 0;
			count = 65;
			putdone = 1;
			left_d = 0;
			right_d = 0;
			put_d = 0;
			cnt = 0;
			yes = 0;
			pcol = 0;
			prow = 2;
			data_r = 8'b11111111;
			data_g = 8'b11111111;
			data_b = 8'b11111111;
			COMM = 4'b1000;
			for (int i=0 ; i<=7 ;i++)//red initial
					begin
						for (int j=0 ; j<=7 ;j++)
							begin
								red[i][j] = 1'b1;
							end
					end
			for (int i=0 ; i<=7 ;i++)//blue initial
					begin
						for (int j=0 ; j<=7 ;j++)
							begin
								blue[i][j] = 1'b1;
							end
					end
			for (int i=0 ; i<=7 ;i++)//green initial
					begin
						for (int j=0 ; j<=7 ;j++)
							begin
								green[i][j] = 1'b1;
							end
					end
			for (int i=0 ; i<=7 ;i++)//data initial
					begin
						for (int j=0 ; j<=7 ;j++)
							begin
								data[i][j] = 2'b00;
							end
					end
			player = 0;
			red[3][3]=0;
			red[4][4]=0;
			blue[3][4]=0;
			blue[4][3]=0;
			for (int i=0 ; i<=7 ;i++)//data initial
				begin
					for (int j=0 ; j<=7 ;j++)
						begin
							if(red[i][j] == 0)
								data[i][j] = 2'b01;
							else if(blue[i][j] == 0)
								data[i][j] = 2'b10;
							else if(green[i][j] == 0)
								data[i][j] = 2'b11;
						end
				end
		end

	always @(posedge CLK_div)
		begin
			if(cnt >= 7)
				cnt = 0;
			else 
				cnt = cnt + 1;
			COMM = {1'b1,cnt};
			for(int i = 0;i<=7;i++)
				begin
					data_r[i] <= red[cnt][i]; 
					data_b[i] <= blue[cnt][i];
					data_g[i] <= green[cnt][i];
				end
		end
	
	always @(posedge CLK_div)
		begin
			if(player==0) //product green for red
				begin
					if(data[g_counter/8][g_counter%8] == 2'b01)
						begin
							for(int i=0; i<=7 ;i++)//right
								begin
									if(i > g_counter/8)
										begin
											if(data[i][g_counter%8] == 2'b10)
												begin
													yes = 1;
													continue;
												end
											else if(data[i][g_counter%8] == 2'b01 || data[i][g_counter%8] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 1)
												begin
													data[i][g_counter%8] = 2'b11;
													green[i][g_counter%8] = 0;
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=7; i>=0 ;i--)//left
								begin
									if(i < g_counter/8)
										begin
											if(data[i][g_counter%8] == 2'b10)
												begin
													yes = 1;
													continue;
												end
											else if(data[i][g_counter%8] == 2'b01 || data[i][g_counter%8] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 1)
												begin
													data[i][g_counter%8] = 2'b11;
													green[i][g_counter%8] = 0;
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=0; i<=7 ;i++)//down
								begin
									if(i > g_counter%8)
										begin
											if(data[g_counter/8][i] == 2'b10)
												begin
													yes = 1;
													continue;
												end
											else if(data[g_counter/8][i] == 2'b01 || data[g_counter/8][i] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 1)
												begin
													data[g_counter/8][i] = 2'b11;
													green[g_counter/8][i] = 0;
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=7; i>=0 ;i--)//up
								begin
									if(i < g_counter%8)
										begin
											if(data[g_counter/8][i] == 2'b10)
												begin
													yes = 1;
													continue;
												end
											else if(data[g_counter/8][i] == 2'b01 || data[g_counter/8][i] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 1)
												begin
													data[g_counter/8][i] = 2'b11;
													green[g_counter/8][i] = 0;
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=0; i<=7 ;i++)//right up
								begin
									for(int j=7; j>=0 ;j--)
										begin
											if(i > g_counter/8 && j < g_counter%8)
												begin
													if(i+j == g_counter/8 + g_counter%8)
														begin
															if(data[i][j] == 2'b10)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b01 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
							for(int i=0; i<=7 ;i++)//right down
								begin
									for(int j=0; j<=7 ;j++)
										begin
											if(i > g_counter/8 && j > g_counter%8)
												begin
													if(i-j == g_counter/8 - g_counter%8)
														begin
															if(data[i][j] == 2'b10)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b01 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
							for(int i=7; i>=0 ;i--)//left down
								begin
									for(int j=0; j<=7 ;j++)
										begin
											if(i < g_counter/8 && j > g_counter%8)
												begin
													if(i+j == g_counter/8 + g_counter%8)
														begin
															if(data[i][j] == 2'b10)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b01 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
							for(int i=7; i>=0 ;i--)//left up
								begin
									for(int j=7; j>=0 ;j--)
										begin
											if(i < g_counter/8 && j < g_counter%8)
												begin
													if(i-j == g_counter/8 - g_counter%8)
														begin
															if(data[i][j] == 2'b10)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b01 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
						end
				end
			if(player==1)
				begin
					if(data[g_counter/8][g_counter%8] == 2'b10)
						begin
							for(int i=0; i<=7 ;i++)//right
								begin
									if(i > g_counter/8)
										begin
											if(data[i][g_counter%8] == 2'b01)
												begin
													yes = 1;
													continue;
												end
											else if(data[i][g_counter%8] == 2'b10 || data[i][g_counter%8] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 1)
												begin
													data[i][g_counter%8] = 2'b11;
													green[i][g_counter%8] = 0;
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=7; i>=0 ;i--)//left
								begin
									if(i < g_counter/8)
										begin
											if(data[i][g_counter%8] == 2'b01)
												begin
													yes = 1;
													continue;
												end
											else if(data[i][g_counter%8] == 2'b10 || data[i][g_counter%8] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 1)
												begin
													data[i][g_counter%8] = 2'b11;
													green[i][g_counter%8] = 0;
													yes = 0;
													break;
												end
											else if(data[i][g_counter%8] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=0; i<=7 ;i++)//down
								begin
									if(i > g_counter%8)
										begin
											if(data[g_counter/8][i] == 2'b01)
												begin
													yes = 1;
													continue;
												end
											else if(data[g_counter/8][i] == 2'b10 || data[g_counter/8][i] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 1)
												begin
													data[g_counter/8][i] = 2'b11;
													green[g_counter/8][i] = 0;
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=7; i>=0 ;i--)//up
								begin
									if(i < g_counter%8)
										begin
											if(data[g_counter/8][i] == 2'b01)
												begin
													yes = 1;
													continue;
												end
											else if(data[g_counter/8][i] == 2'b10 || data[g_counter/8][i] == 2'b11)
												begin
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 1)
												begin
													data[g_counter/8][i] = 2'b11;
													green[g_counter/8][i] = 0;
													yes = 0;
													break;
												end
											else if(data[g_counter/8][i] == 2'b00 && yes == 0)
												break;
										end
								end
							for(int i=0; i<=7 ;i++)//right up
								begin
									for(int j=7; j>=0 ;j--)
										begin
											if(i > g_counter/8 && j < g_counter%8)
												begin
													if(i+j == g_counter/8 + g_counter%8)
														begin
															if(data[i][j] == 2'b01)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b10 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
							for(int i=0; i<=7 ;i++)//right down
								begin
									for(int j=0; j<=7 ;j++)
										begin
											if(i > g_counter/8 && j > g_counter%8)
												begin
													if(i-j == g_counter/8 - g_counter%8)
														begin
															if(data[i][j] == 2'b01)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b10 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
							for(int i=7; i>=0 ;i--)//left down
								begin
									for(int j=0; j<=7 ;j++)
										begin
											if(i < g_counter/8 && j > g_counter%8)
												begin
													if(i+j == g_counter/8 + g_counter%8)
														begin
															if(data[i][j] == 2'b01)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b10 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
							for(int i=7; i>=0 ;i--)//left up
								begin
									for(int j=7; j>=0 ;j--)
										begin
											if(i < g_counter/8 && j < g_counter%8)
												begin
													if(i-j == g_counter/8 - g_counter%8)
														begin
															if(data[i][j] == 2'b01)
																begin
																	yes = 1;
																	continue;
																end
															else if(data[i][j] == 2'b10 || data[i][j] == 2'b11)
																begin
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 1)
																begin
																	data[i][j] = 2'b11;
																	green[i][j] = 0;
																	yes = 0;
																	break;
																end
															else if(data[i][j] == 2'b00 && yes == 0)
																break;
														end
												end
										end
								end
						end
				end
			if(g_counter >= 63)
				g_counter = 0;
			else
				g_counter = g_counter + 1;
			if(count >= 66)
				count = 65;
			else
				count = count + 1;
			for (int i=0 ; i<=7 ;i++)//data initial
				begin
					for (int j=0 ; j<=7 ;j++)
						begin
							data[i][j] = 2'b00;
						end
				end
			for (int i=0 ; i<=7 ;i++)//data load
				begin
					for (int j=0 ; j<=7 ;j++)
						begin
							if(red[i][j] == 0)
								data[i][j] = 2'b01;
							else if(blue[i][j] == 0)
								data[i][j] = 2'b10;
							else if(green[i][j] == 0)
								data[i][j] = 2'b11;
						end
				end
			if(putdone == 1 && count > 65)
				begin
					for(int i = 0; i<=63 ;i++)//find new position
						begin
							if(data[i/8][i%8] == 2'b11)
								begin
									pcol = i/8;
									prow = i%8;
									break;
								end
						end
					red[pcol][prow] = player;
					blue[pcol][prow] = player;
					putdone = 0;
				end
			right_d <= right;
			left_d <= left;
			put_d <= put;
			if(right_d == 1'd0 && right == 1'd1)
				begin
					for (int i=0 ; i<=63 ;i++)//data check and move(right down)
						begin
							if(i%8 > prow && i/8 == pcol)
								begin
									if(data[i/8][i%8] == 2'b11)
										begin
											red[pcol][prow] = 1;
											blue[pcol][prow] = 1;
											pcol = i/8;
											prow = i%8;
											green[pcol][prow] = 0;
											red[pcol][prow] = player;
											break;
										end
								end
							
							else if(i/8 > pcol)
								begin
									if(data[i/8][i%8] == 2'b11)
										begin
											red[pcol][prow] = 1;
											blue[pcol][prow] = 1;
											pcol = i/8;
											prow = i%8;
											green[pcol][prow] = 0;
											red[pcol][prow] = player;
											break;
										end
								end
						end
				end
			if(left_d == 1'd0 && left == 1'd1)
				begin
					for (int i= 63; i>=0 ;i--)//data check and move(left up)
						begin
							if(i/8 == pcol)
								begin
									if(i%8 < prow)
										begin
											if(data[i/8][i%8] == 2'b11)
												begin
													red[pcol][prow] = 1;
													blue[pcol][prow] = 1;
													pcol = i/8;
													prow = i%8;
													green[pcol][prow] = 0;
													red[pcol][prow] = player;
													break;
												end
										end
								end
							else if(i/8 < pcol)
								begin
									if(data[i/8][i%8] == 2'b11)
										begin
											red[pcol][prow] = 1;
											blue[pcol][prow] = 1;
											pcol = i/8;
											prow = i%8;
											green[pcol][prow] = 0;
											red[pcol][prow] = player;
											break;
										end
								end
						end
				end
			if(player == 0 && put_d == 1'd0 && put == 1'd1) //(red round)
				begin
					green[pcol][prow] = 1;
					blue[pcol][prow] = 1;
					red[pcol][prow] = 0;
					for (int i=0 ; i<=7 ;i++)//data initial
						begin
							for (int j=0 ; j<=7 ;j++)
								begin
									data[i][j] = 2'b00;
									green[i][j] = 1;
								end
						end
					for (int i=0 ; i<=7 ;i++)//data load
						begin
							for (int j=0 ; j<=7 ;j++)
								begin
									if(red[i][j] == 0)
										data[i][j] = 2'b01;
									else if(blue[i][j] == 0)
										data[i][j] = 2'b10;
								end
						end
					for (int j= 0; j<=7 ;j++)//blue transform to red (down)
						begin
							if(j > prow)
								begin
									if(data[pcol][j] == 2'b10)
										begin
											continue;
										end
									else if(data[pcol][j] == 2'b01)
										begin
											fcol = pcol;
											frow = j;
											break;
										end
									else
										break;
								end
						end
					for(int i = 0 ;i<=7;i++)
						begin
							if(i > prow && i < frow)
							begin
								red[pcol][i] = 0;
								blue[pcol][i] = 1;
							end
						end
					fcol = pcol;
					frow = prow;
					for (int j= 7; j>=0 ;j--)//blue transform to red (up)
						begin
							if(j < prow)
								begin
									if(data[pcol][j] == 2'b10)
										begin
											continue;
										end
									else if(data[pcol][j] == 2'b01)
										begin
											fcol = pcol;
											frow = j;
											break;
										end
									else
										break;
								end
						end
					for(int i = 0 ;i<=7;i++)
						begin
							if(i > frow && i < prow)
								begin
									red[pcol][i] = 0;
									blue[pcol][i] = 1;
								end
						end
					fcol = pcol;
					frow = prow;
					for (int i=7; i>=0 ;i--)//blue transform to red (left)
						begin
							if(i < pcol)
								begin
									if(data[i][prow] == 2'b10)
										begin
											continue;
										end
									else if(data[i][prow] == 2'b01)
										begin
											fcol = i;
											frow = prow;
											break;
										end
									else
										break;
								end
						end
					for(int i = 0 ;i<=7;i++)
						begin
							if(i > fcol && i < pcol)
							begin
								red[i][prow] = 0;
								blue[i][prow] = 1;
							end
						end
					fcol = pcol;
					frow = prow;
					for (int i= 0; i<=7 ;i++)//blue transform to red (right)
						begin
							if(i > pcol)
								begin
									if(data[i][prow] == 2'b10)
										begin
											continue;
										end
									else if(data[i][prow] == 2'b01)
										begin
											fcol = i;
											frow = prow;
											break;
										end
									else
										break;
								end
						end
					for(int i = 0 ;i<=7;i++)
						begin
							if(i < fcol && i > pcol)
							begin
								red[i][prow] = 0;
								blue[i][prow] = 1;
							end
						end
					fcol = pcol;
					frow = prow;
					for (int i= 0; i<=63 ;i++)//blue transform to red (right up)
						begin
							if(i/8+(7-(i%8)) == pcol + prow)
								begin
										if((i/8 > pcol) && (7-(i%8) < prow))
											begin
												if(data[i/8][(7-(i%8))] == 2'b10)
													begin
														continue;
													end
												else if(data[i/8][(7-(i%8))] == 2'b01)
													begin
														fcol = i/8;
														frow = 7-(i%8);
														break;
													end
												else
													break;
											end
								end
							end
					for(int i = 0 ;i<=63;i++)
						begin
							if(i/8 > pcol&& i/8 <fcol)
								begin
									if(i/8+(7-(i%8)) == pcol + prow)
										begin
											red[i/8][i%8] = 0;
											blue[i/8][i%8] = 1;
										end
								end
						end
					fcol = pcol;
					frow = prow;
					putdone = 1;
					count = 0;
					//player = 1;//change player
				end
				if(player == 1 && put_d == 1'd0 && put == 1'd1) //(blue round)
					begin
						blue[pcol][prow] = 0;
						for (int i=0 ; i<=7 ;i++)//data initial
							begin
								for (int j=0 ; j<=7 ;j++)
									begin
										data[i][j] = 2'b00;
										green[i][j] = 1;
									end
							end
						for (int i=0 ; i<=7 ;i++)//data load
							begin
								for (int j=0 ; j<=7 ;j++)
									begin
										if(red[i][j] == 0)
											data[i][j] = 2'b01;
										else if(blue[i][j] == 0)
											data[i][j] = 2'b10;
									end
							end
						for (int j= 0; j<=7 ;j++)//red transform to blue (down)
							begin
								if(j > prow)
									begin
										if(data[pcol][j] == 2'b01)
											begin
												continue;
											end
										else if(data[pcol][j] == 2'b10)
											begin
												fcol = pcol;
												frow = j;
												break;
											end
										else
											break;
									end
							end
						for(int i = 0 ;i<=7;i++)
							begin
								if(i > prow && i < frow)
								begin
									red[pcol][i] = 1;
									blue[pcol][i] = 0;
								end
							end
						fcol = pcol;
						frow = prow;
						for (int j= 7; j>=0 ;j--)//red transform to blue (up)
							begin
								if(j < prow)
									begin
										if(data[pcol][j] == 2'b01)
											begin
												continue;
											end
										else if(data[pcol][j] == 2'b10)
											begin
												fcol = pcol;
												frow = j;
												break;
											end
										else
											break;
									end
							end
						for(int i = 0 ;i<=7;i++)
							begin
								if(i > frow && i < prow)
									begin
										red[pcol][i] = 1;
										blue[pcol][i] = 0;
									end
							end
						fcol = pcol;
						frow = prow;
						for (int i=7; i>=0 ;i--)//red transform to blue (left)
							begin
								if(i < pcol)
									begin
										if(data[i][prow] == 2'b01)
											begin
												continue;
											end
										else if(data[i][prow] == 2'b10)
											begin
												fcol = i;
												frow = prow;
												break;
											end
										else
											break;
									end
							end
						for(int i = 0 ;i<=7;i++)
							begin
								if(i > fcol && i < pcol)
								begin
									red[i][prow] = 1;
									blue[i][prow] = 0;
								end
							end
						fcol = pcol;
						frow = prow;
						for (int i= 0; i<=7 ;i++)//red transform to blue (right)
							begin
								if(i > pcol)
									begin
										if(data[i][prow] == 2'b01)
											begin
												continue;
											end
										else if(data[i][prow] == 2'b10)
											begin
												fcol = i;
												frow = prow;
												break;
											end
										else
											break;
									end
							end
						for(int i = 0 ;i<=7;i++)
							begin
								if(i < fcol && i > pcol)
								begin
									red[i][prow] = 1;
									blue[i][prow] = 0;
								end
							end
						fcol = pcol;
						frow = prow;
						putdone = 1;
						count = 0;
						//player = 0;//change player
				end
			end
endmodule
	
module divfreq(input CLK,output reg CLK_div);
	reg[24:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 2500)
				begin
					Count <= 25'b0;
					CLK_div <= ~CLK_div;
				end
			else
				Count <= Count + 1'b1;
			end
endmodule

module divfreq2(input CLK,output reg CLK_div);
	reg[24:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 2500)
				begin
					Count <= 25'b0;
					CLK_div <= ~CLK_div;
				end
			else
				Count <= Count + 1'b1;
			end
endmodule
