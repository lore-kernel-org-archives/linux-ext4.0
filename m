From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Tue, 11 Jul 2017 09:59:13 +0000
Message-ID: <bug-196223-13602-uvKXNrPBAf@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36134 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753412AbdGKJ7Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Jul 2017 05:59:16 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 973D528438
        for <linux-ext4@vger.kernel.org>; Tue, 11 Jul 2017 09:59:15 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #22 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
It seems that Broxton is hanging to this issue each fast-feedback run, with
MCE. Takes 5 minutes to reproduce.

I'll try bisecting with this setup.

- cmdline:
testrunner@bxt-j3405:/opt/igt$ ./scripts/run-tests.sh -vT
tests/intel-ci/fast-feedback.testlist 

- output before hang
running: igt/gem_exec_suspend/basic
pass: igt/gem_exec_suspend/basic   
running: igt/gem_exec_suspend/basic-s3
pass: igt/gem_exec_suspend/basic-s3   
[108/279] skip: 11, pass: 97 \

Note that basic-s3 passes before host hangs

- serial
bxt-j3405 login: [  273.799025] mce: [Hardware Error]: CPU 0: Machine Check: 0
Bank 4: a600000000028
[  273.799033] mce: [Hardware Error]: TSC 0 ADDR fef13b80 
[  273.799057] mce: [Hardware Error]: PROCESSOR 0:506c9 TIME 1499766163 SOCKET
0 APIC 0 microcode 1c
[  369.635514] INFO: task NetworkManager:582 blocked for more than 60 seconds.
[  369.643203]       Tainted: G     U         
4.12.0-next-20170711-CI-next-20170711 #1
[  369.652000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  369.662019] Kernel panic - not syncing: hung_task: blocked tasks
[  369.668287] CPU: 0 PID: 36 Comm: khungtaskd Tainted: G     U         
4.12.0-next-20170711-CI-ne1
[  369.678913] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./J3455-ITX, BIOS P1.10 06
[  369.689036] Call Trace:
[  369.691613]  dump_stack+0x67/0x97
[  369.695146]  panic+0xcf/0x212
[  369.698314]  watchdog+0x469/0x620
[  369.701849]  kthread+0x10f/0x150
[  369.705267]  ? reset_hung_task_detector+0x10/0x10
[  369.710259]  ? kthread_create_on_node+0x40/0x40
[  369.715079]  ret_from_fork+0x27/0x40
[  369.718888] Kernel Offset: disabled
[  369.722627] Rebooting in 1 seconds..
[  370.726512] ACPI MEMORY or I/O RESET_REG.

- dmesg
[  276.985613] r8169 0000:01:00.0 enp1s0: link up
[  333.940312] usb 1-6: USB disconnect, device number 7
[  335.471502] usb 1-6: new low-speed USB device number 8 using xhci_hcd
[  335.644636] usb 1-6: New USB device found, idVendor=046d, idProduct=c077
[  335.644652] usb 1-6: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  335.644665] usb 1-6: Product: USB Optical Mouse
[  335.644676] usb 1-6: Manufacturer: Logitech
[  335.655340] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:15.0/usb1/1-6/1-6:1.0/0003:046D:C077.0008/input/input21
[  335.708842] hid-generic 0003:046D:C077.0008: input,hidraw2: USB HID v1.11
Mouse [Logitech USB Optical Mouse] on usb-0000:00:15.0-6/input0
[  369.635514] INFO: task NetworkManager:582 blocked for more than 60 seconds.
[  369.643203]       Tainted: G     U         
4.12.0-next-20170711-CI-next-20170711 #1
[  369.652000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  369.660444] NetworkManager  D    0   582      1 0x00000000
[  369.660454] Call Trace:
[  369.660470]  __schedule+0x405/0xb40
[  369.660479]  ? bit_wait+0x50/0x50
[  369.660484]  schedule+0x3b/0x90
[  369.660491]  io_schedule+0x11/0x40
[  369.660496]  bit_wait_io+0xc/0x50
[  369.660501]  __wait_on_bit+0x5c/0x90
[  369.660508]  out_of_line_wait_on_bit+0x7c/0x80
[  369.660515]  ? bit_waitqueue+0x30/0x30
[  369.660522]  __wait_on_buffer+0x3b/0x40
[  369.660530]  ext4_find_entry+0x3f8/0x5b0
[  369.660543]  ? d_alloc+0x84/0xc0
[  369.660553]  ext4_lookup+0x46/0x1c0
[  369.660560]  __lookup_hash+0x53/0x80
[  369.660566]  do_unlinkat+0x12c/0x2a0
[  369.660575]  SyS_unlink+0x11/0x20
[  369.660580]  entry_SYSCALL_64_fastpath+0x1c/0xb1
[  369.660585] RIP: 0033:0x7f2e06056a57
[  369.660590] RSP: 002b:00007fff23acbac8 EFLAGS: 00000206 ORIG_RAX:
0000000000000057
[  369.660600] RAX: ffffffffffffffda RBX: ffffffff8146e023 RCX:
00007f2e06056a57
[  369.660605] RDX: 0000000002260d90 RSI: 00007f2e06322b28 RDI:
0000000002237be0
[  369.660610] RBP: ffffc9000067bf88 R08: 0000000002260df0 R09:
0000000000000100
[  369.660614] R10: 00000000000004c9 R11: 0000000000000206 R12:
0000000002221980
[  369.660618] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000002237be0
[  369.660626]  ? __this_cpu_preempt_check+0x13/0x20
[  369.660635] 
               Showing all locks held in the system:
[  369.660650] 2 locks held by khungtaskd/36:
[  369.660668]  #0:  (rcu_read_lock){......}, at: [<ffffffff81138c2c>]
watchdog+0x9c/0x620
[  369.660690]  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff810d76ad>]
debug_show_all_locks+0x3d/0x1a0
[  369.660720] 2 locks held by NetworkManager/582:
[  369.660724]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8122d39f>]
mnt_want_write+0x1f/0x50
[  369.660747]  #1:  (&type->i_mutex_dir_key/1){+.+.+.}, at:
[<ffffffff8121865c>] do_unlinkat+0x11c/0x2a0
[  369.660770] 1 lock held by in:imklog/612:
[  369.660774]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff8122a59e>]
__fdget_pos+0x3e/0x50
[  369.660794] 1 lock held by rs:main Q:Reg/613:
[  369.660797]  #0:  (&type->i_mutex_dir_key){++++++}, at: [<ffffffff81212ca2>]
lookup_slow+0xb2/0x1e0
[  369.660822] 1 lock held by dmesg/1402:
[  369.660826]  #0:  (&user->lock){+.+...}, at: [<ffffffff810ecc88>]
devkmsg_read+0x38/0x2d0
[  369.660852] 2 locks held by kworker/u8:29/2982:
[  369.660856]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff8109c208>]
process_one_work+0x178/0x670
[  369.660876]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8109c208>]
process_one_work+0x178/0x670

[  369.660903] =============================================

[  369.660908] NMI backtrace for cpu 0
[  369.660914] CPU: 0 PID: 36 Comm: khungtaskd Tainted: G     U         
4.12.0-next-20170711-CI-next-20170711 #1
[  369.660917] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./J3455-ITX, BIOS P1.10 09/29/2016
[  369.660921] Call Trace:
[  369.660927]  dump_stack+0x67/0x97
[  369.660933]  nmi_cpu_backtrace+0xbf/0xd0
[  369.660939]  ? irq_force_complete_move+0xf0/0xf0
[  369.660945]  nmi_trigger_cpumask_backtrace+0xc0/0x100
[  369.660951]  arch_trigger_cpumask_backtrace+0x14/0x20
[  369.660955]  watchdog+0x45d/0x620
[  369.660962]  kthread+0x10f/0x150
[  369.660966]  ? reset_hung_task_detector+0x10/0x10
[  369.660972]  ? kthread_create_on_node+0x40/0x40
[  369.660977]  ret_from_fork+0x27/0x40
[  369.660989] Sending NMI from CPU 0 to CPUs 1-3:
[  369.661001] NMI backtrace for cpu 1
[  369.661004] CPU: 1 PID: 195 Comm: systemd-journal Tainted: G     U         
4.12.0-next-20170711-CI-next-20170711 #1
[  369.661004] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./J3455-ITX, BIOS P1.10 09/29/2016
[  369.661005] task: ffff8802743b8040 task.stack: ffffc90000224000
[  369.661007] RIP: 0033:0x7ffca352ba3d
[  369.661008] RSP: 002b:00007ffca349de10 EFLAGS: 00000202
[  369.661010] RAX: 0000000000000000 RBX: 0000000000000007 RCX:
00007ffca352ba3d
[  369.661010] RDX: 0000000000000000 RSI: 00007ffca349de40 RDI:
0000000000000007
[  369.661011] RBP: 00007ffca349de10 R08: 0000000015fe7e40 R09:
0000000000000001
[  369.661012] R10: 0027183014d2c5aa R11: 0000000000000202 R12:
00007ffca349de70
[  369.661013] R13: 0000000000000001 R14: 00007ffca349e0f0 R15:
0000000000000001
[  369.661014] FS:  00007fb99d7d1840(0000) GS:ffff88027fc80000(0000)
knlGS:0000000000000000
[  369.661015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  369.661016] CR2: 00007fb99b6ee010 CR3: 0000000272577000 CR4:
00000000003406e0
[  369.661020] NMI backtrace for cpu 3 skipped: idling at pc 0xffffffff8188d448
[  369.661023] NMI backtrace for cpu 2 skipped: idling at pc 0xffffffff8188d448
[  369.662019] Kernel panic - not syncing: hung_task: blocked tasks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
