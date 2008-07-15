From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 06/15][e2fsprogs] Add 64-bit alloc_stats interface.
Date: Tue, 15 Jul 2008 11:50:38 -0500
Message-ID: <20080715165038.28567.81930.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:34187 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYGOQuo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 12:50:44 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGohZ2025208
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:50:43 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGoeLc150466
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:50:40 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGodGO007627
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:50:39 -0600
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
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

 lib/ext2fs/alloc_stats.c |   11 +++++++++--
 lib/ext2fs/ext2fs.h      |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index a8514cc..7288829 100644
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
@@ -88,3 +90,8 @@ void ext2fs_set_block_alloc_stats_callback(ext2_filsys fs,
 
 	fs->block_alloc_stats = func;
 }
+
+void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
+{
+	ext2fs_block_alloc_stats2(fs, blk, inuse);
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index a643aa1..fd5b69a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -586,6 +586,7 @@ void ext2fs_inode_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int inuse);
 void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 			       int inuse, int isdir);
 void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse);
+void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse);
 
 /* alloc_tables.c */
 extern errcode_t ext2fs_allocate_tables(ext2_filsys fs);

