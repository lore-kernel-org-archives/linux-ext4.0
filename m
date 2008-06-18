From: Jan Kara <jack@suse.cz>
Subject: Re: circular locking dependency detected with lock inversion
Date: Wed, 18 Jun 2008 11:45:42 +0200
Message-ID: <20080618094542.GD18994@duck.suse.cz>
References: <20080617170249.GB29335@skywalker>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43574 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751582AbYFRJpo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2008 05:45:44 -0400
Content-Disposition: inline
In-Reply-To: <20080617170249.GB29335@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

On Tue 17-06-08 22:32:49, Aneesh Kumar K.V wrote:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc6-autokern1 #1
> -------------------------------------------------------
> umount/28231 is trying to acquire lock:
>  (&ei->i_data_sem){----}, at: [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c
> 
> but task is already holding lock:
>  (&type->s_lock_key#7){--..}, at: [<ffffffff8028a856>] lock_super+0x22/0x24
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&type->s_lock_key#7){--..}:
>        [<ffffffff8024dbcf>] __lock_acquire+0xc3c/0xe20
>        [<ffffffff8024e052>] lock_acquire+0x53/0x6d
>        [<ffffffff80503ae2>] mutex_lock_nested+0xd6/0x27d
>        [<ffffffff8028a856>] lock_super+0x22/0x24
>        [<ffffffff803105e1>] ext4_orphan_add+0x29/0x17d
>        [<ffffffff8031a538>] ext4_ext_truncate+0x91/0x19c
>        [<ffffffff8030c984>] ext4_truncate+0xbb/0x568
>        [<ffffffff8026f07e>] vmtruncate+0xc2/0xe0
>        [<ffffffff8029d586>] inode_setattr+0x28/0x123
>        [<ffffffff8030ad2f>] ext4_setattr+0x226/0x284
>        [<ffffffff8029d7ea>] notify_change+0x169/0x27b
>        [<ffffffff80287886>] do_truncate+0x60/0x7e
>        [<ffffffff80287a16>] sys_truncate+0x172/0x1a8
>        [<ffffffff80222721>] sys32_truncate64+0x16/0x18
>        [<ffffffff802223a2>] ia32_sysret+0x0/0xa
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (&ei->i_data_sem){----}:
>        [<ffffffff8024dab7>] __lock_acquire+0xb24/0xe20
>        [<ffffffff8024e052>] lock_acquire+0x53/0x6d
>        [<ffffffff805045f7>] down_read+0x25/0x31
>        [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c
>        [<ffffffff8030c4cc>] ext4_get_block+0xb5/0xf3
>        [<ffffffff802ab7ee>] generic_block_bmap+0x3a/0x40
>        [<ffffffff803093bb>] ext4_bmap+0x70/0x79
>        [<ffffffff8029c9aa>] bmap+0x1f/0x27
>        [<ffffffff80335c8d>] jbd2_journal_bmap+0x2c/0x8a
>        [<ffffffff80335fe5>] jbd2_journal_next_log_block+0x76/0x7e
>        [<ffffffff803362cd>] jbd2_journal_get_descriptor_buffer+0x17/0x80
>        [<ffffffff80331b15>] jbd2_journal_commit_transaction+0x56e/0x1045
>        [<ffffffff803356c4>] jbd2_journal_destroy+0xfc/0x250
>        [<ffffffff80312acf>] ext4_put_super+0x3e/0x213
>        [<ffffffff8028a96a>] generic_shutdown_super+0x63/0xf8
>        [<ffffffff8028b6d6>] kill_block_super+0x12/0x27
>        [<ffffffff8028a81f>] deactivate_super+0x4c/0x61
>        [<ffffffff8029f28b>] mntput_no_expire+0xed/0x120
>        [<ffffffff802a0d30>] sys_umount+0x312/0x327
>        [<ffffffff802223a2>] ia32_sysret+0x0/0xa
>        [<ffffffffffffffff>] 0xffffffffffffffff
  The problem is we call ext4_orphan_add() in ext4_ext_truncate() under
i_data_sem. I wonder why we didn't hit it earlier... In principle, there's
no reason why ext4_orphan_add() could not be called earlier. So the patch
below should help.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ext4-fix-lock-inversion-in-ext4_ext_truncate

ext4: Fix lock inversion in ext4_ext_truncate()

We cannot call ext4_orphan_add() from under i_data_sem because that causes
lock inversion between i_data_sem and superblock lock:

 -> #1 (&type->s_lock_key#7){--..}:
       [<ffffffff8024dbcf>] __lock_acquire+0xc3c/0xe20
       [<ffffffff8024e052>] lock_acquire+0x53/0x6d
       [<ffffffff80503ae2>] mutex_lock_nested+0xd6/0x27d
       [<ffffffff8028a856>] lock_super+0x22/0x24
       [<ffffffff803105e1>] ext4_orphan_add+0x29/0x17d
       [<ffffffff8031a538>] ext4_ext_truncate+0x91/0x19c
       [<ffffffff8030c984>] ext4_truncate+0xbb/0x568
       [<ffffffff8026f07e>] vmtruncate+0xc2/0xe0
       [<ffffffff8029d586>] inode_setattr+0x28/0x123
       [<ffffffff8030ad2f>] ext4_setattr+0x226/0x284
       [<ffffffff8029d7ea>] notify_change+0x169/0x27b
       [<ffffffff80287886>] do_truncate+0x60/0x7e
       [<ffffffff80287a16>] sys_truncate+0x172/0x1a8
       [<ffffffff80222721>] sys32_truncate64+0x16/0x18

 -> #0 (&ei->i_data_sem){----}:
       [<ffffffff8024dab7>] __lock_acquire+0xb24/0xe20
       [<ffffffff8024e052>] lock_acquire+0x53/0x6d
       [<ffffffff805045f7>] down_read+0x25/0x31
       [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c
       [<ffffffff8030c4cc>] ext4_get_block+0xb5/0xf3
       [<ffffffff802ab7ee>] generic_block_bmap+0x3a/0x40
       [<ffffffff803093bb>] ext4_bmap+0x70/0x79
       [<ffffffff8029c9aa>] bmap+0x1f/0x27
       [<ffffffff80335c8d>] jbd2_journal_bmap+0x2c/0x8a
       [<ffffffff80335fe5>] jbd2_journal_next_log_block+0x76/0x7e
       [<ffffffff803362cd>] jbd2_journal_get_descriptor_buffer+0x17/0x80
       [<ffffffff80331b15>] jbd2_journal_commit_transaction+0x56e/0x1045
       [<ffffffff803356c4>] jbd2_journal_destroy+0xfc/0x250
       [<ffffffff80312acf>] ext4_put_super+0x3e/0x213
       [<ffffffff8028a96a>] generic_shutdown_super+0x63/0xf8
       [<ffffffff8028b6d6>] kill_block_super+0x12/0x27
       [<ffffffff8028a81f>] deactivate_super+0x4c/0x61
       [<ffffffff8029f28b>] mntput_no_expire+0xed/0x120
       [<ffffffff802a0d30>] sys_umount+0x312/0x327

Signed-off-by: Jan Kara <jack@suse.cz>

Index: linux-2.6-linus/fs/ext4/extents.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/extents.c
+++ linux-2.6-linus/fs/ext4/extents.c
@@ -2943,6 +2943,9 @@ void ext4_ext_truncate(struct inode *ino
 	if (inode->i_size & (sb->s_blocksize - 1))
 		ext4_block_truncate_page(handle, mapping, inode->i_size);
 
+	if (ext4_orphan_add(handle, inode))
+		goto out_stop;
+
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_ext_invalidate_cache(inode);
 
@@ -2953,8 +2956,6 @@ void ext4_ext_truncate(struct inode *ino
 	 * Probably we need not scan at all,
 	 * because page truncation is enough.
 	 */
-	if (ext4_orphan_add(handle, inode))
-		goto out_stop;
 
 	/* we have to know where to truncate from in crash case */
 	EXT4_I(inode)->i_disksize = inode->i_size;

--7AUc2qLy4jB3hD7Z--
