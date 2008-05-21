From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [Take2 PATCH 05/10][e2fsprogs] Add 64-bit alloc_stats interface.
Date: Wed, 21 May 2008 12:53:55 -0500
Message-ID: <20080521175355.18810.95279.stgit@gara>
References: <20080521175325.18810.25160.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:45214 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936298AbYEURyD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 13:54:03 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4LHoUCj023674
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:50:30 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4LHs0iK092342
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 11:54:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4LHrxLa001554
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 11:54:00 -0600
In-Reply-To: <20080521175325.18810.25160.stgit@gara>
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

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 3956528..2f1a8e7 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -54,13 +54,15 @@ void ext2fs_inode_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int inuse)
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
@@ -70,3 +72,8 @@ void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 }
+
+void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
+{
+	ext2fs_block_alloc_stats2(fs, blk, inuse);
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0043803..de32dd4 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -554,6 +554,7 @@ void ext2fs_inode_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int inuse);
 void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 			       int inuse, int isdir);
 void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse);
+void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse);
 
 /* alloc_tables.c */
 extern errcode_t ext2fs_allocate_tables(ext2_filsys fs);

