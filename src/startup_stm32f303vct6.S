/**************************************************************************//**
 * @file     startup_<Device>.S
 * @brief    CMSIS-Core(M) Device Startup File for
 *           Device <Device> (using Arm Compiler 6 with scatter file)
 * @version  V1.0.0
 * @date     20. January 2021
 ******************************************************************************/
/*
 * Copyright (c) 2009-2021 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/* Modified by jotamudo
 * Device: stm32f303vct6
 */

                .syntax  unified
                .arch    armv7e-m

                #define __INITIAL_SP     0x20000000
                #define __STACK_LIMIT    0x2000C000

                .section RESET
                .align   2
                .globl   __Vectors
                .globl   __Vectors_End
                .globl   __Vectors_Size
/* ToDo: Add Cortex exception vectors according the used Cortex-Core */
__Vectors:
                .long    __INITIAL_SP                       /*     Initial Stack Pointer */
                .long    Reset_Handler                      /*     Reset Handler         */
                .long    NMI_Handler                        /* -3 NMI Handler            */
                .long    HardFault_Handler                  /* -2 Hard Fault Handler     */
                .long    MemManage_Handler                  /* -1 MPU Fault Handler      */
                .long    BusFault_Handler                   /*  0 Bus Fault Handler      */
                .long    UsageFault_Handler                 /*  1 Usage Fault Handler    */
                .long    0                                  /*     Reserved              */
                .long    SVC_Handler                        /*  3  SVCall Handler        */
                .long    PendSV_Handler                     /*  5 PendSV Handler         */
                .long    SysTick_Handler                    /*  -1 SysTick Handler       */

/* TODO: Add your device specific interrupt vectors */
                /* Interrupts */
                .long    Window_Watchdog_Handler //   Window Watchdog interrupt   /*   first Device Interrupt */
                /*         ...    Implement other interrupt handlers*/
                //.long    <DeviceInterrupt last>_Handler    /*   last Device Interrupt */

/* TODO	: calculate the empty space according the used Cortex-Core (WWVG interrupt is the 1st out of 85 */
                .space   (84 * 4)                          /* Interrupts 1 .. 84 are left out */
__Vectors_End:
                .equ     __Vectors_Size, __Vectors_End - __Vectors
                .size    __Vectors, . - __Vectors


                .thumb
                .section .text
                .align   2

                .thumb_func
                .type    Reset_Handler, %function
                .globl   Reset_Handler
                .fnstart
Reset_Handler:
                ldr      r0, =__INITIAL_SP
                msr      psp, r0

                ldr      r0, =__STACK_LIMIT
                msr      msplim, r0
                msr      psplim, r0


                bl       SystemInit

                bl       __main

                .fnend
                .size    Reset_Handler, . - Reset_Handler


/* The default macro is not used for HardFault_Handler
 * because this results in a poor debug illusion.
 */
                .thumb_func
                .type    HardFault_Handler, %function
                .weak    HardFault_Handler
                .fnstart
HardFault_Handler:
                b        .
                .fnend
                .size    HardFault_Handler, . - HardFault_Handler

                .thumb_func
                .type    Default_Handler, %function
                .weak    Default_Handler
                .fnstart
Default_Handler:
                b        .
                .fnend
                .size    Default_Handler, . - Default_Handler

/* Macro to define default exception/interrupt handlers.
 * Default handler are weak symbols with an endless loop.
 * They can be overwritten by real handlers.
 */
                .macro   Set_Default_Handler  Handler_Name
                .weak    \Handler_Name
                .set     \Handler_Name, Default_Handler
                .endm


/* ToDo: Add Cortex exception handler according the used Cortex-Core */
/* Default exception/interrupt handler */
                Set_Default_Handler  NMI_Handler
                Set_Default_Handler  MemManage_Handler
                Set_Default_Handler  BusFault_Handler
                Set_Default_Handler  UsageFault_Handler
                Set_Default_Handler  SVC_Handler
                Set_Default_Handler  DebugMon_Handler
                Set_Default_Handler  PendSV_Handler
                Set_Default_Handler  SysTick_Handler



/* ToDo: Add your device specific interrupt handler */
                Set_Default_Handler  Window_Watchdog_Handler
                //...
                //Set_Default_Handler  <DeviceInterrupt last>_Handler

                .end
