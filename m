Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,TVD_PH_SUBJ_META1,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6854AC282C3
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 06:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BDD320861
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 06:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfAVGyv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Jan 2019 01:54:51 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44024 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727312AbfAVGyt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Jan 2019 01:54:49 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 80AAFDD5CDB767B230CC;
        Tue, 22 Jan 2019 14:54:46 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.408.0; Tue, 22 Jan 2019 14:54:39 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <miaoxie@huawei.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <yangerkun@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: [PATCH V2 3/4] ext4: update quota information while swapping boot loader inode
Date:   Tue, 22 Jan 2019 14:58:22 +0800
Message-ID: <20190122065823.67957-4-yangerkun@huawei.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20190122065823.67957-1-yangerkun@huawei.com>
References: <20190122065823.67957-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

While do swap between two inode, they swap i_data without update
quota information. Also, swap_inode_boot_loader can do "revert"
somtimes, so update the quota while all operations has been finished.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext4/ioctl.c | 56 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index ea05e8d..eff6835 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -68,8 +68,6 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	ei2 = EXT4_I(inode2);
 
 	swap(inode1->i_version, inode2->i_version);
-	swap(inode1->i_blocks, inode2->i_blocks);
-	swap(inode1->i_bytes, inode2->i_bytes);
 	swap(inode1->i_atime, inode2->i_atime);
 	swap(inode1->i_mtime, inode2->i_mtime);
 
@@ -115,6 +113,9 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	int err;
 	struct inode *inode_bl;
 	struct ext4_inode_info *ei_bl;
+	qsize_t size, size_bl, diff;
+	blkcnt_t blocks;
+	unsigned short bytes;
 
 	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(inode_bl))
@@ -180,6 +181,13 @@ static long swap_inode_boot_loader(struct super_block *sb,
 			memset(ei_bl->i_data, 0, sizeof(ei_bl->i_data));
 	}
 
+	err = dquot_initialize(inode);
+	if (err)
+		goto err_out1;
+
+	size = (qsize_t)(inode->i_blocks) * (1 << 9) + inode->i_bytes;
+	size_bl = (qsize_t)(inode_bl->i_blocks) * (1 << 9) + inode_bl->i_bytes;
+	diff = size - size_bl;
 	swap_inode_data(inode, inode_bl);
 
 	inode->i_ctime = inode_bl->i_ctime = current_time(inode);
@@ -193,24 +201,46 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err < 0) {
+		/* No need to update quota information. */
 		ext4_warning(inode->i_sb,
 			"couldn't mark inode #%lu dirty (err %d)",
 			inode->i_ino, err);
 		/* Revert all changes: */
 		swap_inode_data(inode, inode_bl);
 		ext4_mark_inode_dirty(handle, inode);
-	} else {
-		err = ext4_mark_inode_dirty(handle, inode_bl);
-		if (err < 0) {
-			ext4_warning(inode_bl->i_sb,
-				"couldn't mark inode #%lu dirty (err %d)",
-				inode_bl->i_ino, err);
-			/* Revert all changes: */
-			swap_inode_data(inode, inode_bl);
-			ext4_mark_inode_dirty(handle, inode);
-			ext4_mark_inode_dirty(handle, inode_bl);
-		}
+		goto err_out1;
+	}
+
+	blocks = inode_bl->i_blocks;
+	bytes = inode_bl->i_bytes;
+	inode_bl->i_blocks = inode->i_blocks;
+	inode_bl->i_bytes = inode->i_bytes;
+	err = ext4_mark_inode_dirty(handle, inode_bl);
+	if (err < 0) {
+		/* No need to update quota information. */
+		ext4_warning(inode_bl->i_sb,
+			"couldn't mark inode #%lu dirty (err %d)",
+			inode_bl->i_ino, err);
+		goto revert;
 	}
+
+	/* Bootloader inode should not be counted into quota information. */
+	if (diff > 0)
+		dquot_free_space(inode, diff);
+	else
+		err = dquot_alloc_space(inode, -1 * diff);
+
+	if (err < 0) {
+revert:
+		/* Revert all changes: */
+		inode_bl->i_blocks = blocks;
+		inode_bl->i_bytes = bytes;
+		swap_inode_data(inode, inode_bl);
+		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode_bl);
+	}
+
+err_out1:
 	ext4_journal_stop(handle);
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
-- 
2.9.5

