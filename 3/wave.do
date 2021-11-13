onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/dut/dm/mem
add wave -noupdate -radix decimal -childformat {{{/tb/dut/cpu_inst/pc_reg[63]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[62]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[61]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[60]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[59]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[58]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[57]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[56]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[55]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[54]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[53]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[52]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[51]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[50]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[49]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[48]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[47]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[46]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[45]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[44]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[43]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[42]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[41]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[40]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[39]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[38]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[37]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[36]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[35]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[34]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[33]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[32]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[31]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[30]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[29]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[28]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[27]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[26]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[25]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[24]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[23]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[22]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[21]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[20]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[19]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[18]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[17]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[16]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[15]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[14]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[13]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[12]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[11]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[10]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[9]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[8]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[7]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[6]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[5]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[4]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[3]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[2]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[1]} -radix binary} {{/tb/dut/cpu_inst/pc_reg[0]} -radix binary}} -subitemconfig {{/tb/dut/cpu_inst/pc_reg[63]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[62]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[61]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[60]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[59]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[58]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[57]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[56]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[55]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[54]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[53]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[52]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[51]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[50]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[49]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[48]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[47]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[46]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[45]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[44]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[43]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[42]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[41]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[40]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[39]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[38]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[37]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[36]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[35]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[34]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[33]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[32]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[31]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[30]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[29]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[28]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[27]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[26]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[25]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[24]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[23]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[22]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[21]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[20]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[19]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[18]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[17]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[16]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[15]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[14]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[13]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[12]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[11]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[10]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[9]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[8]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[7]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[6]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[5]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[4]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[3]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[2]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[1]} {-radix binary} {/tb/dut/cpu_inst/pc_reg[0]} {-radix binary}} /tb/dut/cpu_inst/pc_reg
add wave -noupdate -radix binary /tb/dut/cpu_inst/xu/negative
add wave -noupdate -radix binary /tb/dut/cpu_inst/xu/zero
add wave -noupdate -radix binary /tb/dut/cpu_inst/xu/overflow
add wave -noupdate -radix binary /tb/dut/cpu_inst/xu/carry_out
add wave -noupdate -childformat {{{/tb/dut/cpu_inst/rf/mem[0]} -radix decimal} {{/tb/dut/cpu_inst/rf/mem[1]} -radix decimal} {{/tb/dut/cpu_inst/rf/mem[2]} -radix decimal} {{/tb/dut/cpu_inst/rf/mem[3]} -radix decimal} {{/tb/dut/cpu_inst/rf/mem[4]} -radix decimal} {{/tb/dut/cpu_inst/rf/mem[5]} -radix decimal} {{/tb/dut/cpu_inst/rf/mem[6]} -radix decimal} {{/tb/dut/cpu_inst/rf/mem[7]} -radix decimal}} -expand -subitemconfig {{/tb/dut/cpu_inst/rf/mem[0]} {-height 15 -radix decimal} {/tb/dut/cpu_inst/rf/mem[1]} {-height 15 -radix decimal} {/tb/dut/cpu_inst/rf/mem[2]} {-height 15 -radix decimal} {/tb/dut/cpu_inst/rf/mem[3]} {-height 15 -radix decimal} {/tb/dut/cpu_inst/rf/mem[4]} {-height 15 -radix decimal} {/tb/dut/cpu_inst/rf/mem[5]} {-height 15 -radix decimal} {/tb/dut/cpu_inst/rf/mem[6]} {-height 15 -radix decimal} {/tb/dut/cpu_inst/rf/mem[7]} {-height 15 -radix decimal}} /tb/dut/cpu_inst/rf/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1999380 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1999193 ps} {2000043 ps}