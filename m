From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Thu, 25 Aug 2011 06:49:31 GMT
Message-ID: <201108250649.p7P6nVo6004877@demeter1.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:35644 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1HYGtc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Aug 2011 02:49:32 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7P6nV5x004878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Aug 2011 06:49:31 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682


Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |penguin-kernel@I-love.SAKUR
                   |                            |A.ne.jp




--- Comment #3 from Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>  2011-08-25 06:49:29 ---
I got similar one. Is this known?
Mounting ext3 using CONFIG_EXT4_USE_FOR_EXT23=y .

[12693.651048]
[12693.651051] =================================
[12693.656823] [ INFO: inconsistent lock state ]
[12693.677329] 3.1.0-rc3-ccs #2
[12693.679755] ---------------------------------
[12693.683244] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[12693.688326] kswapd0/480 [HC0[0]:SC0[0]:HE1:SE1] takes:
[12693.719783]  (&sb->s_type->i_mutex_key#8){+.+.?.}, at: [<c112e21a>]
ext4_evict_inode+0x1a/0x390
[12693.731590] {RECLAIM_FS-ON-W} state was registered at:
[12693.762451]   [<c106fab2>] mark_held_locks+0x92/0xf0
[12693.768854]   [<c10700f8>] __lockdep_trace_alloc+0x48/0x80
[12693.775581]   [<c1070172>] lockdep_trace_alloc+0x42/0x60
[12693.782109]   [<c10cc4b7>] kmem_cache_alloc+0x27/0x110
[12693.812808]   [<c10e458e>] __d_alloc+0x1e/0x150
[12693.819798]   [<c10e46db>] d_alloc+0x1b/0x70
[12693.825203]   [<c10da750>] d_alloc_and_lookup+0x20/0x60
[12693.855996]   [<c10da94a>] do_lookup+0x16a/0x250
[12693.864001]   [<c10db5fc>] path_lookupat+0xac/0x5f0
[12693.870089]   [<c10dbb66>] do_path_lookup+0x26/0xc0
[12693.876151]   [<c10dbecc>] user_path_at+0x3c/0x80
[12693.906933]   [<c10ed550>] sys_pivot_root+0x60/0x230
[12693.913199]   [<c13d7e61>] syscall_call+0x7/0xb
[12693.919067] irq event stamp: 2056703
[12693.923434] hardirqs last  enabled at (2056703): [<c10a5fdc>]
free_hot_cold_page+0xdc/0x140
[12693.958561] hardirqs last disabled at (2056702): [<c10a5f6d>]
free_hot_cold_page+0x6d/0x140
[12693.968638] softirqs last  enabled at (2056670): [<c1044c61>]
__do_softirq+0xa1/0x130
[12694.003380] softirqs last disabled at (2056655): [<c1004ce5>]
call_on_stack+0x15/0x30
[12694.012930]
[12694.012933] other info that might help us debug this:
[12694.046175]  Possible unsafe locking scenario:
[12694.046181]
[12694.053930]        CPU0
[12694.057055]        ----
[12694.060178]   lock(&sb->s_type->i_mutex_key);
[12694.114766]   <Interrupt>
[12694.118110]     lock(&sb->s_type->i_mutex_key);
[12694.124029]
[12694.124031]  *** DEADLOCK ***
[12694.124033]
[12694.156906] 2 locks held by kswapd0/480:
[12694.162522]  #0:  (shrinker_rwsem){++++..}, at: [<c10ac5dc>]
shrink_slab+0x2c/0x1e0
[12694.172667]  #1:  (&type->s_umount_key#20){+++++.}, at: [<c10d279a>]
grab_super_passive+0x5a/0x80
[12694.208654]
[12694.208658] stack backtrace:
[12694.214322] Pid: 480, comm: kswapd0 Not tainted 3.1.0-rc3-ccs #2
[12694.246558] Call Trace:
[12694.249721]  [<c106f2fe>] print_usage_bug+0x16e/0x1b0
[12694.256060]  [<c106f9ca>] mark_lock_irq+0x1ea/0x240
[12694.261860]  [<c106f510>] ? print_irq_inversion_bug+0x1d0/0x1d0
[12694.293211]  [<c10705ac>] mark_lock+0x21c/0x3c0
[12694.298676]  [<c1070243>] mark_irqflags+0xb3/0x180
[12694.304386]  [<c107100d>] __lock_acquire+0x37d/0x8f0
[12694.310277]  [<c106ec27>] ? validate_chain+0x2a7/0x530
[12694.341481]  [<c10705ac>] ? mark_lock+0x21c/0x3c0
[12694.347577]  [<c10725da>] lock_acquire+0x7a/0xa0
[12694.353106]  [<c112e21a>] ? ext4_evict_inode+0x1a/0x390
[12694.359303]  [<c13d5965>] mutex_lock_nested+0x45/0x280
[12694.390984]  [<c112e21a>] ? ext4_evict_inode+0x1a/0x390
[12694.397262]  [<c112e21a>] ? ext4_evict_inode+0x1a/0x390
[12694.403439]  [<c10722d7>] ? __lock_release+0x47/0x70
[12694.433772]  [<c112e21a>] ext4_evict_inode+0x1a/0x390
[12694.466113]  [<c10e746f>] evict+0x11f/0x180
[12694.471237]  [<c10e74fc>] dispose_list+0x2c/0x40
[12694.476780]  [<c10e77ee>] prune_icache_sb+0xce/0x240
[12694.482694]  [<c10d223f>] prune_super+0xaf/0x130
[12694.513169]  [<c10ac712>] shrink_slab+0x162/0x1e0
[12694.518857]  [<c10ae3e8>] ? shrink_zone+0xf8/0x140
[12694.524569]  [<c10aed47>] balance_pgdat+0x3d7/0x440
[12694.530376]  [<c106fc50>] ? trace_hardirqs_on_caller+0x90/0x100
[12694.562185]  [<c10aef8e>] kswapd+0xbe/0x160
[12694.567365]  [<c105a3a5>] kthread+0x75/0x80
[12694.572419]  [<c10aeed0>] ? kswapd_try_to_sleep+0x120/0x120
[12694.604239]  [<c105a330>] ? kthread_data+0x20/0x20
[12694.610065]  [<c13d8b5a>] kernel_thread_helper+0x6/0xd

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
