From: Nikolay Borisov <kernel@kyup.com>
Subject: Sleeping function called in invalid context
Date: Wed, 3 Aug 2016 10:22:03 +0300
Message-ID: <57A19B9B.60005@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37324 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbcHCHWI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2016 03:22:08 -0400
Received: by mail-wm0-f49.google.com with SMTP id i5so321920020wmg.0
        for <linux-ext4@vger.kernel.org>; Wed, 03 Aug 2016 00:22:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While doing some testing on today's checkout of Linus' master branch I got the following: 

[    9.302725] BUG: sleeping function called from invalid context at ./include/linux/buffer_head.h:358
[    9.304403] in_atomic(): 1, irqs_disabled(): 0, pid: 1718, name: mount
[    9.305633] 8 locks held by mount/1718:
[    9.306382]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff811f0473>] __sb_start_write+0xd3/0xf0
[    9.308178]  #1:  (&type->i_mutex_dir_key#2/1){+.+.+.}, at: [<ffffffff811f9574>] lock_rename+0xe4/0x120
[    9.310096]  #2:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff8120c157>] lock_two_nondirectories+0x47/0x90
[    9.312195]  #3:  (&sb->s_type->i_mutex_key#9/4){+.+.+.}, at: [<ffffffff8120c18f>] lock_two_nondirectories+0x7f/0x90
[    9.314315]  #4:  (&sbi->s_journal_flag_rwsem){.+.+.+}, at: [<ffffffff812988c0>] ext4_writepages+0x50/0xff0
[    9.316278]  #5:  (jbd2_handle){++++..}, at: [<ffffffff812e8d43>] start_this_handle+0x143/0x4c0
[    9.318032]  #6:  (&ei->i_data_sem){++++..}, at: [<ffffffff81294803>] ext4_map_blocks+0x123/0x540
[    9.319793]  #7:  (&(&bgl->locks[i].lock)->rlock){+.+...}, at: [<ffffffff812d0df3>] ext4_mb_init_cache+0x3e3/0xa70
[    9.321887] CPU: 0 PID: 1718 Comm: mount Not tainted 4.7.0-clouder1 #5
[    9.322873] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
[    9.322873]  0000000000000000 ffff88003a4d3058 ffffffff81375c97 ffffffff819c29f9
[    9.322873]  0000000000000166 ffff880038a41500 ffffffff819c29f9 ffff88003a4d3088
[    9.322873]  ffffffff8108dc43 ffff88003a4d3088 0000000000000000 0000000000000166
[    9.322873] Call Trace:
[    9.322873]  [<ffffffff81375c97>] dump_stack+0x6b/0xa4
[    9.322873]  [<ffffffff8108dc43>] ___might_sleep+0x183/0x240
[    9.322873]  [<ffffffff8108dd52>] __might_sleep+0x52/0x90
[    9.322873]  [<ffffffff812ae9c1>] ext4_commit_super+0x191/0x2a0
[    9.322873]  [<ffffffff812af790>] __ext4_grp_locked_error+0x170/0x240
[    9.322873]  [<ffffffff8108dd52>] ? __might_sleep+0x52/0x90
[    9.322873]  [<ffffffff812cf00c>] ext4_mb_generate_buddy+0x20c/0x360
[    9.322873]  [<ffffffff812d0e61>] ext4_mb_init_cache+0x451/0xa70
[    9.322873]  [<ffffffff812d167c>] ext4_mb_init_group+0x1fc/0x2b0
[    9.322873]  [<ffffffff812d73dd>] ? ext4_mb_new_blocks+0x24d/0x1160
[    9.322873]  [<ffffffff812d18af>] ext4_mb_good_group+0x17f/0x190
[    9.322873]  [<ffffffff812d6fa7>] ext4_mb_regular_allocator+0x2c7/0x4b0
[    9.322873]  [<ffffffff812d05ae>] ? ext4_mb_use_preallocated+0x3e/0x4a0
[    9.322873]  [<ffffffff811c9e0c>] ? kmem_cache_alloc+0x24c/0x2d0
[    9.322873]  [<ffffffff812d73dd>] ? ext4_mb_new_blocks+0x24d/0x1160
[    9.322873]  [<ffffffff812cdea4>] ? ext4_mb_initialize_context+0x84/0x1a0
[    9.322873]  [<ffffffff812d7a84>] ext4_mb_new_blocks+0x8f4/0x1160
[    9.322873]  [<ffffffff810b1bf6>] ? check_usage+0x86/0x4c0
[    9.322873]  [<ffffffff810b2f9b>] ? __lock_acquire+0x39b/0x1800
[    9.322873]  [<ffffffff810b379e>] ? __lock_acquire+0xb9e/0x1800
[    9.322873]  [<ffffffff812c28de>] ? ext4_find_extent+0x23e/0x2b0
[    9.322873]  [<ffffffff810c6fff>] ? rcu_read_lock_sched_held+0x4f/0x90
[    9.322873]  [<ffffffff811caf84>] ? __kmalloc+0x274/0x320
[    9.322873]  [<ffffffff812c28de>] ? ext4_find_extent+0x23e/0x2b0
[    9.322873]  [<ffffffff812c28de>] ? ext4_find_extent+0x23e/0x2b0
[    9.322873]  [<ffffffff812c7f5c>] ext4_ext_map_blocks+0xcfc/0x1140
[    9.322873]  [<ffffffff812de7d8>] ? ext4_es_lookup_extent+0x58/0x3a0
[    9.322873]  [<ffffffff81294803>] ? ext4_map_blocks+0x123/0x540
[    9.322873]  [<ffffffff81294803>] ? ext4_map_blocks+0x123/0x540
[    9.322873]  [<ffffffff81294827>] ext4_map_blocks+0x147/0x540
[    9.322873]  [<ffffffff81298ea8>] ? ext4_writepages+0x638/0xff0
[    9.322873]  [<ffffffff812991c4>] ext4_writepages+0x954/0xff0
[    9.322873]  [<ffffffff810b0908>] ? add_lock_to_list.clone.0+0x78/0xb0
[    9.322873]  [<ffffffff810b379e>] ? __lock_acquire+0xb9e/0x1800
[    9.322873]  [<ffffffff816fc1db>] ? _raw_spin_unlock+0x2b/0x40
[    9.322873]  [<ffffffff81223fb9>] ? wbc_attach_and_unlock_inode+0x179/0x290
[    9.322873]  [<ffffffff8116eb43>] do_writepages+0x23/0x40
[    9.322873]  [<ffffffff8115c6a5>] __filemap_fdatawrite_range+0xb5/0x100
[    9.322873]  [<ffffffff810b0908>] ? add_lock_to_list.clone.0+0x78/0xb0
[    9.322873]  [<ffffffff8115c8fc>] filemap_flush+0x1c/0x20
[    9.322873]  [<ffffffff81293bf6>] ext4_alloc_da_blocks+0x56/0x160
[    9.322873]  [<ffffffff812a7655>] ext4_rename+0x665/0x900
[    9.322873]  [<ffffffff8120c18f>] ? lock_two_nondirectories+0x7f/0x90
[    9.322873]  [<ffffffff8120c18f>] ? lock_two_nondirectories+0x7f/0x90
[    9.322873]  [<ffffffff812a7912>] ext4_rename2+0x22/0x40
[    9.322873]  [<ffffffff811fa5ec>] vfs_rename+0x27c/0x5e0
[    9.322873]  [<ffffffff811fea71>] SyS_renameat2+0x431/0x4c0
[    9.322873]  [<ffffffff811f88ce>] SyS_rename+0x1e/0x20
[    9.322873]  [<ffffffff816fc365>] entry_SYSCALL_64_fastpath+0x18/0xa8
[    9.322873]  [<ffffffff816fc31a>] ? entry_SYSCALL_64_after_swapgs+0x17/0x4a

Line 358 is lock_buffer
