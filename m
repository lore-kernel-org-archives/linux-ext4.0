Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:35098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727026AbfAJDdW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Jan 2019 22:33:22 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B5E97BB855B1D4452EAB
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2019 11:33:20 +0800 (CST)
From: yangerkun <yangerkun@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <miaoxie@huawei.com>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 1/4] ext4: fix check of inode in swap_inode_boot_loader
Date: Thu, 10 Jan 2019 11:36:47 +0800
Message-ID: <20190110033650.108403-2-yangerkun@huawei.com>
In-Reply-To: <20190110033650.108403-1-yangerkun@huawei.com>
References: <20190110033650.108403-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What there need to be checked should be protected by inode lock.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext4/ioctl.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0edee31..579ebe5 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -116,15 +116,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	struct inode *inode_bl;
 	struct ext4_inode_info *ei_bl;
 
-	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
-	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
-	    ext4_has_inline_data(inode))
-		return -EINVAL;
-
-	if (IS_RDONLY(inode) || IS_APPEND(inode) || IS_IMMUTABLE(inode) ||
-	    !inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
@@ -137,6 +128,19 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	 * that only 1 swap_inode_boot_loader is running. */
 	lock_two_nondirectories(inode, inode_bl);
 
+	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
+	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
+	    ext4_has_inline_data(inode)) {
+		err = -EINVAL;
+		goto journal_err_out;
+	}
+
+	if (IS_RDONLY(inode) || IS_APPEND(inode) || IS_IMMUTABLE(inode) ||
+	    !inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto journal_err_out;
+	}
+
 	/* Wait for all existing dio workers */
 	inode_dio_wait(inode);
 	inode_dio_wait(inode_bl);
-- 
2.9.5
