Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FCAC282C2
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 228452146E
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfAYMgu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:36:50 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44072 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbfAYMgu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 07:36:50 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 215674E1EA2CF31A30E4;
        Fri, 25 Jan 2019 20:36:48 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.408.0; Fri, 25 Jan 2019
 20:36:37 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH] jbd2: fix race when writing superblock
Date:   Fri, 25 Jan 2019 20:40:23 +0800
Message-ID: <1548420023-8519-1-git-send-email-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The jbd2 superblock is lockless now, so there is probably a race
condition between writing it so disk and modifing contents of it, which
may lead to checksum error. The following race is the one case that we
have captured.

jbd2                                fsstress
jbd2_journal_commit_transaction
 jbd2_journal_update_sb_log_tail
  jbd2_write_superblock
   jbd2_superblock_csum_set         jbd2_journal_revoke
                                     jbd2_journal_set_features(revork)
                                     modify superblock
   submit_bh(checksum incorrect)

One alternative fix is to lock the buffer everywhere that modifing it,
but it may expensive. So this patch introduce an in-memory jbd2
superblock, update it to the on-disk superblock and calculate checksum
at write time.

This checksum corruption problem can be reproduced by xfstests
generic/475.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/jbd2/journal.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8ef6b6d..ad59909 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1133,6 +1133,7 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	static struct lock_class_key jbd2_trans_commit_key;
 	journal_t *journal;
 	int err;
+	journal_superblock_t *sb = NULL;
 	struct buffer_head *bh;
 	int n;
 
@@ -1182,6 +1183,10 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	if (!journal->j_wbuf)
 		goto err_cleanup;
 
+	sb = kzalloc(sizeof(*sb), GFP_KERNEL);
+	if (!sb)
+		goto err_cleanup;
+
 	bh = getblk_unmovable(journal->j_dev, start, journal->j_blocksize);
 	if (!bh) {
 		pr_err("%s: Cannot get buffer for journal superblock\n",
@@ -1189,11 +1194,12 @@ static journal_t *journal_init_common(struct block_device *bdev,
 		goto err_cleanup;
 	}
 	journal->j_sb_buffer = bh;
-	journal->j_superblock = (journal_superblock_t *)bh->b_data;
+	journal->j_superblock = sb;
 
 	return journal;
 
 err_cleanup:
+	kfree(sb);
 	kfree(journal->j_wbuf);
 	jbd2_journal_destroy_revoke(journal);
 	kfree(journal);
@@ -1360,6 +1366,7 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
 	journal_superblock_t *sb = journal->j_superblock;
+	journal_superblock_t *raw_sb = (journal_superblock_t *)bh->b_data;
 	int ret;
 
 	trace_jbd2_write_superblock(journal, write_flags);
@@ -1381,7 +1388,8 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 		clear_buffer_write_io_error(bh);
 		set_buffer_uptodate(bh);
 	}
-	jbd2_superblock_csum_set(journal, sb);
+	memcpy(raw_sb, sb, sizeof(journal_superblock_t));
+	jbd2_superblock_csum_set(journal, raw_sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	ret = submit_bh(REQ_OP_WRITE, write_flags, bh);
@@ -1507,7 +1515,7 @@ EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 static int journal_get_superblock(journal_t *journal)
 {
 	struct buffer_head *bh;
-	journal_superblock_t *sb;
+	journal_superblock_t *sb, *raw_sb;
 	int err = -EIO;
 
 	bh = journal->j_sb_buffer;
@@ -1526,7 +1534,9 @@ static int journal_get_superblock(journal_t *journal)
 	if (buffer_verified(bh))
 		return 0;
 
+	raw_sb = (journal_superblock_t *)bh->b_data;
 	sb = journal->j_superblock;
+	memcpy(sb, raw_sb, sizeof(journal_superblock_t));
 
 	err = -EINVAL;
 
@@ -1777,6 +1787,7 @@ int jbd2_journal_destroy(journal_t *journal)
 		jbd2_journal_destroy_revoke(journal);
 	if (journal->j_chksum_driver)
 		crypto_free_shash(journal->j_chksum_driver);
+	kfree(journal->j_superblock);
 	kfree(journal->j_wbuf);
 	kfree(journal);
 
-- 
2.7.4

