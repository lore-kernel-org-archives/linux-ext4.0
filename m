From: Christoph Hellwig <hch@lst.de>
Subject: quota locking inversion with ext2
Date: Mon, 31 May 2010 11:47:04 +0200
Message-ID: <20100531094704.GB10283@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60423 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab0EaJrG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 05:47:06 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2 + quota isn't too happy during xfstests 230:

230 14s ...[ 2657.175866] 
[ 2657.175868] =======================================================
[ 2657.176060] [ INFO: possible circular locking dependency detected ]
[ 2657.176060] 2.6.35-rc1 #140
[ 2657.176060] -------------------------------------------------------
[ 2657.176060] xfs_io/24446 is trying to acquire lock:
[ 2657.176060]  (&tty->atomic_write_lock){+.+.+.}, at: [<c076e0c6>]
tty_write_message+0x26/0xb0
[ 2657.176060] 
[ 2657.176060] but task is already holding lock:
[ 2657.176060]  (&s->s_dquot.dqptr_sem){++++..}, at: [<c0242015>]
__dquot_alloc_space+0xb5/0x260
[ 2657.176060] 
[ 2657.176060] which lock already depends on the new lock.
[ 2657.176060] 
[ 2657.176060] 
[ 2657.176060] the existing dependency chain (in reverse order) is:
[ 2657.176060] 
[ 2657.176060] -> #3 (&s->s_dquot.dqptr_sem){++++..}:
[ 2657.176060]        [<c01927f4>] lock_acquire+0x94/0x110
[ 2657.176060]        [<c0959837>] down_read+0x47/0x90
[ 2657.176060]        [<c0242015>] __dquot_alloc_space+0xb5/0x260
[ 2657.176060]        [<c02b4531>] ext2_new_blocks+0x61/0x550
[ 2657.176060]        [<c02b7722>] ext2_get_block+0x282/0x880
[ 2657.176060]        [<c022e1b9>] __mpage_writepage+0x4d9/0x6a0
[ 2657.176060]        [<c01d6c62>] write_cache_pages+0x162/0x2f0
[ 2657.176060]        [<c022d43a>] mpage_writepages+0x3a/0x70
[ 2657.176060]        [<c02b6f3d>] ext2_writepages+0xd/0x10
[ 2657.176060]        [<c01d6e37>] do_writepages+0x17/0x30
[ 2657.176060]        [<c01cfc7c>] __filemap_fdatawrite_range+0x5c/0x70
[ 2657.176060]        [<c01cfcdf>]
filemap_write_and_wait_range+0x4f/0x80
[ 2657.176060]        [<c0222e54>] vfs_fsync_range+0x54/0x90
[ 2657.176060]        [<c0222f32>] vfs_fsync+0x22/0x30
[ 2657.176060]        [<c01ed2fe>] sys_msync+0x11e/0x1a0
[ 2657.176060]        [<c012eedc>] sysenter_do_call+0x12/0x3c
[ 2657.176060] 
[ 2657.176060] -> #2 (&ei->truncate_mutex#2){+.+...}:
[ 2657.176060]        [<c01927f4>] lock_acquire+0x94/0x110
[ 2657.176060]        [<c095a530>] _raw_spin_lock_irqsave+0x50/0x90
[ 2657.176060]        [<c072033d>] free_object+0x1d/0xa0
[ 2657.176060]        [<c0720605>] debug_object_free+0xc5/0x110
[ 2657.176060]        [<c016f15d>] destroy_timer_on_stack+0xd/0x10
[ 2657.176060]        [<c0958a26>] schedule_timeout+0x146/0x260
[ 2657.176060]        [<c0957ef5>] io_schedule_timeout+0x35/0x50
[ 2657.176060]        [<c01d6fce>]
balance_dirty_pages_ratelimited_nr+0x11e/0x390
[ 2657.176060]        [<c01e59b0>] __do_fault+0x240/0x400
[ 2657.176060]        [<c01e7710>] handle_mm_fault+0xf0/0x650
[ 2657.176060]        [<c095deb2>] do_page_fault+0x142/0x430
[ 2657.176060]        [<c095b597>] error_code+0x6b/0x70
[ 2657.176060] 
[ 2657.176060] -> #1 (&mm->mmap_sem){++++++}:
[ 2657.176060]        [<c01927f4>] lock_acquire+0x94/0x110
[ 2657.176060]        [<c01e45b7>] might_fault+0x77/0xa0
[ 2657.176060]        [<c0719b48>] _copy_from_user+0x38/0x130
[ 2657.176060]        [<c076cfe8>] copy_from_user+0x8/0x10
[ 2657.176060]        [<c076e346>] tty_write+0x196/0x220
[ 2657.176060]        [<c076e454>] redirected_tty_write+0x84/0x90
[ 2657.176060]        [<c02024fa>] vfs_write+0x9a/0x160
[ 2657.176060]        [<c0202dcd>] sys_write+0x3d/0x70
[ 2657.176060]        [<c012eedc>] sysenter_do_call+0x12/0x3c
[ 2657.176060] 
[ 2657.176060] -> #0 (&tty->atomic_write_lock){+.+.+.}:
[ 2657.176060]        [<c01926e8>] __lock_acquire+0x1298/0x1310
[ 2657.176060]        [<c01927f4>] lock_acquire+0x94/0x110
[ 2657.176060]        [<c09590f7>] __mutex_lock_common+0x47/0x360
[ 2657.176060]        [<c09594c5>] mutex_lock_nested+0x35/0x40
[ 2657.176060]        [<c076e0c6>] tty_write_message+0x26/0xb0
[ 2657.176060]        [<c0241e4a>] flush_warnings+0xca/0x1e0
[ 2657.176060]        [<c02420f7>] __dquot_alloc_space+0x197/0x260
[ 2657.176060]        [<c02b4531>] ext2_new_blocks+0x61/0x550
[ 2657.176060]        [<c02b7722>] ext2_get_block+0x282/0x880
[ 2657.176060]        [<c0227270>] block_prepare_write+0x150/0x3a0
[ 2657.176060]        [<c02275fd>] __block_write_begin+0x1d/0x30
[ 2657.176060]        [<c022765a>] block_write_begin+0x4a/0x80
[ 2657.176060]        [<c02b89d0>] ext2_write_begin+0x40/0x70
[ 2657.176060]        [<c01cf01d>]
generic_file_buffered_write+0xcd/0x1f0
[ 2657.176060]        [<c01d1770>] __generic_file_aio_write+0x200/0x4f0
[ 2657.176060]        [<c01d1abe>] generic_file_aio_write+0x5e/0xc0
[ 2657.176060]        [<c02022ac>] do_sync_write+0x9c/0xd0
[ 2657.176060]        [<c02024fa>] vfs_write+0x9a/0x160
[ 2657.176060]        [<c0202ee3>] sys_pwrite64+0x63/0x80
[ 2657.176060]        [<c012eedc>] sysenter_do_call+0x12/0x3c
[ 2657.176060] 
[ 2657.176060] other info that might help us debug this:
[ 2657.176060] 
[ 2657.176060] 3 locks held by xfs_io/24446:
[ 2657.176060]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at:
[<c01d1aab>] generic_file_aio_write+0x4b/0xc0
[ 2657.176060]  #1:  (&ei->truncate_mutex#2){+.+...}, at: [<c02b7575>]
ext2_get_block+0xd5/0x880
[ 2657.176060]  #2:  (&s->s_dquot.dqptr_sem){++++..}, at: [<c0242015>]
__dquot_alloc_space+0xb5/0x260
[ 2657.176060] 
[ 2657.176060] stack backtrace:
[ 2657.176060] Pid: 24446, comm: xfs_io Not tainted 2.6.35-rc1 #140
[ 2657.176060] Call Trace:
[ 2657.176060]  [<c0957e2e>] ? printk+0x28/0x2a
[ 2657.176060]  [<c0190382>] print_circular_bug+0xc2/0xd0
[ 2657.176060]  [<c01926e8>] __lock_acquire+0x1298/0x1310
[ 2657.176060]  [<c01927f4>] lock_acquire+0x94/0x110
[ 2657.176060]  [<c076e0c6>] ? tty_write_message+0x26/0xb0
[ 2657.176060]  [<c09590f7>] __mutex_lock_common+0x47/0x360
[ 2657.176060]  [<c076e0c6>] ? tty_write_message+0x26/0xb0
[ 2657.176060]  [<c0190dc2>] ? mark_held_locks+0x62/0x90
[ 2657.176060]  [<c095ad05>] ? _raw_spin_unlock_irqrestore+0x35/0x60
[ 2657.176060]  [<c09594c5>] mutex_lock_nested+0x35/0x40
[ 2657.176060]  [<c076e0c6>] ? tty_write_message+0x26/0xb0
[ 2657.176060]  [<c076e0c6>] tty_write_message+0x26/0xb0
[ 2657.176060]  [<c0241e4a>] flush_warnings+0xca/0x1e0
[ 2657.176060]  [<c02420f7>] __dquot_alloc_space+0x197/0x260
[ 2657.176060]  [<c02b4531>] ext2_new_blocks+0x61/0x550
[ 2657.176060]  [<c09592fd>] ? __mutex_lock_common+0x24d/0x360
[ 2657.176060]  [<c02b7575>] ? ext2_get_block+0xd5/0x880
[ 2657.176060]  [<c09594c5>] ? mutex_lock_nested+0x35/0x40
[ 2657.176060]  [<c02b7722>] ext2_get_block+0x282/0x880
[ 2657.176060]  [<c01fab5f>] ? cache_alloc_debugcheck_after+0xdf/0x1d0
[ 2657.176060]  [<c0227270>] block_prepare_write+0x150/0x3a0
[ 2657.176060]  [<c01d1072>] ? grab_cache_page_write_begin+0x82/0xb0
[ 2657.176060]  [<c02b74a0>] ? ext2_get_block+0x0/0x880
[ 2657.176060]  [<c02275fd>] __block_write_begin+0x1d/0x30
[ 2657.176060]  [<c02b74a0>] ? ext2_get_block+0x0/0x880
[ 2657.176060]  [<c022765a>] block_write_begin+0x4a/0x80
[ 2657.176060]  [<c02b74a0>] ? ext2_get_block+0x0/0x880
[ 2657.176060]  [<c02b89d0>] ext2_write_begin+0x40/0x70
[ 2657.176060]  [<c02b74a0>] ? ext2_get_block+0x0/0x880
[ 2657.176060]  [<c01cf01d>] generic_file_buffered_write+0xcd/0x1f0
[ 2657.176060]  [<c01d1770>] __generic_file_aio_write+0x200/0x4f0
[ 2657.176060]  [<c01d1aab>] ? generic_file_aio_write+0x4b/0xc0
[ 2657.176060]  [<c01d1abe>] generic_file_aio_write+0x5e/0xc0
[ 2657.176060]  [<c02022ac>] do_sync_write+0x9c/0xd0
[ 2657.176060]  [<c0192aff>] ? lock_release_non_nested+0x28f/0x300
[ 2657.176060]  [<c01e4586>] ? might_fault+0x46/0xa0
[ 2657.176060]  [<c02024fa>] vfs_write+0x9a/0x160
[ 2657.176060]  [<c0202210>] ? do_sync_write+0x0/0xd0
[ 2657.176060]  [<c012ef15>] ? sysenter_exit+0xf/0x1a
[ 2657.176060]  [<c0202ee3>] sys_pwrite64+0x63/0x80
[ 2657.176060]  [<c012eedc>] sysenter_do_call+0x12/0x3c

