Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:60678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726987AbfAJDdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Jan 2019 22:33:23 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8C75B567F56A3EC5E2CD
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2019 11:33:20 +0800 (CST)
From: yangerkun <yangerkun@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <miaoxie@huawei.com>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 4/4] ext4: add mask of ext4 flags to swap
Date: Thu, 10 Jan 2019 11:36:50 +0800
Message-ID: <20190110033650.108403-5-yangerkun@huawei.com>
In-Reply-To: <20190110033650.108403-1-yangerkun@huawei.com>
References: <20190110033650.108403-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Not all flags should be swap, add a mask to do this.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext4/ext4.h  | 4 ++++
 fs/ext4/ioctl.c | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f89d0a..b438a7c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -426,6 +426,10 @@ struct flex_groups {
 /* Flags that are appropriate for non-directories/regular files. */
 #define EXT4_OTHER_FLMASK (EXT4_NODUMP_FL | EXT4_NOATIME_FL)
 
+/* Flags that should be swap */
+#define EXT4_FL_SHOULD_SWAP (EXT4_COMPR_FL | EXT4_COMPRBLK_FL | EXT4_NOCOMPR_FL |\
+			EXT4_HUGE_FILE_FL | EXT4_EXTENTS_FL)
+
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 60d406f..53e26a6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -66,6 +66,7 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	struct inode *big_inode;
 	struct inode *small_inode;
 	qsize_t size1, size2, diff;
+	unsigned long tmp;
 
 	ei1 = EXT4_I(inode1);
 	ei2 = EXT4_I(inode2);
@@ -75,7 +76,10 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	swap(inode1->i_mtime, inode2->i_mtime);
 
 	memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));
-	swap(ei1->i_flags, ei2->i_flags);
+	tmp = ei1->i_flags & EXT4_FL_SHOULD_SWAP;
+	ei1->i_flags = (ei2->i_flags & EXT4_FL_SHOULD_SWAP) |
+		(ei1->i_flags & ~EXT4_FL_SHOULD_SWAP);
+	ei2->i_flags = tmp | (ei2->i_flags & ~EXT4_FL_SHOULD_SWAP);
 	swap(ei1->i_disksize, ei2->i_disksize);
 	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
 	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
-- 
2.9.5
