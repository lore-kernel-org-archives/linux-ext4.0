Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240DDC47089
	for <linux-ext4@archiver.kernel.org>; Thu, 27 May 2021 13:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 076B2613CC
	for <linux-ext4@archiver.kernel.org>; Thu, 27 May 2021 13:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhE0NtA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 27 May 2021 09:49:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2065 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbhE0Nsz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 27 May 2021 09:48:55 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FrTXM3Fp4zWp36;
        Thu, 27 May 2021 21:42:43 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme752-chm.china.huawei.com
 (10.3.19.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 27
 May 2021 21:47:18 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <yi.zhang@huawei.com>, <yukuai3@huawei.com>
Subject: [RFC PATCH v3 4/8] jbd2: remove redundant buffer io error checks
Date:   Thu, 27 May 2021 21:56:37 +0800
Message-ID: <20210527135641.420514-5-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210527135641.420514-1-yi.zhang@huawei.com>
References: <20210527135641.420514-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme752-chm.china.huawei.com (10.3.19.98)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Now that __jbd2_journal_remove_checkpoint() can detect buffer io error
and mark journal checkpoint error, then we abort the journal later
before updating log tail to ensure the filesystem works consistently.
So we could remove other redundant buffer io error checkes.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/jbd2/checkpoint.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 2cbac0e3cff3..c1f746a5cc1a 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -91,8 +91,7 @@ static int __try_to_free_cp_buf(struct journal_head *jh)
 	int ret = 0;
 	struct buffer_head *bh = jh2bh(jh);
 
-	if (jh->b_transaction == NULL && !buffer_locked(bh) &&
-	    !buffer_dirty(bh) && !buffer_write_io_error(bh)) {
+	if (!jh->b_transaction && !buffer_locked(bh) && !buffer_dirty(bh)) {
 		JBUFFER_TRACE(jh, "remove from checkpoint list");
 		ret = __jbd2_journal_remove_checkpoint(jh) + 1;
 	}
@@ -295,8 +294,6 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 			goto restart;
 		}
 		if (!buffer_dirty(bh)) {
-			if (unlikely(buffer_write_io_error(bh)) && !result)
-				result = -EIO;
 			BUFFER_TRACE(bh, "remove from checkpoint");
 			if (__jbd2_journal_remove_checkpoint(jh))
 				/* The transaction was released; we're done */
@@ -356,8 +353,6 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 			spin_lock(&journal->j_list_lock);
 			goto restart2;
 		}
-		if (unlikely(buffer_write_io_error(bh)) && !result)
-			result = -EIO;
 
 		/*
 		 * Now in whatever state the buffer currently is, we
-- 
2.25.4

