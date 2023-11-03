Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7EFC4167B
	for <linux-ext4@archiver.kernel.org>; Fri,  3 Nov 2023 06:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjKCG6H (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 3 Nov 2023 02:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjKCG6F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Nov 2023 02:58:05 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12CC131
        for <linux-ext4@vger.kernel.org>; Thu,  2 Nov 2023 23:58:02 -0700 (PDT)
Received: from kwepemm000013.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SMBM41zV8zrTrk;
        Fri,  3 Nov 2023 14:54:56 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 3 Nov
 2023 14:58:00 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <chengzhihao1@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH 1/5] jbd2: Add errseq to detect client fs's bdev writeback error
Date:   Fri, 3 Nov 2023 22:52:46 +0800
Message-ID: <20231103145250.2995746-2-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231103145250.2995746-1-chengzhihao1@huawei.com>
References: <20231103145250.2995746-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm000013.china.huawei.com (7.193.23.81)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Add errseq in journal, so that JBD2 can detect whether metadata is
successfully fallen on fs bdev. This patch adds detection in recovery
process to replace original solution(using local variable wb_err).

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/journal.c    |  1 +
 fs/jbd2/recovery.c   |  7 +------
 include/linux/jbd2.h | 26 ++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 30dec2bd2ecc..a655d9a88f79 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1535,6 +1535,7 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_total_len = len;
+	jbd2_init_fs_dev_write_error(journal);
 
 	err = journal_load_superblock(journal);
 	if (err)
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 01f744cb97a4..1f7664984d6e 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -289,8 +289,6 @@ int jbd2_journal_recover(journal_t *journal)
 	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
-	errseq_t		wb_err;
-	struct address_space	*mapping;
 
 	memset(&info, 0, sizeof(info));
 	sb = journal->j_superblock;
@@ -308,9 +306,6 @@ int jbd2_journal_recover(journal_t *journal)
 		return 0;
 	}
 
-	wb_err = 0;
-	mapping = journal->j_fs_dev->bd_inode->i_mapping;
-	errseq_check_and_advance(&mapping->wb_err, &wb_err);
 	err = do_one_pass(journal, &info, PASS_SCAN);
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REVOKE);
@@ -334,7 +329,7 @@ int jbd2_journal_recover(journal_t *journal)
 	err2 = sync_blockdev(journal->j_fs_dev);
 	if (!err)
 		err = err2;
-	err2 = errseq_check_and_advance(&mapping->wb_err, &wb_err);
+	err2 = jbd2_check_fs_dev_write_error(journal);
 	if (!err)
 		err = err2;
 	/* Make sure all replayed data is on permanent storage */
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 52772c826c86..15798f88ade4 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -998,6 +998,13 @@ struct journal_s
 	 */
 	struct block_device	*j_fs_dev;
 
+	/**
+	 * @j_fs_dev_wb_err:
+	 *
+	 * Records the errseq of the client fs's backing block device.
+	 */
+	errseq_t		j_fs_dev_wb_err;
+
 	/**
 	 * @j_total_len: Total maximum capacity of the journal region on disk.
 	 */
@@ -1695,6 +1702,25 @@ static inline void jbd2_journal_abort_handle(handle_t *handle)
 	handle->h_aborted = 1;
 }
 
+static inline void jbd2_init_fs_dev_write_error(journal_t *journal)
+{
+	struct address_space *mapping = journal->j_fs_dev->bd_inode->i_mapping;
+
+	/*
+	 * Save the original wb_err value of client fs's bdev mapping which
+	 * could be used to detect the client fs's metadata async write error.
+	 */
+	errseq_check_and_advance(&mapping->wb_err, &journal->j_fs_dev_wb_err);
+}
+
+static inline int jbd2_check_fs_dev_write_error(journal_t *journal)
+{
+	struct address_space *mapping = journal->j_fs_dev->bd_inode->i_mapping;
+
+	return errseq_check(&mapping->wb_err,
+			    READ_ONCE(journal->j_fs_dev_wb_err));
+}
+
 #endif /* __KERNEL__   */
 
 /* Comparison functions for transaction IDs: perform comparisons using
-- 
2.39.2

