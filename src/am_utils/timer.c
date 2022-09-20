//*****************************************************************************
//
//! @file hp_mode_192mhz.c
//!
//! @brief Example demonstrates the usage of High Performance Mode(192MHz) HAL.
//!
//! Purpose: This example sets the Apollo4 into High Power Mode(192MHz), then
//! times a calculation of prime numbers, displaying the elapsed time.
//! Next, it switches the Apollo4 into Low Performance Mode(96MHz), performs
//! the same calculation, then displays the elapsed time, which should be
//! roughly double the time of Low Power Mode.
//!
//! The entire test takes around 30s to run on Apollo4.
//!
//! Printing takes place over the ITM at 1M Baud.
//
//*****************************************************************************

//*****************************************************************************
//
// Copyright (c) 2021, Ambiq Micro, Inc.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
//
// Third party software included in this distribution is subject to the
// additional license terms as defined in the /docs/licenses directory.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// This is part of revision release_sdk_4_0_1-bef824fa27 of the AmbiqSuite Development Package.
//
//*****************************************************************************
#include "am_mcu_apollo.h"
#include "am_bsp.h"
#include "am_util.h"
#include "timer.h"

uint32_t
timer_init(uint32_t ui32TimerNum)
{
    am_hal_timer_config_t       TimerConfig;
    uint32_t ui32Status         = AM_HAL_STATUS_SUCCESS;

#if EE_CFG_ENERGY_MODE==1
    // Configure the timer pin
    am_hal_gpio_pinconfig(TIMER_GPIO, am_hal_gpio_pincfg_output);
    return ui32Status;
#endif

    //
    // Set the timer configuration
    // The default timer configuration is HFRC_DIV16, EDGE, compares=0, no trig.
    //
    am_hal_timer_default_config_set(&TimerConfig);
    ui32Status = am_hal_timer_config(ui32TimerNum, &TimerConfig);
    if ( ui32Status != AM_HAL_STATUS_SUCCESS )
    {
        am_util_stdio_printf("Failed to configure TIMER%d, return value=%d\r\n", ui32TimerNum, ui32Status);
        return ui32Status;
    }

    //
    // Stop and clear the timer.
    //
    am_hal_timer_clear(ui32TimerNum);

    //
    // Timer interrupt not needed for this purpose.
    //

    return ui32Status;

} // timer_init()

uint32_t
us_ticker_read(uint32_t ui32TimerNum)
{
    return am_hal_timer_read(ui32TimerNum) / 6;
}

//*****************************************************************************
// Power Monitor State Signalling
// This routine outputs a 2 bit state to GPIO pins that can be monitored
// by power measurement tools such as Joulescope
//*****************************************************************************

void am_init_power_monitor_state(void)
{
    am_hal_gpio_pinconfig(AM_AI_POWER_MONITOR_GPIO_0, am_hal_gpio_pincfg_output);
    am_hal_gpio_pinconfig(AM_AI_POWER_MONITOR_GPIO_1, am_hal_gpio_pincfg_output);
    am_set_power_monitor_state(AM_AI_IDLE);

}


void am_set_power_monitor_state(uint8_t state)
{
      am_hal_gpio_state_write(AM_AI_POWER_MONITOR_GPIO_0, state&0x01);
      am_hal_gpio_state_write(AM_AI_POWER_MONITOR_GPIO_1, (state>>1)&0x01);
}
