From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 06/15][e2fsprogs] Add 64-bit alloc_stats interface.
Date: Wed, 20 Aug 2008 12:33:12 -0500
Message-ID: <20080820173312.23412.21515.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37447 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYHTRcK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 13:32:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHW9JE019444
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:32:09 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHW9YH185388
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:32:09 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHW9YO012919
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:32:09 -0400
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit alloc_stats interface.

Add new ext2fs_block_alloc_stats2() routine that takes blk64_t as an
input.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/alloc_stats.c |   11 +++++++++--
 lib/ext2fs/ext2fs.h      |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
--

 lib/ext2fs/alloc_stats.c |   13 ++++++++++---
 lib/ext2fs/ext2fs.h      |    1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index a8514cc..6f9720b 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -54,25 +54,32 @@ void ext2fs_inode_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int inuse)
 	ext2fs_inode_alloc_stats2(fs, ino, inuse, 0);
 }
 
-void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
+void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 {
-	int	group = ext2fs_group_of_blk(fs, blk);
+	int	group = ext2fs_group_of_blk2(fs, blk);
 
 	if (inuse > 0)
+		/* FIXME-64 */
 		ext2fs_mark_block_bitmap(fs->block_map, blk);
 	else
+		/* FIXME-64 */
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
 	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 	ext2fs_group_desc_csum_set(fs, group);
 
-	fs->super->s_free_blocks_count -= inuse;
+	ext2fs_free_blocks_count_add(fs->super, -inuse);
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 	if (fs->block_alloc_stats)
 		(fs->block_alloc_stats)(fs, (blk64_t) blk, inuse);
 }
 
+void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
+{
+	ext2fs_block_alloc_stats2(fs, blk, inuse);
+}
+
 void ext2fs_set_block_alloc_stats_callback(ext2_filsys fs, 
 					   void (*func)(ext2_filsys fs,
 							blk64_t blk,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index efd40cb..434ff02 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -586,6 +586,7 @@ void ext2fs_inode_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int inuse);
 void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 			       int inuse, int isdir);
 void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse);
+void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse);
 
 /* alloc_tables.c */
 extern errcode_t ext2fs_allocate_tables(ext2_filsys fs);

