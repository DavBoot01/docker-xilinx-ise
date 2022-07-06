#!/usr/bin/expect

set timeout -1

spawn /Xilinx_ISE_DS_Lin_14.7_1015_1/bin/lin64/batchxsetup -batch /install//batch_file

expect {
    "Press Enter key to continue " { 
        send -- "\r"
        exp_continue
    }
    "I accept and agree to the terms and conditions above." {
        send -- "Y\r"
        exp_continue
    }
    "Press Enter key to continue " { 
        send -- "\r"
        exp_continue
    }
    "Installation is complete" {
        expect eof
    }
}
