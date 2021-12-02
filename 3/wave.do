onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb/dut/cpu_inst/pc_reg
add wave -noupdate -radix decimal -childformat {{{/tb/dut/cpu_inst/rf/ro[31]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[30]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[29]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[28]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[27]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[26]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[25]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[24]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[23]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[22]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[21]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[20]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[19]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[18]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[17]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[16]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[15]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[14]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[13]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[12]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[11]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[10]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[9]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[8]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[7]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[6]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[5]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[4]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[3]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[2]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[1]} -radix decimal} {{/tb/dut/cpu_inst/rf/ro[0]} -radix decimal}} -expand -subitemconfig {{/tb/dut/cpu_inst/rf/ro[31]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[30]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[29]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[28]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[27]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[26]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[25]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[24]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[23]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[22]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[21]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[20]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[19]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[18]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[17]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[16]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[15]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[14]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[13]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[12]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[11]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[10]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[9]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[8]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[7]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[6]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[5]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[4]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[3]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[2]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[1]} {-height 17 -radix decimal} {/tb/dut/cpu_inst/rf/ro[0]} {-height 17 -radix decimal}} /tb/dut/cpu_inst/rf/ro
add wave -noupdate -radix unsigned /tb/dut/cpu_inst/c
add wave -noupdate -radix unsigned /tb/dut/cpu_inst/n
add wave -noupdate -radix unsigned /tb/dut/cpu_inst/o
add wave -noupdate -radix unsigned /tb/dut/cpu_inst/z
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {291195229 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {290025 ns} {300525 ns}
