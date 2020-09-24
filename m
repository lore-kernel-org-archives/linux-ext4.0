Return-Path: <SRS0=Pl0f=DB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA271C4346E
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 07:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F54521D91
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 07:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgIXHct (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Sep 2020 03:32:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbgIXHct (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Sep 2020 03:32:49 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 62F22D86E4925881FA69;
        Thu, 24 Sep 2020 15:32:47 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 24 Sep 2020
 15:32:39 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>
Subject: [PATCH v2 4/7] ext4: use ext4_buffer_uptodate() in __ext4_get_inode_loc()
Date:   Thu, 24 Sep 2020 15:33:34 +0800
Message-ID: <20200924073337.861472-5-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200924073337.861472-1-yi.zhang@huawei.com>
References: <20200924073337.861472-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We have already introduced ext4_buffer_uptodate() to re-set the uptodate
bit on buffer which has been failed to write out to disk. Just remove
the redundant codes and switch to use ext4_buffer_uptodate() in
__ext4_get_inode_loc().

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3661ed126c5f..171df289ef7e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4287,16 +4287,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	if (!buffer_uptodate(bh)) {
 		lock_buffer(bh);
 
-		/*
-		 * If the buffer has the write error flag, we have failed
-		 * to write out another inode in the same block.  In this
-		 * case, we don't have to read the block because we may
-		 * read the old inode data successfully.
-		 */
-		if (buffer_write_io_error(bh) && !buffer_uptodate(bh))
-			set_buffer_uptodate(bh);
-
-		if (buffer_uptodate(bh)) {
+		if (ext4_buffer_uptodate(bh)) {
 			/* someone brought it uptodate while we waited */
 			unlock_buffer(bh);
 			goto has_buffer;
-- 
2.25.4

