Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A69C433B4
	for <linux-ext4@archiver.kernel.org>; Mon, 26 Apr 2021 06:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D33611F0
	for <linux-ext4@archiver.kernel.org>; Mon, 26 Apr 2021 06:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhDZGaa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 26 Apr 2021 02:30:30 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:42661 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231616AbhDZGa3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Apr 2021 02:30:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UWlCGB._1619418587;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UWlCGB._1619418587)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 26 Apr 2021 14:29:47 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     riteshh@linux.ibm.com, linux-ext4@vger.kernel.org
Subject: [PATCH v2] ext4: remove redundant check buffer_uptodate()
Date:   Mon, 26 Apr 2021 14:29:47 +0800
Message-Id: <1619418587-5580-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Now set_buffer_uptodate() will test first and then set, so we don't have
to check buffer_uptodate() first, remove it to simplify code.

Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
v2: change ext4_buffer_uptodate() as well suggested by Ritesh.

 fs/ext4/ext4.h  | 2 +-
 fs/ext4/inode.c | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 826a56e..92b06c7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3727,7 +3727,7 @@ static inline int ext4_buffer_uptodate(struct buffer_head *bh)
 	 * have to read the block because we may read the old data
 	 * successfully.
 	 */
-	if (!buffer_uptodate(bh) && buffer_write_io_error(bh))
+	if (buffer_write_io_error(bh))
 		set_buffer_uptodate(bh);
 	return buffer_uptodate(bh);
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0948a43..9e02538 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1065,10 +1065,8 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 	    block++, block_start = block_end, bh = bh->b_this_page) {
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
-			if (PageUptodate(page)) {
-				if (!buffer_uptodate(bh))
-					set_buffer_uptodate(bh);
-			}
+			if (PageUptodate(page))
+				set_buffer_uptodate(bh);
 			continue;
 		}
 		if (buffer_new(bh))
@@ -1092,8 +1090,7 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 			}
 		}
 		if (PageUptodate(page)) {
-			if (!buffer_uptodate(bh))
-				set_buffer_uptodate(bh);
+			set_buffer_uptodate(bh);
 			continue;
 		}
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
-- 
1.8.3.1

