From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Mon, 29 Aug 2011 02:59:19 GMT
Message-ID: <201108290259.p7T2xJq0025517@demeter1.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48262 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1H2C7U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Aug 2011 22:59:20 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7T2xJKs025518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Aug 2011 02:59:19 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682


Shaun Ruffell <sruffell@sruffell.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sruffell@sruffell.net




--- Comment #7 from Shaun Ruffell <sruffell@sruffell.net>  2011-08-29 02:59:11 ---
It looks like this is already being worked, but I thought I would add my
backtrace, which looks nearly identical to the one from Tetsuo Handa on
2011-08-25 06:49:29.

[ 3188.604654] =================================
[ 3188.610014] [ INFO: inconsistent lock state ]
[ 3188.610014] 3.1.0-rc3.sruffelldbg #13
[ 3188.610014] ---------------------------------
[ 3188.610014] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 3188.610014] kswapd0/26 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 3188.610014]  (&sb->s_type->i_mutex_key#11){+.+.?.}, at: [<ffffffff81224a84>]
ext4_evict_inode+0x34/0x4a0
[ 3188.610014] {RECLAIM_FS-ON-W} state was registered at:
[ 3188.610014]   [<ffffffff810a2fb7>] mark_held_locks+0xb7/0x150
[ 3188.610014]   [<ffffffff810a30ef>] lockdep_trace_alloc+0x9f/0xd0
[ 3188.610014]   [<ffffffff8116427a>] kmem_cache_alloc+0x3a/0x160
[ 3188.610014]   [<ffffffff8118d7f7>] __d_alloc+0x37/0x1a0
[ 3188.610014]   [<ffffffff8118d9f8>] d_alloc+0x28/0x80
[ 3188.610014]   [<ffffffff811801bd>] d_alloc_and_lookup+0x2d/0x90
[ 3188.610014]   [<ffffffff81180773>] do_lookup+0x263/0x380
[ 3188.610014]   [<ffffffff811825ac>] path_lookupat+0x12c/0x7a0
[ 3188.690010]   [<ffffffff81182c51>] do_path_lookup+0x31/0xc0
[ 3188.690010]   [<ffffffff81182d7a>] kern_path+0x2a/0x50
[ 3188.690010]   [<ffffffff81196ed7>] do_mount+0xa7/0x240
[ 3188.690010]   [<ffffffff81197100>] sys_mount+0x90/0xe0
[ 3188.690010]   [<ffffffff815ff442>] system_call_fastpath+0x16/0x1b
[ 3188.690010] irq event stamp: 1383041
[ 3188.690010] hardirqs last  enabled at (1383041): [<ffffffff810e2b51>]
__call_rcu+0x101/0x1e0
[ 3188.690010] hardirqs last disabled at (1383040): [<ffffffff810e2acc>]
__call_rcu+0x7c/0x1e0
[ 3188.690010] softirqs last  enabled at (1380030): [<ffffffff8106d1a6>]
__do_softirq+0x146/0x230
[ 3188.690010] softirqs last disabled at (1380015): [<ffffffff8160173c>]
call_softirq+0x1c/0x30
[ 3188.690010]
[ 3188.690010] other info that might help us debug this:
[ 3188.690010]  Possible unsafe locking scenario:
[ 3188.690010]
[ 3188.690010]        CPU0
[ 3188.690010]        ----
[ 3188.690010]   lock(&sb->s_type->i_mutex_key);
[ 3188.690010]   <Interrupt>
[ 3188.690010]     lock(&sb->s_type->i_mutex_key);
[ 3188.690010]
[ 3188.690010]  *** DEADLOCK ***
[ 3188.690010]
[ 3188.690010] 2 locks held by kswapd0/26:
[ 3188.690010]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8112da8c>]
shrink_slab+0x3c/0x2f0
[ 3188.690010]  #1:  (&type->s_umount_key#22){+++++.}, at: [<ffffffff81177b94>]
grab_super_passive+0x54/0xa0
[ 3188.690010]
[ 3188.690010] stack backtrace:
[ 3188.690010] Pid: 26, comm: kswapd0 Not tainted 3.1.0-rc3.sruffelldbg #13
[ 3188.690010] Call Trace:
[ 3188.690010]  [<ffffffff815f6797>] ? _raw_spin_unlock_irqrestore+0x67/0x70
[ 3188.690010]  [<ffffffff810a2630>] print_usage_bug+0x1a0/0x1f0
[ 3188.690010]  [<ffffffff810a39b0>] ? print_irq_inversion_bug+0x220/0x220
[ 3188.690010]  [<ffffffff810a2797>] mark_lock_irq+0x117/0x2d0
[ 3188.690010]  [<ffffffff810a2add>] mark_lock+0x18d/0x410
[ 3188.690010]  [<ffffffff8109248f>] ? local_clock+0x6f/0x80
[ 3188.690010]  [<ffffffff810a2e16>] mark_irqflags+0xb6/0x1a0
[ 3188.690010]  [<ffffffff810a65ec>] __lock_acquire+0x20c/0x930
[ 3188.690010]  [<ffffffff810a73e4>] lock_acquire+0xa4/0x130
[ 3188.690010]  [<ffffffff81224a84>] ? ext4_evict_inode+0x34/0x4a0
[ 3188.690010]  [<ffffffff8109248f>] ? local_clock+0x6f/0x80
[ 3188.690010]  [<ffffffff815f4637>] mutex_lock_nested+0x57/0x340
[ 3188.690010]  [<ffffffff81224a84>] ? ext4_evict_inode+0x34/0x4a0
[ 3188.690010]  [<ffffffff810a08a5>] ? lock_release_holdtime+0x35/0x180
[ 3188.690010]  [<ffffffff81224a84>] ? ext4_evict_inode+0x34/0x4a0
[ 3188.690010]  [<ffffffff81190001>] ? evict+0x91/0x1a0
[ 3188.690010]  [<ffffffff81224a84>] ext4_evict_inode+0x34/0x4a0
[ 3188.690010]  [<ffffffff8119000f>] evict+0x9f/0x1a0
[ 3188.690010]  [<ffffffff811906c7>] dispose_list+0x47/0x60
[ 3188.690010]  [<ffffffff81190832>] prune_icache_sb+0x152/0x320
[ 3188.690010]  [<ffffffff81177d2b>] prune_super+0x14b/0x1a0
[ 3188.690010]  [<ffffffff8112dbe4>] shrink_slab+0x194/0x2f0
[ 3188.690010]  [<ffffffff8112d6d5>] ? shrink_zone+0x175/0x270
[ 3188.690010]  [<ffffffff815f67cb>] ? _raw_spin_unlock+0x2b/0x40
[ 3188.690010]  [<ffffffff8112e896>] balance_pgdat+0x736/0x940
[ 3188.690010]  [<ffffffff8112eaa0>] ? balance_pgdat+0x940/0x940
[ 3188.690010]  [<ffffffff8112eba9>] kswapd+0x109/0x220
[ 3188.690010]  [<ffffffff8112eaa0>] ? balance_pgdat+0x940/0x940
[ 3188.690010]  [<ffffffff8108ab66>] kthread+0xb6/0xc0
[ 3188.690010]  [<ffffffff810a3335>] ? trace_hardirqs_on_caller+0x125/0x1b0
[ 3188.690010]  [<ffffffff81601644>] kernel_thread_helper+0x4/0x10
[ 3188.690010]  [<ffffffff815f6a34>] ? retint_restore_args+0x13/0x13
[ 3188.690010]  [<ffffffff8108aab0>] ? __init_kthread_worker+0x70/0x70
[ 3188.690010]  [<ffffffff81601640>] ? gs_change+0x13/0x13

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
