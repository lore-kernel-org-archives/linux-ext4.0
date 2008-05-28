From: Jan Kara <jack@suse.cz>
Subject: Re: Circular locking dependency with delalloc
Date: Wed, 28 May 2008 18:38:05 +0200
Message-ID: <20080528163805.GB32634@atrey.karlin.mff.cuni.cz>
References: <20080522095011.GA30056@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33357 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYE1QiH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 May 2008 12:38:07 -0400
Content-Disposition: inline
In-Reply-To: <20080522095011.GA30056@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Aneesh,

  I think it was this lock inversion you mentioned in one of your
emails...

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc2 #56
> -------------------------------------------------------
> umount/2662 is trying to acquire lock:
> (jbd2_handle){--..}, at: [<c01fa63b>] jbd2_journal_start+0xce/0xf0
> 
> but task is already holding lock:
> (&type->s_lock_key#7){--..}, at: [<c0169685>] lock_super+0x1b/0x1d
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&type->s_lock_key#7){--..}:
> [<c013cd50>] __lock_acquire+0x97f/0xb32
> [<c013cf6f>] lock_acquire+0x6c/0x89
> [<c043ac8a>] mutex_lock_nested+0xc9/0x248
> [<c0169685>] lock_super+0x1b/0x1d
> [<c01db851>] ext4_orphan_add+0x1b/0x12e
> [<c01e5143>] ext4_ext_truncate+0x99/0x166
> [<c01d7664>] ext4_truncate+0x84/0x40d
> [<c01d88b0>] ext4_delete_inode+0x74/0xc0
> [<c01790f4>] generic_delete_inode+0x61/0xcb
> [<c0179170>] generic_drop_inode+0x12/0x137
> [<c01787e3>] iput+0x4b/0x4e
> [<c0170c4f>] do_unlinkat+0xd3/0x145
> [<c0170cd1>] sys_unlink+0x10/0x12
> [<c0103931>] sysenter_past_esp+0x6a/0xb1
> [<ffffffff>] 0xffffffff
> 
> -> #1 (&ei->i_data_sem){----}:
> [<c013cd50>] __lock_acquire+0x97f/0xb32
> [<c013cf6f>] lock_acquire+0x6c/0x89
> [<c043b1d0>] down_read+0x2b/0x65
> [<c01d6afe>] ext4_get_blocks_wrap+0x2b/0xfc
> [<c01d6ca5>] ext4_getblk+0x49/0x18a
> [<c01da947>] ext4_find_entry+0x331/0x58b
> [<c01dc7c3>] ext4_unlink+0x6e/0x18e
> [<c016f236>] vfs_unlink+0x4d/0xa5
> [<c0170c23>] do_unlinkat+0xa7/0x145
> [<c0170cd1>] sys_unlink+0x10/0x12
> [<c0103931>] sysenter_past_esp+0x6a/0xb1
> [<ffffffff>] 0xffffffff
> 
> -> #0 (jbd2_handle){--..}:
> [<c013cc77>] __lock_acquire+0x8a6/0xb32
> [<c013cf6f>] lock_acquire+0x6c/0x89
> [<c01fa650>] jbd2_journal_start+0xe3/0xf0
> [<c01ddb4b>] ext4_journal_start_sb+0x40/0x42
> [<c01d8c0c>] ext4_da_writepages+0x45/0xbb
> [<c0150176>] do_writepages+0x23/0x34
> [<c0180fe6>] __writeback_single_inode+0x12a/0x260
> [<c01811bc>] write_inode_now+0x72/0xbc
> [<c01791ef>] generic_drop_inode+0x91/0x137
> [<c01787e3>] iput+0x4b/0x4e
> [<c01ff465>] jbd2_journal_destroy+0x19f/0x1c9
> [<c01de66c>] ext4_put_super+0x35/0x18d
> [<c0169e19>] generic_shutdown_super+0x52/0xd3
> [<c0169ea9>] kill_block_super+0xf/0x20
> [<c0169f4a>] deactivate_super+0x3f/0x51
> [<c017b4b3>] mntput_no_expire+0xba/0xdd
> [<c017b955>] sys_umount+0x259/0x29b
> [<c0103931>] sysenter_past_esp+0x6a/0xb1
> [<ffffffff>] 0xffffffff
  What has changed is that now we start a transaction before we find any
pages to write. During dropping of journal inode (which is the trace
above), there are actually no dirty pages so previously we didn't start
a transaction but now we do start it... So this is mostly cosmetic error
(I think no real deadlock can be triggered) but I agree we should fix
it. Probably by somehow detecting that we are shutting down superblock
in ext4_da_writepages() and simply return - if there are any dirty data
by that time, we are screwed anyway...

> other info that might help us debug this:
> 
> 2 locks held by umount/2662:
> #0:  (&type->s_umount_key#17){----}, at: [<c0169f45>] deactivate_super+0x3a/0x51
> #1:  (&type->s_lock_key#7){--..}, at: [<c0169685>] lock_super+0x1b/0x1d
> 
> stack backtrace:
> Pid: 2662, comm: umount Not tainted 2.6.26-rc2 #56
> [<c013af32>] print_circular_bug_tail+0x5b/0x66
> [<c013cc77>] __lock_acquire+0x8a6/0xb32
> [<c043c44d>] ? _spin_unlock+0x27/0x3c
> [<c013cf6f>] lock_acquire+0x6c/0x89
> [<c01fa63b>] ? jbd2_journal_start+0xce/0xf0
> [<c01fa650>] jbd2_journal_start+0xe3/0xf0
> [<c01fa63b>] ? jbd2_journal_start+0xce/0xf0
> [<c01ddb4b>] ext4_journal_start_sb+0x40/0x42
> [<c01d8c0c>] ext4_da_writepages+0x45/0xbb
> [<c01d8bc7>] ? ext4_da_writepages+0x0/0xbb
> [<c0150176>] do_writepages+0x23/0x34
> [<c0180fe6>] __writeback_single_inode+0x12a/0x260
> [<c01811bc>] write_inode_now+0x72/0xbc
> [<c01791ef>] generic_drop_inode+0x91/0x137
> [<c01787e3>] iput+0x4b/0x4e
> [<c01ff465>] jbd2_journal_destroy+0x19f/0x1c9
> [<c0132571>] ? autoremove_wake_function+0x0/0x33
> [<c01de66c>] ext4_put_super+0x35/0x18d
> [<c0169e19>] generic_shutdown_super+0x52/0xd3
> [<c0169ea9>] kill_block_super+0xf/0x20
> [<c0169f4a>] deactivate_super+0x3f/0x51
> [<c017b4b3>] mntput_no_expire+0xba/0xdd
> [<c017b955>] sys_umount+0x259/0x29b
> [<c016b482>] ? vfs_stat+0x11/0x13
> [<c010396c>] ? sysenter_past_esp+0xa5/0xb1
> [<c0103931>] sysenter_past_esp+0x6a/0xb1
> =======================
> [ OK ]
> 

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
