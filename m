From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: A peculiar case of a stuck process (ext3/sched-related?)
Date: Fri, 18 Jul 2008 12:17:17 +0200
Message-ID: <19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
References: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	"Ingo Molnar" <mingo@elte.hu>,
	"Peter Zijlstra" <a.p.zijlstra@chello.nl>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.234]:43525 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYGRKRT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 06:17:19 -0400
Received: by qb-out-0506.google.com with SMTP id p36so1262912qba.17
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 03:17:18 -0700 (PDT)
In-Reply-To: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 11:45 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> I was running a test which corrupts ext3 filesystem images on purpose.
> After quite a long time, I have ended up with a grep that runs at 98%
> CPU and is unkillable even though it is in state R:
>
> root      6573 98.6  0.0   4008   820 pts/0    R    11:17  15:48 grep -r . mnt
>
> It doesn't go away with kill -9 either. A sysrq-t shows this info:
>
> grep          R running   5704  6573   6552
>       f4ff3c3c c0747b19 00000000 f4ff3bd4 c01507ba ffffffff 00000000 f4ff3bf0
>       f5992fd0 f4ff3c4c 01597000 00000000 c09cd080 f312afd0 f312b248 c1fb2f80
>       00000001 00000002 00000000 f312afd0 f312afd0 f4ff3c24 c015ab70 00000000
> Call Trace:
>  [<c0747b19>] ? schedule+0x459/0x960
>  [<c01507ba>] ? atomic_notifier_call_chain+0x1a/0x20
>  [<c015ab70>] ? mark_held_locks+0x40/0x80
>  [<c015addb>] ? trace_hardirqs_on+0xb/0x10
>  [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
>  [<c074816e>] preempt_schedule_irq+0x3e/0x70
>  [<c0103ffc>] need_resched+0x1f/0x23
>  [<c022c041>] ? ext3_find_entry+0x401/0x6f0
>  [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
>  [<c019d63c>] ? slab_pad_check+0x3c/0x120
>  [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
>  [<c015906b>] ? trace_hardirqs_off+0xb/0x10
>  [<c022cb3a>] ext3_lookup+0x3a/0xd0
>  [<c01b7bb3>] ? d_alloc+0x133/0x190
>  [<c01ac110>] do_lookup+0x160/0x1b0
>  [<c01adc38>] __link_path_walk+0x208/0xdc0
>  [<c0159173>] ? lock_release_holdtime+0x83/0x120
>  [<c01bd97e>] ? mnt_want_write+0x4e/0xb0
>  [<c01ae327>] __link_path_walk+0x8f7/0xdc0
>  [<c015906b>] ? trace_hardirqs_off+0xb/0x10
>  [<c01ae844>] path_walk+0x54/0xb0
>  [<c01aea45>] do_path_lookup+0x85/0x230
>  [<c01af7a8>] __user_walk_fd+0x38/0x50
>  [<c01a7fb1>] vfs_stat_fd+0x21/0x50
>  [<c01590cd>] ? put_lock_stats+0xd/0x30
>  [<c01bc81d>] ? mntput_no_expire+0x1d/0x110
>  [<c01a8081>] vfs_stat+0x11/0x20
>  [<c01a80a4>] sys_stat64+0x14/0x30
>  [<c01a5a8f>] ? fput+0x1f/0x30
>  [<c0430948>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
>  [<c0430948>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c010407f>] sysenter_past_esp+0x78/0xc5
>  =======================

Ah, I tried echo l > /proc/sysrq-trigger and it gives this useful information:

SysRq : Show backtrace of all active CPUs
CPU1:
       f4ff3bd8 00000000 00000000 c1fadcc0 f4ff3c00 c0106a66 00000000 c083c0d8
       00200096 00000002 f4ff3c14 c0498ccb c08937c4 00000001 e589b050 f4ff3c38
       c0161f88 f4ff3c24 c1fadcc8 f4ff3c24 f4ff3c24 c0a1bd80 00010000 f3f81041
Call Trace:
 [<c0106a66>] ? show_stack+0x36/0x40
 [<c0498ccb>] ? showacpu+0x4b/0x60
 [<c0161f88>] ? generic_smp_call_function_single_interrupt+0x78/0xc0
 [<c0118620>] ? smp_call_function_single_interrupt+0x20/0x40
 [<c0104bf5>] ? call_function_single_interrupt+0x2d/0x34
 [<c022c02b>] ? ext3_find_entry+0x3eb/0x6f0
 [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
 [<c019d63c>] ? slab_pad_check+0x3c/0x120
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c022cb3a>] ? ext3_lookup+0x3a/0xd0

And the ext3_find_entry() corresponds to this line:

        for (; de < top; de = ext3_next_entry(de)) /* <--- HERE! */
        if (ext3_match (namelen, name, de)) {
                if (!ext3_check_dir_entry("ext3_find_entry",
                                          dir, de, bh,
                          (block<<EXT3_BLOCK_SIZE_BITS(sb))
                                  +((char *)de - bh->b_data))) {
                        brelse (bh);
                        *err = ERR_BAD_DX_DIR;
                        goto errout;
                }
                *res_dir = de;
                dx_release (frames);
                return bh;
        }

Is it possible that this loop can get stuck with a corrupt filesystem image?

A few more iterations of this gives that the task is ALWAYS
interrupted somewhere on line 994:

        for (; de < top; de = ext3_next_entry(de))

..but at slightly different EIPs. I find a bit odd as there are no
loops in ext3_next_entry(), and the for-loop itself isn't that tight
either. Any ideas?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
