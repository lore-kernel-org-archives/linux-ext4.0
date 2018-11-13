Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:46069 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKBG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:01:06 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 07/10] ext2: fix coding style for ialloc.c
Date: Tue, 13 Nov 2018 08:04:45 +0800
Message-Id: <20181113000448.16023-8-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/ialloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 5c3d7b7e4975..38165101df3b 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -44,7 +44,7 @@
  * Return buffer_head of bitmap on success or NULL.
  */
 static struct buffer_head *
-read_inode_bitmap(struct super_block * sb, unsigned long block_group)
+read_inode_bitmap(struct super_block *sb, unsigned long block_group)
 {
 	struct ext2_group_desc *desc;
 	struct buffer_head *bh = NULL;
@@ -65,7 +65,7 @@ read_inode_bitmap(struct super_block * sb, unsigned long block_group)
 
 static void ext2_release_inode(struct super_block *sb, int group, int dir)
 {
-	struct ext2_group_desc * desc;
+	struct ext2_group_desc *desc;
 	struct buffer_head *bh;
 
 	desc = ext2_get_group_desc(sb, group, &bh);
@@ -101,15 +101,15 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
  * though), and then we'd have two inodes sharing the
  * same inode number and space on the harddisk.
  */
-void ext2_free_inode (struct inode * inode)
+void ext2_free_inode(struct inode *inode)
 {
-	struct super_block * sb = inode->i_sb;
+	struct super_block *sb = inode->i_sb;
 	int is_directory;
 	unsigned long ino;
 	struct buffer_head *bitmap_bh;
 	unsigned long block_group;
 	unsigned long bit;
-	struct ext2_super_block * es;
+	struct ext2_super_block *es;
 
 	ino = inode->i_ino;
 	ext2_debug ("freeing inode %lu\n", ino);
@@ -168,7 +168,7 @@ static void ext2_preread_inode(struct inode *inode)
 	unsigned long block_group;
 	unsigned long offset;
 	unsigned long block;
-	struct ext2_group_desc * gdp;
+	struct ext2_group_desc *gdp;
 	struct backing_dev_info *bdi;
 
 	bdi = inode_to_bdi(inode);
@@ -436,7 +436,7 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 	struct buffer_head *bh2;
 	int group, i;
 	ino_t ino = 0;
-	struct inode * inode;
+	struct inode *inode;
 	struct ext2_group_desc *gdp;
 	struct ext2_super_block *es;
 	struct ext2_inode_info *ei;
@@ -620,7 +620,7 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 	return ERR_PTR(err);
 }
 
-unsigned long ext2_count_free_inodes (struct super_block * sb)
+unsigned long ext2_count_free_inodes(struct super_block *sb)
 {
 	struct ext2_group_desc *desc;
 	unsigned long desc_count = 0;
@@ -667,7 +667,7 @@ unsigned long ext2_count_free_inodes (struct super_block * sb)
 }
 
 /* Called at mount-time, super-block is locked */
-unsigned long ext2_count_dirs (struct super_block * sb)
+unsigned long ext2_count_dirs(struct super_block *sb)
 {
 	unsigned long count = 0;
 	int i;
-- 
2.17.2
