onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ssd_bin_to_dec_tb/clk
add wave -noupdate /ssd_bin_to_dec_tb/res_n
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex0
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex1
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex2
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex3
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex4
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex5
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex6
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/hex7
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/bin
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/clk
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/res_n
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/ssd
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/bin
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/state
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/next_state
add wave -noupdate -radix decimal /ssd_bin_to_dec_tb/dut/cnt
add wave -noupdate -radix decimal /ssd_bin_to_dec_tb/dut/next_cnt
add wave -noupdate -radix binary -childformat {{/ssd_bin_to_dec_tb/dut/scratch_reg(20) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(19) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(18) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(17) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(16) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(15) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(14) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(13) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(12) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(11) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(10) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(9) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(8) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(7) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(6) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(5) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(4) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(3) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(2) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(1) -radix binary} {/ssd_bin_to_dec_tb/dut/scratch_reg(0) -radix binary}} -subitemconfig {/ssd_bin_to_dec_tb/dut/scratch_reg(20) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(19) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(18) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(17) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(16) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(15) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(14) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(13) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(12) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(11) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(10) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(9) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(8) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(7) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(6) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(5) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(4) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(3) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(2) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(1) {-radix binary} /ssd_bin_to_dec_tb/dut/scratch_reg(0) {-radix binary}} /ssd_bin_to_dec_tb/dut/scratch_reg
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/next_scratch_reg
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/bcd_reg
add wave -noupdate -radix binary /ssd_bin_to_dec_tb/dut/next_bcd_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1605197 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 106
configure wave -valuecolwidth 206
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {1225317 ps} {1736640 ps}
