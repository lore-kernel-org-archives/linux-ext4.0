Return-Path: <SRS0=yRHK=OD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:15600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725844AbeKXWHV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 24 Nov 2018 17:07:21 -0500
From: Hou Tao <houtao1@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <xingaopeng@huawei.com>, <jack@suse.com>
Subject: [PATCH] ext2: initialize opts.s_mount_opt as zero before using it
Date: Sat, 24 Nov 2018 19:21:59 +0800
Message-ID: <20181124112159.16974-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: xingaopeng <xingaopeng@huawei.com>

We need to initialize opts.s_mount_opt as zero before using it, else we
may get some unexpected mount options.

Fixes: 088519572ca8 ("ext2: Parse mount options into a dedicated structure")
Signed-off-by: xingaopeng <xingaopeng@huawei.com>
---
 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index cb91baa4275d..eb11502e3fcd 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -892,6 +892,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	if (sb->s_magic != EXT2_SUPER_MAGIC)
 		goto cantfind_ext2;
 
+	opts.s_mount_opt = 0;
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	if (def_mount_opts & EXT2_DEFM_DEBUG)
-- 
2.16.2.dirty
