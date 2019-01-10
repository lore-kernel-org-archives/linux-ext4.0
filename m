Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:60674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727015AbfAJDdW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Jan 2019 22:33:22 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 86370C9DFB17C13B86FF
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2019 11:33:20 +0800 (CST)
From: yangerkun <yangerkun@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <miaoxie@huawei.com>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 2/4] ext4: cleanup pagecache before swap i_data
Date: Thu, 10 Jan 2019 11:36:48 +0800
Message-ID: <20190110033650.108403-3-yangerkun@huawei.com>
In-Reply-To: <20190110033650.108403-1-yangerkun@huawei.com>
References: <20190110033650.108403-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure new dirty page will not appear.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext4/ioctl.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 579ebe5..fdfada3 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -121,9 +121,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);
 
-	filemap_flush(inode->i_mapping);
-	filemap_flush(inode_bl->i_mapping);
-
 	/* Protect orig inodes against a truncate and make sure,
 	 * that only 1 swap_inode_boot_loader is running. */
 	lock_two_nondirectories(inode, inode_bl);
@@ -141,6 +138,15 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		goto journal_err_out;
 	}
 
+	down_write(&EXT4_I(inode)->i_mmap_sem);
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto err_out;
+
+	err = filemap_write_and_wait(inode_bl->i_mapping);
+	if (err)
+		goto err_out;
+
 	/* Wait for all existing dio workers */
 	inode_dio_wait(inode);
 	inode_dio_wait(inode_bl);
@@ -151,7 +157,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	handle = ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
 	if (IS_ERR(handle)) {
 		err = -EINVAL;
-		goto journal_err_out;
+		goto err_out;
 	}
 
 	/* Protect extent tree against block allocations via delalloc */
@@ -208,6 +214,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	ext4_journal_stop(handle);
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
+err_out:
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 journal_err_out:
 	unlock_two_nondirectories(inode, inode_bl);
 	iput(inode_bl);
-- 
2.9.5
