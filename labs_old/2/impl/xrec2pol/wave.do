onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /s6base_tb/rx
add wave -noupdate /s6base_tb/tx
add wave -noupdate /s6base_tb/uart_txen
add wave -noupdate /s6base_tb/uart_rxready
add wave -noupdate /s6base_tb/uart_txready
add wave -noupdate /s6base_tb/uart_din
add wave -noupdate /s6base_tb/uart_dout
add wave -noupdate -radix decimal /s6base_tb/x
add wave -noupdate -radix decimal /s6base_tb/y
add wave -noupdate -radix decimal /s6base_tb/modul
add wave -noupdate -radix decimal /s6base_tb/angle
add wave -noupdate /s6base_tb/s6base_top_1/rec2pol_all_1/enable
add wave -noupdate /s6base_tb/s6base_top_1/rec2pol_all_1/start
add wave -noupdate -radix decimal /s6base_tb/s6base_top_1/rec2pol_all_1/x
add wave -noupdate -radix decimal /s6base_tb/s6base_top_1/rec2pol_all_1/y
add wave -noupdate -radix decimal /s6base_tb/s6base_top_1/rec2pol_all_1/mod
add wave -noupdate -radix decimal /s6base_tb/s6base_top_1/rec2pol_all_1/angle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {21400734600 ps}
