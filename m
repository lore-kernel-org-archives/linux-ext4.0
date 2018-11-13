Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52185 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:01:11 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 09/10] ext2: fix coding style for super.c
Date: Tue, 13 Nov 2018 08:04:47 +0800
Message-Id: <20181113000448.16023-10-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/super.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index cb91baa4275d..c58ca931a2e5 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -39,8 +39,8 @@
 #include "acl.h"
 
 static void ext2_write_super(struct super_block *sb);
-static int ext2_remount (struct super_block * sb, int * flags, char * data);
-static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf);
+static int ext2_remount(struct super_block *sb, int *flags, char *data);
+static int ext2_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int ext2_sync_fs(struct super_block *sb, int wait);
 static int ext2_freeze(struct super_block *sb);
 static int ext2_unfreeze(struct super_block *sb);
@@ -140,7 +140,7 @@ static inline void ext2_quota_off_umount(struct super_block *sb)
 }
 #endif
 
-static void ext2_put_super (struct super_block * sb)
+static void ext2_put_super(struct super_block *sb)
 {
 	int db_count;
 	int i;
@@ -176,7 +176,7 @@ static void ext2_put_super (struct super_block * sb)
 	kfree(sbi);
 }
 
-static struct kmem_cache * ext2_inode_cachep;
+static struct kmem_cache *ext2_inode_cachep;
 
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
@@ -648,8 +648,8 @@ static int parse_options(char *options, struct super_block *sb,
 	return 1;
 }
 
-static int ext2_setup_super (struct super_block * sb,
-			      struct ext2_super_block * es,
+static int ext2_setup_super(struct super_block *sb,
+			      struct ext2_super_block *es,
 			      int read_only)
 {
 	int res = 0;
@@ -819,9 +819,9 @@ static unsigned long descriptor_loc(struct super_block *sb,
 static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
-	struct buffer_head * bh;
-	struct ext2_sb_info * sbi;
-	struct ext2_super_block * es;
+	struct buffer_head *bh;
+	struct ext2_sb_info *sbi;
+	struct ext2_super_block *es;
 	struct inode *root;
 	unsigned long block;
 	unsigned long sb_block = get_sb_block(&data);
@@ -1321,10 +1321,10 @@ static void ext2_write_super(struct super_block *sb)
 		ext2_sync_fs(sb, 1);
 }
 
-static int ext2_remount (struct super_block * sb, int * flags, char * data)
+static int ext2_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct ext2_sb_info * sbi = EXT2_SB(sb);
-	struct ext2_super_block * es;
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct ext2_super_block *es;
 	struct ext2_mount_options new_opts;
 	int err;
 
@@ -1404,7 +1404,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	return 0;
 }
 
-static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
+static int ext2_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
-- 
2.17.2
