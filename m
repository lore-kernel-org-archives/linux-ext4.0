From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 4/9][e2fsprogs] Add 64-bit alloc_stats interface.
Date: Fri, 09 May 2008 11:39:52 -0500
Message-ID: <20080509163952.15484.56168.stgit@gara>
References: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51016 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393AbYEIQjX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 May 2008 12:39:23 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49GdNlr019795
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:23 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49GdMwP053374
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:22 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49GdMjp009646
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:22 -0400
In-Reply-To: <20080509163928.15484.22146.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit alloc_stats interface.

Add new ext2fs_block_alloc_stats2() routine that takes blk64_t as an
input.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/alloc_stats.c |   10 +++++++++-
 lib/ext2fs/ext2fs.h      |    1 +
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 3956528..2183507 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -54,13 +54,16 @@ void ext2fs_inode_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int inuse)
 	ext2fs_inode_alloc_stats2(fs, ino, inuse, 0);
 }
 
-void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
+void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 {
+	/*FIXME: Not blk64_t clean */
 	int	group = ext2fs_group_of_blk(fs, blk);
 
 	if (inuse > 0)
+		/*FIXME: Not blk64_t clean */
 		ext2fs_mark_block_bitmap(fs->block_map, blk);
 	else
+		/*FIXME: Not blk64_t clean */
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
 	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
@@ -70,3 +73,8 @@ void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 }
+
+void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
+{
+	ext2fs_block_alloc_stats2(fs, blk, inuse);
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 3f640cf..8107d94 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -554,6 +554,7 @@ void ext2fs_inode_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int inuse);
 void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 			       int inuse, int isdir);
 void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse);
+void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse);
 
 /* alloc_tables.c */
 extern errcode_t ext2fs_allocate_tables(ext2_filsys fs);

