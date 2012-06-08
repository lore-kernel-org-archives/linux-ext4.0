From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Circular locking bug found in xfstests
Date: Thu, 07 Jun 2012 23:48:03 -0400
Message-ID: <E1ScqB9-0004Ay-P8@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48441 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab2FHDsG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jun 2012 23:48:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I found this while testing 3.5-rc1 with a two ext4 bug fix patches
(b22b1f178f from the ext4 tree) that will be shortly pushed to Linus.

The two bug fixes are unrelated to the quota system; and I don't recall
seeing anything like this when I was testing 3.4-rcX based kernels.  I
could try bisecting it, but I thought I'd ask if you could see something
obvious.

Cheers,

						- Ted

219	[  938.212950] 
[  938.213365] ======================================================
[  938.214690] [ INFO: possible circular locking dependency detected ]
[  938.215853] 3.5.0-rc1-00002-gb22b1f1 #124 Not tainted
[  938.216005] -------------------------------------------------------
[  938.216005] quotaon/27560 is trying to acquire lock:
[  938.216005]  (&sb->s_type->i_mutex_key#7){+.+.+.}, at: [<c0249bbd>] vfs_load_quota_inode+0x15b/0x3f2
[  938.216005] 
[  938.216005] but task is already holding lock:
[  938.216005]  (&s->s_dquot.dqonoff_mutex){+.+...}, at: [<c0249b80>] vfs_load_quota_inode+0x11e/0x3f2
[  938.216005] 
[  938.216005] which lock already depends on the new lock.
[  938.216005] 
[  938.216005] 
[  938.216005] the existing dependency chain (in reverse order) is:
[  938.216005] 
[  938.216005] -> #2 (&s->s_dquot.dqonoff_mutex){+.+...}:
[  938.216005]        [<c019b4ff>] lock_acquire+0x99/0xbd
[  938.216005]        [<c06ea154>] __mutex_lock_common+0x30/0x316
[  938.216005]        [<c06ea4e8>] mutex_lock_nested+0x26/0x2f
[  938.216005]        [<c024a03e>] dquot_resume+0x39/0xe8
[  938.216005]        [<c028d631>] ext4_remount+0x358/0x429
[  938.216005]        [<c0210aef>] do_remount_sb+0xae/0x120
[  938.216005]        [<c0225af0>] do_mount+0x236/0x691
[  938.216005]        [<c0225fb1>] sys_mount+0x66/0x95
[  938.216005]        [<c06ec7d5>] syscall_call+0x7/0xb
[  938.216005] 
[  938.216005] -> #1 (&type->s_umount_key#18){+++++.}:
[  938.216005]        [<c019b4ff>] lock_acquire+0x99/0xbd
[  938.216005]        [<c06ea99f>] down_read+0x28/0x65
[  938.216005]        [<c022bf3a>] writeback_inodes_sb_if_idle+0x2c/0x47
[  938.216005]        [<c02757bc>] ext4_nonda_switch+0xf4/0x105
[  938.216005]        [<c027abfa>] ext4_da_write_begin+0x3c/0x194
[  938.216005]        [<c01df8e6>] generic_file_buffered_write+0xd1/0x1db
[  938.216005]        [<c01e0a29>] __generic_file_aio_write+0x25e/0x28f
[  938.216005]        [<c01e0ac4>] generic_file_aio_write+0x6a/0xba
[  938.216005]        [<c02734ba>] ext4_file_write+0x1dc/0x22a
[  938.216005]        [<c020edb3>] do_sync_write+0x92/0xcd
[  938.216005]        [<c020f702>] vfs_write+0x85/0xe3
[  938.216005]        [<c020f801>] sys_write+0x40/0x65
[  938.216005]        [<c06ec7d5>] syscall_call+0x7/0xb
[  938.216005] 
[  938.216005] -> #0 (&sb->s_type->i_mutex_key#7){+.+.+.}:
[  938.216005]        [<c019b1fa>] __lock_acquire+0x982/0xbee
[  938.216005]        [<c019b4ff>] lock_acquire+0x99/0xbd
[  938.216005]        [<c06ea154>] __mutex_lock_common+0x30/0x316
[  938.216005]        [<c06ea4e8>] mutex_lock_nested+0x26/0x2f
[  938.216005]        [<c0249bbd>] vfs_load_quota_inode+0x15b/0x3f2
[  938.216005]        [<c0249ffd>] dquot_quota_on+0x41/0x49
[  938.216005]        [<c028bfed>] ext4_quota_on+0x12e/0x13b
[  938.216005]        [<c024cbd1>] do_quotactl+0x1b8/0x3a0
[  938.216005]        [<c024cefb>] sys_quotactl+0x142/0x17b
[  938.216005]        [<c06ec7d5>] syscall_call+0x7/0xb
[  938.216005] 
[  938.216005] other info that might help us debug this:
[  938.216005] 
[  938.216005] Chain exists of:
[  938.216005]   &sb->s_type->i_mutex_key#7 --> &type->s_umount_key#18 --> &s->s_dquot.dqonoff_mutex
[  938.216005] 
[  938.216005]  Possible unsafe locking scenario:
[  938.216005] 
[  938.216005]        CPU0                    CPU1
[  938.216005]        ----                    ----
[  938.216005]   lock(&s->s_dquot.dqonoff_mutex);
[  938.216005]                                lock(&type->s_umount_key#18);
[  938.216005]                                lock(&s->s_dquot.dqonoff_mutex);
[  938.216005]   lock(&sb->s_type->i_mutex_key#7);
[  938.216005] 
[  938.216005]  *** DEADLOCK ***
[  938.216005] 
[  938.216005] 2 locks held by quotaon/27560:
[  938.216005]  #0:  (&type->s_umount_key#18){+++++.}, at: [<c0210d0a>] get_super+0x50/0x93
[  938.216005]  #1:  (&s->s_dquot.dqonoff_mutex){+.+...}, at: [<c0249b80>] vfs_load_quota_inode+0x11e/0x3f2
[  938.216005] 
[  938.216005] stack backtrace:
[  938.216005] Pid: 27560, comm: quotaon Not tainted 3.5.0-rc1-00002-gb22b1f1 #124
[  938.216005] Call Trace:
[  938.216005]  [<c0199164>] print_circular_bug+0x194/0x1a1
[  938.216005]  [<c019b1fa>] __lock_acquire+0x982/0xbee
[  938.216005]  [<c01dfe69>] ? find_get_pages+0xee/0xf8
[  938.216005]  [<c019b4ff>] lock_acquire+0x99/0xbd
[  938.216005]  [<c0249bbd>] ? vfs_load_quota_inode+0x15b/0x3f2
[  938.216005]  [<c06ea154>] __mutex_lock_common+0x30/0x316
[  938.216005]  [<c0249bbd>] ? vfs_load_quota_inode+0x15b/0x3f2
[  938.216005]  [<c06ea4e8>] mutex_lock_nested+0x26/0x2f
[  938.216005]  [<c0249bbd>] ? vfs_load_quota_inode+0x15b/0x3f2
[  938.216005]  [<c0249bbd>] vfs_load_quota_inode+0x15b/0x3f2
[  938.216005]  [<c0249ffd>] dquot_quota_on+0x41/0x49
[  938.216005]  [<c028bfed>] ext4_quota_on+0x12e/0x13b
[  938.216005]  [<c024cbd1>] do_quotactl+0x1b8/0x3a0
[  938.216005]  [<c028bebf>] ? ext4_msg+0x3c/0x3c
[  938.216005]  [<c06ea9d5>] ? down_read+0x5e/0x65
[  938.216005]  [<c0210d0a>] ? get_super+0x50/0x93
[  938.216005]  [<c0210f82>] ? get_super_thawed+0x25/0xa9
[  938.216005]  [<c024cefb>] sys_quotactl+0x142/0x17b
[  938.216005]  [<c06ec7d5>] syscall_call+0x7/0xb
