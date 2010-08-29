From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] New: Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Sun, 29 Aug 2010 20:00:16 GMT
Message-ID: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60958 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0H2UAS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Aug 2010 16:00:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7TK0Gk1031839
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 29 Aug 2010 20:00:16 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361

           Summary: Watchdog detected hard LOCKUP in
                    jbd2_journal_get_write_access
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: casteyde.christian@free.fr
        Regression: Yes


Created an attachment (id=28361)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=28361)
full dmesg output

Kernel configuration: 2.6.36-rc3
Athlon 64 X2 3GHz in 64bits mode
Slackware64 13.1

maybe an ext4 problem

At boot, with a kernel compiled with support for locks, kmemcheck and so, I got
this from time to time (amoung several other problems reported from kmemcheck
and sometimes a total freeze at boot):


kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): using internal journal
EXT3-fs (sda1): mounted filesystem with ordered data mode
ADDRCONF(NETDEV_UP): eth0: link is not ready
uli526x: eth0 NIC Link is Up 100 Mbps Full duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:233 watchdog_overflow_callback+0xe3/0x110()
Hardware name: K8 Combo-Z
Watchdog detected hard LOCKUP on cpu 0
Modules linked in: snd_intel8x0 snd_cmipci snd_opl3_lib snd_hwdep
snd_mpu401_uart snd_ac97_codec snd_ra
wmidi ac97_bus
Pid: 1923, comm: update-mime-dat Not tainted 2.6.36-rc3 #6
Call Trace:
 <NMI>  [<ffffffff81042cda>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81042db1>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81086d37>] ? watchdog_overflow_callback+0x7/0x110
 [<ffffffff81086e13>] watchdog_overflow_callback+0xe3/0x110
 [<ffffffff81096281>] ? __perf_event_overflow+0x141/0x210
 [<ffffffff8109133a>] ? perf_event_update_userpage+0x10a/0x1b0
 [<ffffffff81091230>] ? perf_event_update_userpage+0x0/0x1b0
 [<ffffffff8101247d>] ? x86_perf_event_set_period+0xdd/0x160
 [<ffffffff810964f4>] ? perf_event_overflow+0x14/0x20
 [<ffffffff8101414f>] ? x86_pmu_handle_irq+0x10f/0x140
 [<ffffffff81010d8b>] ? perf_event_nmi_handler+0x4b/0x60
 [<ffffffff810660d0>] ? notifier_call_chain+0x50/0xa0
 [<ffffffff810666a5>] ? __atomic_notifier_call_chain+0x95/0xd0
 [<ffffffff81066610>] ? __atomic_notifier_call_chain+0x0/0xd0
 [<ffffffff8108b255>] ? rcu_nmi_exit+0x15/0x60
 [<ffffffff8100424b>] ? do_nmi+0x9b/0x2b0
 [<ffffffff815981ca>] ? nmi+0x1a/0x2c
 [<ffffffff8118fc46>] ? jbd2_journal_get_write_access+0x36/0x50
 [<ffffffff81597de0>] ? debug+0x0/0x40
 <<EOE>>  <#DB>  [<ffffffff81086d42>] ? watchdog_overflow_callback+0x12/0x110
 <<EOE>> 
---[ end trace 1408e87e8e109015 ]---
BUG: sleeping function called from invalid context at fs/ext4/inode.c:5833
in_atomic(): 1, irqs_disabled(): 0, pid: 1923, name: update-mime-dat
2 locks held by update-mime-dat/1923:
 #0:  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<ffffffff810db511>]
do_last+0x111/0x690
 #1:  (jbd2_handle){+.+...}, at: [<ffffffff811904f0>]
start_this_handle+0x470/0x510
Pid: 1923, comm: update-mime-dat Tainted: G        W   2.6.36-rc3 #6
Call Trace:
 [<ffffffff810721f3>] ? __debug_show_held_locks+0x13/0x30
 [<ffffffff81036b85>] __might_sleep+0x105/0x130
 [<ffffffff8115c137>] ext4_mark_inode_dirty+0x47/0x1d0
 [<ffffffff8116643b>] ext4_add_nondir+0x6b/0x80
 [<ffffffff81166bf6>] ext4_create+0xd6/0x130
 [<ffffffff810da459>] vfs_create+0x89/0xc0
 [<ffffffff810db9fa>] ? do_last+0x5fa/0x690
 [<ffffffff810db935>] do_last+0x535/0x690
 [<ffffffff810dd97d>] do_filp_open+0x21d/0x660
 [<ffffffff81596c98>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff810393c5>] ? sub_preempt_count+0x95/0xd0
 [<ffffffff815977d0>] ? _raw_spin_unlock+0x30/0x60
 [<ffffffff810e9132>] ? alloc_fd+0x122/0x1d0
 [<ffffffff810cd7e0>] do_sys_open+0x60/0x120
 [<ffffffff81596c59>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810cd8cb>] sys_open+0x1b/0x20
 [<ffffffff810023ab>] system_call_fastpath+0x16/0x1b
note: update-mime-dat[1923] exited with preempt_count 1
BUG: scheduling while atomic: update-mime-dat/1923/0x10000002
no locks held by update-mime-dat/1923.
Modules linked in: snd_intel8x0 snd_cmipci snd_opl3_lib snd_hwdep
snd_mpu401_uart snd_ac97_codec snd_rawmidi ac97_bus
Pid: 1923, comm: update-mime-dat Tainted: G        W   2.6.36-rc3 #6
Call Trace:
 [<ffffffff810721f3>] ? __debug_show_held_locks+0x13/0x30
 [<ffffffff81039257>] __schedule_bug+0x77/0x80
 [<ffffffff815943f9>] schedule+0x6e9/0xa30
 [<ffffffff8103d153>] __cond_resched+0x13/0x30
 [<ffffffff8159482b>] _cond_resched+0x2b/0x40
 [<ffffffff810b1a59>] unmap_vmas+0x7c9/0x940
 [<ffffffff810b6c2d>] exit_mmap+0xdd/0x1a0
 [<ffffffff81040677>] mmput+0x57/0xe0
 [<ffffffff81045250>] exit_mm+0x100/0x130
 [<ffffffff810477ad>] do_exit+0x64d/0x720
 [<ffffffff810478cf>] do_group_exit+0x4f/0xc0
 [<ffffffff8105448a>] get_signal_to_deliver+0x31a/0x510
 [<ffffffff81040090>] ? kick_process+0x50/0xa0
 [<ffffffff8159778d>] ? _raw_spin_unlock_irqrestore+0x5d/0x70
 [<ffffffff810017c0>] do_signal+0x70/0x790
 [<ffffffff8159776d>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
 [<ffffffff8100dd71>] ? syscall_trace_leave+0xd1/0xe0
 [<ffffffff81001f2f>] do_notify_resume+0x4f/0x60
 [<ffffffff81596c59>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100264b>] int_signal+0x12/0x17
BUG: scheduling while atomic: update-mime-dat/1923/0x10000002
no locks held by update-mime-dat/1923.
Modules linked in: snd_intel8x0 snd_cmipci snd_opl3_lib snd_hwdep
snd_mpu401_uart snd_ac97_codec snd_rawmidi ac97_bus
Pid: 1923, comm: update-mime-dat Tainted: G        W   2.6.36-rc3 #6
Call Trace:
...

etc
full dmesg appended as attachement.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
