onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate -radix hexadecimal /tb/dut/pc_in
add wave -noupdate -radix hexadecimal /tb/dut/pc_out
add wave -noupdate /tb/dut/BrTaken
add wave -noupdate /tb/dut/BrTaken_IF
add wave -noupdate /tb/dut/inst
add wave -noupdate /tb/dut/inst_IF
add wave -noupdate /tb/dut/opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {181683 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1032135 ps}