From: Jan Kara <jack@suse.cz>
Subject: Re: lockdep detects possible deadlock scenario
Date: Thu, 20 Jul 2017 14:16:07 +0200
Message-ID: <20170720121607.GA27103@quack2.suse.cz>
References: <CAKQB+fvfDeqZnLq--aybS9+TmkhgnxOPTjKua6_VWaf3u+ygfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        jack@suse.com
To: Jerry Lee <leisurelysw24@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34613 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933904AbdGTMQK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Jul 2017 08:16:10 -0400
Content-Disposition: inline
In-Reply-To: <CAKQB+fvfDeqZnLq--aybS9+TmkhgnxOPTjKua6_VWaf3u+ygfw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

On Thu 20-07-17 19:29:28, Jerry Lee wrote:
> I hit the following lockdep trace on linux-4.2.8 and I could steadily
> re-produce it on some of my machine.  Although the trace shows up, the
> file system works quite well without seeing any operations being stuck
> on it.  Does it mean that the trace is just a false alarm?  Thanks.
> 
> BTW, I've saw some similar traces previously in the mailing list and
> found that the patch, "ext4: add lockdep annotations for i_data_sem
> (daf647d2dd58)", which is already included in my kernel.

I don't think that patch is included in the kernel reporting this trace - 
from the trace ei->i_data_sem obtained on quota file (the first stack
trace) did not use the special I_DATA_SEM_QUOTA locking class which commit
daf647d2dd58 introduced and it should have... In either case this report
is a false positive.

								Honza

> 
> ======================================================
> <4>[  205.633705] [ INFO: possible circular locking dependency detected ]
> <4>[  205.639962] 4.2.8 #3 Tainted: G        W  O
> <4>[  205.644395] -------------------------------------------------------
> <4>[  205.650650] rm/19302 is trying to acquire lock:
> <4>[  205.655174]  (&s->s_dquot.dqio_mutex){+.+...}, at:
> [<ffffffff81250678>] dquot_commit+0x28/0xc0
> <4>[  205.663835]
> <4>[  205.663835] but task is already holding lock:
> <4>[  205.669659]  (&ei->i_data_sem){++++..}, at: [<ffffffff812b2329>]
> ext4_truncate+0x379/0x680
> <4>[  205.677960]
> <4>[  205.677960] which lock already depends on the new lock.
> <4>[  205.677960]
> <4>[  205.686119]
> <4>[  205.686119] the existing dependency chain (in reverse order) is:
> <4>[  205.693586]
> <4>[  205.693586] -> #1 (&ei->i_data_sem){++++..}:
> <4>[  205.698071]        [<ffffffff810cde05>] lock_acquire+0xd5/0x280
> <4>[  205.703995]        [<ffffffff81c82727>] down_read+0x47/0x60
> <4>[  205.709573]        [<ffffffff812acefb>] ext4_map_blocks+0x48b/0x5f0
> <4>[  205.715845]        [<ffffffff812ad653>] ext4_getblk+0x43/0x190
> <4>[  205.721682]        [<ffffffff812ad7ae>] ext4_bread+0xe/0xa0
> <4>[  205.727260]        [<ffffffff812c225d>] ext4_quota_read+0xcd/0x110
> <4>[  205.733442]        [<ffffffff81254687>] read_blk+0x47/0x50
> <4>[  205.738933]        [<ffffffff81255452>] find_tree_dqentry+0x42/0x230
> <4>[  205.745290]        [<ffffffff812555b4>] find_tree_dqentry+0x1a4/0x230
> <4>[  205.751730]        [<ffffffff812555b4>] find_tree_dqentry+0x1a4/0x230
> <4>[  205.758172]        [<ffffffff812555b4>] find_tree_dqentry+0x1a4/0x230
> <4>[  205.764612]        [<ffffffff81255773>] qtree_read_dquot+0x133/0x260
> <4>[  205.770968]        [<ffffffff81253d89>] v2_read_dquot+0x29/0x30
> <4>[  205.776892]        [<ffffffff8124f7f6>] dquot_acquire+0xe6/0x130
> <4>[  205.782902]        [<ffffffff812c1c9a>] ext4_acquire_dquot+0x6a/0xb0
> <4>[  205.789258]        [<ffffffff81251970>] dqget+0x3c0/0x420
> <4>[  205.794662]        [<ffffffff81251afd>] __dquot_initialize+0x12d/0x230
> <4>[  205.801187]        [<ffffffff81251c0e>] dquot_initialize+0xe/0x10
> <4>[  205.807283]        [<ffffffff812d215b>] ext4_fill_super+0x2d9b/0x3150
> <4>[  205.813729]        [<ffffffff811e0f00>] mount_bdev+0x180/0x1b0
> <4>[  205.819566]        [<ffffffff812c18c0>] ext4_mount+0x10/0x20
> <4>[  205.825230]        [<ffffffff811e17a4>] mount_fs+0x14/0xa0
> <4>[  205.830719]        [<ffffffff81203736>] vfs_kern_mount+0x66/0x150
> <4>[  205.836815]        [<ffffffff812066a5>] do_mount+0x1e5/0xd00
> <4>[  205.842476]        [<ffffffff812074b6>] SyS_mount+0x86/0xc0
> <4>[  205.848048]        [<ffffffff81c84bd7>]
> entry_SYSCALL_64_fastpath+0x12/0x6f
> <4>[  205.855010]
> <4>[  205.855010] -> #0 (&s->s_dquot.dqio_mutex){+.+...}:
> <4>[  205.860103]        [<ffffffff810ccccc>] __lock_acquire+0x1fdc/0x23a0
> <4>[  205.866464]        [<ffffffff810cde05>] lock_acquire+0xd5/0x280
> <4>[  205.872393]        [<ffffffff81c80990>] mutex_lock_nested+0x60/0x370
> <4>[  205.878753]        [<ffffffff81250678>] dquot_commit+0x28/0xc0
> <4>[  205.884594]        [<ffffffff812c1d4e>] ext4_write_dquot+0x6e/0xa0
> <4>[  205.890783]        [<ffffffff812c1dbe>] ext4_mark_dquot_dirty+0x3e/0x60
> <4>[  205.897408]        [<ffffffff81250857>] __dquot_free_space+0x147/0x310
> <4>[  205.903943]        [<ffffffff812ebe0d>] ext4_free_blocks+0x77d/0x1010
> <4>[  205.910390]        [<ffffffff812dbb66>] ext4_ext_remove_space+0x8f6/0x16a0
> <4>[  205.917271]        [<ffffffff812de49f>] ext4_ext_truncate+0xaf/0xe0
> <4>[  205.923547]        [<ffffffff812b23f0>] ext4_truncate+0x440/0x680
> <4>[  205.929651]        [<ffffffff812b2a9f>] ext4_evict_inode+0x46f/0x730
> <4>[  205.936017]        [<ffffffff811fe473>] evict+0xb3/0x180
> <4>[  205.941337]        [<ffffffff811fecc7>] iput+0x187/0x350
> <4>[  205.946662]        [<ffffffff811f0243>] do_unlinkat+0x163/0x340
> <4>[  205.952588]        [<ffffffff811f0481>] SyS_unlink+0x11/0x20
> <4>[  205.958258]        [<ffffffff81c84bd7>]
> entry_SYSCALL_64_fastpath+0x12/0x6f
> <4>[  205.965226]
> <4>[  205.965226] other info that might help us debug this:
> <4>[  205.965226]
> <4>[  205.973217]  Possible unsafe locking scenario:
> <4>[  205.973217]
> <4>[  205.979127]        CPU0                    CPU1
> <4>[  205.983652]        ----                    ----
> <4>[  205.988174]   lock(&ei->i_data_sem);
> <4>[  205.991772]                                lock(&s->s_dquot.dqio_mutex);
> <4>[  205.998487]                                lock(&ei->i_data_sem);
> <4>[  206.004596]   lock(&s->s_dquot.dqio_mutex);
> <4>[  206.008795]
> <4>[  206.008795]  *** DEADLOCK ***
> <4>[  206.008795]
> <4>[  206.014708] 5 locks held by rm/19302:
> <4>[  206.018364]  #0:  (sb_writers#10){.+.+.+}, at:
> [<ffffffff81204bbf>] mnt_want_write+0x1f/0x50
> <4>[  206.026870]  #1:  (sb_internal){.+.+..}, at:
> [<ffffffff812b27a9>] ext4_evict_inode+0x179/0x730
> <4>[  206.035538]  #2:  (jbd2_handle){+.+...}, at:
> [<ffffffff81306cc1>] start_this_handle+0x191/0x630
> <4>[  206.044298]  #3:  (&ei->i_data_sem){++++..}, at:
> [<ffffffff812b2329>] ext4_truncate+0x379/0x680
> <4>[  206.053052]  #4:  (dquot_srcu){......}, at: [<ffffffff8125076a>]
> __dquot_free_space+0x5a/0x310
> <4>[  206.061719]
> <4>[  206.061719] stack backtrace:
> <4>[  206.066072] CPU: 0 PID: 19302 Comm: rm Tainted: G        W  O    4.2.8 #3
> <4>[  206.072848] Hardware name: To be filled by O.E.M. To be filled
> by O.E.M./MAHOBAY, BIOS QC30AR23 08/14/2014
> <4>[  206.082486]  ffffffff82effc40 ffff88004cebf7d8 ffffffff81c767eb
> 0000000000000007
> <4>[  206.089919]  ffffffff82effc40 ffff88004cebf828 ffffffff81c739cd
> ffff880044724e08
> <4>[  206.097364]  ffff88004cebf898 ffff88004cebf828 0000000000000005
> ffff880044724640
> <4>[  206.104807] Call Trace:
> <4>[  206.107257]  [<ffffffff81c767eb>] dump_stack+0x4c/0x65
> <4>[  206.112393]  [<ffffffff81c739cd>] print_circular_bug+0x202/0x213
> <4>[  206.118394]  [<ffffffff810ccccc>] __lock_acquire+0x1fdc/0x23a0
> <4>[  206.124222]  [<ffffffff810cde05>] lock_acquire+0xd5/0x280
> <4>[  206.129616]  [<ffffffff81250678>] ? dquot_commit+0x28/0xc0
> <4>[  206.135099]  [<ffffffff81c80990>] mutex_lock_nested+0x60/0x370
> <4>[  206.140931]  [<ffffffff81250678>] ? dquot_commit+0x28/0xc0
> <4>[  206.146414]  [<ffffffff812c1d3a>] ? ext4_write_dquot+0x5a/0xa0
> <4>[  206.152245]  [<ffffffff8130784a>] ? jbd2__journal_start+0x1a/0x20
> <4>[  206.158766]  [<ffffffff81250678>] dquot_commit+0x28/0xc0
> <4>[  206.164074]  [<ffffffff812c1d4e>] ext4_write_dquot+0x6e/0xa0
> <4>[  206.169731]  [<ffffffff812c1dbe>] ext4_mark_dquot_dirty+0x3e/0x60
> <4>[  206.175821]  [<ffffffff81250857>] __dquot_free_space+0x147/0x310
> <4>[  206.181825]  [<ffffffff8125076a>] ? __dquot_free_space+0x5a/0x310
> <4>[  206.187917]  [<ffffffff812ebc62>] ? ext4_free_blocks+0x5d2/0x1010
> <4>[  206.194005]  [<ffffffff812ebe0d>] ext4_free_blocks+0x77d/0x1010
> <4>[  206.199920]  [<ffffffff810ca7e1>] ? mark_held_locks+0x71/0x90
> <4>[  206.205662]  [<ffffffff811cadc6>] ? __kmalloc+0xa6/0x5d0
> <4>[  206.210972]  [<ffffffff810c8f4d>] ? __lock_is_held+0x4d/0x70
> <4>[  206.216627]  [<ffffffff812db2ca>] ? ext4_ext_remove_space+0x5a/0x16a0
> <4>[  206.223061]  [<ffffffff812dbb66>] ext4_ext_remove_space+0x8f6/0x16a0
> <4>[  206.229412]  [<ffffffff812de49f>] ext4_ext_truncate+0xaf/0xe0
> <4>[  206.235157]  [<ffffffff812b23f0>] ext4_truncate+0x440/0x680
> <4>[  206.240723]  [<ffffffff812b2a9f>] ext4_evict_inode+0x46f/0x730
> <4>[  206.246551]  [<ffffffff811fe473>] evict+0xb3/0x180
> <4>[  206.251339]  [<ffffffff811fecc7>] iput+0x187/0x350
> <4>[  206.256129]  [<ffffffff811f0243>] do_unlinkat+0x163/0x340
> <4>[  206.261525]  [<ffffffff812041c0>] ? mnt_get_count+0x60/0x60
> <4>[  206.267092]  [<ffffffff81002044>] ? lockdep_sys_exit_thunk+0x12/0x14
> <4>[  206.273441]  [<ffffffff811f0481>] SyS_unlink+0x11/0x20
> <4>[  206.278578]  [<ffffffff81c84bd7>] entry_SYSCALL_64_fastpath+0x12/0x6f
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
