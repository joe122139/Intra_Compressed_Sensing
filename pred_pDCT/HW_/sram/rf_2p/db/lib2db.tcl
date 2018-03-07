

set corners [list \
  _ff_1p21v_1p21v_125c \
  _ff_1p21v_1p21v_m40c \
  _ss_0p99v_0p99v_125c \
  _ss_0p99v_0p99v_m40c \
  _tt_1p10v_1p10v_25c \
]

set libraries [list \
  rf_2p_hde \
]

enable_write_lib_mode

foreach mylibrary $libraries {
  foreach mycorner $corners {
    read_lib "../${mylibrary}${mycorner}.lib"
    write_lib "USERLIB${mycorner}" -o "${mylibrary}${mycorner}.db"
    remove_design -all
  }
}

exit
