Return-Path: <SRS0=5xRJ=B5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DCCC433DF
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 12:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87967206FA
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 12:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHSMbm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 19 Aug 2020 08:31:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45536 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726952AbgHSMbk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Aug 2020 08:31:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AB49E2E7917A994B3512;
        Wed, 19 Aug 2020 20:31:36 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 20:31:26 +0800
From:   Shijie Luo <luoshijie1@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <linfeilong@huawei.com>
Subject: [PATCH] jbd2: remove unnecessary chksum variables in do_one_pass
Date:   Wed, 19 Aug 2020 08:29:55 -0400
Message-ID: <20200819122955.33526-1-luoshijie1@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Remove unnecessary chksum variables, and add a chksum_err
 branch to make it cleaner.

Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/recovery.c | 46 ++++++++++++----------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 2ed278f0dced..faa97d748474 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -690,14 +690,11 @@ static int do_one_pass(journal_t *journal,
 			 * number. */
 			if (pass == PASS_SCAN &&
 			    jbd2_has_feature_checksum(journal)) {
-				int chksum_err, chksum_seen;
 				struct commit_header *cbh =
 					(struct commit_header *)bh->b_data;
 				unsigned found_chksum =
 					be32_to_cpu(cbh->h_chksum[0]);
 
-				chksum_err = chksum_seen = 0;
-
 				if (info->end_transaction) {
 					journal->j_failed_commit =
 						info->end_transaction;
@@ -705,42 +702,23 @@ static int do_one_pass(journal_t *journal,
 					break;
 				}
 
-				if (crc32_sum == found_chksum &&
-				    cbh->h_chksum_type == JBD2_CRC32_CHKSUM &&
-				    cbh->h_chksum_size ==
-						JBD2_CRC32_CHKSUM_SIZE)
-				       chksum_seen = 1;
-				else if (!(cbh->h_chksum_type == 0 &&
-					     cbh->h_chksum_size == 0 &&
-					     found_chksum == 0 &&
-					     !chksum_seen))
-				/*
-				 * If fs is mounted using an old kernel and then
-				 * kernel with journal_chksum is used then we
-				 * get a situation where the journal flag has
-				 * checksum flag set but checksums are not
-				 * present i.e chksum = 0, in the individual
-				 * commit blocks.
-				 * Hence to avoid checksum failures, in this
-				 * situation, this extra check is added.
-				 */
-						chksum_err = 1;
-
-				if (chksum_err) {
-					info->end_transaction = next_commit_ID;
-
-					if (!jbd2_has_feature_async_commit(journal)) {
-						journal->j_failed_commit =
-							next_commit_ID;
-						brelse(bh);
-						break;
-					}
-				}
+				/* Neither checksum match nor unused? */
+				if (!((crc32_sum == found_chksum &&
+				       cbh->h_chksum_type ==
+						JBD2_CRC32_CHKSUM &&
+				       cbh->h_chksum_size ==
+						JBD2_CRC32_CHKSUM_SIZE) ||
+				      (cbh->h_chksum_type == 0 &&
+				       cbh->h_chksum_size == 0 &&
+				       found_chksum == 0)))
+					goto chksum_error;
+
 				crc32_sum = ~0;
 			}
 			if (pass == PASS_SCAN &&
 			    !jbd2_commit_block_csum_verify(journal,
 							   bh->b_data)) {
+			chksum_error:
 				info->end_transaction = next_commit_ID;
 
 				if (!jbd2_has_feature_async_commit(journal)) {
-- 
2.19.1

