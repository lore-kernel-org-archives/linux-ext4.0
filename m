Return-Path: <SRS0=k8Ev=N4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57227 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbeKQXQG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 17 Nov 2018 18:16:06 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext2: surround xattr related code with macro CONFIG_EXT2_FS_XATTR
Date: Sat, 17 Nov 2018 20:59:16 +0800
Message-Id: <20181117125916.31461-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2_xattr_destroy_cache() is only needed when macro
CONFIG_EXT2_FS_XATTR is enabled, so surround related
code with the macro.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index e4351c280608..67a71b0cb5e0 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -148,8 +148,10 @@ static void ext2_put_super (struct super_block * sb)
 
 	ext2_quota_off_umount(sb);
 
+#ifdef CONFIG_EXT2_FS_XATTR
 	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
 	sbi->s_ea_block_cache = NULL;
+#endif
 
 	if (!sb_rdonly(sb)) {
 		struct ext2_super_block *es = sbi->s_es;
@@ -1196,7 +1198,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 			sb->s_id);
 	goto failed_mount;
 failed_mount3:
+#ifdef CONFIG_EXT2_FS_XATTR
 	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
+#endif
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
2.17.2
