From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 36202] New: sleeping function called from
 invalid context
Date: Mon, 6 Jun 2011 14:31:13 -0700
Message-ID: <20110606143113.165bae7c.akpm@linux-foundation.org>
References: <bug-36202-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, jwrdegoede@fedoraproject.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab1FFVcB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 17:32:01 -0400
In-Reply-To: <bug-36202-10286@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon, 30 May 2011 08:07:36 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> 
> https://bugzilla.kernel.org/show_bug.cgi?id=36202
> 
>            Summary: sleeping function called from invalid context
>            Product: Memory Management
>            Version: 2.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: akpm@linux-foundation.org
>         ReportedBy: jwrdegoede@fedoraproject.org
>         Regression: No
> 
> 
> Lately I've got several backtraces related to "sleeping function called from
> invalid context", this happens with both fedora provided kernels, both:
> 2.6.39-0.rc7.git6.1.fc16.x86_64 and 2.6.39-1.fc16.x86_64. I'll copy paste one
> backtrace per comment here to keep the begin / start of each trace clearly
> separated. First a bunch of backtraces from 2.6.39-0.rc7.git6.1.fc16.x86_64,
> starting with:

Every oops trace in that bugzilla report has been wordwrapped, which
makes them fantastically hard to read.  Please use attachments in bugzilla.

I fixed up the first one.  I think it's fingering ext4, calling into
the BIO layer with IRQs disabled.


May 23 11:24:47 shalem kernel: [ 4156.296806] BUG: sleeping function called from invalid context at kernel/cpuset.c:2352
May 23 11:24:47 shalem kernel: [ 4156.296812] in_atomic(): 0, irqs_disabled(): 1, pid: 1007, name: flush-8:16
May 23 11:24:47 shalem kernel: [ 4156.296815] Pid: 1007, comm: flush-8:16 Not tainted 2.6.39-0.rc7.git6.1.fc16.x86_64 #1
May 23 11:24:47 shalem kernel: [ 4156.296817] Call Trace:
May 23 11:24:47 shalem kernel: [ 4156.296833]  [<ffffffff81046920>] __might_sleep+0xeb/0xf0
May 23 11:24:47 shalem kernel: [ 4156.296839]  [<ffffffff81096752>] __cpuset_node_allowed_softwall+0x5e/0x122
May 23 11:24:47 shalem kernel: [ 4156.296843]  [<ffffffff810dc778>] get_page_from_freelist+0x144/0x64e
May 23 11:24:47 shalem kernel: [ 4156.296846]  [<ffffffff810dc9e6>] ? get_page_from_freelist+0x3b2/0x64e
May 23 11:24:47 shalem kernel: [ 4156.296848]  [<ffffffff810dcfdc>] __alloc_pages_nodemask+0x35a/0x7ef
May 23 11:24:47 shalem kernel: [ 4156.296855]  [<ffffffff8110725a>] alloc_pages_current+0xbe/0xd8
May 23 11:24:47 shalem kernel: [ 4156.296859]  [<ffffffff8110e587>] alloc_slab_page+0x1c/0x4d
May 23 11:24:47 shalem kernel: [ 4156.296861]  [<ffffffff8110fc31>] new_slab+0x4f/0x197
May 23 11:24:47 shalem kernel: [ 4156.296867]  [<ffffffff81475be6>] __slab_alloc+0x269/0x350
May 23 11:24:47 shalem kernel: [ 4156.296872]  [<ffffffff810d8365>] ? mempool_alloc_slab+0x15/0x17
May 23 11:24:47 shalem kernel: [ 4156.296874]  [<ffffffff810d8365>] ? mempool_alloc_slab+0x15/0x17
May 23 11:24:47 shalem kernel: [ 4156.296876]  [<ffffffff81110442>] kmem_cache_alloc+0x6e/0x10a
May 23 11:24:47 shalem kernel: [ 4156.296879]  [<ffffffff810d8365>] mempool_alloc_slab+0x15/0x17
May 23 11:24:47 shalem kernel: [ 4156.296881]  [<ffffffff810d85da>] mempool_alloc+0x68/0x116
May 23 11:24:47 shalem kernel: [ 4156.296885]  [<ffffffff812fb125>] ? scsi_pool_alloc_command+0x43/0x68
May 23 11:24:47 shalem kernel: [ 4156.296888]  [<ffffffff81301f11>] scsi_sg_alloc+0x2d/0x2f
May 23 11:24:47 shalem kernel: [ 4156.296893]  [<ffffffff81237b7f>] __sg_alloc_table+0x63/0x11c
May 23 11:24:47 shalem kernel: [ 4156.296895]  [<ffffffff81301ee4>] ? scsi_sg_free+0x2f/0x2f
May 23 11:24:47 shalem kernel: [ 4156.296897]  [<ffffffff81301f3d>] scsi_alloc_sgtable+0x2a/0x4f
May 23 11:24:47 shalem kernel: [ 4156.296899]  [<ffffffff81301f83>] scsi_init_sgtable+0x21/0x61
May 23 11:24:47 shalem kernel: [ 4156.296901]  [<ffffffff81301ff5>] scsi_init_io+0x32/0x13b
May 23 11:24:47 shalem kernel: [ 4156.296904]  [<ffffffff81302204>] scsi_setup_fs_cmnd+0x87/0x8c
May 23 11:24:47 shalem kernel: [ 4156.296908]  [<ffffffff8130acac>] sd_prep_fn+0x301/0xbf3
May 23 11:24:47 shalem kernel: [ 4156.296915]  [<ffffffff812285be>] ? cfq_dispatch_requests+0x753/0x8c2
May 23 11:24:47 shalem kernel: [ 4156.296918]  [<ffffffff8121a0f9>] blk_peek_request+0xdb/0x17b
May 23 11:24:47 shalem kernel: [ 4156.296920]  [<ffffffff81301af3>] scsi_request_fn+0x7d/0x409
May 23 11:24:47 shalem kernel: [ 4156.296925]  [<ffffffff81214e1b>] __blk_run_queue+0x1b/0x1d
May 23 11:24:47 shalem kernel: [ 4156.296927]  [<ffffffff8121a532>] __make_request+0x29b/0x2b8
May 23 11:24:47 shalem kernel: [ 4156.296930]  [<ffffffff81219118>] generic_make_request+0x2a9/0x323
May 23 11:24:47 shalem kernel: [ 4156.296935]  [<ffffffff811471bc>] ? bvec_alloc_bs+0xae/0xcc
May 23 11:24:47 shalem kernel: [ 4156.296938]  [<ffffffff81110442>] ? kmem_cache_alloc+0x6e/0x10a
May 23 11:24:47 shalem kernel: [ 4156.296940]  [<ffffffff81219270>] submit_bio+0xde/0xfd
May 23 11:24:47 shalem kernel: [ 4156.296944]  [<ffffffff810eb5b1>] ? inc_zone_page_state+0x27/0x29
May 23 11:24:47 shalem kernel: [ 4156.296947]  [<ffffffff810dd6c1>] ? account_page_writeback+0x25/0x29
May 23 11:24:47 shalem kernel: [ 4156.296950]  [<ffffffff81230038>] ? radix_tree_gang_lookup_slot+0x66/0x87
May 23 11:24:47 shalem kernel: [ 4156.296953]  [<ffffffff8119b1d8>] ext4_io_submit+0x2c/0x58
May 23 11:24:47 shalem kernel: [ 4156.296955]  [<ffffffff8119b380>] ext4_bio_write_page+0x17c/0x320
May 23 11:24:47 shalem kernel: [ 4156.296958]  [<ffffffff81196432>] mpage_da_submit_io+0x306/0x389
May 23 11:24:47 shalem kernel: [ 4156.296961]  [<ffffffff81199e44>] mpage_da_map_and_submit+0x2b7/0x2cd
May 23 11:24:47 shalem kernel: [ 4156.296963]  [<ffffffff81199f28>] mpage_add_bh_to_extent+0xce/0xdd
May 23 11:24:47 shalem kernel: [ 4156.296965]  [<ffffffff8103fdbb>] ? should_resched+0xe/0x2d
May 23 11:24:47 shalem kernel: [ 4156.296967]  [<ffffffff8119a177>] write_cache_pages_da+0x240/0x325
May 23 11:24:47 shalem kernel: [ 4156.296969]  [<ffffffff8119a502>] ext4_da_writepages+0x2a6/0x44d
May 23 11:24:47 shalem kernel: [ 4156.296972]  [<ffffffff810de978>] do_writepages+0x21/0x2a
May 23 11:24:47 shalem kernel: [ 4156.296976]  [<ffffffff8113ddff>] writeback_single_inode+0xb2/0x1bc
May 23 11:24:47 shalem kernel: [ 4156.296978]  [<ffffffff8113e14b>] writeback_sb_inodes+0xcd/0x161
May 23 11:24:47 shalem kernel: [ 4156.296980]  [<ffffffff8113e64f>] writeback_inodes_wb+0x119/0x12b
May 23 11:24:47 shalem kernel: [ 4156.296982]  [<ffffffff8113e84f>] wb_writeback+0x1ee/0x335
May 23 11:24:47 shalem kernel: [ 4156.296985]  [<ffffffff81080d17>] ? arch_local_irq_save+0x15/0x1b
May 23 11:24:47 shalem kernel: [ 4156.296989]  [<ffffffff8147beb2>] ? _raw_spin_lock_irqsave+0x12/0x2f
May 23 11:24:47 shalem kernel: [ 4156.296991]  [<ffffffff8113ea1c>] wb_do_writeback+0x86/0x19d
May 23 11:24:47 shalem kernel: [ 4156.296995]  [<ffffffff81060268>] ? del_timer+0x7a/0x7a
May 23 11:24:47 shalem kernel: [ 4156.296998]  [<ffffffff8113ebbb>] bdi_writeback_thread+0x88/0x1e5
May 23 11:24:47 shalem kernel: [ 4156.297000]  [<ffffffff8113eb33>] ? wb_do_writeback+0x19d/0x19d
May 23 11:24:47 shalem kernel: [ 4156.297004]  [<ffffffff8106e287>] kthread+0x84/0x8c
May 23 11:24:47 shalem kernel: [ 4156.297008]  [<ffffffff814837a4>] kernel_thread_helper+0x4/0x10
May 23 11:24:47 shalem kernel: [ 4156.297010]  [<ffffffff8106e203>] ? kthread_worker_fn+0x148/0x148
May 23 11:24:47 shalem kernel: [ 4156.297012]  [<ffffffff814837a0>] ? gs_change+0x13/0x13

