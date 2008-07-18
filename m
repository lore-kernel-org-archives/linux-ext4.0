From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] sync up block & inode bitmap reading functions
Date: Fri, 18 Jul 2008 14:52:53 -0500
Message-ID: <4880F495.5050808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbYGRTwz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 15:52:55 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6IJqsZ9024733
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:52:54 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IJqsD3031170
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:52:54 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IJqrT1006894
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:52:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_read_block_bitmap and read_inode_bitmap do essentially
the same thing, and yet they are structured quite differently.
I came across this difference while looking at doing bg locking
during bg initialization.

This patch:

* removes unnecessary casts in the error messages
* renames read_inode_bitmap to ext4_read_inode_bitmap
* and more substantially, restructures the inode bitmap
  reading function to be more like the block bitmap counterpart.

The change to the inode bitmap reader simplifies the locking
to be applied in the next patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/balloc.c	2008-07-18 12:35:13.097291209 -0500
+++ linux-2.6/fs/ext4/balloc.c	2008-07-18 14:46:10.873291452 -0500
@@ -314,8 +314,8 @@ ext4_read_block_bitmap(struct super_bloc
 	if (unlikely(!bh)) {
 		ext4_error(sb, __func__,
 			    "Cannot read block bitmap - "
-			    "block_group = %d, block_bitmap = %llu",
-			    (int)block_group, (unsigned long long)bitmap_blk);
+			    "block_group = %lu, block_bitmap = %llu",
+			    block_group, bitmap_blk);
 		return NULL;
 	}
 	if (bh_uptodate_or_lock(bh))
@@ -331,8 +331,8 @@ ext4_read_block_bitmap(struct super_bloc
 		put_bh(bh);
 		ext4_error(sb, __func__,
 			    "Cannot read block bitmap - "
-			    "block_group = %d, block_bitmap = %llu",
-			    (int)block_group, (unsigned long long)bitmap_blk);
+			    "block_group = %lu, block_bitmap = %llu",
+			    block_group, bitmap_blk);
 		return NULL;
 	}
 	ext4_valid_block_bitmap(sb, desc, block_group, bh);
Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c	2008-07-18 12:35:13.102291227 -0500
+++ linux-2.6/fs/ext4/ialloc.c	2008-07-18 14:46:10.873291452 -0500
@@ -97,34 +97,41 @@ unsigned ext4_init_inode_bitmap(struct s
  * Return buffer_head of bitmap on success or NULL.
  */
 static struct buffer_head *
-read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
+ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 {
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh = NULL;
+	ext4_fsblk_t bitmap_blk;
 
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
+		return NULL;
+	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	bh = sb_getblk(sb, bitmap_blk);
+	if (unlikely(!bh)) {
+		ext4_error(sb, __func__,
+			    "Cannot read inode bitmap - "
+			    "block_group = %lu, inode_bitmap = %llu",
+			    block_group, bitmap_blk);
+		return NULL;
+	}
+	if (bh_uptodate_or_lock(bh))
+		return bh;
+
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
-		bh = sb_getblk(sb, ext4_inode_bitmap(sb, desc));
-		if (!buffer_uptodate(bh)) {
-			lock_buffer(bh);
-			if (!buffer_uptodate(bh)) {
-				ext4_init_inode_bitmap(sb, bh, block_group,
-						       desc);
-				set_buffer_uptodate(bh);
-			}
-			unlock_buffer(bh);
-		}
-	} else {
-		bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
+		ext4_init_inode_bitmap(sb, bh, block_group, desc);
+		set_buffer_uptodate(bh);
+		unlock_buffer(bh);
+		return bh;
 	}
-	if (!bh)
-		ext4_error(sb, "read_inode_bitmap",
+	if (bh_submit_read(bh) < 0) {
+		put_bh(bh);
+		ext4_error(sb, __func__,
 			    "Cannot read inode bitmap - "
 			    "block_group = %lu, inode_bitmap = %llu",
-			    block_group, ext4_inode_bitmap(sb, desc));
-error_out:
+			    block_group, bitmap_blk);
+		return NULL;
+	}
 	return bh;
 }
 
@@ -200,7 +207,7 @@ void ext4_free_inode (handle_t *handle, 
 	}
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
-	bitmap_bh = read_inode_bitmap(sb, block_group);
+	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
 	if (!bitmap_bh)
 		goto error_return;
 
@@ -623,7 +630,7 @@ got_group:
 			goto fail;
 
 		brelse(bitmap_bh);
-		bitmap_bh = read_inode_bitmap(sb, group);
+		bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		if (!bitmap_bh)
 			goto fail;
 
@@ -891,7 +898,7 @@ struct inode *ext4_orphan_get(struct sup
 
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
-	bitmap_bh = read_inode_bitmap(sb, block_group);
+	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
 	if (!bitmap_bh) {
 		ext4_warning(sb, __func__,
 			     "inode bitmap error for orphan %lu", ino);
@@ -969,7 +976,7 @@ unsigned long ext4_count_free_inodes (st
 			continue;
 		desc_count += le16_to_cpu(gdp->bg_free_inodes_count);
 		brelse(bitmap_bh);
-		bitmap_bh = read_inode_bitmap(sb, i);
+		bitmap_bh = ext4_read_inode_bitmap(sb, i);
 		if (!bitmap_bh)
 			continue;
 

