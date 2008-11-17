From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 3/4] ext3: allocate ->s_blockgroup_lock separately
Date: Mon, 17 Nov 2008 23:55:35 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0811172355080.18904@melkki.cs.Helsinki.FI>
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
	with ESMTP id S1754718AbYKQVzg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 16:55:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As spotted by kmemtrace, struct ext3_sb_info is 17152 bytes on 64-bit which
makes it a very bad fit for SLAB allocators. The culprit of the wasted memory
is ->s_blockgroup_lock which can be as big as 16 KB when NR_CPUS >= 32.

To fix that, allocate ->s_blockgroup_lock, which fits nicely in a order 2 page
in the worst case, separately. This shinks down struct ext3_sb_info enough to
fit a 1 KB slab cache so now we allocate 16 KB + 1 KB instead of 32 KB saving
15 KB of memory.

Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext3/super.c            |   10 +++++++++-
 include/linux/ext3_fs_sb.h |    4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f6c94f2..f41df22 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -439,6 +439,7 @@ static void ext3_put_super (struct super_block * sb)
 		ext3_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	return;
 }
@@ -1548,6 +1549,13 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
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
 	sbi->s_resuid = EXT3_DEF_RESUID;
@@ -1788,7 +1796,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logic_sb_block, i);
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index e024e38..76fdc0f 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -60,7 +60,7 @@ struct ext3_sb_info {
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
-	struct blockgroup_lock s_blockgroup_lock;
+	struct blockgroup_lock *s_blockgroup_lock;
 
 	/* root of the per fs reservation window tree */
 	spinlock_t s_rsv_window_lock;
@@ -86,7 +86,7 @@ struct ext3_sb_info {
 static inline spinlock_t *
 sb_bgl_lock(struct ext3_sb_info *sbi, unsigned int block_group)
 {
-	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+	return bgl_lock_ptr(sbi->s_blockgroup_lock, block_group);
 }
 
 #endif	/* _LINUX_EXT3_FS_SB */
-- 
1.5.4.3

