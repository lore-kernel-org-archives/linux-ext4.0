From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12430] New: different oops & panic on accessing an intentionally corrupted ext4 fs image
Date: Sun, 11 Jan 2009 08:24:06 -0800 (PST)
Message-ID: <bug-12430-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbZAKQYk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 11:24:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0BGO69t004343
	for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 08:24:07 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12430

           Summary: different oops & panic on accessing an intentionally
                    corrupted ext4 fs image
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sliedes@cc.hut.fi


Hardware Environment: qemu x86
Software Environment: Minimal Debian sid/unstable
Problem Description:

On accessing an intentionally corrupted ext4 filesystem, I got a BUG once and a
panic in interrupt in another run on the same filesystem image.

Steps to reproduce:

1. gunzip the attached filesystem image
2. mount hdb.30000241 /mnt -t ext4 -o loop,errors=continue
3. cd /mnt
4. find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null

Here are the two quite different backtraces I got:

------------------------------------------------------------
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=10988, inode=2993, rec_len=44, name_len=36
EXT4-fs error (device hdb): ext4_add_entry: bad entry in directory #772: inode
out of bounds - offset=748, inode=2993, rec_len=44, name_len=36
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=14452, inode=525135, rec_len=48, name_len=40
EXT4-fs error (device hdb): ext4_add_entry: bad entry in directory #772: inode
out of bounds - offset=116, inode=525135, rec_len=48, name_len=40
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
rec_len is too small for name_len - offset=13312, inode=783, rec_len=96,
name_len=92
EXT4-fs error (device hdb): ext4_add_entry: bad entry in directory #772:
rec_len is too small for name_len - offset=0, inode=783, rec_len=96,
name_len=92
attempt to access beyond end of device
hdb: rw=0, want=3670337260, limit=20480
attempt to access beyond end of device
hdb: rw=0, want=3670337260, limit=20480
attempt to access beyond end of device
hdb: rw=0, want=3670337260, limit=20480
BUG: unable to handle kernel paging request at c721a000
IP: [<c030da11>] ext4_add_entry+0x40c/0x868
*pde = 00017067 *pte = 0721a160 
Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: 

Pid: 702, comm: touch Not tainted (2.6.28 #1) 
EIP: 0060:[<c030da11>] EFLAGS: 00000202 CPU: 0
EIP is at ext4_add_entry+0x40c/0x868
EAX: ffff9e91 EBX: c71a6c00 ECX: 3ffe1aa4 EDX: c73ae000
ESI: c742796f EDI: c721a000 EBP: c5c68e68 ESP: c5c68db0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process touch (pid: 702, ti=c5c68000 task=c7a44d80 task.ti=c5c68000)
Stack:
 c5c68e4c c74ca700 00000000 00000000 c5c68e4c c7611d9c c75f85f0 c7444000
 c750880c c7a52800 00000000 00000400 c7508730 00000128 c5c68e3c 00000000
 c7a44d80 c5ed9740 c7a44d80 000081a4 c750880c 00000400 c75769a0 c750880c
Call Trace:
 [<c032d628>] ? jbd2_journal_start+0xdf/0x115
 [<c030e681>] ? ext4_add_nondir+0x15/0x4d
 [<c030ed44>] ? ext4_create+0xde/0xf1
 [<c030ec66>] ? ext4_create+0x0/0xf1
 [<c027b22a>] ? vfs_create+0x78/0xb8
 [<c027ded4>] ? do_filp_open+0x6fb/0x7ca
 [<c0563481>] ? _spin_unlock+0x1d/0x20
 [<c0285b2e>] ? alloc_fd+0x84/0xfa
 [<c027202c>] ? do_sys_open+0x4b/0xd4
 [<c0272101>] ? sys_open+0x23/0x2b
 [<c020309e>] ? syscall_call+0x7/0xb
Code: c0 0c 89 45 a8 8b 55 ac 0f b7 72 10 81 fe ff ff 00 00 b8 00 00 01 00 0f
44 f0 03 75 a8 89 d0 03 45 9c 29 f0 89 c1 c1 e9 02 89 df <f3> a5 89 c1 83 e1 03
74 02 f3 a4 89 da 8d 0c 03 be 00 00 01 00 
EIP: [<c030da11>] ext4_add_entry+0x40c/0x868 SS:ESP 0068:c5c68db0
---[ end trace 442c731a60691f13 ]---
xargs[701]: segfault at 65677275 ip b7f0e16f sp bfa1fd60 error 4 in
ld-2.7.so[b7f05000+1a000]
------------------------------------------------------------

And the other:

------------------------------------------------------------
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
rec_len is too small for name_len - offset=13312, inode=783, rec_len=96,
name_len=92
EXT4-fs error (device hdb): ext4_add_entry: bad entry in directory #772:
rec_len is too small for name_len - offset=0, inode=783, rec_len=96,
name_len=92
attempt to access beyond end of device
hdb: rw=0, want=3670337260, limit=20480
attempt to access beyond end of device
hdb: rw=0, want=3670337260, limit=20480
attempt to access beyond end of device
hdb: rw=0, want=3670337260, limit=20480
BUG: unable to handle kernel NULL pointer dereference at 000000c4
IP: [<c021faf5>] account_system_time+0x8c/0x147
*pde = 00000000 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: 

Pid: 0, comm:  Not tainted (2.6.28 #1) 
EIP: 0060:[<c021faf5>] EFLAGS: 00000046 CPU: 0
EIP is at account_system_time+0x8c/0x147
EAX: 00000000 EBX: c06cb020 ECX: 00000001 EDX: c06cef00
ESI: 00000000 EDI: c78cc3d0 EBP: c7a92d10 ESP: c7a92cf0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process  (pid: 0, ti=c7a92000 task=c78cc3d0 task.ti=00000000)
Stack:
 00010000 00adb000 c06cef00 ffffffff 00000001 c78cc3d0 00000000 c78cc3d0
 c7a92d1c c022b8fa 00000000 c7a92d30 c022b941 c11a55a0 00000000 c11a55a0
 c7a92d38 c023e790 c7a92d58 c023e7f0 c7a92000 c11a55a0 00000000 c11a55a0
Call Trace:
 [<c022b8fa>] ? account_process_tick+0x19/0x41
 [<c022b941>] ? update_process_times+0x1f/0x4e
 [<c023e790>] ? tick_periodic+0x25/0x6c
 [<c023e7f0>] ? tick_handle_periodic+0x19/0x79
 [<c020db09>] ? smp_apic_timer_interrupt+0x57/0x88
 [<c0203cb4>] ? apic_timer_interrupt+0x28/0x30
 [<c030da11>] ? ext4_add_entry+0x40c/0x868
 [<c032d628>] ? jbd2_journal_start+0xdf/0x115
 [<c030e681>] ? ext4_add_nondir+0x15/0x4d
 [<c030ed44>] ? ext4_create+0xde/0xf1
 [<c030ec66>] ? ext4_create+0x0/0xf1
 [<c027b22a>] ? vfs_create+0x78/0xb8
 [<c027ded4>] ? do_filp_open+0x6fb/0x7ca
 [<c0563481>] ? _spin_unlock+0x1d/0x20
 [<c0285b2e>] ? alloc_fd+0x84/0xfa
 [<c027202c>] ? do_sys_open+0x4b/0xd4
 [<c0274b13>] ? fput+0x19/0x1f
 [<c0271f0e>] ? filp_close+0x41/0x5f
 [<c0272101>] ? sys_open+0x23/0x2b
 [<c020309e>] ? syscall_call+0x7/0xb
Code: ff 8b 48 14 89 c8 25 00 00 ff 0f 3b 45 e0 74 35 01 5a 20 11 72 24 89 f8
e8 d0 e1 02 00 83 c4 14 5b 5e 5f 5d c3 8b 87 ac 03 00 00 <8b> 90 c4 00 00 00 85
d2 74 bc 64 a1 04 a0 6c c0 f7 d2 8b 04 82 
EIP: [<c021faf5>] account_system_time+0x8c/0x147 SS:ESP 0068:c7a92cf0
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------
WARNING: at kernel/smp.c:333 smp_call_function_mask+0x1ae/0x1b3()
Pid: 0, comm:  Tainted: G      D    2.6.28 #1
Call Trace:
 [<c0560abb>] ? printk+0x18/0x1a
 [<c02231ad>] warn_on_slowpath+0x49/0x6b
 [<c04775e8>] ? delay_tsc+0x31/0x51
 [<c04775e8>] ? delay_tsc+0x31/0x51
 [<c0477544>] ? __const_udelay+0x34/0x36
 [<c04a28d5>] ? wait_for_xmitr+0x4e/0x9b
 [<c04775e8>] ? delay_tsc+0x31/0x51
 [<c0477544>] ? __const_udelay+0x34/0x36
 [<c0563481>] ? _spin_unlock+0x1d/0x20
 [<c04a2922>] ? serial8250_console_putchar+0x0/0x22
 [<c0246aa8>] smp_call_function_mask+0x1ae/0x1b3
 [<c020cdea>] ? stop_this_cpu+0x0/0x36
 [<c0205ac5>] ? show_registers+0x79/0x1ef
 [<c049c6b2>] ? do_unblank_screen+0x1d/0x127
 [<c0246ac4>] smp_call_function+0x17/0x19
 [<c020cddd>] native_smp_send_stop+0x1b/0x28
 [<c05609f1>] panic+0x4b/0xfd
 [<c020575c>] oops_end+0x6f/0x7b
 [<c0205e6b>] die+0x4e/0x64
 [<c0211b2b>] do_page_fault+0x292/0x797
 [<c0320a22>] ? ext4_mb_new_blocks+0x13e/0x729
 [<c0319e30>] ? ext4_ext_get_blocks+0x1c9/0xee5
 [<c023c8af>] ? clocksource_get_next+0x3d/0x44
 [<c0211899>] ? do_page_fault+0x0/0x797
 [<c0563a2a>] error_code+0x72/0x78
 [<c021faf5>] ? account_system_time+0x8c/0x147
 [<c022b8fa>] account_process_tick+0x19/0x41
 [<c022b941>] update_process_times+0x1f/0x4e
 [<c023e790>] tick_periodic+0x25/0x6c
 [<c023e7f0>] tick_handle_periodic+0x19/0x79
 [<c020db09>] smp_apic_timer_interrupt+0x57/0x88
 [<c0203cb4>] apic_timer_interrupt+0x28/0x30
 [<c030da11>] ? ext4_add_entry+0x40c/0x868
 [<c032d628>] ? jbd2_journal_start+0xdf/0x115
 [<c030e681>] ext4_add_nondir+0x15/0x4d
 [<c030ed44>] ext4_create+0xde/0xf1
 [<c030ec66>] ? ext4_create+0x0/0xf1
 [<c027b22a>] vfs_create+0x78/0xb8
 [<c027ded4>] do_filp_open+0x6fb/0x7ca
 [<c0563481>] ? _spin_unlock+0x1d/0x20
 [<c0285b2e>] ? alloc_fd+0x84/0xfa
 [<c027202c>] do_sys_open+0x4b/0xd4
 [<c0274b13>] ? fput+0x19/0x1f
 [<c0271f0e>] ? filp_close+0x41/0x5f
 [<c0272101>] sys_open+0x23/0x2b
 [<c020309e>] syscall_call+0x7/0xb
---[ end trace e7c34c864c51f32f ]---
general protection fault: fffa [#2] SMP DEBUG_PAGEALLOC
last sysfs file: 

Pid: 0, comm:  Tainted: G      D W  (2.6.28 #1) 
EIP: 0060:[<c0560a17>] EFLAGS: 00000246 CPU: 0
EIP is at panic+0x71/0xfd
EAX: 00000000 EBX: 00000000 ECX: c02399db EDX: 00000001
ESI: c7a92cb8 EDI: 0000000b EBP: c7a92b28 ESP: c7a92b18
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process  (pid: 0, ti=c7a92000 task=c78cc3d0 task.ti=00000000)
Stack:
 c05f0c4c c06ecc20 00000006 c7a92cb8 c7a92b40 c020575c c05e6c56 c7a92cb8
 00000000 c05ec4e2 c7a92b5c c0205e6b 00000000 00000006 c78cc3d0 00000034
 00000000 c7a92cb0 c0211b2b c05f9052 00000000 c7a92bf0 c0320a22 0000003f
Call Trace:
 [<c020575c>] ? oops_end+0x6f/0x7b
 [<c0205e6b>] ? die+0x4e/0x64
 [<c0211b2b>] ? do_page_fault+0x292/0x797
 [<c0320a22>] ? ext4_mb_new_blocks+0x13e/0x729
 [<c0319e30>] ? ext4_ext_get_blocks+0x1c9/0xee5
 [<c023c8af>] ? clocksource_get_next+0x3d/0x44
 [<c0211899>] ? do_page_fault+0x0/0x797
 [<c0563a2a>] ? error_code+0x72/0x78
 [<c021faf5>] ? account_system_time+0x8c/0x147
 [<c022b8fa>] ? account_process_tick+0x19/0x41
 [<c022b941>] ? update_process_times+0x1f/0x4e
 [<c023e790>] ? tick_periodic+0x25/0x6c
 [<c023e7f0>] ? tick_handle_periodic+0x19/0x79
 [<c020db09>] ? smp_apic_timer_interrupt+0x57/0x88
 [<c0203cb4>] ? apic_timer_interrupt+0x28/0x30
 [<c030da11>] ? ext4_add_entry+0x40c/0x868
 [<c032d628>] ? jbd2_journal_start+0xdf/0x115
 [<c030e681>] ? ext4_add_nondir+0x15/0x4d
 [<c030ed44>] ? ext4_create+0xde/0xf1
 [<c030ec66>] ? ext4_create+0x0/0xf1
 [<c027b22a>] ? vfs_create+0x78/0xb8
 [<c027ded4>] ? do_filp_open+0x6fb/0x7ca
 [<c0563481>] ? _spin_unlock+0x1d/0x20
 [<c0285b2e>] ? alloc_fd+0x84/0xfa
 [<c027202c>] ? do_sys_open+0x4b/0xd4
 [<c0274b13>] ? fput+0x19/0x1f
 [<c0271f0e>] ? filp_close+0x41/0x5f
 [<c0272101>] ? sys_open+0x23/0x2b
 [<c020309e>] ? syscall_call+0x7/0xb
Code: 15 8c 77 64 c0 b9 20 cc 6e c0 31 d2 b8 40 b0 64 c0 e8 f7 8f cd ff a1 e0
cb 6e c0 85 c0 74 2d a1 e4 cb 6e c0 85 c0 7f 30 fb 31 db <e8> 05 7e ce ff 89 d8
ff 15 e0 cb 6e c0 89 c6 b8 58 89 41 00 e8 
EIP: [<c0560a17>] panic+0x71/0xfd SS:ESP 0068:c7a92b18
Kernel panic - not syncing: Fatal exception in interrupt
------------------------------------------------------------


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
