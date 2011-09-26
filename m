From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [BUG] INFO: inconsistent lock state
Date: Mon, 26 Sep 2011 15:21:31 +0530
Message-ID: <4E804B23.7010204@linux.vnet.ibm.com>
References: <4E7859EC.4070904@linux.vnet.ibm.com> <1317026416.3536.23.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47599 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1IZJvj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Sep 2011 05:51:39 -0400
In-Reply-To: <1317026416.3536.23.camel@x61.thuisdomein>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/26/2011 02:10 PM, Paul Bolle wrote:
> On Tue, 2011-09-20 at 14:46 +0530, Srivatsa S. Bhat wrote:
>> While running kernel compilation along with suspend/resume
>> tests using the pm_test framework (at the processors level),
>> lockdep reports inconsistent lock state.
>> This is with Kernel 3.0.4.
> 
> Something very similar happened to be in the logs of a machine running
> v3.0.4 too. It happened a few days ago (but I missed it initially). I
> have no idea what triggered this:
> 
> kernel: [ 3501.569697] 
> kernel: [ 3501.569699] =================================
> kernel: [ 3501.569703] [ INFO: inconsistent lock state ]
> kernel: [ 3501.569706] 3.0.4-local0.fc14.x86_64 #1
> kernel: [ 3501.569708] ---------------------------------
> kernel: [ 3501.569711] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> kernel: [ 3501.569714] kswapd0/25 [HC0[0]:SC0[0]:HE1:SE1] takes:
> kernel: [ 3501.569717]  (&sb->s_type->i_mutex_key#13){+.+.?.}, at: [<ffffffff811b08eb>] ext4_evict_inode+0x41/0x255
> kernel: [ 3501.569728] {RECLAIM_FS-ON-W} state was registered at:
> kernel: [ 3501.569730]   [<ffffffff8108fcd1>] mark_held_locks+0x50/0x72
> kernel: [ 3501.569736]   [<ffffffff81090273>] lockdep_trace_alloc+0xa2/0xc6
> kernel: [ 3501.569740]   [<ffffffff811302da>] slab_pre_alloc_hook+0x1e/0x54
> kernel: [ 3501.569745]   [<ffffffff81132f3d>] kmem_cache_alloc+0x25/0x105
> kernel: [ 3501.569749]   [<ffffffff81155a26>] d_alloc+0x27/0x1b3
> kernel: [ 3501.569754]   [<ffffffff8114c785>] d_alloc_and_lookup+0x2c/0x6d
> kernel: [ 3501.569758]   [<ffffffff8114db93>] walk_component+0x1ea/0x3da
> kernel: [ 3501.569762]   [<ffffffff8114eda2>] link_path_walk+0x18a/0x477
> kernel: [ 3501.569766]   [<ffffffff8114f1a5>] path_lookupat+0x59/0x34b
> kernel: [ 3501.569770]   [<ffffffff8114f4c1>] do_path_lookup+0x2a/0x99
> kernel: [ 3501.569774]   [<ffffffff8114f8fb>] user_path_at+0x56/0x93
> kernel: [ 3501.569778]   [<ffffffff81147227>] vfs_fstatat+0x49/0x74
> kernel: [ 3501.569782]   [<ffffffff8114728d>] vfs_stat+0x1b/0x1d
> kernel: [ 3501.569786]   [<ffffffff811473a3>] sys_newstat+0x1f/0x39
> kernel: [ 3501.569790]   [<ffffffff814f62c2>] system_call_fastpath+0x16/0x1b
> kernel: [ 3501.569796] irq event stamp: 2656001
> kernel: [ 3501.569798] hardirqs last  enabled at (2656001): [<ffffffff814efa54>] restore_args+0x0/0x30
> kernel: [ 3501.569803] hardirqs last disabled at (2655999): [<ffffffff810632a8>] __do_softirq+0x15c/0x1ed
> kernel: [ 3501.569809] softirqs last  enabled at (2656000): [<ffffffff810632df>] __do_softirq+0x193/0x1ed
> kernel: [ 3501.569813] softirqs last disabled at (2654505): [<ffffffff814f755c>] call_softirq+0x1c/0x30
> kernel: [ 3501.569818] 
> kernel: [ 3501.569819] other info that might help us debug this:
> kernel: [ 3501.569821]  Possible unsafe locking scenario:
> kernel: [ 3501.569822] 
> kernel: [ 3501.569824]        CPU0
> kernel: [ 3501.569826]        ----
> kernel: [ 3501.569827]   lock(&sb->s_type->i_mutex_key);
> kernel: [ 3501.569831]   <Interrupt>
> kernel: [ 3501.569833]     lock(&sb->s_type->i_mutex_key);
> kernel: [ 3501.569836] 
> kernel: [ 3501.569837]  *** DEADLOCK ***
> kernel: [ 3501.569837] 
> kernel: [ 3501.569840] 2 locks held by kswapd0/25:
> kernel: [ 3501.569842]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff81101fc9>] shrink_slab+0x3d/0x189
> kernel: [ 3501.569850]  #1:  (iprune_sem){++++.-}, at: [<ffffffff81158be2>] shrink_icache_memory+0x50/0x288
> kernel: [ 3501.569857] 
> kernel: [ 3501.569858] stack backtrace:
> kernel: [ 3501.569861] Pid: 25, comm: kswapd0 Not tainted 3.0.4-local0.fc14.x86_64 #1
> kernel: [ 3501.569863] Call Trace:
> kernel: [ 3501.569868]  [<ffffffff8108e538>] valid_state+0x215/0x227
> kernel: [ 3501.569873]  [<ffffffff8108dd2e>] ? print_irq_inversion_bug+0x1c4/0x1c4
> kernel: [ 3501.569876]  [<ffffffff8108e62c>] mark_lock+0xe2/0x1d8
> kernel: [ 3501.569880]  [<ffffffff8108eafc>] __lock_acquire+0x3da/0xdd8
> kernel: [ 3501.569885]  [<ffffffff8108fcd1>] ? mark_held_locks+0x50/0x72
> kernel: [ 3501.569889]  [<ffffffff814efa54>] ? retint_restore_args+0x13/0x13
> kernel: [ 3501.569892]  [<ffffffff81158869>] ? evict+0x4f/0x127
> kernel: [ 3501.569896]  [<ffffffff8108fdfe>] ? trace_hardirqs_on_caller+0x10b/0x12f
> kernel: [ 3501.569900]  [<ffffffff811b08eb>] ? ext4_evict_inode+0x41/0x255
> kernel: [ 3501.569904]  [<ffffffff8108f9c6>] lock_acquire+0xb7/0xfb
> kernel: [ 3501.569908]  [<ffffffff811b08eb>] ? ext4_evict_inode+0x41/0x255
> kernel: [ 3501.569912]  [<ffffffff811b08eb>] ? ext4_evict_inode+0x41/0x255
> kernel: [ 3501.569916]  [<ffffffff814edb1f>] __mutex_lock_common+0x4c/0x361
> kernel: [ 3501.569920]  [<ffffffff811b08eb>] ? ext4_evict_inode+0x41/0x255
> kernel: [ 3501.569924]  [<ffffffff8108be8d>] ? trace_hardirqs_off+0xd/0xf
> kernel: [ 3501.569928]  [<ffffffff810802da>] ? local_clock+0x36/0x4d
> kernel: [ 3501.569932]  [<ffffffff8108c123>] ? lock_release_holdtime+0x54/0x5b
> kernel: [ 3501.569936]  [<ffffffff814edf43>] mutex_lock_nested+0x40/0x45
> kernel: [ 3501.569940]  [<ffffffff811b08eb>] ext4_evict_inode+0x41/0x255
> kernel: [ 3501.569944]  [<ffffffff81158899>] evict+0x7f/0x127
> kernel: [ 3501.569947]  [<ffffffff8115897f>] dispose_list+0x3e/0x50
> kernel: [ 3501.569951]  [<ffffffff81158dea>] shrink_icache_memory+0x258/0x288
> kernel: [ 3501.569955]  [<ffffffff81101fc9>] ? shrink_slab+0x3d/0x189
> kernel: [ 3501.569958]  [<ffffffff8110207e>] shrink_slab+0xf2/0x189
> kernel: [ 3501.569962]  [<ffffffff81104995>] balance_pgdat+0x2f7/0x5d3
> kernel: [ 3501.569967]  [<ffffffff81104f3f>] kswapd+0x2ce/0x314
> kernel: [ 3501.569971]  [<ffffffff8107a76a>] ? wake_up_bit+0x2a/0x2a
> kernel: [ 3501.569975]  [<ffffffff81104c71>] ? balance_pgdat+0x5d3/0x5d3
> kernel: [ 3501.569978]  [<ffffffff8107a25c>] kthread+0xa0/0xa8
> kernel: [ 3501.569983]  [<ffffffff8108fdfe>] ? trace_hardirqs_on_caller+0x10b/0x12f
> kernel: [ 3501.569987]  [<ffffffff814f7464>] kernel_thread_helper+0x4/0x10
> kernel: [ 3501.569991]  [<ffffffff814efa54>] ? retint_restore_args+0x13/0x13
> kernel: [ 3501.569995]  [<ffffffff8107a1bc>] ? __init_kthread_worker+0x5b/0x5b
> kernel: [ 3501.569999]  [<ffffffff814f7460>] ? gs_change+0x13/0x13

Hi Paul,
The issue that you and I encountered seems to have some similarity with the one
reported in http://www.spinics.net/lists/linux-ext4/msg27273.html

I am wondering if this warning is also a false positive like that in XFS.
I am CC'ing the linux-ext4 and linux-fsdevel mailing lists.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
