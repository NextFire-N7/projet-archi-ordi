SRC = UART_FPGA_N4.vhd \
      diviseurClk.vhd \
      echoUnit.vhd \
      UART.vhd \
      ../clkUnit/clkUnit.vhd \
      ctrlUnit.vhd \
      ../TxUnit/TxUnit.vhd \
      RxUnit.vhd

# for synthesis:
UNIT = UART_FPGA_N4
ARCH = synthesis
UCF  = UART_FPGA_N4.ucf
#UCF  = UART_FPGA_N4_DDR.ucf
