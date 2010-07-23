From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: fix ext4_get_blocks references
Date: Fri, 23 Jul 2010 15:23:42 -0500
Message-ID: <4C49FA4E.80109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0GWUXp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 16:23:45 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6NKNjCY017198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jul 2010 16:23:45 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6NKNgA6021089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jul 2010 16:23:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_get_blocks got renamed to ext4_map_blocks, but left stale
comments and a prototype littered around.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..401713e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -460,7 +462,7 @@ struct ext4_new_group_data {
 };
 
 /*
- * Flags used by ext4_get_blocks()
+ * Flags used by ext4_map_blocks()
  */
 	/* Allocate any needed blocks and/or convert an unitialized
 	   extent to be an initialized ext4 */
@@ -1905,9 +1907,6 @@ extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 			  ssize_t len);
 extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map, int flags);
-extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
-			   sector_t block, unsigned int max_blocks,
-			   struct buffer_head *bh, int flags);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 /* move_extent.c */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0afc8c1..7d44bcf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2194,7 +2194,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	BUG_ON(!handle);
 
 	/*
-	 * Call ext4_get_blocks() to allocate any delayed allocation
+	 * Call ext4_map_blocks() to allocate any delayed allocation
 	 * blocks, or to convert an uninitialized extent to be
 	 * initialized (in the case where we have written into
 	 * one or more preallocated blocks).
@@ -2203,7 +2203,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * indicate that we are on the delayed allocation path.  This
 	 * affects functions in many different parts of the allocation
 	 * call path.  This flag exists primarily because we don't
-	 * want to change *many* call functions, so ext4_get_blocks()
+	 * want to change *many* call functions, so ext4_map_blocks()
 	 * will set the magic i_delalloc_reserved_flag once the
 	 * inode's allocation semaphore is taken.
 	 *
@@ -2320,7 +2320,7 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	 * XXX Don't go larger than mballoc is willing to allocate
 	 * This is a stopgap solution.  We eventually need to fold
 	 * mpage_da_submit_io() into this function and then call
-	 * ext4_get_blocks() multiple times in a loop
+	 * ext4_map_blocks() multiple times in a loop
 	 */
 	if (nrblocks >= 8*1024*1024/mpd->inode->i_sb->s_blocksize)
 		goto flush_it;
@@ -3941,7 +3948,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 				return -ENOMEM;
 			/*
 			 * we save the io structure for current async
-			 * direct IO, so that later ext4_get_blocks()
+			 * direct IO, so that later ext4_map_blocks()
 			 * could flag the io structure whether there
 			 * is a unwritten extents needs to be converted
 			 * when IO is completed.
@@ -5692,7 +5699,7 @@ int ext4_writepage_trans_blocks(struct inode *inode)
  * Calculate the journal credits for a chunk of data modification.
  *
  * This is called from DIO, fallocate or whoever calling
- * ext4_get_blocks() to map/allocate a chunk of contiguous disk blocks.
+ * ext4_map_blocks() to map/allocate a chunk of contiguous disk blocks.
  *
  * journal buffers for data blocks are not included here, as DIO
  * and fallocate do no need to journal data buffers.

