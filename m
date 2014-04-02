From: Theodore Ts'o <tytso@mit.edu>
Subject: xfstest generic/127 rcu_sched self-detected stall
Date: Wed, 02 Apr 2014 09:55:54 -0400
Message-ID: <nsxzjk3omxh.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49010 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660AbaDBN43 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 09:56:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I'm seeing a test failure using a standard 4k blocksize run with
generic/127, using the test branch on the linux-ext4.git tree (commit
4df1c7d).  This tree contains the set of patches that I plan to send to
Linus, with the v3.14 and the xfs-collapse-range branches merged in.

(The reason why I merge in v3.14 is because since that's closest to what
Linus will be running, and the xfs-collapse-range branch was so we could
exercise the new ext4 collapse-range codepaths.)

The test takes a lot longer than it should, and then it eventually spits
out the following stack traces.  I don't see ext4 anywhere in the stack
trace, so this might not necessarily be an ext4 failure.

Eric, have you seen this in your testing?  Also, are you testing just
the ext4 dev branch, or have you tried doing a test with anything else
merged in.

Thanks!

                                        - Ted

Test config:

fio		fio-2.1-19-g0b14f0a (Thu, 23 May 2013 21:27:54 +0200)
quota		0d0a674 (Tue, 26 Mar 2013 17:13:33 +0100)
xfsprogs	v3.2.0-alpha2-60-gaa210c4 (Thu, 13 Mar 2014 21:23:50 +1100)
xfstests-bld	1efde7a (Tue, 1 Apr 2014 14:42:07 -0400)
xfstests	linux-v3.8-336-g3948694 (Thu, 13 Mar 2014 15:20:54 +1100)

BEGIN TEST: Ext4 4k block Wed Apr  2 02:27:35 UTC 2014
Device: /dev/vdb
mk2fs options: -q
mount options: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.14.0-00048-g4df1c7d
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

generic/127 2184s ...	[02:51:02]
[35629.446574] INFO: rcu_sched self-detected stall on CPU { 1}  (t=1319414 jiffies g=75861 c=75860 q=5)
[35629.448083] NMI backtrace for cpu 1
[35629.448565] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-00048-g4df1c7d #1744
[35629.449577] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[35629.449800] task: f5936250 ti: f5938000 task.ti: f5938000
[35629.449800] EIP: 0060:[<c0157157>] EFLAGS: 00210046 CPU: 1
[35629.449800] EIP is at native_apic_mem_write+0x12/0x14
[35629.449800] EAX: ffffa300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[35629.449800] ESI: 00000c00 EDI: 03000000 EBP: f5939e08 ESP: f5939e08
[35629.449800]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[35629.449800] CR0: 8005003b CR2: b758b000 CR3: 3506c000 CR4: 000006f0
[35629.449800] Stack:
[35629.449800]  f5939e1c c01571d6 00200006 00000003 00000002 f5939e30 c01574a7 00002710
[35629.449800]  f6648d68 00000005 f5939e38 c015753a f5939e48 c0157609 c0a2cbc6 c0b67780
[35629.449800]  f5939e84 c01b3162 c0a3a821 001421f6 00012855 00012854 00000005 f5939e6c
[35629.449800] Call Trace:
[35629.449800]  [<c01571d6>] __default_send_IPI_dest_field+0x4c/0x51
[35629.449800]  [<c01574a7>] default_send_IPI_mask_logical+0x51/0x75
[35629.449800]  [<c015753a>] default_send_IPI_all+0x26/0x37
[35629.449800]  [<c0157609>] arch_trigger_all_cpu_backtrace+0x3d/0x65
[35629.449800]  [<c01b3162>] rcu_check_callbacks+0x194/0x41e
[35629.449800]  [<c019c169>] ? trace_hardirqs_off+0xb/0xd
[35629.449800]  [<c0172a42>] update_process_times+0x32/0x55
[35629.449800]  [<c01bb8b3>] ? tick_sched_do_timer+0x2d/0x2d
[35629.449800]  [<c01bb033>] tick_sched_handle+0x35/0x41
[35629.449800]  [<c01bb8e6>] tick_sched_timer+0x33/0x58
[35629.449800]  [<c018468a>] __run_hrtimer+0xbc/0x1c9
[35629.449800]  [<c0184f88>] hrtimer_interrupt+0xfd/0x1f5
[35629.449800]  [<c0155e61>] local_apic_timer_interrupt+0x46/0x4b
[35629.449800]  [<c015612e>] smp_apic_timer_interrupt+0x25/0x34
[35629.449800]  [<c07b8a52>] apic_timer_interrupt+0x32/0x38
[35629.449800]  [<c013007b>] ? vmx_handle_exit+0x500/0x85c
[35629.449800]  [<c015d95d>] ? native_safe_halt+0x5/0x7
[35629.449800]  [<c0139b24>] default_idle+0x22/0x4b
[35629.449800]  [<c013a039>] arch_cpu_idle+0x17/0x25
[35629.449800]  [<c01ab71a>] cpu_startup_entry+0xdd/0x146
[35629.449800]  [<c015480c>] start_secondary+0x207/0x210
[35629.449800] Code: 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa 90 8d 74 26 00 5d c3 8b 0d 6c d1 b5 c0 55 89 e5 8d 84 08 00 b0 ff ff 89 10 <5d> c3 55 89 e5 53 89 d3 8d 48 01 ba 08 00 00 00 89 d8 e8 4b 08
[35629.449805] NMI backtrace for cpu 0
[35629.449805] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-00048-g4df1c7d #1744
[35629.449805] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[35629.449805] task: c0b4eab8 ti: c0b42000 task.ti: c0b42000
[35629.449805] EIP: 0060:[<c015d95d>] EFLAGS: 00200206 CPU: 0
[35629.449805] EIP is at native_safe_halt+0x5/0x7
[35629.449805] EAX: c0b4eab8 EBX: c0b42000 ECX: 00200046 EDX: 00000004
[35629.449805] ESI: 00020800 EDI: c0dfc800 EBP: c0b43fb0 ESP: c0b43fb0
[35629.449805]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[35629.449805] CR0: 8005003b CR2: b758b000 CR3: 3506c000 CR4: 000006f0
[35629.449805] Stack:
[35629.449805]  c0b43fb8 c0139b24 c0b43fc0 c013a039 c0b43fcc c01ab71a 00000002 c0b43fd8
[35629.449805]  c07aa2ba c0c3f390 c0b43fe8 c0be79a7 c0c3f390 00000800 c0b43ff8 c0be72ab
[35629.449805]  00000800 c0dfc800 017fe003 00000000
[35629.449805] Call Trace:
[35629.449805]  [<c0139b24>] default_idle+0x22/0x4b
[35629.449805]  [<c013a039>] arch_cpu_idle+0x17/0x25
[35629.449805]  [<c01ab71a>] cpu_startup_entry+0xdd/0x146
[35629.449805]  [<c07aa2ba>] rest_init+0x111/0x116
[35629.449805]  [<c0be79a7>] start_kernel+0x361/0x366
[35629.449805]  [<c0be72ab>] i386_start_kernel+0x79/0x7d
[35629.449805] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 89 c7 56 89 ce 53 53 8b 00
[40027.558012] INFO: rcu_sched self-detected stall on CPU { 0}  (t=1319433 jiffies g=75861 c=75860 q=5)
[40027.560475] NMI backtrace for cpu 1
[40027.561017] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-00048-g4df1c7d #1744
[40027.561929] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[40027.561929] task: f5936250 ti: f596e000 task.ti: f5938000
[40027.561929] EIP: 0060:[<c01724a5>] EFLAGS: 00200002 CPU: 1
[40027.561929] EIP is at run_timer_softirq+0xb3/0x195
[40027.561929] EAX: 00b5dbbd EBX: f594c000 ECX: 00abbc60 EDX: f596ffac
[40027.561929] ESI: 00000060 EDI: c0685229 EBP: f596ffc0 ESP: f596ff98
[40027.561929]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[40027.561929] CR0: 8005003b CR2: b758b000 CR3: 3506c000 CR4: 000006f0
[40027.561929] Stack:
[40027.561929]  f594ca38 f594c838 f596ffac 00000000 c13be580 f596ffac f596ffac 00000001
[40027.561929]  00000000 00000101 f596fff8 c016c561 00000001 0000000a 00000002 00200040
[40027.561929]  00b5dbbe f596e000 01000000 c0b48204 00000282 f5939f18 00000000 c016c43f
[40027.561929] Call Trace:
[40027.561929]  [<c016c561>] __do_softirq+0x122/0x2cf
[40027.561929]  [<c016c43f>] ? __local_bh_disable_ip+0x6e/0x6e
[40027.561929]  <IRQ> 
[40027.561929]  [<c016c904>] ? irq_exit+0x42/0x8b
[40027.561929]  [<c0156133>] ? smp_apic_timer_interrupt+0x2a/0x34
[40027.561929]  [<c07b8a52>] ? apic_timer_interrupt+0x32/0x38
[40027.561929]  [<c013007b>] ? vmx_handle_exit+0x500/0x85c
[40027.561929]  [<c015d95d>] ? native_safe_halt+0x5/0x7
[40027.561929]  [<c0139b24>] ? default_idle+0x22/0x4b
[40027.561929]  [<c013a039>] ? arch_cpu_idle+0x17/0x25
[40027.561929]  [<c01ab71a>] ? cpu_startup_entry+0xdd/0x146
[40027.561929]  [<c015480c>] ? start_secondary+0x207/0x210
[40027.561929] Code: 38 0c 00 00 89 d8 c1 e9 14 83 e1 3f e8 08 ff ff ff 85 c0 75 13 8b 4b 2c 8d 93 38 0e 00 00 89 d8 c1 e9 1a e8 f1 fe ff ff ff 43 2c <8d> 0c f3 8b 71 38 8d 55 ec 8d 41 38 89 55 e0 89 56 04 89 75 ec
[40027.561336] NMI backtrace for cpu 0
[40027.561336] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-00048-g4df1c7d #1744
[40027.561336] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[40027.561336] task: c0b4eab8 ti: c0b42000 task.ti: c0b42000
[40027.561336] EIP: 0060:[<c0157157>] EFLAGS: 00210046 CPU: 0
[40027.561336] EIP is at native_apic_mem_write+0x12/0x14
[40027.561336] EAX: ffffa300 EBX: 00000002 ECX: fffff000 EDX: 00000c00
[40027.561336] ESI: 00000c00 EDI: 03000000 EBP: c0b43e40 ESP: c0b43e40
[40027.561336]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[40027.561336] CR0: 8005003b CR2: b758b000 CR3: 3506c000 CR4: 000006f0
[40027.561336] Stack:
[40027.561336]  c0b43e54 c01571d6 00200006 00000003 00000002 c0b43e68 c01574a7 00002710
[40027.561336]  f64fad68 00000005 c0b43e70 c015753a c0b43e80 c0157609 c0a2cbc6 c0b67780
[40027.561336]  c0b43ebc c01b3162 c0a3a821 00142209 00012855 00012854 00000005 c0b43ea4
[40027.561336] Call Trace:
[40027.561336]  [<c01571d6>] __default_send_IPI_dest_field+0x4c/0x51
[40027.561336]  [<c01574a7>] default_send_IPI_mask_logical+0x51/0x75
[40027.561336]  [<c015753a>] default_send_IPI_all+0x26/0x37
[40027.561336]  [<c0157609>] arch_trigger_all_cpu_backtrace+0x3d/0x65
[40027.561336]  [<c01b3162>] rcu_check_callbacks+0x194/0x41e
[40027.561336]  [<c019c169>] ? trace_hardirqs_off+0xb/0xd
[40027.561336]  [<c0172a42>] update_process_times+0x32/0x55
[40027.561336]  [<c01bb8b3>] ? tick_sched_do_timer+0x2d/0x2d
[40027.561336]  [<c01bb033>] tick_sched_handle+0x35/0x41
[40027.561336]  [<c01bb8e6>] tick_sched_timer+0x33/0x58
[40027.561336]  [<c018468a>] __run_hrtimer+0xbc/0x1c9
[40027.561336]  [<c0184f88>] hrtimer_interrupt+0xfd/0x1f5
[40027.561336]  [<c0155e61>] local_apic_timer_interrupt+0x46/0x4b
[40027.561336]  [<c015612e>] smp_apic_timer_interrupt+0x25/0x34
[40027.561336]  [<c07b8a52>] apic_timer_interrupt+0x32/0x38
[40027.561336]  [<c013007b>] ? vmx_handle_exit+0x500/0x85c
[40027.561336]  [<c015d95d>] ? native_safe_halt+0x5/0x7
[40027.561336]  [<c0139b24>] default_idle+0x22/0x4b
[40027.561336]  [<c013a039>] arch_cpu_idle+0x17/0x25
[40027.561336]  [<c01ab71a>] cpu_startup_entry+0xdd/0x146
[40027.561336]  [<c07aa2ba>] rest_init+0x111/0x116
[40027.561336]  [<c0be79a7>] start_kernel+0x361/0x366
[40027.561336]  [<c0be72ab>] i386_start_kernel+0x79/0x7d
