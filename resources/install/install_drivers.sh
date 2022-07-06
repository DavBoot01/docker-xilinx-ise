#!/usr/bin/expect

set timeout -1

spawn /opt/Xilinx/14.7/ISE_DS/common/bin/lin64/digilent/install_digilent.sh

expect {
    "In which directory should " { 
        send -- "\r"
        exp_continue
    }
    "Successfully installed Digilent Cable Drivers" {
        expect eof
    }
}
