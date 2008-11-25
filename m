From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3] ext4: Fix the race between read_inode_bitmap() and ext4_new_inode()
Date: Tue, 25 Nov 2008 22:03:41 +0530
Message-ID: <1227630821-17755-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49617 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYKYQds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 11:33:48 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id mAPGXiIa032566
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 22:03:44 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAPGXj0G3497994
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 22:03:45 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mAPGXhnB011495
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 03:33:44 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure we update the inode bitmap and clear
EXT4_BG_INODE_UNINIT flag with sb_bgl_lock held. We look
at EXT4_BG_INODE_UNINIT and reinit the inode bitmap each
time in ext4_read_inode_bitmap (introduced by
c806e68f5647109350ec546fee5b526962970fd2 )

ext4_read_inode_bitmap does:

spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
	ext4_init_inode_bitmap(sb, bh, block_group, desc);

and ext4_new_inode does
if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
                   ino, inode_bitmap_bh->b_data))
		   ......
		   ...
spin_lock(sb_bgl_lock(sbi, group));

gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
ie,on allocation we update the bitmap then we take the sb_bgl_lock
and clear the EXT4_BG_INODE_UNINIT flag. What can happen is a
parallel ext4_read_inode_bitmap can zero out the bitmap in between
the above ext4_set_bit_atomic and spin_lock(sb_bg_lock..)

The race results in below user visible errors
EXT4-fs error (device sdb1): ext4_free_inode: bit already cleared for inode 168449
EXT4-fs warning (device sdb1): ext4_unlink: Deleting nonexistent file ...
EXT4-fs warning (device sdb1): ext4_rmdir: empty directory has too many links ...
# ls -al /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l71
ls: /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l71: Stale NFS file handle

FILENAME: fix-race-between-read_inode_bitmap-and-ext4_new_inode

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c |  146 ++++++++++++++++++++++++++++++++----------------------
 1 files changed, 86 insertions(+), 60 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 229708b..d1ccae5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -573,6 +573,79 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 }
 
 /*
+ * claim the inode from the inode bitmap. If the group
+ * is uninit we need to take the groups's sb_bgl_lock
+ * and clear the uninit flag. The inode bitmap update
+ * and group desc uninit flag clear should be done
+ * after holding sb_bgl_lock so that ext4_read_inode_bitmap
+ * doesn't race with the ext4_claim_inode
+ */
+static int ext4_claim_inode(struct super_block *sb,
+			struct buffer_head *inode_bitmap_bh,
+			unsigned long ino, ext4_group_t group, int mode)
+{
+	int free = 0, retval = 0, count;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
+
+	spin_lock(sb_bgl_lock(sbi, group));
+	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
+		/* not a free inode */
+		retval = 1;
+		goto err_ret;
+	}
+	ino++;
+	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
+			ino > EXT4_INODES_PER_GROUP(sb)) {
+		spin_unlock(sb_bgl_lock(sbi, group));
+		ext4_error(sb, __func__,
+			   "reserved inode or inode > inodes count - "
+			   "block_group = %u, inode=%lu", group,
+			   ino + group * EXT4_INODES_PER_GROUP(sb));
+		return 1;
+	}
+	/* If we didn't allocate from within the initialized part of the inode
+	 * table then we need to initialize up to this inode. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+
+		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
+			/* When marking the block group with
+			 * ~EXT4_BG_INODE_UNINIT we don't want to depend
+			 * on the value of bg_itable_unused even though
+			 * mke2fs could have initialized the same for us.
+			 * Instead we calculated the value below
+			 */
+
+			free = 0;
+		} else {
+			free = EXT4_INODES_PER_GROUP(sb) -
+				ext4_itable_unused_count(sb, gdp);
+		}
+
+		/*
+		 * Check the relative inode number against the last used
+		 * relative inode number in this group. if it is greater
+		 * we need to  update the bg_itable_unused count
+		 *
+		 */
+		if (ino > free)
+			ext4_itable_unused_set(sb, gdp,
+					(EXT4_INODES_PER_GROUP(sb) - ino));
+	}
+	count = ext4_free_inodes_count(sb, gdp) - 1;
+	ext4_free_inodes_set(sb, gdp, count);
+	if (S_ISDIR(mode)) {
+		count = ext4_used_dirs_count(sb, gdp) + 1;
+		ext4_used_dirs_set(sb, gdp, count);
+	}
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+err_ret:
+	spin_unlock(sb_bgl_lock(sbi, group));
+	return retval;
+}
+
+/*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
  * free space and a low directory-to-inode ratio; if that fails, then of
@@ -594,7 +667,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 	struct ext4_super_block *es;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int ret2, err = 0, count;
+	int ret2, err = 0;
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
@@ -657,8 +730,13 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 			if (err)
 				goto fail;
 
-			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
-						ino, inode_bitmap_bh->b_data)) {
+			BUFFER_TRACE(group_desc_bh, "get_write_access");
+			err = ext4_journal_get_write_access(handle,
+								group_desc_bh);
+			if (err)
+				goto fail;
+			if (!ext4_claim_inode(sb, inode_bitmap_bh,
+						ino, group, mode)) {
 				/* we won it */
 				BUFFER_TRACE(inode_bitmap_bh,
 					"call ext4_journal_dirty_metadata");
@@ -666,10 +744,13 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 							inode_bitmap_bh);
 				if (err)
 					goto fail;
+				/* zero bit is inode number 1*/
+				ino++;
 				goto got;
 			}
 			/* we lost it */
 			jbd2_journal_release_buffer(handle, inode_bitmap_bh);
+			jbd2_journal_release_buffer(handle, group_desc_bh);
 
 			if (++ino < EXT4_INODES_PER_GROUP(sb))
 				goto repeat_in_this_group;
@@ -689,22 +770,6 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 	goto out;
 
 got:
-	ino++;
-	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
-	    ino > EXT4_INODES_PER_GROUP(sb)) {
-		ext4_error(sb, __func__,
-			   "reserved inode or inode > inodes count - "
-			   "block_group = %u, inode=%lu", group,
-			   ino + group * EXT4_INODES_PER_GROUP(sb));
-		err = -EIO;
-		goto fail;
-	}
-
-	BUFFER_TRACE(group_desc_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, group_desc_bh);
-	if (err)
-		goto fail;
-
 	/* We may have to initialize the block bitmap if it isn't already */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
@@ -741,49 +806,10 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 		if (err)
 			goto fail;
 	}
-
-	spin_lock(sb_bgl_lock(sbi, group));
-	/* If we didn't allocate from within the initialized part of the inode
-	 * table then we need to initialize up to this inode. */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
-			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
-
-			/* When marking the block group with
-			 * ~EXT4_BG_INODE_UNINIT we don't want to depend
-			 * on the value of bg_itable_unused even though
-			 * mke2fs could have initialized the same for us.
-			 * Instead we calculated the value below
-			 */
-
-			free = 0;
-		} else {
-			free = EXT4_INODES_PER_GROUP(sb) -
-				ext4_itable_unused_count(sb, gdp);
-		}
-
-		/*
-		 * Check the relative inode number against the last used
-		 * relative inode number in this group. if it is greater
-		 * we need to  update the bg_itable_unused count
-		 *
-		 */
-		if (ino > free)
-			ext4_itable_unused_set(sb, gdp,
-					(EXT4_INODES_PER_GROUP(sb) - ino));
-	}
