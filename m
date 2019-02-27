Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C7BC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 02:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67949218CD
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 02:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfB0CWu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Feb 2019 21:22:50 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729527AbfB0CWu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 26 Feb 2019 21:22:50 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 707BED1C77651EBE3B3C;
        Wed, 27 Feb 2019 10:22:48 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.408.0; Wed, 27 Feb 2019
 10:22:39 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ext4: remove useless ext4_pin_inode()
Date:   Wed, 27 Feb 2019 10:20:48 +0800
Message-ID: <20190227022048.22887-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This function is never used from the beginning. Let's remove it.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 fs/ext4/inode.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34d7e0703cc6..0060d08edd92 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6089,36 +6089,6 @@ void ext4_dirty_inode(struct inode *inode, int flags)
 	return;
 }
 
-#if 0
-/*
- * Bind an inode's backing buffer_head into this transaction, to prevent
- * it from being flushed to disk early.  Unlike
- * ext4_reserve_inode_write, this leaves behind no bh reference and
- * returns no iloc structure, so the caller needs to repeat the iloc
- * lookup to mark the inode dirty later.
- */
-static int ext4_pin_inode(handle_t *handle, struct inode *inode)
-{
-	struct ext4_iloc iloc;
-
-	int err = 0;
-	if (handle) {
-		err = ext4_get_inode_loc(inode, &iloc);
-		if (!err) {
-			BUFFER_TRACE(iloc.bh, "get_write_access");
-			err = jbd2_journal_get_write_access(handle, iloc.bh);
-			if (!err)
-				err = ext4_handle_dirty_metadata(handle,
-								 NULL,
-								 iloc.bh);
-			brelse(iloc.bh);
-		}
-	}
-	ext4_std_error(inode->i_sb, err);
-	return err;
-}
-#endif
-
 int ext4_change_inode_journal_flag(struct inode *inode, int val)
 {
 	journal_t *journal;
-- 
2.14.5

