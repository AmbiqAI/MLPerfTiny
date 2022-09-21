/* Copyright 2020 The MLPerf Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/
/// \file
/// \brief Main function to run benchmark on device.

/// NeuralSPOT Includes
#include "ns_ambiqsuite_harness.h"
#include "ns_peripherals_power.h"

#include "internally_implemented.h"
#include "submitter_implemented.h"
// #include "am_bsp_pp.h"


int main(int argc, char *argv[]) {
    // am_bsp_pp_snapshot(true, 3000, true);

  ee_benchmark_initialize();
  // am_bsp_pp_snapshot(true, 3001, true);
  while (1) {
    int c;
    c = th_getchar();
    ee_serial_callback(c);
  }
  return 0;
}