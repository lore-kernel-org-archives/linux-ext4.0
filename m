Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0721FC433B4
	for <linux-ext4@archiver.kernel.org>; Fri,  7 May 2021 07:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA46D61041
	for <linux-ext4@archiver.kernel.org>; Fri,  7 May 2021 07:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhEGHMd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 7 May 2021 03:12:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18006 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhEGHMc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2021 03:12:32 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fc1kP6pMzzQjt6;
        Fri,  7 May 2021 15:08:13 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 7 May 2021
 15:11:21 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <yi.zhang@huawei.com>, <yukuai3@huawei.com>
Subject: [PATCH] ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle
Date:   Fri, 7 May 2021 15:19:04 +0800
Message-ID: <20210507071904.160808-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In ext4_orphan_cleanup(), if ext4_truncate() failed to get a transaction
handle, it didn't remove the inode from the in-core orphan list, which
may probably trigger below error dump in ext4_destroy_inode() during the
final iput() and could lead to memory corruption on the later orphan
list changes.

 EXT4-fs (sda): Inode 6291467 (00000000b8247c67): orphan list check failed!
 00000000b8247c67: 0001f30a 00000004 00000000 00000023  ............#...
 00000000e24cde71: 00000006 014082a3 00000000 00000000  ......@.........
 0000000072c6a5ee: 00000000 00000000 00000000 00000000  ................
 ...

This patch fix this by cleanup in-core orphan list manually if
ext4_truncate() return error.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/super.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7dc94f3e18e6..12850d72e9a4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3101,8 +3101,15 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 			inode_lock(inode);
 			truncate_inode_pages(inode->i_mapping, inode->i_size);
 			ret = ext4_truncate(inode);
-			if (ret)
+			if (ret) {
+				/*
+				 * We need to clean up the in-core orphan list
+				 * manually if ext4_truncate() failed to get a
+				 * transaction handle.
+				 */
+				ext4_orphan_del(NULL, inode);
 				ext4_std_error(inode->i_sb, ret);
+			}
 			inode_unlock(inode);
 			nr_truncates++;
 		} else {
-- 
2.25.4

