From: Roland Dreier <roland@digitalvampire.org>
Subject: ext4 lockdep report re possible reclaim deadlock on jbd2_handle
Date: Sat, 04 Jul 2009 14:49:06 -0700
Message-ID: <87prcgp19p.fsf@shaolin.home.digitalvampire.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:37369 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbZGDVtU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Jul 2009 17:49:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I recently got the following lockdep warning on my laptop.  The kernel
is Ubuntu's tree with Linus's git up to d960eea9 pulled it; I don't
think there are any non-mainline ext4 changes involved, and the
warning below does look valid on mainline.

As far as I can tell, lockdep is warning that jbd2_handle is usually
acquired while doing reclaim -- which makes sense, as pushing dirty
inodes out of memory is of course going to want to do fs transactions;
but also there is the code path:

	ext4_ext_truncate():
		...
		handle = ext4_journal_start(inode, err);
		...
		ext4_block_truncate_page(handle, mapping, inode->i_size);
		...

where we have

	ext4_block_truncate_page():
		...
		page = grab_cache_page(mapping, from >> PAGE_CACHE_SHIFT);

and grab_cache_page() expands as:

	static inline struct page *grab_cache_page(struct address_space	*mapping,
									pgoff_t index)
	{
		return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
	}

and if find_or_create_page() doesn't find the page, it just does:

	page = __page_cache_alloc(gfp_mask);

Now, I'm not much of a VM or FS expert, but I see no reason why
find_or_create_page() would never have to create a page in the ext4
usage, and I don't see any reason mapping_gfp_mask() would never
include __GFP_FS; so it seems that lockdep is correct that this
codepath could then trigger reclaim and deadlock by calling back into
ext4 and trying to start another transaction.  (And indeed the my
system did hit the page allocate path, although perhaps that is a bug
somewhere else)

It does seem a little odd to me that no one else has seen this,
since I thought quite a few people tested with lockdep enabled.  So
maybe something is odd about my system or kernel config.  Anyway, I'm
happy to try further tests and/or debugging patches.

Full lockdep output is below.

Thanks,
  Roland

[20786.363249] =================================
[20786.363257] [ INFO: inconsistent lock state ]
[20786.363265] 2.6.31-2-generic #14~rbd4gitd960eea9
[20786.363270] ---------------------------------
[20786.363276] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[20786.363285] http/8397 [HC0[0]:SC0[0]:HE1:SE1] takes:
[20786.363291]  (jbd2_handle){+.+.?.}, at: [<ffffffff812008bb>] jbd2_journal_start+0xdb/0x150
[20786.363314] {IN-RECLAIM_FS-W} state was registered at:
[20786.363320]   [<ffffffff8108bef6>] mark_irqflags+0xc6/0x1a0
[20786.363334]   [<ffffffff8108d347>] __lock_acquire+0x287/0x430
[20786.363345]   [<ffffffff8108d595>] lock_acquire+0xa5/0x150
[20786.363355]   [<ffffffff812008da>] jbd2_journal_start+0xfa/0x150
[20786.363365]   [<ffffffff811d98a8>] ext4_journal_start_sb+0x58/0x90
[20786.363377]   [<ffffffff811cce85>] ext4_delete_inode+0xc5/0x2c0
[20786.363389]   [<ffffffff81146fa3>] generic_delete_inode+0xd3/0x1a0
[20786.363401]   [<ffffffff81147095>] generic_drop_inode+0x25/0x30
[20786.363411]   [<ffffffff81145ce2>] iput+0x62/0x70
[20786.363420]   [<ffffffff81142878>] dentry_iput+0x98/0x110
[20786.363429]   [<ffffffff81142a00>] d_kill+0x50/0x80
[20786.363438]   [<ffffffff811444c5>] dput+0x95/0x180
[20786.363447]   [<ffffffff8120de4b>] ecryptfs_d_release+0x2b/0x70
[20786.363459]   [<ffffffff81142978>] d_free+0x28/0x60
[20786.363468]   [<ffffffff81142a18>] d_kill+0x68/0x80
[20786.363477]   [<ffffffff81142ad3>] prune_one_dentry+0xa3/0xc0
[20786.363487]   [<ffffffff81142d61>] __shrink_dcache_sb+0x271/0x290
[20786.363497]   [<ffffffff81142e89>] prune_dcache+0x109/0x1b0
[20786.363506]   [<ffffffff81142f6f>] shrink_dcache_memory+0x3f/0x50
[20786.363516]   [<ffffffff810f6d3d>] shrink_slab+0x12d/0x190
[20786.363527]   [<ffffffff810f97d7>] balance_pgdat+0x4d7/0x640
[20786.363537]   [<ffffffff810f9a57>] kswapd+0x117/0x170
[20786.363546]   [<ffffffff810773ce>] kthread+0x9e/0xb0
[20786.363558]   [<ffffffff8101430a>] child_rip+0xa/0x20
[20786.363569]   [<ffffffffffffffff>] 0xffffffffffffffff
[20786.363598] irq event stamp: 15997
[20786.363603] hardirqs last  enabled at (15997): [<ffffffff81125f9d>] kmem_cache_alloc+0xfd/0x1a0
[20786.363617] hardirqs last disabled at (15996): [<ffffffff81125f01>] kmem_cache_alloc+0x61/0x1a0
[20786.363628] softirqs last  enabled at (15966): [<ffffffff810631ea>] __do_softirq+0x14a/0x220
[20786.363641] softirqs last disabled at (15861): [<ffffffff8101440c>] call_softirq+0x1c/0x30
[20786.363651] 
[20786.363653] other info that might help us debug this:
[20786.363660] 3 locks held by http/8397:
[20786.363665]  #0:  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<ffffffff8112ed24>] do_truncate+0x64/0x90
[20786.363685]  #1:  (&sb->s_type->i_alloc_sem_key#5){+++++.}, at: [<ffffffff81147f90>] notify_change+0x250/0x350
[20786.363707]  #2:  (jbd2_handle){+.+.?.}, at: [<ffffffff812008bb>] jbd2_journal_start+0xdb/0x150
[20786.363724] 
[20786.363726] stack backtrace:
[20786.363734] Pid: 8397, comm: http Tainted: G         C 2.6.31-2-generic #14~rbd4gitd960eea9
[20786.363741] Call Trace:
[20786.363752]  [<ffffffff8108ad7c>] print_usage_bug+0x18c/0x1a0
[20786.363763]  [<ffffffff8108b0c0>] ? check_usage_backwards+0x0/0xb0
[20786.363773]  [<ffffffff8108bad2>] mark_lock_irq+0xf2/0x280
[20786.363783]  [<ffffffff8108bd97>] mark_lock+0x137/0x1d0
[20786.363793]  [<ffffffff8108c03c>] mark_held_locks+0x6c/0xa0
[20786.363803]  [<ffffffff8108c11f>] lockdep_trace_alloc+0xaf/0xe0
[20786.363813]  [<ffffffff810efbac>] __alloc_pages_nodemask+0x7c/0x180
[20786.363824]  [<ffffffff810e9411>] ? find_get_page+0x91/0xf0
[20786.363835]  [<ffffffff8111d3b7>] alloc_pages_current+0x87/0xd0
[20786.363845]  [<ffffffff810e9827>] __page_cache_alloc+0x67/0x70
[20786.363856]  [<ffffffff810eb7df>] find_or_create_page+0x4f/0xb0
[20786.363867]  [<ffffffff811cb3be>] ext4_block_truncate_page+0x3e/0x460
[20786.363876]  [<ffffffff812008da>] ? jbd2_journal_start+0xfa/0x150
[20786.363885]  [<ffffffff812008bb>] ? jbd2_journal_start+0xdb/0x150
[20786.363895]  [<ffffffff811c6415>] ? ext4_meta_trans_blocks+0x75/0xf0
[20786.363905]  [<ffffffff811e8d8b>] ext4_ext_truncate+0x1bb/0x1e0
[20786.363916]  [<ffffffff811072c5>] ? unmap_mapping_range+0x75/0x290
[20786.363926]  [<ffffffff811ccc28>] ext4_truncate+0x498/0x630
[20786.363938]  [<ffffffff8129b4ce>] ? _raw_spin_unlock+0x5e/0xb0
[20786.363947]  [<ffffffff81107306>] ? unmap_mapping_range+0xb6/0x290
[20786.363957]  [<ffffffff8108c3ad>] ? trace_hardirqs_on+0xd/0x10
[20786.363966]  [<ffffffff811ffe58>] ? jbd2_journal_stop+0x1f8/0x2e0
[20786.363976]  [<ffffffff81107690>] vmtruncate+0xb0/0x110
[20786.363986]  [<ffffffff81147c05>] inode_setattr+0x35/0x170
[20786.363995]  [<ffffffff811c9906>] ext4_setattr+0x186/0x370
[20786.364005]  [<ffffffff81147eab>] notify_change+0x16b/0x350
[20786.364014]  [<ffffffff8112ed30>] do_truncate+0x70/0x90
[20786.364021]  [<ffffffff8112f48b>] T.657+0xeb/0x110
[20786.364021]  [<ffffffff8112f4be>] sys_ftruncate+0xe/0x10
[20786.364021]  [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
