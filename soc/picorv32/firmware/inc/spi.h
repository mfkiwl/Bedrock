#ifndef SPI_H
#define SPI_H

#include <stdint.h>
#include "common.h"
#include "sfr.h"

#define SPI_DAT_REG   0
#define SPI_CFG_REG   1

#define BIT_CLK_DIV   0   // 8 bit spi clock prescaler (halfperiod cycle count)
#define BIT_NBITS     8   // Send / Receive N bits per transfer
#define BIT_CPOL     16   // Clock polarity: 0 = idle low, 1 = idle high
#define BIT_CPHA     17   // Clock phase: 0 = sample on first edge, 1 = second edge
#define BIT_LSB      18   // When set, transmit LSB first, otherwise MSB
#define BIT_SS_MAN   25   // when set, the SS pin can be controlled through cfg_ss_ctrl
#define BIT_SS_CTRL  26   // Manually control state of SS pin
#define BIT_BUSY     30   // set when spi_engine is busy
#define BIT_MISO     31   // Status of MISO

// Initialize the SPI master
#define SPI_INIT(                                                          \
    spi_base_addr, ss_man, ss_ctrl, cpol, cpha, lsb, nbits, clk_div        \
  ) SET_REG (                                                              \
    spi_base_addr+(SPI_CFG_REG<<2),                                        \
    (clk_div)<<BIT_CLK_DIV | (cpol)<<BIT_CPOL   | (cpha)<<BIT_CPHA     |   \
    (lsb)<<BIT_LSB         | (nbits)<<BIT_NBITS | (ss_man)<<BIT_SS_MAN |   \
    (ss_ctrl)<<BIT_SS_CTRL                                                 \
  )

// Returns the config word (initialized by SPI_INIT())
#define SPI_GET_STATUS(spi_base_addr) \
  GET_REG(spi_base_addr+(SPI_CFG_REG<<2))

// Returns 1 if a transmission is in progress, otherwise 0
#define SPI_IS_BUSY(spi_base_addr) \
  GET_SFR1( spi_base_addr, SPI_CFG_REG, BIT_BUSY )

// Set the SS pin high / low (BIT_SS_CTRL must be set)
#define SPI_SS_SET( spi_base_addr, val ) \
  SET_SFR1( spi_base_addr, SPI_CFG_REG, BIT_SS_CTRL, val )

// Returns the last received data word
#define SPI_GET_DAT(spi_base_addr) \
  GET_REG(spi_base_addr+(SPI_DAT_REG<<2))

// Start the transmission of val
#define SPI_SET_DAT(spi_base_addr, val) \
  SET_REG(spi_base_addr+(SPI_DAT_REG<<2), val)

// Start the transmission of val and block until done
#define SPI_SET_DAT_BLOCK(spi_base_addr, val) { \
  SPI_SET_DAT(spi_base_addr, val);              \
  while(SPI_IS_BUSY(spi_base_addr));            \
}

#endif
