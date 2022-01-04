SRC = UART_FPGA_N4.vhd \
      diviseurClk.vhd \
      echoUnit.vhd \
      UART.vhd \
      ../clkUnit/clkUnit.vhd \
      ctrlUnit.vhd \
      ../TxUnit/TxUnit.vhd \
      RxUnit.vhd \
      compteur16.vhd \
      controleRx.vhd \
      compteur16Test.vhd \
      RxUnitTest.vhd

# for synthesis:
UNIT = UART_FPGA_N4
ARCH = synthesis
UCF  = UART_FPGA_N4.ucf
#UCF  = UART_FPGA_N4_DDR.ucf

# for simulation:
#TEST = compteur16Test
TEST = RxUnitTest
# duration (to adjust if necessary)
TIME = 10000ns
PLOT = output
