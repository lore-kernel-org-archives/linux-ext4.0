Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53075 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKCL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:02:11 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 05/10] ext2: fix coding style for inode.c
Date: Tue, 13 Nov 2018 08:04:43 +0800
Message-Id: <20181113000448.16023-6-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e4bb9386c045..63a6cf33cd78 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -69,7 +69,7 @@ static void ext2_write_failed(struct address_space *mapping, loff_t to)
 /*
  * Called at the last iput() if i_nlink is zero.
  */
-void ext2_evict_inode(struct inode * inode)
+void ext2_evict_inode(struct inode *inode)
 {
 	struct ext2_block_alloc_info *rsv;
 	int want_delete = 0;
@@ -359,7 +359,7 @@ static inline ext2_fsblk_t ext2_find_goal(struct inode *inode, long block,
  *	direct and indirect blocks.
  */
 static int
-ext2_blks_to_allocate(Indirect * branch, int k, unsigned long blks,
+ext2_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
 		int blocks_to_boundary)
 {
 	unsigned long count = 0;
@@ -1393,10 +1393,10 @@ void ext2_set_file_ops(struct inode *inode)
 		inode->i_mapping->a_ops = &ext2_aops;
 }
 
-struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
+struct inode *ext2_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext2_inode_info *ei;
-	struct buffer_head * bh;
+	struct buffer_head *bh;
 	struct ext2_inode *raw_inode;
 	struct inode *inode;
 	long ret = -EIO;
@@ -1533,8 +1533,8 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 	ino_t ino = inode->i_ino;
 	uid_t uid = i_uid_read(inode);
 	gid_t gid = i_gid_read(inode);
-	struct buffer_head * bh;
-	struct ext2_inode * raw_inode = ext2_get_inode(sb, ino, &bh);
+	struct buffer_head *bh;
+	struct ext2_inode *raw_inode = ext2_get_inode(sb, ino, &bh);
 	int n;
 	int err = 0;
 
-- 
2.17.2
