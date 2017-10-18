From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: improve smp scalability for inode generation
Date: Wed, 18 Oct 2017 20:36:55 +0300
Message-ID: <8760bcpdc8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:51824 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdJRRdJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Oct 2017 13:33:09 -0400
Received: by mail-lf0-f65.google.com with SMTP id r129so6698760lff.8
        for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2017 10:33:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


->s_next_generation is protected by s_next_gen_lock but it usage
pattern is very primitive and can be replaced with atomic_ops

This significantly improve creation/unlink scenario on SMP systems,
for example lat_fs_create_unlink test [1] on x2 E5-2680 (32vcpu) system
shows ~20% improvement.
| nr_tsk | wo/ patch | w/ patch |
|--------+-----------+----------|
|      1 |       137 |      140 |
|      2 |       224 |      233 |
|      4 |       356 |      372 |
|      8 |       439 |      519 |
|     16 |       443 |      585 |
|     32 |       598 |      695 |
|     64 |       559 |      707 |
|    128 |       385 |      437 |

Footnotes:
[1]https://github.com/dmonakhov/lmbench/blob/master/src/lat_fs_create_unlink.c

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h   | 3 +--
 fs/ext4/ialloc.c | 4 +---
 fs/ext4/ioctl.c  | 6 ++----
 fs/ext4/super.c  | 8 ++++----
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e2abe01..6be1aa8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1392,8 +1392,7 @@ struct ext4_sb_info {
 	int s_first_ino;
 	unsigned int s_inode_readahead_blks;
 	unsigned int s_inode_goal;
-	spinlock_t s_next_gen_lock;
-	u32 s_next_generation;
+	atomic_t s_next_generation;
 	u32 s_hash_seed[4];
 	int s_def_hash_version;
 	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ee82302..d12dabc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1138,9 +1138,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 			   inode->i_ino);
 		goto out;
 	}
-	spin_lock(&sbi->s_next_gen_lock);
-	inode->i_generation = sbi->s_next_generation++;
-	spin_unlock(&sbi->s_next_gen_lock);
+	inode->i_generation = atomic_inc_return(&sbi->s_next_generation);
 
 	/* Precompute checksum seed for inode metadata */
 	if (ext4_has_metadata_csum(sb)) {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index afb66d4..7d8b1a5 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -157,10 +157,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	inode->i_ctime = inode_bl->i_ctime = current_time(inode);
 
-	spin_lock(&sbi->s_next_gen_lock);
-	inode->i_generation = sbi->s_next_generation++;
-	inode_bl->i_generation = sbi->s_next_generation++;
-	spin_unlock(&sbi->s_next_gen_lock);
+	inode_bl->i_generation = atomic_add_return(2, &sbi->s_next_generation);
+	inode->i_generation = inode_bl->i_generation -1;
 
 	ext4_discard_preallocations(inode);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b104096..bfc6d2e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3419,7 +3419,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err = 0;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
-
+	u32 igen;
+	
 	if ((data && !orig_data) || !sbi)
 		goto out_free_base;
 
@@ -3977,9 +3978,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	sbi->s_gdb_count = db_count;
-	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
-	spin_lock_init(&sbi->s_next_gen_lock);
