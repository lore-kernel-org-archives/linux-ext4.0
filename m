From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH v4 1/3] ext4: handle unwritten or delalloc buffers before
 enabling per-file data journaling
Date: Mon, 14 Mar 2016 11:34:58 +0900
Message-ID: <1457922900-30367-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46968 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbcCNCeg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Mar 2016 22:34:36 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O40012SBCHMUJ70@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 14 Mar 2016 11:34:34 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We already allocate delalloc blocks before changing the inode mode into
"per-file data journal" mode to prevent delalloc blocks from remaining
not allocated, but another issue concerned with "BH_Unwritten" status
still exists. For example, by fallocate(), several buffers' status
change into "BH_Unwritten", but these buffers cannot be processed by
ext4_alloc_da_blocks(). So, they still remain in unwritten status after
per-file data journaling is enabled and they cannot be changed into
written status any more and, if they are journaled and eventually
checkpointed, these unwritten buffer will cause a kernel panic by the
below BUG_ON() function of submit_bh_wbc() when they are submitted
during checkpointing.

static int submit_bh_wbc(int rw, struct buffer_head *bh,...
{
        ...
        BUG_ON(buffer_unwritten(bh));

Moreover, when "dioread_nolock" option is enabled, the status of a
buffer is changed into "BH_Unwritten" after write_begin() completes and
the "BH_Unwritten" status will be cleared after I/O is done. Therefore,
if a buffer's status is changed into unwrutten but the buffer's I/O is
not submitted and completed, it can cause the same problem after
enabling per-file data journaling. You can easily generate this bug by
executing the following command.

./kvm-xfstests -C 10000 -m nodelalloc,dioread_nolock generic/269

To resolve these problems and define a boundary between the previous
mode and per-file data journaling mode, we need to flush and wait all
the I/O of buffers of a file before enabling per-file data journaling
of the file.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index aee960b..71fab4c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5382,22 +5382,29 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		return 0;
 	if (is_journal_aborted(journal))
 		return -EROFS;
-	/* We have to allocate physical blocks for delalloc blocks
-	 * before flushing journal. otherwise delalloc blocks can not
-	 * be allocated any more. even more truncate on delalloc blocks
-	 * could trigger BUG by flushing delalloc blocks in journal.
-	 * There is no delalloc block in non-journal data mode.
-	 */
-	if (val && test_opt(inode->i_sb, DELALLOC)) {
-		err = ext4_alloc_da_blocks(inode);
-		if (err < 0)
-			return err;
-	}
 
 	/* Wait for all existing dio workers */
 	ext4_inode_block_unlocked_dio(inode);
 	inode_dio_wait(inode);
 
+	/*
+	 * Before flushing the journal and switching inode's aops, we have
+	 * to flush all dirty data the inode has. There can be outstanding
+	 * delayed allocations, there can be unwritten extents created by
+	 * fallocate or buffered writes in dioread_nolock mode covered by
+	 * dirty data which can be converted only after flushing the dirty
+	 * data (and journalled aops don't know how to handle these cases).
+	 */
+	if (val) {
+		down_write(&EXT4_I(inode)->i_mmap_sem);
+		err = filemap_write_and_wait(inode->i_mapping);
+		if (err < 0) {
+			up_write(&EXT4_I(inode)->i_mmap_sem);
+			ext4_inode_resume_unlocked_dio(inode);
+			return err;
+		}
+	}
+
 	jbd2_journal_lock_updates(journal);
 
 	/*
@@ -5422,6 +5429,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
+	if (val)
+		up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 
 	/* Finally we can mark the inode as dirty. */
-- 
1.7.9.5

