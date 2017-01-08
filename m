From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 192131] New: Hang up at boot time [<c0c4d1ac>]
 (io_schedule_timeout) from [<c0c4e344>] (bit_wait_i)
Date: Sun, 08 Jan 2017 23:51:56 +0000
Message-ID: <bug-192131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934218AbdAHXwD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 8 Jan 2017 18:52:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5DF9C202A1
        for <linux-ext4@vger.kernel.org>; Sun,  8 Jan 2017 23:52:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 853872025A
        for <linux-ext4@vger.kernel.org>; Sun,  8 Jan 2017 23:51:58 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=192131

            Bug ID: 192131
           Summary: Hang up at boot time [<c0c4d1ac>]
                    (io_schedule_timeout) from [<c0c4e344>] (bit_wait_i)
           Product: File System
           Version: 2.5
    Kernel Version: 4.10.0-rc2
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: bugux@miouyouyou.fr
        Regression: No

Created attachment 250821
  --> https://bugzilla.kernel.org/attachment.cgi?id=250821&action=edit
Kernel .config file used to compile the kernel in question

Greetings,

I'm currently experiencing hang up at boot time when using a Linux Kernel
4.10.0-rc2 on a Rockchip 3288 ARM board. Since I cannot login to the system in
such conditions, I'm using a UART←→USB cable and minicom to read the console
messages.

The system first hangs at:

[    4.445965] ttyS2 - failed to request DMA 

Then print the following after a few minutes:

[  246.829223] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  246.835665]       Not tainted 4.10.0-rc2MyyMyy #1
[  246.840368] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this.
[  246.848190] swapper/0       D    0     1      0 0x00000000
[  246.853685] [<c0c4d684>] (__schedule) from [<c0c4da3c>] (schedule+0xb8/0xd0)
[  246.860731] [<c0c4da3c>] (schedule) from [<c0c51280>]
(schedule_timeout+0x2c)
[  246.868383] [<c0c51280>] (schedule_timeout) from [<c0c4d1ac>]
(io_schedule_t)
[  246.876901] [<c0c4d1ac>] (io_schedule_timeout) from [<c0c4e344>]
(bit_wait_i)
[  246.884986] [<c0c4e344>] (bit_wait_io) from [<c0c4df58>]
(__wait_on_bit+0x70)
[  246.892550] [<c0c4df58>] (__wait_on_bit) from [<c0c4e0b4>]
(out_of_line_wait)
[  246.901156] [<c0c4e0b4>] (out_of_line_wait_on_bit) from [<c0273904>]
(__wait)
[  246.910022] [<c0273904>] (__wait_on_buffer) from [<c0276da8>]
(__bread_gfp+0)
[  246.917847] [<c0276da8>] (__bread_gfp) from [<c0303e5c>]
(ext4_fill_super+0x)
[  246.925847] [<c0303e5c>] (ext4_fill_super) from [<c0243c8c>]
(mount_bdev+0x1)
[  246.933673] [<c0243c8c>] (mount_bdev) from [<c0300104>]
(ext4_mount+0x24/0x3)
[  246.940893] [<c0300104>] (ext4_mount) from [<c0244c68>]
(mount_fs+0x80/0x15c)
[  246.948025] [<c0244c68>] (mount_fs) from [<c025faa8>]
(vfs_kern_mount+0x58/0)
[  246.955503] [<c025faa8>] (vfs_kern_mount) from [<c0263300>]
(do_mount+0x814/)
[  246.963069] [<c0263300>] (do_mount) from [<c0263810>] (SyS_mount+0x84/0xac)
[  246.970028] [<c0263810>] (SyS_mount) from [<c110129c>]
(mount_block_root+0x1)
[  246.977856] [<c110129c>] (mount_block_root) from [<c11015a4>]
(mount_root+0x)
[  246.985594] [<c11015a4>] (mount_root) from [<c1101720>]
(prepare_namespace+0)
[  246.993593] [<c1101720>] (prepare_namespace) from [<c1100f54>]
(kernel_init_)
[  247.002458] [<c1100f54>] (kernel_init_freeable) from [<c0c4c8c0>]
(kernel_in)
[  247.010718] [<c0c4c8c0>] (kernel_init) from [<c0107a38>]
(ret_from_fork+0x14)
[  247.018282] NMI backtrace for cpu 2                                          
[  247.021770] CPU: 2 PID: 34 Comm: khungtaskd Not tainted 4.10.0-rc2MyyMyy #1  
[  247.028718] Hardware name: Rockchip (Device Tree)                            
[  247.033416] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  247.041147] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  247.048358] [<c06526e4>] (dump_stack) from [<c06567c4>]
(nmi_cpu_backtrace+0)
[  247.056175] [<c06567c4>] (nmi_cpu_backtrace) from [<c06568a0>]
(nmi_trigger_)
[  247.065725] [<c06568a0>] (nmi_trigger_cpumask_backtrace) from [<c010eefc>]
()
[  247.076317] [<c010eefc>] (arch_trigger_cpumask_backtrace) from [<c01b7a98>]
)
[  247.085262] [<c01b7a98>] (watchdog) from [<c013f710>] (kthread+0x128/0x144)  
[  247.092215] [<c013f710>] (kthread) from [<c0107a38>]
(ret_from_fork+0x14/0x3)
[  247.099435] Sending NMI from CPU 2 to CPUs 0-1,3:                            
[  247.104239] NMI backtrace for cpu 3                                          
[  247.107720] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.114492] Hardware name: Rockchip (Device Tree)                            
[  247.119185] task: ee94de80 task.stack: ee978000                              
[  247.123705] PC is at arch_cpu_idle+0x3c/0x48                                 
[  247.127964] LR is at arch_cpu_idle+0x38/0x48                                 
[  247.132224] pc : [<c01084cc>]    lr : [<c01084c8>]    psr: 60000013          
[  247.138477] sp : ee979f90  ip : ee979fa0  fp : ee979f9c                      
[  247.143690] r10: 00000000  r9 : 410fc0d1  r8 : 0000406a                      
[  247.148902] r7 : c12e52e8  r6 : c11c41d0  r5 : 00000000  r4 : 00000000       
[  247.155415] r3 : c011ba80  r2 : 00000000  r1 : 00000000  r0 : 00000001       
[  247.161928] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment
none
[  247.169047] Control: 10c5387d  Table: 0000406a  DAC: 00000051                
[  247.174781] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.181553] Hardware name: Rockchip (Device Tree)                            
[  247.186246] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  247.193972] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  247.201179] [<c06526e4>] (dump_stack) from [<c010875c>]
(show_regs+0x1c/0x20)
[  247.208298] [<c010875c>] (show_regs) from [<c06567bc>]
(nmi_cpu_backtrace+0x)
[  247.216024] [<c06567bc>] (nmi_cpu_backtrace) from [<c010ec7c>]
(handle_IPI+0)
[  247.224011] [<c010ec7c>] (handle_IPI) from [<c01014ac>]
(gic_handle_irq+0x88)
[  247.231563] [<c01014ac>] (gic_handle_irq) from [<c010cb8c>]
(__irq_svc+0x6c/)
[  247.239030] Exception stack(0xee979f40 to 0xee979f88)                        
[  247.244069] 9f40: 00000001 00000000 00000000 c011ba80 00000000 00000000
c11c8
[  247.252229] 9f60: 0000406a 410fc0d1 00000000 ee979f9c ee979fa0 ee979f90
c010c
[  247.260388] 9f80: 60000013 ffffffff                                          
[  247.263868] [<c010cb8c>] (__irq_svc) from [<c01084cc>]
(arch_cpu_idle+0x3c/0)
[  247.271248] [<c01084cc>] (arch_cpu_idle) from [<c0c52124>]
(default_idle_cal)
[  247.279321] [<c0c52124>] (default_idle_call) from [<c01663e8>]
(do_idle+0xf0)
[  247.286960] [<c01663e8>] (do_idle) from [<c0166788>]
(cpu_startup_entry+0x28)
[  247.294513] [<c0166788>] (cpu_startup_entry) from [<c010e814>]
(secondary_st)
[  247.303540] [<c010e814>] (secondary_start_kernel) from [<0010192c>]
(0x10192)
[  247.310747] NMI backtrace for cpu 1                                          
[  247.314228] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.321001] Hardware name: Rockchip (Device Tree)                            
[  247.325693] task: ee94d100 task.stack: ee974000                              
[  247.330213] PC is at arch_cpu_idle+0x3c/0x48                                 
[  247.334472] LR is at arch_cpu_idle+0x38/0x48                                 
[  247.338731] pc : [<c01084cc>]    lr : [<c01084c8>]    psr: 60000013          
[  247.344983] sp : ee975f90  ip : ee975fa0  fp : ee975f9c                      
[  247.350196] r10: 00000000  r9 : 410fc0d1  r8 : 0000406a                      
[  247.355409] r7 : c12e52e8  r6 : c11c41d0  r5 : 00000000  r4 : 00000000       
[  247.361922] r3 : c011ba80  r2 : 00000000  r1 : 00000000  r0 : 00000001       
[  247.368435] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment
none
[  247.375554] Control: 10c5387d  Table: 0000406a  DAC: 00000051                
[  247.381288] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.388060] Hardware name: Rockchip (Device Tree)                            
[  247.392753] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  247.400479] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  247.407686] [<c06526e4>] (dump_stack) from [<c010875c>]
(show_regs+0x1c/0x20)
[  247.414806] [<c010875c>] (show_regs) from [<c06567bc>]
(nmi_cpu_backtrace+0x)
[  247.422533] [<c06567bc>] (nmi_cpu_backtrace) from [<c010ec7c>]
(handle_IPI+0)
[  247.430519] [<c010ec7c>] (handle_IPI) from [<c01014ac>]
(gic_handle_irq+0x88)
[  247.438071] [<c01014ac>] (gic_handle_irq) from [<c010cb8c>]
(__irq_svc+0x6c/)
[  247.445538] Exception stack(0xee975f40 to 0xee975f88)                        
[  247.450577] 5f40: 00000001 00000000 00000000 c011ba80 00000000 00000000
c11c8
[  247.458737] 5f60: 0000406a 410fc0d1 00000000 ee975f9c ee975fa0 ee975f90
c010c
[  247.466897] 5f80: 60000013 ffffffff                                          
[  247.470376] [<c010cb8c>] (__irq_svc) from [<c01084cc>]
(arch_cpu_idle+0x3c/0)
[  247.477755] [<c01084cc>] (arch_cpu_idle) from [<c0c52124>]
(default_idle_cal)
[  247.485828] [<c0c52124>] (default_idle_call) from [<c01663e8>]
(do_idle+0xf0)
[  247.493467] [<c01663e8>] (do_idle) from [<c0166788>]
(cpu_startup_entry+0x28)
[  247.501020] [<c0166788>] (cpu_startup_entry) from [<c010e814>]
(secondary_st)
[  247.510047] [<c010e814>] (secondary_start_kernel) from [<0010192c>]
(0x10192)
[  247.517254] NMI backtrace for cpu 0                                          
[  247.520736] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.527509] Hardware name: Rockchip (Device Tree)                            
[  247.532201] task: c120f100 task.stack: c1200000                              
[  247.536721] PC is at arch_cpu_idle+0x3c/0x48                                 
[  247.540981] LR is at arch_cpu_idle+0x38/0x48                                 
[  247.545241] pc : [<c01084cc>]    lr : [<c01084c8>]    psr: 60000113          
[  247.551493] sp : c1201f50  ip : c1201f60  fp : c1201f5c                      
[  247.556706] r10: 00000000  r9 : c116da38  r8 : eefdedc0                      
[  247.561919] r7 : c1209480  r6 : c11c41d0  r5 : 00000000  r4 : 00000000       
[  247.568432] r3 : c011ba80  r2 : 00000000  r1 : 00000000  r0 : 00000001       
[  247.574945] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment
none
[  247.582064] Control: 10c5387d  Table: 0000406a  DAC: 00000051                
[  247.587796] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.594569] Hardware name: Rockchip (Device Tree)                            
[  247.599262] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  247.606988] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  247.614194] [<c06526e4>] (dump_stack) from [<c010875c>]
(show_regs+0x1c/0x20)
[  247.621315] [<c010875c>] (show_regs) from [<c06567bc>]
(nmi_cpu_backtrace+0x)
[  247.629041] [<c06567bc>] (nmi_cpu_backtrace) from [<c010ec7c>]
(handle_IPI+0)
[  247.637028] [<c010ec7c>] (handle_IPI) from [<c01014ac>]
(gic_handle_irq+0x88)
[  247.644580] [<c01014ac>] (gic_handle_irq) from [<c010cb8c>]
(__irq_svc+0x6c/)
[  247.652046] Exception stack(0xc1201f00 to 0xc1201f48)                        
[  247.657086] 1f00: 00000001 00000000 00000000 c011ba80 00000000 00000000
c11c0
[  247.665247] 1f20: eefdedc0 c116da38 00000000 c1201f5c c1201f60 c1201f50
c010c
[  247.673406] 1f40: 60000113 ffffffff                                          
[  247.676885] [<c010cb8c>] (__irq_svc) from [<c01084cc>]
(arch_cpu_idle+0x3c/0)
[  247.684266] [<c01084cc>] (arch_cpu_idle) from [<c0c52124>]
(default_idle_cal)
[  247.692339] [<c0c52124>] (default_idle_call) from [<c01663e8>]
(do_idle+0xf0)
[  247.699979] [<c01663e8>] (do_idle) from [<c0166788>]
(cpu_startup_entry+0x28)
[  247.707531] [<c0166788>] (cpu_startup_entry) from [<c0c4c890>]
(rest_init+0x)
[  247.715258] [<c0c4c890>] (rest_init) from [<c1100cbc>]
(start_kernel+0x338/0)
[  247.722725] [<c1100cbc>] (start_kernel) from [<0000807c>] (0x807c)           
[  247.728903] Kernel panic - not syncing: hung_task: blocked tasks             
[  247.734899] CPU: 2 PID: 34 Comm: khungtaskd Not tainted 4.10.0-rc2MyyMyy #1  
[  247.741846] Hardware name: Rockchip (Device Tree)                            
[  247.746543] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  247.754273] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  247.761483] [<c06526e4>] (dump_stack) from [<c01f3edc>] (panic+0xd8/0x25c)   
[  247.768347] [<c01f3edc>] (panic) from [<c01b7aa0>] (watchdog+0x38c/0x40c)    
[  247.775123] [<c01b7aa0>] (watchdog) from [<c013f710>] (kthread+0x128/0x144)  
[  247.782074] [<c013f710>] (kthread) from [<c0107a38>]
(ret_from_fork+0x14/0x3)
[  247.789284] CPU0: stopping                                                   
[  247.791985] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.798758] Hardware name: Rockchip (Device Tree)                            
[  247.803455] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  247.811184] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  247.818393] [<c06526e4>] (dump_stack) from [<c010ebec>]
(handle_IPI+0x180/0x)
[  247.825776] [<c010ebec>] (handle_IPI) from [<c01014ac>]
(gic_handle_irq+0x88)
[  247.833331] [<c01014ac>] (gic_handle_irq) from [<c010cb8c>]
(__irq_svc+0x6c/)
[  247.840797] Exception stack(0xc1201f00 to 0xc1201f48)                        
[  247.845840] 1f00: 00000001 00000000 00000000 c011ba80 00000000 00000000
c11c0
[  247.854003] 1f20: eefdedc0 c116da38 00000000 c1201f5c c1201f60 c1201f50
c010c
[  247.862164] 1f40: 60000113 ffffffff                                          
[  247.865646] [<c010cb8c>] (__irq_svc) from [<c01084cc>]
(arch_cpu_idle+0x3c/0)
[  247.873030] [<c01084cc>] (arch_cpu_idle) from [<c0c52124>]
(default_idle_cal)
[  247.881099] [<c0c52124>] (default_idle_call) from [<c01663e8>]
(do_idle+0xf0)
[  247.888742] [<c01663e8>] (do_idle) from [<c0166788>]
(cpu_startup_entry+0x28)
[  247.896298] [<c0166788>] (cpu_startup_entry) from [<c0c4c890>]
(rest_init+0x)
[  247.904028] [<c0c4c890>] (rest_init) from [<c1100cbc>]
(start_kernel+0x338/0)
[  247.911497] [<c1100cbc>] (start_kernel) from [<0000807c>] (0x807c)           
[  247.917665] CPU3: stopping                                                   
[  247.920367] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.10.0-rc2MyyMyy #1    
[  247.927140] Hardware name: Rockchip (Device Tree)                            
[  247.931838] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  247.939568] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  247.946777] [<c06526e4>] (dump_stack) from [<c010ebec>]
(handle_IPI+0x180/0x)
[  247.954160] [<c010ebec>] (handle_IPI) from [<c01014ac>]
(gic_handle_irq+0x88)
[  247.961715] [<c01014ac>] (gic_handle_irq) from [<c010cb8c>]
(__irq_svc+0x6c/)
[  247.969182] Exception stack(0xee979f40 to 0xee979f88)                        
[  247.974224] 9f40: 00000001 00000000 00000000 c011ba80 00000000 00000000
c11c8
[  247.982387] 9f60: 0000406a 410fc0d1 00000000 ee979f9c ee979fa0 ee979f90
c010c
[  247.990547] 9f80: 60000013 ffffffff                                          
[  247.994031] [<c010cb8c>] (__irq_svc) from [<c01084cc>]
(arch_cpu_idle+0x3c/0)
[  248.001415] [<c01084cc>] (arch_cpu_idle) from [<c0c52124>]
(default_idle_cal)
[  248.009492] [<c0c52124>] (default_idle_call) from [<c01663e8>]
(do_idle+0xf0)
[  248.017136] [<c01663e8>] (do_idle) from [<c0166788>]
(cpu_startup_entry+0x28)
[  248.024692] [<c0166788>] (cpu_startup_entry) from [<c010e814>]
(secondary_st)
[  248.033713] [<c010e814>] (secondary_start_kernel) from [<0010192c>]
(0x10192)
[  248.040920] CPU1: stopping                                                   
[  248.043621] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.10.0-rc2MyyMyy #1    
[  248.050393] Hardware name: Rockchip (Device Tree)                            
[  248.055090] [<c0110674>] (unwind_backtrace) from [<c010c034>]
(show_stack+0x)
[  248.062819] [<c010c034>] (show_stack) from [<c06526e4>]
(dump_stack+0x80/0xa)
[  248.070029] [<c06526e4>] (dump_stack) from [<c010ebec>]
(handle_IPI+0x180/0x)
[  248.077411] [<c010ebec>] (handle_IPI) from [<c01014ac>]
(gic_handle_irq+0x88)
[  248.084967] [<c01014ac>] (gic_handle_irq) from [<c010cb8c>]
(__irq_svc+0x6c/)
[  248.092433] Exception stack(0xee975f40 to 0xee975f88)                        
[  248.097476] 5f40: 00000001 00000000 00000000 c011ba80 00000000 00000000
c11c8
[  248.105638] 5f60: 0000406a 410fc0d1 00000000 ee975f9c ee975fa0 ee975f90
c010c
[  248.113799] 5f80: 60000013 ffffffff                                          
[  248.117282] [<c010cb8c>] (__irq_svc) from [<c01084cc>]
(arch_cpu_idle+0x3c/0)
[  248.124666] [<c01084cc>] (arch_cpu_idle) from [<c0c52124>]
(default_idle_cal)
[  248.132743] [<c0c52124>] (default_idle_call) from [<c01663e8>]
(do_idle+0xf0)
[  248.140386] [<c01663e8>] (do_idle) from [<c0166788>]
(cpu_startup_entry+0x28)
[  248.147943] [<c0166788>] (cpu_startup_entry) from [<c010e814>]
(secondary_st)
[  248.156971] [<c010e814>] (secondary_start_kernel) from [<0010192c>]
(0x10192)
[  248.164184] ---[ end Kernel panic - not syncing: hung_task: blocked tasks    

Since the first backtrace relates to ext4 mount functions, I'm putting this
bugreport here.

However, I'm not sure where this bug comes from.

The system is a Rockchip 3288 MiQi board. The DTB is compiled from the
arch/arm/boot/dts/rk3288-miqi.dts file.

I'm attaching the kernel .config file used to compile this kernel.

The 4.9 kernels worked flawlessly, on that regard.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.