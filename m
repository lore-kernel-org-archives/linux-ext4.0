From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: latest -git: A peculiar case of a stuck process (ext3/sched-related?)
Date: Fri, 18 Jul 2008 11:45:08 +0200
Message-ID: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	"Ingo Molnar" <mingo@elte.hu>,
	"Peter Zijlstra" <a.p.zijlstra@chello.nl>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:24974 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYGRJpK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 05:45:10 -0400
Received: by yx-out-2324.google.com with SMTP id 8so86025yxm.1
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 02:45:09 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was running a test which corrupts ext3 filesystem images on purpose.
After quite a long time, I have ended up with a grep that runs at 98%
CPU and is unkillable even though it is in state R:

root      6573 98.6  0.0   4008   820 pts/0    R    11:17  15:48 grep -r . mnt

It doesn't go away with kill -9 either. A sysrq-t shows this info:

grep          R running   5704  6573   6552
       f4ff3c3c c0747b19 00000000 f4ff3bd4 c01507ba ffffffff 00000000 f4ff3bf0
       f5992fd0 f4ff3c4c 01597000 00000000 c09cd080 f312afd0 f312b248 c1fb2f80
       00000001 00000002 00000000 f312afd0 f312afd0 f4ff3c24 c015ab70 00000000
Call Trace:
 [<c0747b19>] ? schedule+0x459/0x960
 [<c01507ba>] ? atomic_notifier_call_chain+0x1a/0x20
 [<c015ab70>] ? mark_held_locks+0x40/0x80
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c074816e>] preempt_schedule_irq+0x3e/0x70
 [<c0103ffc>] need_resched+0x1f/0x23
 [<c022c041>] ? ext3_find_entry+0x401/0x6f0
 [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
 [<c019d63c>] ? slab_pad_check+0x3c/0x120
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c022cb3a>] ext3_lookup+0x3a/0xd0
 [<c01b7bb3>] ? d_alloc+0x133/0x190
 [<c01ac110>] do_lookup+0x160/0x1b0
 [<c01adc38>] __link_path_walk+0x208/0xdc0
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c01bd97e>] ? mnt_want_write+0x4e/0xb0
 [<c01ae327>] __link_path_walk+0x8f7/0xdc0
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c01ae844>] path_walk+0x54/0xb0
 [<c01aea45>] do_path_lookup+0x85/0x230
 [<c01af7a8>] __user_walk_fd+0x38/0x50
 [<c01a7fb1>] vfs_stat_fd+0x21/0x50
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c01bc81d>] ? mntput_no_expire+0x1d/0x110
 [<c01a8081>] vfs_stat+0x11/0x20
 [<c01a80a4>] sys_stat64+0x14/0x30
 [<c01a5a8f>] ? fput+0x1f/0x30
 [<c0430948>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c0430948>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c010407f>] sysenter_past_esp+0x78/0xc5
 =======================

..so it's clearly related to the corrupted ext3 filesystem. The
strange thing, in my opinion, is this stack frame:

 [<c022cb3a>] ext3_lookup+0x3a/0xd0

..but this address corresponds to fs/ext3/namei.c:1039:

        bh = ext3_find_entry(dentry, &de);
        inode = NULL;
        if (bh) { /* <--- here */
                unsigned long ino = le32_to_cpu(de->inode);
                brelse (bh);

What happened? Did the scheduler get stuck? Softlockup detection and
NMI watchdog are both enabled, but none of them are triggering.

Trying to strace the problem doesn't really help either:

    # strace -p 6573
    Process 6573 attached - interrupt to quit
    ^C^C^C^C

(and hangs unkillably too.)

See full log at:

    http://folk.uio.no/vegardno/linux/log-1216370788.txt

The machine is still running in the same state and CPU0 is still
usable. What more info can I provide to help debug this?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
