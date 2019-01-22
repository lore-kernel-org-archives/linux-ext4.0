Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF10C282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 06:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A50120861
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 06:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfAVGyt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Jan 2019 01:54:49 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44032 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727303AbfAVGyt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Jan 2019 01:54:49 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8978369B12092F0E14F0;
        Tue, 22 Jan 2019 14:54:46 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.408.0; Tue, 22 Jan 2019 14:54:39 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <miaoxie@huawei.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <yangerkun@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: [PATCH V2 2/4] ext4: cleanup pagecache before swap i_data
Date:   Tue, 22 Jan 2019 14:58:21 +0800
Message-ID: <20190122065823.67957-3-yangerkun@huawei.com>
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

While do swap, we should make sure there has no new dirty page since we
should swap i_data between two inode:
1.We should locki i_mmap_sem with write to avoid new pagecache from mmap
read/write;
2.Change filemap_flush to filemap_write_and_wait and move them to the
space protected by inode lock to avoid new pagecache from buffer read/write.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext4/ioctl.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 597e8b6..ea05e8d 100644
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

