From: amir73il@users.sourceforge.net
Subject: [PATCH v1 28/36] ext4: snapshot list - read through to previous snapshot
Date: Tue,  7 Jun 2011 18:07:55 +0300
Message-ID: <1307459283-22130-29-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab1FGPKO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:14 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:13 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

On snapshot page read, the function ext4_get_block() is called
to map the page to a disk block.  If the page is not mapped in the
snapshot file, the newer snapshots on the list are checked and the
oldest found mapping is returned.  If the page is not mapped in any of
the newer snapshots, a direct mapping to the block device is returned.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/snapshot_inode.c |   74 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
index 74b455d..a97411e 100644
--- a/fs/ext4/snapshot_inode.c
+++ b/fs/ext4/snapshot_inode.c
@@ -46,12 +46,62 @@
  * in which case 'prev_snapshot' is pointed to the previous snapshot
  * on the list or set to NULL to indicate read through to block device.
  */
+/*
+ * In-memory snapshot list manipulation is protected by snapshot_mutex.
+ * In this function we read the in-memory snapshot list without holding
+ * snapshot_mutex, because we don't want to slow down snapshot read performance.
+ * Following is a proof, that even though we don't hold snapshot_mutex here,
+ * reading the list is safe from races with snapshot list delete and add (take).
+ *
+ * Proof of no race with snapshot delete:
+ * --------------------------------------
+ * We get here only when reading from an enabled snapshot or when reading
+ * through from an enabled snapshot to a newer snapshot.  Snapshot delete
+ * operation is only allowed for a disabled snapshot, when no older enabled
+ * snapshot exists (i.e., the deleted snapshot in not 'in-use').  Hence,
+ * read through is safe from races with snapshot list delete operations.
+ *
+ * Proof of no race with snapshot take:
+ * ------------------------------------
+ * Snapshot B take is composed of the following steps:
+ * ext4_snapshot_create():
+ * - Add snapshot B to head of list (active_snapshot is A).
+ * - Allocate and copy snapshot B initial blocks.
+ * ext4_snapshot_take():
+ * - Freeze FS
+ * - Clear snapshot A 'active' flag.
+ * - Set snapshot B 'list'+'active' flags.
+ * - Set snapshot B as active snapshot (active_snapshot=B).
+ * - Unfreeze FS
+ *
+ * Note that we do not need to rely on correct order of instructions within
+ * each of the functions above, but we can assume that Freeze FS will provide
+ * a strong barrier between adding B to list and the ops inside snapshot_take.
+ *
+ * When reading from snapshot A during snapshot B take, we have 2 cases:
+ * 1. is_active(A) is tested before setting active_snapshot=B -
+ *    read through from A to block device.
+ * 2. is_active(A) is tested after setting active_snapshot=B -
+ *    read through from A to B.
+ *
+ * When reading from snapshot B during snapshot B take, we have 2 cases:
+ * 1. B->flags and B->prev are read before adding B to list
+ *    AND/OR before setting the 'list'+'active' flags -
+ *    access to B denied.
+ * 2. is_active(B) is tested after setting active_snapshot=B
+ *    AND/OR after setting the 'list'+'active' flags -
+ *    read through from B to block device.
+ */
 static int ext4_snapshot_get_block_access(struct inode *inode,
 		struct inode **prev_snapshot)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned long flags = ext4_get_snapstate_flags(inode);
+	struct list_head *prev = ei->i_snaplist.prev;
 
+	if (!(flags & 1UL<<EXT4_SNAPSTATE_LIST))
+		/* snapshot not on the list - read/write access denied */
+		return -EPERM;
 
 	*prev_snapshot = NULL;
 	if (ext4_snapshot_is_active(inode) ||
@@ -59,7 +109,23 @@ static int ext4_snapshot_get_block_access(struct inode *inode,
 		/* read through from active snapshot to block device */
 		return 0;
 
-	return -EPERM;
+	if (prev == &ei->i_snaplist)
+		/* not on snapshots list? */
+		return -EIO;
+
+	if (prev == &EXT4_SB(inode->i_sb)->s_snapshot_list)
+		/* active snapshot not found on list? */
+		return -EIO;
+
+	/* read through to prev snapshot on the list */
+	ei = list_entry(prev, struct ext4_inode_info, i_snaplist);
+	*prev_snapshot = &ei->vfs_inode;
+
+	if (!ext4_snapshot_file(*prev_snapshot))
+		/* non snapshot file on the list? */
+		return -EIO;
+
+	return 0;
 }
 
 #ifdef CONFIG_EXT4_DEBUG
@@ -122,6 +188,7 @@ static int ext4_snapshot_read_through(struct inode *inode, sector_t iblock,
 	map.m_pblk = 0;
 	map.m_len = bh_result->b_size >> inode->i_blkbits;
 
+get_block:
 	prev_snapshot = NULL;
 	/* request snapshot file read access */
 	err = ext4_snapshot_get_block_access(inode, &prev_snapshot);
@@ -134,6 +201,11 @@ static int ext4_snapshot_read_through(struct inode *inode, sector_t iblock,
 		       prev_snapshot ? prev_snapshot->i_generation : 0);
 	if (err < 0)
 		return err;
+	if (!err && prev_snapshot) {
+		/* hole in snapshot - check again with prev snapshot */
+		inode = prev_snapshot;
+		goto get_block;
+	}
 	if (!err)
 		/* hole in active snapshot - read though to block device */
 		return 0;
-- 
1.7.4.1

