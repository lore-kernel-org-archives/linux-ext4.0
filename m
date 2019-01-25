Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637C7C282C0
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C0632085B
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfAYM1Y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:27:24 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:36104 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727558AbfAYM1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 07:27:22 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D82ACF9FC2AA232268EC;
        Fri, 25 Jan 2019 20:27:19 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Fri, 25 Jan 2019
 20:27:11 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH v3 2/4] jbd2: discard dirty data when forgetting an un-journalled buffer
Date:   Fri, 25 Jan 2019 20:30:54 +0800
Message-ID: <1548419456-4331-3-git-send-email-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
References: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We do not unmap and clear dirty flag when forgetting a buffer without
journal or does not belongs to any transaction, so the invalid dirty
data may still be written to the disk later. It's fine if the
corresponding block is never used before the next mount, and it's also
fine that we invoke clean_bdev_aliases() related functions to unmap
the block device mapping when re-allocating such freed block as data
block. But this logic is somewhat fragile and risky that may lead to
data corruption if we forget to clean bdev aliases. So, It's better to
discard dirty data during forget time.

We have been already handled all the cases of forgetting journalled
buffer, this patch deal with the remaining two cases.

- buffer is not journalled yet,
- buffer is journalled but doesn't belongs to any transaction.

We invoke __bforget() instead of __brelese() when forgetting an
un-journalled buffer in jbd2_journal_forget(). After this patch we can
remove all clean_bdev_aliases() related calls in ext4.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/jbd2/transaction.c | 43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 0c0cbda..8825d45 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1597,9 +1597,7 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 			__jbd2_journal_unfile_buffer(jh);
 			if (!buffer_jbd(bh)) {
 				spin_unlock(&journal->j_list_lock);
-				jbd_unlock_bh_state(bh);
-				__bforget(bh);
-				goto drop;
+				goto not_jbd;
 			}
 		}
 		spin_unlock(&journal->j_list_lock);
@@ -1632,9 +1630,41 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 			if (was_modified)
 				drop_reserve = 1;
 		}
+	} else {
+		/*
+		 * Finally, if the buffer is not belongs to any
+		 * transaction, we can just drop it now if it has no
+		 * checkpoint.
+		 */
+		spin_lock(&journal->j_list_lock);
+		if (!jh->b_cp_transaction) {
+			JBUFFER_TRACE(jh, "belongs to none transaction");
+			spin_unlock(&journal->j_list_lock);
+			goto not_jbd;
+		}
+
+		/*
+		 * Otherwise, if the buffer has been written to disk,
+		 * it is safe to remove the checkpoint and drop it.
+		 */
+		if (!buffer_dirty(bh)) {
+			__jbd2_journal_remove_checkpoint(jh);
+			spin_unlock(&journal->j_list_lock);
+			goto not_jbd;
+		}
+
+		/*
+		 * The buffer is still not written to disk, we should
+		 * attach this buffer to current transaction to prevent
+		 * missing writing back when doing checkpoint before
+		 * the current transaction complete submittion.
+		 */
+		__jbd2_journal_temp_unlink_buffer(jh);
+		clear_buffer_dirty(bh);
+		__jbd2_journal_file_buffer(jh, transaction, BJ_Forget);
+		spin_unlock(&journal->j_list_lock);
 	}
 
-not_jbd:
 	jbd_unlock_bh_state(bh);
 	__brelse(bh);
 drop:
@@ -1643,6 +1673,11 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 		handle->h_buffer_credits++;
 	}
 	return err;
+
+not_jbd:
+	jbd_unlock_bh_state(bh);
+	__bforget(bh);
+	goto drop;
 }
 
 /**
-- 
2.7.4

