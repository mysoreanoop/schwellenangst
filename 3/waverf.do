onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /rf_tb/_rf
add wave -noupdate -radix hexadecimal /rf_tb/clk
add wave -noupdate -radix hexadecimal /rf_tb/inc
add wave -noupdate -radix hexadecimal -childformat {{{/rf_tb/dut/r/data_in[31]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[30]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[29]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[28]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[27]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[26]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[25]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[24]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[23]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[22]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[21]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[20]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[19]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[18]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[17]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[16]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[15]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[14]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[13]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[12]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[11]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[10]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[9]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[8]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[7]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[6]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[5]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[4]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[3]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[2]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[1]} -radix hexadecimal} {{/rf_tb/dut/r/data_in[0]} -radix hexadecimal}} -subitemconfig {{/rf_tb/dut/r/data_in[31]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[30]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[29]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[28]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[27]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[26]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[25]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[24]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[23]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[22]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[21]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[20]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[19]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[18]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[17]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[16]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[15]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[14]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[13]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[12]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[11]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[10]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[9]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[8]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[7]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[6]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[5]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[4]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[3]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[2]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[1]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_in[0]} {-height 17 -radix hexadecimal}} /rf_tb/dut/r/data_in
add wave -noupdate -radix hexadecimal -childformat {{{/rf_tb/dut/r/data_out[31]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[30]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[29]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[28]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[27]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[26]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[25]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[24]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[23]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[22]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[21]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[20]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[19]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[18]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[17]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[16]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[15]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[14]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[13]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[12]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[11]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[10]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[9]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[8]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[7]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[6]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[5]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[4]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[3]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[2]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[1]} -radix hexadecimal} {{/rf_tb/dut/r/data_out[0]} -radix hexadecimal}} -subitemconfig {{/rf_tb/dut/r/data_out[31]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[30]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[29]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[28]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[27]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[26]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[25]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[24]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[23]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[22]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[21]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[20]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[19]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[18]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[17]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[16]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[15]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[14]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[13]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[12]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[11]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[10]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[9]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[8]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[7]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[6]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[5]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[4]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[3]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[2]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[1]} {-height 17 -radix hexadecimal} {/rf_tb/dut/r/data_out[0]} {-height 17 -radix hexadecimal}} /rf_tb/dut/r/data_out
add wave -noupdate -radix hexadecimal /rf_tb/dut/r/reset
add wave -noupdate -radix hexadecimal /rf_tb/dut/r/write_en
add wave -noupdate -radix hexadecimal /rf_tb/dut/d/e
add wave -noupdate -radix hexadecimal /rf_tb/dut/d/in
add wave -noupdate -radix hexadecimal /rf_tb/dut/d/out
add wave -noupdate -radix hexadecimal /rf_tb/dut/d/x
add wave -noupdate -radix hexadecimal /rf_tb/dut/ReadData1
add wave -noupdate -radix hexadecimal /rf_tb/dut/ReadData2
add wave -noupdate -radix hexadecimal /rf_tb/dut/ReadRegister1
add wave -noupdate -radix hexadecimal /rf_tb/dut/ReadRegister2
add wave -noupdate -radix hexadecimal /rf_tb/dut/RegWrite
add wave -noupdate -radix hexadecimal -childformat {{{/rf_tb/dut/ri[31]} -radix hexadecimal} {{/rf_tb/dut/ri[30]} -radix hexadecimal} {{/rf_tb/dut/ri[29]} -radix hexadecimal} {{/rf_tb/dut/ri[28]} -radix hexadecimal} {{/rf_tb/dut/ri[27]} -radix hexadecimal} {{/rf_tb/dut/ri[26]} -radix hexadecimal} {{/rf_tb/dut/ri[25]} -radix hexadecimal} {{/rf_tb/dut/ri[24]} -radix hexadecimal} {{/rf_tb/dut/ri[23]} -radix hexadecimal} {{/rf_tb/dut/ri[22]} -radix hexadecimal} {{/rf_tb/dut/ri[21]} -radix hexadecimal} {{/rf_tb/dut/ri[20]} -radix hexadecimal} {{/rf_tb/dut/ri[19]} -radix hexadecimal} {{/rf_tb/dut/ri[18]} -radix hexadecimal} {{/rf_tb/dut/ri[17]} -radix hexadecimal} {{/rf_tb/dut/ri[16]} -radix hexadecimal} {{/rf_tb/dut/ri[15]} -radix hexadecimal} {{/rf_tb/dut/ri[14]} -radix hexadecimal} {{/rf_tb/dut/ri[13]} -radix hexadecimal} {{/rf_tb/dut/ri[12]} -radix hexadecimal} {{/rf_tb/dut/ri[11]} -radix hexadecimal} {{/rf_tb/dut/ri[10]} -radix hexadecimal} {{/rf_tb/dut/ri[9]} -radix hexadecimal} {{/rf_tb/dut/ri[8]} -radix hexadecimal} {{/rf_tb/dut/ri[7]} -radix hexadecimal} {{/rf_tb/dut/ri[6]} -radix hexadecimal} {{/rf_tb/dut/ri[5]} -radix hexadecimal} {{/rf_tb/dut/ri[4]} -radix hexadecimal} {{/rf_tb/dut/ri[3]} -radix hexadecimal} {{/rf_tb/dut/ri[2]} -radix hexadecimal} {{/rf_tb/dut/ri[1]} -radix hexadecimal} {{/rf_tb/dut/ri[0]} -radix hexadecimal}} -subitemconfig {{/rf_tb/dut/ri[31]} {-radix hexadecimal} {/rf_tb/dut/ri[30]} {-radix hexadecimal} {/rf_tb/dut/ri[29]} {-radix hexadecimal} {/rf_tb/dut/ri[28]} {-radix hexadecimal} {/rf_tb/dut/ri[27]} {-radix hexadecimal} {/rf_tb/dut/ri[26]} {-radix hexadecimal} {/rf_tb/dut/ri[25]} {-radix hexadecimal} {/rf_tb/dut/ri[24]} {-radix hexadecimal} {/rf_tb/dut/ri[23]} {-radix hexadecimal} {/rf_tb/dut/ri[22]} {-radix hexadecimal} {/rf_tb/dut/ri[21]} {-radix hexadecimal} {/rf_tb/dut/ri[20]} {-radix hexadecimal} {/rf_tb/dut/ri[19]} {-radix hexadecimal} {/rf_tb/dut/ri[18]} {-radix hexadecimal} {/rf_tb/dut/ri[17]} {-radix hexadecimal} {/rf_tb/dut/ri[16]} {-radix hexadecimal} {/rf_tb/dut/ri[15]} {-radix hexadecimal} {/rf_tb/dut/ri[14]} {-radix hexadecimal} {/rf_tb/dut/ri[13]} {-radix hexadecimal} {/rf_tb/dut/ri[12]} {-radix hexadecimal} {/rf_tb/dut/ri[11]} {-radix hexadecimal} {/rf_tb/dut/ri[10]} {-radix hexadecimal} {/rf_tb/dut/ri[9]} {-radix hexadecimal} {/rf_tb/dut/ri[8]} {-radix hexadecimal} {/rf_tb/dut/ri[7]} {-radix hexadecimal} {/rf_tb/dut/ri[6]} {-radix hexadecimal} {/rf_tb/dut/ri[5]} {-radix hexadecimal} {/rf_tb/dut/ri[4]} {-radix hexadecimal} {/rf_tb/dut/ri[3]} {-radix hexadecimal} {/rf_tb/dut/ri[2]} {-radix hexadecimal} {/rf_tb/dut/ri[1]} {-radix hexadecimal} {/rf_tb/dut/ri[0]} {-radix hexadecimal}} /rf_tb/dut/ri
add wave -noupdate -radix hexadecimal -childformat {{{/rf_tb/dut/ro[31]} -radix hexadecimal} {{/rf_tb/dut/ro[30]} -radix hexadecimal} {{/rf_tb/dut/ro[29]} -radix hexadecimal} {{/rf_tb/dut/ro[28]} -radix hexadecimal} {{/rf_tb/dut/ro[27]} -radix hexadecimal} {{/rf_tb/dut/ro[26]} -radix hexadecimal} {{/rf_tb/dut/ro[25]} -radix hexadecimal} {{/rf_tb/dut/ro[24]} -radix hexadecimal} {{/rf_tb/dut/ro[23]} -radix hexadecimal} {{/rf_tb/dut/ro[22]} -radix hexadecimal} {{/rf_tb/dut/ro[21]} -radix hexadecimal} {{/rf_tb/dut/ro[20]} -radix hexadecimal} {{/rf_tb/dut/ro[19]} -radix hexadecimal} {{/rf_tb/dut/ro[18]} -radix hexadecimal} {{/rf_tb/dut/ro[17]} -radix hexadecimal} {{/rf_tb/dut/ro[16]} -radix hexadecimal} {{/rf_tb/dut/ro[15]} -radix hexadecimal} {{/rf_tb/dut/ro[14]} -radix hexadecimal} {{/rf_tb/dut/ro[13]} -radix hexadecimal} {{/rf_tb/dut/ro[12]} -radix hexadecimal} {{/rf_tb/dut/ro[11]} -radix hexadecimal} {{/rf_tb/dut/ro[10]} -radix hexadecimal} {{/rf_tb/dut/ro[9]} -radix hexadecimal} {{/rf_tb/dut/ro[8]} -radix hexadecimal} {{/rf_tb/dut/ro[7]} -radix hexadecimal} {{/rf_tb/dut/ro[6]} -radix hexadecimal} {{/rf_tb/dut/ro[5]} -radix hexadecimal} {{/rf_tb/dut/ro[4]} -radix hexadecimal} {{/rf_tb/dut/ro[3]} -radix hexadecimal} {{/rf_tb/dut/ro[2]} -radix hexadecimal} {{/rf_tb/dut/ro[1]} -radix hexadecimal} {{/rf_tb/dut/ro[0]} -radix hexadecimal}} -subitemconfig {{/rf_tb/dut/ro[31]} {-radix hexadecimal} {/rf_tb/dut/ro[30]} {-radix hexadecimal} {/rf_tb/dut/ro[29]} {-radix hexadecimal} {/rf_tb/dut/ro[28]} {-radix hexadecimal} {/rf_tb/dut/ro[27]} {-radix hexadecimal} {/rf_tb/dut/ro[26]} {-radix hexadecimal} {/rf_tb/dut/ro[25]} {-radix hexadecimal} {/rf_tb/dut/ro[24]} {-radix hexadecimal} {/rf_tb/dut/ro[23]} {-radix hexadecimal} {/rf_tb/dut/ro[22]} {-radix hexadecimal} {/rf_tb/dut/ro[21]} {-radix hexadecimal} {/rf_tb/dut/ro[20]} {-radix hexadecimal} {/rf_tb/dut/ro[19]} {-radix hexadecimal} {/rf_tb/dut/ro[18]} {-radix hexadecimal} {/rf_tb/dut/ro[17]} {-radix hexadecimal} {/rf_tb/dut/ro[16]} {-radix hexadecimal} {/rf_tb/dut/ro[15]} {-radix hexadecimal} {/rf_tb/dut/ro[14]} {-radix hexadecimal} {/rf_tb/dut/ro[13]} {-radix hexadecimal} {/rf_tb/dut/ro[12]} {-radix hexadecimal} {/rf_tb/dut/ro[11]} {-radix hexadecimal} {/rf_tb/dut/ro[10]} {-radix hexadecimal} {/rf_tb/dut/ro[9]} {-radix hexadecimal} {/rf_tb/dut/ro[8]} {-radix hexadecimal} {/rf_tb/dut/ro[7]} {-radix hexadecimal} {/rf_tb/dut/ro[6]} {-radix hexadecimal} {/rf_tb/dut/ro[5]} {-radix hexadecimal} {/rf_tb/dut/ro[4]} {-radix hexadecimal} {/rf_tb/dut/ro[3]} {-radix hexadecimal} {/rf_tb/dut/ro[2]} {-radix hexadecimal} {/rf_tb/dut/ro[1]} {-radix hexadecimal} {/rf_tb/dut/ro[0]} {-radix hexadecimal}} /rf_tb/dut/ro
add wave -noupdate -radix hexadecimal /rf_tb/dut/rst
add wave -noupdate -radix hexadecimal /rf_tb/dut/we
add wave -noupdate -radix hexadecimal /rf_tb/dut/WriteData
add wave -noupdate -radix hexadecimal /rf_tb/dut/WriteRegister
add wave -noupdate /rf_tb/dut/clk
add wave -noupdate -radix hexadecimal /rf_tb/dut/m0/in
add wave -noupdate -radix hexadecimal /rf_tb/dut/m0/out
add wave -noupdate -radix hexadecimal /rf_tb/dut/m0/read_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {601 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 160
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1562 ps}