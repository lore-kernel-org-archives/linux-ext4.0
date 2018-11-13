Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56377 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeKNJYi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 14 Nov 2018 04:24:38 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext2: remove redundant condition check
Date: Wed, 14 Nov 2018 07:23:53 +0800
Message-Id: <20181113232353.11011-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2_xattr_destroy_cache() can handle NULL pointer correctly,
so there is no need to check NULL pointer before calling
ext2_xattr_destroy_cache().

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/super.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index cb91baa4275d..e4351c280608 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -148,10 +148,9 @@ static void ext2_put_super (struct super_block * sb)
 
 	ext2_quota_off_umount(sb);
 
-	if (sbi->s_ea_block_cache) {
-		ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
-		sbi->s_ea_block_cache = NULL;
-	}
+	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
+	sbi->s_ea_block_cache = NULL;
+
 	if (!sb_rdonly(sb)) {
 		struct ext2_super_block *es = sbi->s_es;
 
@@ -1197,8 +1196,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 			sb->s_id);
 	goto failed_mount;
 failed_mount3:
-	if (sbi->s_ea_block_cache)
-		ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
+	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
2.17.2
