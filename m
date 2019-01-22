Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4593C282C3
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 06:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 748C020861
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 06:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfAVGyt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Jan 2019 01:54:49 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44028 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727308AbfAVGys (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Jan 2019 01:54:48 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7C7A03EB9EC71A421B34;
        Tue, 22 Jan 2019 14:54:46 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.408.0; Tue, 22 Jan 2019 14:54:39 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <miaoxie@huawei.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <yangerkun@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: [PATCH V2 1/4] ext4: fix check of inode in swap_inode_boot_loader
Date:   Tue, 22 Jan 2019 14:58:20 +0800
Message-ID: <20190122065823.67957-2-yangerkun@huawei.com>
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

Before really do swap between inode and boot inode, something need to
check to avoid invalid or not permitted operation, like does this inode
has inline data. But the condition check should be protected by inode
lock to avoid change while swapping. Also some other condition will not
change between swapping, but there has no problem to do this under inode
lock.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext4/ioctl.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d37dafa..597e8b6 100644
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
 	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
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

