onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Reset and Clock}
add wave -noupdate -group Reset_Clock /s6base_tb/reset_n
add wave -noupdate -group Reset_Clock /s6base_tb/BIT_CLK
add wave -noupdate -divider {Audio CODEC interface}
add wave -noupdate -group {Audio CODEC} /s6base_tb/XTAL_IN
add wave -noupdate -group {Audio CODEC} /s6base_tb/RESET_N
add wave -noupdate -group {Audio CODEC} /s6base_tb/SYNC
add wave -noupdate -group {Audio CODEC} /s6base_tb/SDATA_OUT
add wave -noupdate -group {Audio CODEC} /s6base_tb/BIT_CLK
add wave -noupdate -group {Audio CODEC} /s6base_tb/SDATA_IN
add wave -noupdate -divider {UART interface}
add wave -noupdate -group UART /s6base_tb/rx
add wave -noupdate -group UART /s6base_tb/tx
add wave -noupdate -group UART /s6base_tb/uart_txen
add wave -noupdate -group UART /s6base_tb/uart_rxready
add wave -noupdate -group UART /s6base_tb/uart_txready
add wave -noupdate -group UART /s6base_tb/uart_din
add wave -noupdate -group UART /s6base_tb/uart_dout
add wave -noupdate -divider {Error counters:}
add wave -noupdate -group {Error counters} /s6base_tb/reset
add wave -noupdate -group {Error counters} /s6base_tb/error_count
add wave -noupdate -group {Error counters} /s6base_tb/clkcount
add wave -noupdate -group {Error counters} /s6base_tb/error_left
add wave -noupdate -group {Error counters} /s6base_tb/error_right
add wave -noupdate -group {Error counters} /s6base_tb/start_checking
add wave -noupdate -group {Error counters} /s6base_tb/i
add wave -noupdate -group {Error counters} /s6base_tb/j
add wave -noupdate -divider {Input signals:}
add wave -noupdate -format Analog-Step -height 80 -max 200000.0 -min -200000.0 -radix decimal /s6base_tb/LEFT_IN
add wave -noupdate -format Analog-Step -height 80 -max 200000.0 -min -200000.0 -radix decimal /s6base_tb/RIGHT_IN
add wave -noupdate -divider {Output signals:}
add wave -noupdate -format Analog-Step -height 80 -max 200000.0 -min -200000.0 -radix decimal /s6base_tb/LEFT_OUT
add wave -noupdate -format Analog-Step -height 80 -max 200000.0 -min -200000.0 -radix decimal /s6base_tb/RIGHT_OUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 231
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
WaveRestoreZoom {0 ps} {1049976059711 ps}
