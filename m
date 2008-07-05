From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 36/52] ext4: Fix lock inversion in ext4_ext_truncate()
Date: Sat,  5 Jul 2008 13:36:02 -0400
Message-ID: <1215279378-30504-37-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Mingming Cao <cmm@us.ibm.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33036 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754340AbYGERg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:29 -0400
In-Reply-To: <1215279378-30504-36-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b722bce..9e8ec60 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2768,6 +2768,9 @@ void ext4_ext_truncate(struct inode *inode)
 	if (inode->i_size & (sb->s_blocksize - 1))
 		ext4_block_truncate_page(handle, mapping, inode->i_size);
 
+	if (ext4_orphan_add(handle, inode))
+		goto out_stop;
+
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_ext_invalidate_cache(inode);
 
@@ -2778,8 +2781,6 @@ void ext4_ext_truncate(struct inode *inode)
 	 * Probably we need not scan at all,
 	 * because page truncation is enough.
 	 */
-	if (ext4_orphan_add(handle, inode))
-		goto out_stop;
 
 	/* we have to know where to truncate from in crash case */
 	EXT4_I(inode)->i_disksize = inode->i_size;
-- 
1.5.6.rc3.1.g36b7.dirty

