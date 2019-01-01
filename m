Return-Path: <SRS0=/7aD=PJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:46953 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbfAANap (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Jan 2019 08:30:45 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext2: set proper return code
Date: Tue,  1 Jan 2019 21:30:28 +0800
Message-Id: <20190101133028.18021-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set proper return code when failing from allocating
memory in ext2_fill_super().

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 73b2d528237f..b6d8402f5c62 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1087,12 +1087,14 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 					   sizeof(struct buffer_head *),
 					   GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
+		ret = -ENOMEM;
 		ext2_msg(sb, KERN_ERR, "error: not enough memory");
 		goto failed_mount;
 	}
 	bgl_lock_init(sbi->s_blockgroup_lock);
 	sbi->s_debts = kcalloc(sbi->s_groups_count, sizeof(*sbi->s_debts), GFP_KERNEL);
 	if (!sbi->s_debts) {
+		ret = -ENOMEM;
 		ext2_msg(sb, KERN_ERR, "error: not enough memory");
 		goto failed_mount_group_desc;
 	}
@@ -1148,6 +1150,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_EXT2_FS_XATTR
 	sbi->s_ea_block_cache = ext2_xattr_create_cache();
 	if (!sbi->s_ea_block_cache) {
+		ret = -ENOMEM;
 		ext2_msg(sb, KERN_ERR, "Failed to create ea_block_cache");
 		goto failed_mount3;
 	}
-- 
2.17.2
