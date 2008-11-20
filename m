From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ext4: unlock group before ext4_error
Date: Fri, 21 Nov 2008 00:04:14 +0530
Message-ID: <20081120183414.GA11212@skywalker>
References: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:54437 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYKTSeY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 13:34:24 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id mAKIYLa8000709
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 00:04:21 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAKIYMCU4120662
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 00:04:22 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id mAKIYKUS027154
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 00:04:21 +0530
Content-Disposition: inline
In-Reply-To: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I intent to sent only three patches. I had some debug
patches in between so git format-patch generated patch
number wrongly. I have also the inode uninit flag clearing race
patch. But I am finding a hang during rename. So didn't sent
the patch in the series. Attaching below for reference. Once
I fix the rename hang I will send the patch again.

commit 0181ece15c1e89c2825e581f03abe746fdebb7cf
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Thu Nov 20 23:45:02 2008 +0530

    ext4: Fix the race between read_inode_bitmap and ext4_new_inode
    
    We need to make sure we update the inode bitmap and clear
    EXT4_BG_INODE_UNINIT flag with sb_bgl_lock held. We look
    at EXT4_BG_INODE_UNINIT and reinit the inode bitmap each
    time in ext4_read_inode_bitmap (introduced by
    c806e68f5647109350ec546fee5b526962970fd2 )
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 84f060b..99b1772 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -572,6 +572,70 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 	return -1;
 }
 
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
+	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
+			ino >= EXT4_INODES_PER_GROUP(sb)) {
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
+		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
+
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
 /*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
@@ -585,8 +649,8 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 {
 	struct super_block *sb;
-	struct buffer_head *bitmap_bh = NULL;
-	struct buffer_head *bh2;
+	struct buffer_head *inode_bitmap_bh = NULL;
+	struct buffer_head *group_desc_bh;
 	ext4_group_t group = 0;
 	unsigned long ino = 0;
 	struct inode *inode;
@@ -594,7 +658,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 	struct ext4_super_block *es;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int ret2, err = 0, count;
+	int ret2, err = 0;
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
@@ -634,40 +698,48 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 	for (i = 0; i < sbi->s_groups_count; i++) {
 		err = -EIO;
 
-		gdp = ext4_get_group_desc(sb, group, &bh2);
+		gdp = ext4_get_group_desc(sb, group, &group_desc_bh);
 		if (!gdp)
 			goto fail;
 
-		brelse(bitmap_bh);
-		bitmap_bh = ext4_read_inode_bitmap(sb, group);
-		if (!bitmap_bh)
+		brelse(inode_bitmap_bh);
+		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
+		if (!inode_bitmap_bh)
 			goto fail;
 
 		ino = 0;
 
 repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
-				bitmap_bh->b_data, EXT4_INODES_PER_GROUP(sb), ino);
+					inode_bitmap_bh->b_data,
+					EXT4_INODES_PER_GROUP(sb), ino);
 		if (ino < EXT4_INODES_PER_GROUP(sb)) {
 
-			BUFFER_TRACE(bitmap_bh, "get_write_access");
-			err = ext4_journal_get_write_access(handle, bitmap_bh);
+			BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
+			err = ext4_journal_get_write_access(handle,
+								inode_bitmap_bh);
 			if (err)
 				goto fail;
 
-			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
-						ino, bitmap_bh->b_data)) {
+			BUFFER_TRACE(group_desc_bh, "get_write_access");
+			err = ext4_journal_get_write_access(handle,
+								group_desc_bh);
+			if (err)
+				goto fail;
+			if (!ext4_claim_inode(sb, inode_bitmap_bh,
+						ino, group, mode)) {
 				/* we won it */
-				BUFFER_TRACE(bitmap_bh,
+				BUFFER_TRACE(inode_bitmap_bh,
 					"call ext4_journal_dirty_metadata");
 				err = ext4_journal_dirty_metadata(handle,
-								bitmap_bh);
+							inode_bitmap_bh);
 				if (err)
 					goto fail;
 				goto got;
 			}
 			/* we lost it */
-			jbd2_journal_release_buffer(handle, bitmap_bh);
+			jbd2_journal_release_buffer(handle, inode_bitmap_bh);
+			jbd2_journal_release_buffer(handle, group_desc_bh);
 
 			if (++ino < EXT4_INODES_PER_GROUP(sb))
 				goto repeat_in_this_group;
@@ -687,30 +759,16 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
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
-	BUFFER_TRACE(bh2, "get_write_access");
-	err = ext4_journal_get_write_access(handle, bh2);
-	if (err) goto fail;
-
 	/* We may have to initialize the block bitmap if it isn't already */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		struct buffer_head *block_bh = ext4_read_block_bitmap(sb, group);
+		struct buffer_head *block_bitmap_bh;
 
-		BUFFER_TRACE(block_bh, "get block bitmap access");
-		err = ext4_journal_get_write_access(handle, block_bh);
+		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
+		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
+		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
 		if (err) {
-			brelse(block_bh);
+			brelse(block_bitmap_bh);
 			goto fail;
 		}
 
@@ -728,57 +786,19 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 
 		/* Don't need to dirty bitmap block if we didn't change it */
 		if (free) {
-			BUFFER_TRACE(block_bh, "dirty block bitmap");
-			err = ext4_journal_dirty_metadata(handle, block_bh);
+			BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
+			err = ext4_journal_dirty_metadata(handle,
+							block_bitmap_bh);
 		}
 
-		brelse(block_bh);
+		brelse(block_bitmap_bh);
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
-
-	count = ext4_free_inodes_count(sb, gdp) - 1;
-	ext4_free_inodes_set(sb, gdp, count);
-	if (S_ISDIR(mode)) {
-		count = ext4_used_dirs_count(sb, gdp) + 1;
-		ext4_used_dirs_set(sb, gdp, count);
-	}
-	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
-	spin_unlock(sb_bgl_lock(sbi, group));
-	BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
-	err = ext4_journal_dirty_metadata(handle, bh2);
-	if (err) goto fail;
+	BUFFER_TRACE(group_desc_bh, "call ext4_journal_dirty_metadata");
+	err = ext4_journal_dirty_metadata(handle, group_desc_bh);
+	if (err)
+		goto fail;
 
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
@@ -876,7 +896,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 	iput(inode);
 	ret = ERR_PTR(err);
 really_out:
-	brelse(bitmap_bh);
+	brelse(inode_bitmap_bh);
 	return ret;
 
 fail_free_drop:
@@ -887,7 +907,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 	inode->i_flags |= S_NOQUOTA;
 	inode->i_nlink = 0;
 	iput(inode);
-	brelse(bitmap_bh);
+	brelse(inode_bitmap_bh);
 	return ERR_PTR(err);
 }
 

