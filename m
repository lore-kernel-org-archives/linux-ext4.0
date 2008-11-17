From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 4/4] ext4: allocate ->s_blockgroup_lock separately
Date: Mon, 17 Nov 2008 23:55:58 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0811172355360.18904@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, cl@linux-foundation.org,
	mpm@selenic.com, eduard.munteanu@linux360.ro
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYKQVz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 16:55:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As spotted by kmemtrace, struct ext4_sb_info is 17664 bytes on 64-bit which
makes it a very bad fit for SLAB allocators. The culprit of the wasted memory
is ->s_blockgroup_lock which can be as big as 16 KB when NR_CPUS >= 32.

To fix that, allocate ->s_blockgroup_lock, which fits nicely in a order 2 page
in the worst case, separately. This shinks down struct ext4_sb_info enough to
fit a 2 KB slab cache so now we allocate 16 KB + 2 KB instead of 32 KB saving
14 KB of memory.

Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext4/ext4_sb.h |    4 ++--
 fs/ext4/super.c   |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index b21f167..ed3bc9c 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -61,7 +61,7 @@ struct ext4_sb_info {
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
 	struct percpu_counter s_dirtyblocks_counter;
-	struct blockgroup_lock s_blockgroup_lock;
+	struct blockgroup_lock *s_blockgroup_lock;
 	struct proc_dir_entry *s_proc;
 
 	/* root of the per fs reservation window tree */
@@ -149,7 +149,7 @@ struct ext4_sb_info {
 static inline spinlock_t *
 sb_bgl_lock(struct ext4_sb_info *sbi, unsigned int block_group)
 {
-	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+	return bgl_lock_ptr(sbi->s_blockgroup_lock, block_group);
 }
 
 #endif	/* _EXT4_SB */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e4a241c..1add517 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -497,6 +497,7 @@ static void ext4_put_super(struct super_block *sb)
 		ext4_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	return;
 }
@@ -1883,6 +1884,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
+
+	sbi->s_blockgroup_lock =
+		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
+	if (!sbi->s_blockgroup_lock) {
+		kfree(sbi);
+		return -ENOMEM;
+	}
 	sb->s_fs_info = sbi;
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT4_DEF_RESUID;
@@ -2179,7 +2187,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				 &sbi->s_inode_readahead_blks);
 #endif
 
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
-- 
1.5.4.3

