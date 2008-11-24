From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 5/5] ext4: Fix the race between read_inode_bitmap
	and ext4_new_inode
Date: Mon, 24 Nov 2008 16:45:53 +0530
Message-ID: <20081124111553.GB8462@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081124040524.GD2163@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:37452 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYKXLQA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 06:16:00 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id mAOBFutK016265
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 16:45:56 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAOBFvvC4509792
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 16:45:57 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id mAOBFsHs000762
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 16:45:55 +0530
Content-Disposition: inline
In-Reply-To: <20081124040524.GD2163@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 23, 2008 at 11:05:24PM -0500, Theodore Tso wrote:
> On Fri, Nov 21, 2008 at 10:14:35PM +0530, Aneesh Kumar K.V wrote:
> > We need to make sure we update the inode bitmap and clear
> > EXT4_BG_INODE_UNINIT flag with sb_bgl_lock held. We look
> > at EXT4_BG_INODE_UNINIT and reinit the inode bitmap each
> > time in ext4_read_inode_bitmap (introduced by
> > c806e68f5647109350ec546fee5b526962970fd2 )
> 
> OK, I believe I've checked in all of your patches in this series into
> the ext4 patch queue
> 
> Some of them have comments that still need to be cleared; this one in
> particular needs a better commit comment, and ideally a comment for
> the new function ext4_claim_inode().

I will add a comment to the above function.

> 
> Also, please don't rename variables unnecessarily; if you really think
> it's needed, please do so in a separate patch.  The renaming of
> variables makes it much harder to review the patch, since it bloats
> the patch, and obscures the true changes happening in the patch.
> Please explain why you are making some of the changes you made in the
> patch.  In particular, why does it matter the order in which you
> unlock the bh and sb_bgl_lock in balloc.c, mballoc.c and inode.c?
> 
> 

I will put the variable name cleanup and unlock cleanup into separate
patch. The unlock is done as a cleanup so that unlock appears in the
reverse order with which we did locking. It doesn't make any difference.

-aneesh

Updated patch below

ext4: Fix the race between read_inode_bitmap() and ext4_new_inode()

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to make sure we update the inode bitmap and clear
EXT4_BG_INODE_UNINIT flag with sb_bgl_lock held. We look
at EXT4_BG_INODE_UNINIT and reinit the inode bitmap each
time in ext4_read_inode_bitmap (introduced by
c806e68f5647109350ec546fee5b526962970fd2 )

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
