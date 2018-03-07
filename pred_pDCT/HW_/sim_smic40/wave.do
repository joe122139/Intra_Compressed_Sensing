onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_predDCT/meas_pred/Qstep
add wave -noupdate /test_predDCT/meas_pred/arst_n
add wave -noupdate /test_predDCT/meas_pred/ave_bot
add wave -noupdate /test_predDCT/meas_pred/ave_le
add wave -noupdate /test_predDCT/meas_pred/buf_s
add wave -noupdate /test_predDCT/meas_pred/clk
add wave -noupdate /test_predDCT/meas_pred/code
add wave -noupdate /test_predDCT/meas_pred/cor_X
add wave -noupdate /test_predDCT/meas_pred/cor_Y
add wave -noupdate /test_predDCT/meas_pred/en_i
add wave -noupdate /test_predDCT/meas_pred/en_o
add wave -noupdate /test_predDCT/meas_pred/isBotLine
add wave -noupdate /test_predDCT/meas_pred/isFirstLine
add wave -noupdate /test_predDCT/meas_pred/pred
add wave -noupdate /test_predDCT/meas_pred/raddr
add wave -noupdate /test_predDCT/meas_pred/rdata
add wave -noupdate /test_predDCT/meas_pred/re_n
add wave -noupdate /test_predDCT/meas_pred/rst_n
add wave -noupdate /test_predDCT/meas_pred/sad_ca
add wave -noupdate /test_predDCT/meas_pred/stages
add wave -noupdate /test_predDCT/meas_pred/waddr
add wave -noupdate /test_predDCT/meas_pred/wdata
add wave -noupdate /test_predDCT/meas_pred/we_n
add wave -noupdate /test_predDCT/meas_pred/x_ave_top
add wave -noupdate /test_predDCT/meas_pred/x_buf_bot
add wave -noupdate /test_predDCT/meas_pred/x_buf_le
add wave -noupdate /test_predDCT/meas_pred/y
add wave -noupdate /test_predDCT/meas_pred/y_cand
add wave -noupdate /test_predDCT/meas_pred/y_p
add wave -noupdate /test_predDCT/meas_pred/y_rec
add wave -noupdate /test_predDCT/meas_pred/y_res
add wave -noupdate /test_predDCT/meas_pred/y_resQ
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 99
configure wave -valuecolwidth 40
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
WaveRestoreZoom {362497 ps} {401974 ps}
