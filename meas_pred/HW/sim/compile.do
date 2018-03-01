vlog -v +incdir+../stdcore/rtl ../stdcore/rtl/*.v
#vlog -sv +define+PIX_8+isSim+incdir+../rtl ../rtl/*.sv
vlog -sv ../rtl ../rtl/*.sv
#vlog +define+PIX_8 ../tb/*.sv
vlog ../tb/*.sv
