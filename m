Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:60680 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726978AbfAJDdW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Jan 2019 22:33:22 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8FEF63BED078F0CF1348
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2019 11:33:20 +0800 (CST)
From: yangerkun <yangerkun@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <miaoxie@huawei.com>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 3/4] ext4: update quota information while swapping boot loader inode
Date: Thu, 10 Jan 2019 11:36:49 +0800
Message-ID: <20190110033650.108403-4-yangerkun@huawei.com>
In-Reply-To: <20190110033650.108403-1-yangerkun@huawei.com>
References: <20190110033650.108403-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The quota information should also be update.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext4/ioctl.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index fdfada3..60d406f 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -63,13 +63,14 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	loff_t isize;
 	struct ext4_inode_info *ei1;
 	struct ext4_inode_info *ei2;
+	struct inode *big_inode;
+	struct inode *small_inode;
+	qsize_t size1, size2, diff;
 
 	ei1 = EXT4_I(inode1);
 	ei2 = EXT4_I(inode2);
 
 	swap(inode1->i_version, inode2->i_version);
-	swap(inode1->i_blocks, inode2->i_blocks);
-	swap(inode1->i_bytes, inode2->i_bytes);
 	swap(inode1->i_atime, inode2->i_atime);
 	swap(inode1->i_mtime, inode2->i_mtime);
 
@@ -79,6 +80,21 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
 	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
 
+	size1 = (qsize_t)(inode1->i_blocks) * (1 << 9) + inode1->i_bytes;
+	size2 = (qsize_t)(inode2->i_blocks) * (1 << 9) + inode2->i_bytes;
+	if (size1 > size2) {
+		big_inode = inode1;
+		small_inode = inode2;
+		diff = size1 - size2;
+	} else {
+		big_inode = inode2;
+		small_inode = inode1;
+		diff = size2 - size1;
+	}
+
+	dquot_alloc_space_nofail(small_inode, diff);
+	dquot_free_space(big_inode, diff);
+
 	isize = i_size_read(inode1);
 	i_size_write(inode1, i_size_read(inode2));
 	i_size_write(inode2, isize);
@@ -180,6 +196,14 @@ static long swap_inode_boot_loader(struct super_block *sb,
 			memset(ei_bl->i_data, 0, sizeof(ei_bl->i_data));
 	}
 
+	err = dquot_initialize(inode);
+	if (err)
+		goto err_out1;
+
+	err = dquot_initialize(inode_bl);
+	if (err)
+		goto err_out1;
+
 	swap_inode_data(inode, inode_bl);
 
 	inode->i_ctime = inode_bl->i_ctime = current_time(inode);
@@ -211,6 +235,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 			ext4_mark_inode_dirty(handle, inode_bl);
 		}
 	}
+err_out1:
 	ext4_journal_stop(handle);
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
-- 
2.9.5
