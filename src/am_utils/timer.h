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
#ifndef MLPERF_TIMER
#define MLPERF_TIMER

#ifdef __cplusplus
extern "C"
{
#endif

#include "am_mcu_apollo.h"
#include "am_bsp.h"
#include "am_util.h"

#define AM_TIMER 0
#define TIMER_GPIO 22

extern uint32_t timer_init(uint32_t ui32TimerNum);
extern uint32_t us_ticker_read(uint32_t ui32TimerNum);

#define AM_AI_POWER_MONITOR_GPIO_0 22
#define AM_AI_POWER_MONITOR_GPIO_1 23

#define AM_AI_IDLE 0
#define AM_AI_DATA_COLLECTION 1
#define AM_AI_FEATURE_EXTRACTION 2
#define AM_AI_INFERING 3

extern void am_init_power_monitor_state(void);
extern void am_set_power_monitor_state(uint8_t state);

#ifdef __cplusplus
}
#endif

#endif // MLPERF_TIMER
