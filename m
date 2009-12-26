From: "Theodore Ts'o" <tytso@mit.edu>
Subject: ext4/quota lockdep complaint: false positive?
Date: Sat, 26 Dec 2009 14:09:32 -0500
Message-ID: <E1NOc16-0003pi-BQ@closure.thunk.org>
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37375 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbZLZTJi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Dec 2009 14:09:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


While running the xfsqa regression test suite, lockdep triggered the
following complaint, as shown below.

I *think* it is a false positive, since the issue involves chown
triggering a write to the quota file; and during the write, we are
extending the quota file, which means grabbing i_data_sem while we have
already grabbed the inode mutex for the quota file.

The potential circular locking dependency that lockdep is complaining
occurs only when we are mounting the filesystem, and reading from the
quota file; and at that point we wouldn't be writing other files and
needing to update quota file as aresult.  So I don't think this is a
problem in practice, but (1) i'd like a second opinion, and (2) I'm not
sure what's the best way to make lockdep happy.

Jan, what do you think?

Thanks,

						- Ted

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-06811-ge47eb9c #226
-------------------------------------------------------
chown/9834 is trying to acquire lock:
 (&ei->i_data_sem){++++..}, at: [<c0238af2>] ext4_get_blocks+0x37/0x2d4

but task is already holding lock:
 (&sb->s_type->i_mutex_key#12/4){+.+...}, at: [<c0245618>] ext4_quota_write+0xb9/0x263

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#12/4){+.+...}:
       [<c017e0d2>] __lock_acquire+0xa16/0xb75
       [<c017e2c4>] lock_acquire+0x93/0xb1
       [<c062d75b>] __mutex_lock_common+0x32/0x314
       [<c062daea>] mutex_lock_nested+0x35/0x3d
       [<c021be29>] vfs_load_quota_inode+0x172/0x40a
       [<c021c365>] vfs_quota_on_path+0x44/0x4d
       [<c02451e5>] ext4_quota_on+0x122/0x171
       [<c0220588>] do_quotactl+0xdb/0x3da
       [<c0220b04>] sys_quotactl+0x27d/0x29d
       [<c062f06d>] syscall_call+0x7/0xb

-> #1 (&s->s_dquot.dqptr_sem){++++..}:
       [<c017e0d2>] __lock_acquire+0xa16/0xb75
       [<c017e2c4>] lock_acquire+0x93/0xb1
       [<c062dd61>] down_read+0x39/0x76
       [<c021ca5e>] dquot_release_reserved_space+0x2d/0x91
       [<c023524d>] vfs_dq_release_reservation_block+0x49/0x55
       [<c0238d03>] ext4_get_blocks+0x248/0x2d4
       [<c0238ea8>] mpage_da_map_blocks+0x86/0x347
       [<c0239417>] ext4_da_writepages+0x2ae/0x452
       [<c01c461c>] do_writepages+0x1c/0x29
       [<c0200f22>] writeback_single_inode+0xd9/0x293
       [<c0201f80>] write_inode_now+0x80/0xc8
       [<c021bdbc>] vfs_load_quota_inode+0x105/0x40a
       [<c021c365>] vfs_quota_on_path+0x44/0x4d
       [<c02451e5>] ext4_quota_on+0x122/0x171
       [<c0220588>] do_quotactl+0xdb/0x3da
       [<c0220b04>] sys_quotactl+0x27d/0x29d
       [<c062f06d>] syscall_call+0x7/0xb

-> #0 (&ei->i_data_sem){++++..}:
       [<c017dfd4>] __lock_acquire+0x918/0xb75
       [<c017e2c4>] lock_acquire+0x93/0xb1
       [<c062dd61>] down_read+0x39/0x76
       [<c0238af2>] ext4_get_blocks+0x37/0x2d4
       [<c0239885>] ext4_getblk+0x56/0x141
       [<c0239988>] ext4_bread+0x18/0x59
       [<c024564c>] ext4_quota_write+0xed/0x263
       [<c021f425>] write_blk+0x33/0x3b
       [<c021ffc6>] do_insert_tree+0x1eb/0x2bd
       [<c0220033>] do_insert_tree+0x258/0x2bd
       [<c0220033>] do_insert_tree+0x258/0x2bd
       [<c0220033>] do_insert_tree+0x258/0x2bd
       [<c02200f7>] qtree_write_dquot+0x5f/0x118
       [<c021ecb8>] v2_write_dquot+0x25/0x27
       [<c021ba9a>] dquot_acquire+0x89/0xde
       [<c0246b40>] ext4_acquire_dquot+0x64/0x7e
       [<c021dbbb>] dqget+0x29d/0x2d9
       [<c021e07e>] dquot_transfer+0x89/0x508
       [<c021bc9c>] vfs_dq_transfer+0x64/0x7f
       [<c0236d46>] ext4_setattr+0xa4/0x2c0
       [<c01fac16>] notify_change+0x164/0x2aa
       [<c01e8825>] chown_common+0x68/0x7a
       [<c01e88eb>] sys_fchownat+0x57/0x72
       [<c062f06d>] syscall_call+0x7/0xb

other info that might help us debug this:

5 locks held by chown/9834:
 #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c01e881a>] chown_common+0x5d/0x7a
 #1:  (jbd2_handle){+.+...}, at: [<c025d7c8>] start_this_handle+0x42d/0x478
 #2:  (&dquot->dq_lock){+.+...}, at: [<c021ba36>] dquot_acquire+0x25/0xde
 #3:  (&s->s_dquot.dqio_mutex){+.+...}, at: [<c021ba46>] dquot_acquire+0x35/0xde
 #4:  (&sb->s_type->i_mutex_key#12/4){+.+...}, at: [<c0245618>] ext4_quota_write+0xb9/0x263

stack backtrace:
Pid: 9834, comm: chown Not tainted 2.6.32-06811-ge47eb9c #226
Call Trace:
 [<c062c548>] ? printk+0x14/0x16
 [<c017d38e>] print_circular_bug+0x8a/0x96
 [<c017dfd4>] __lock_acquire+0x918/0xb75
 [<c017e2c4>] lock_acquire+0x93/0xb1
 [<c0238af2>] ? ext4_get_blocks+0x37/0x2d4
 [<c062dd61>] down_read+0x39/0x76
 [<c0238af2>] ? ext4_get_blocks+0x37/0x2d4
 [<c0238af2>] ext4_get_blocks+0x37/0x2d4
 [<c017cb93>] ? mark_lock+0x1e/0x1d9
 [<c0239885>] ext4_getblk+0x56/0x141
 [<c062da33>] ? __mutex_lock_common+0x30a/0x314
 [<c0239988>] ext4_bread+0x18/0x59
 [<c062daea>] ? mutex_lock_nested+0x35/0x3d
 [<c024564c>] ext4_quota_write+0xed/0x263
 [<c021f425>] write_blk+0x33/0x3b
 [<c021ffc6>] do_insert_tree+0x1eb/0x2bd
 [<c0220033>] do_insert_tree+0x258/0x2bd
 [<c0220033>] do_insert_tree+0x258/0x2bd
 [<c0220033>] do_insert_tree+0x258/0x2bd
 [<c02200f7>] qtree_write_dquot+0x5f/0x118
 [<c021f752>] ? qtree_read_dquot+0x62/0x1bb
 [<c021ecb8>] v2_write_dquot+0x25/0x27
 [<c021ba9a>] dquot_acquire+0x89/0xde
 [<c0246b40>] ext4_acquire_dquot+0x64/0x7e
 [<c021dbbb>] dqget+0x29d/0x2d9
 [<c021e07e>] dquot_transfer+0x89/0x508
 [<c062e8e3>] ? _spin_unlock+0x22/0x25
 [<c021d318>] ? dqput+0x1de/0x1f3
 [<c021bc9c>] vfs_dq_transfer+0x64/0x7f
 [<c0236d46>] ext4_setattr+0xa4/0x2c0
 [<c01fac16>] notify_change+0x164/0x2aa
 [<c01e8825>] chown_common+0x68/0x7a
 [<c01e88eb>] sys_fchownat+0x57/0x72
 [<c062f06d>] syscall_call+0x7/0xb

