Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:17128 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbfAJF2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 00:28:17 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8AF00AC3A152A8DEFD7E
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2019 13:28:15 +0800 (CST)
From: yangerkun <yangerkun@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <miaoxie@huawei.com>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH] ext2: add check for blocksize in ext2_fill_super
Date: Thu, 10 Jan 2019 13:31:45 +0800
Message-ID: <20190110053145.138518-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While mkfs with '-b 65536' and then mount this fs with arm 64KB page
size, function mount_fs will trigger WARNING because that ext2_max_size
will return value less than 0. Also, we cannot write any file in this
fs since the sb->s_maxbytes is less than 0. Avoid this by check blocksize
in ext2_fill_super like ext4_fill_super.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext2/ext2.h  |  1 +
 fs/ext2/super.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index e770cd1..ba95316 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -177,6 +177,7 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
 #define EXT2_MIN_BLOCK_SIZE		1024
 #define	EXT2_MAX_BLOCK_SIZE		4096
 #define EXT2_MIN_BLOCK_LOG_SIZE		  10
+#define EXT2_MAX_BLOCK_LOG_SIZE		  12
 #define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
 #define	EXT2_ADDR_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (__u32))
 #define EXT2_BLOCK_SIZE_BITS(s)		((s)->s_blocksize_bits)
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 73b2d52..029945e 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -960,6 +960,21 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
+	if (blocksize < EXT2_MIN_BLOCK_SIZE ||
+		blocksize > EXT2_MAX_BLOCK_SIZE) {
+		ext2_msg(sb, KERN_ERR,
+				"Unsupported filesystem blocksize %d (%d log_block_size)",
+				blocksize, le32_to_cpu(es->s_log_block_size));
+		goto failed_mount;
+	}
+
+	if (le32_to_cpu(es->s_log_block_size) >
+		(EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE)) {
+			ext2_msg(sb, KERN_ERR,
+				"Invalid log block size: %u",
+				le32_to_cpu(es->s_log_block_size));
+			goto failed_mount;
+		}
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
 		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
-- 
2.9.5
