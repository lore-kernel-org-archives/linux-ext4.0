From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: make more symbols static
Date: Wed, 04 Jan 2012 11:46:08 -0600
Message-ID: <4F049060.20604@redhat.com>
References: <20120104135120.GA12859@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab2ADRqO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 12:46:14 -0500
In-Reply-To: <20120104135120.GA12859@dztty>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A couple more functions can reasonably be made static if desired.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 12ccacd..f9e2cd8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -23,6 +23,8 @@
 
 #include <trace/events/ext4.h>
 
+static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
+					    ext4_group_t block_group);
 /*
  * balloc.c contains the blocks allocation and deallocation routines
  */
@@ -668,7 +670,7 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
  * This function returns the number of file system metadata clusters at
  * the beginning of a block group, including the reserved gdt blocks.
  */
-unsigned ext4_num_base_meta_clusters(struct super_block *sb,
+static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
 				     ext4_group_t block_group)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ae2407f..0298efb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1790,8 +1790,6 @@ extern void ext4_init_block_bitmap(struct super_block *sb,
 extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
 					      ext4_group_t block_group,
 					      struct ext4_group_desc *gdp);
-extern unsigned ext4_num_base_meta_clusters(struct super_block *sb,
-					    ext4_group_t block_group);
 extern unsigned ext4_num_overhead_clusters(struct super_block *sb,
 					   ext4_group_t block_group,
 					   struct ext4_group_desc *gdp);
@@ -1883,9 +1881,6 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_discard_partial_page_buffers(handle_t *handle,
 		struct address_space *mapping, loff_t from,
 		loff_t length, int flags);
-extern int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
-		struct inode *inode, struct page *page, loff_t from,
-		loff_t length, int flags);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fa84575..01f785a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -72,6 +72,9 @@ static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
 static int __ext4_journalled_writepage(struct page *page, unsigned int len);
 static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh);
+static int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
+		struct inode *inode, struct page *page, loff_t from,
+		loff_t length, int flags);
 
 /*
  * Test whether an inode is a fast symlink.
@@ -3161,7 +3164,7 @@ int ext4_discard_partial_page_buffers(handle_t *handle,
  *
  * Returns zero on sucess or negative on failure.
  */
-int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
+static int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 		struct inode *inode, struct page *page, loff_t from,
 		loff_t length, int flags)
 {


