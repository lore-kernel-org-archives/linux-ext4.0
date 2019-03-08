Return-Path: <SRS0=idm8=RL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF29C43381
	for <linux-ext4@archiver.kernel.org>; Fri,  8 Mar 2019 15:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DCEC208E4
	for <linux-ext4@archiver.kernel.org>; Fri,  8 Mar 2019 15:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="N1quzFS1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfCHPfK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:35:10 -0500
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:49908 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfCHPfK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Mar 2019 10:35:10 -0500
X-Greylist: delayed 1704 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2019 10:35:09 EST
Received: from ios.cs.uni-dortmund.de (ios.cs.uni-dortmund.de [129.217.43.100])
        (authenticated bits=0)
        by unimail.uni-dortmund.de (8.16.0.29/8.16.0.41) with ESMTPSA id x28F653Q023425
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 8 Mar 2019 16:06:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
        s=unimail; t=1552057573;
        bh=PWNiNjlc9N/RtIFVtL/iGsr1nM93mWZMXl8l7RoKb68=;
        h=From:To:Cc:Subject:Date;
        b=N1quzFS1wZrASeq3RfeaTp4E4bTMoc63P944IsyNjnq1IQT8MmwCNluDym4Z7pOVv
         j+/S69NST0ts9+KbA++Xr03Jc5FClTMpQ5984SRTlYFk6kkXljIcTatK01rTbSrVnA
         LwYqe/1ZKbq0g1RKW4oLKqG0vlGA7J5OBRDLk2y0=
From:   Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc:     tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lochmann <alexander.lochmann@tu-dortmund.de>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
Subject: [PATCH 1/1] Updated locking documentation for struct journal_t
Date:   Fri,  8 Mar 2019 16:06:05 +0100
Message-Id: <20190308150605.98405-1-alexander.lochmann@tu-dortmund.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We used LockDoc to derive locking rules for each member
of struct journal_t. Based on those results, we extended
the existing documentation by more members
of struct inode, and updated the existing documentation.

Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
---
 include/linux/jbd2.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5fe84f..c1ba44ca515a 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -585,7 +585,8 @@ struct transaction_s
 	}			t_state;
 
 	/*
-	 * Where in the log does this transaction's commit start? [no locking]
+	 * Where in the log does this transaction's commit start?
+	 * [journal_t->j_state_lock]
 	 */
 	unsigned long		t_log_start;
 
@@ -647,17 +648,17 @@ struct transaction_s
 	unsigned long		t_max_wait;
 
 	/*
-	 * When transaction started
+	 * When transaction started [j_state_lock]
 	 */
 	unsigned long		t_start;
 
 	/*
-	 * When commit was requested
+	 * When commit was requested [j_state_lock]
 	 */
 	unsigned long		t_requested;
 
 	/*
-	 * Checkpointing stats [j_checkpoint_sem]
+	 * Checkpointing stats [j_list_lock]
 	 */
 	struct transaction_chp_stats_s t_chp_stats;
 
@@ -744,6 +745,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
 /**
  * struct journal_s - The journal_s type is the concrete type associated with
  *     journal_t.
+ * (Locking Documentation improved by LockDoc)
  */
 struct journal_s
 {
@@ -762,6 +764,7 @@ struct journal_s
 
 	/**
 	 * @j_sb_buffer: The first part of the superblock buffer.
+	 * [j_checkpoint_mutex]
 	 */
 	struct buffer_head	*j_sb_buffer;
 
@@ -1015,6 +1018,7 @@ struct journal_s
 	 * @j_commit_interval:
 	 *
 	 * What is the maximum transaction lifetime before we begin a commit?
+	 * [super_block->s_umount]
 	 */
 	unsigned long		j_commit_interval;
 
@@ -1032,7 +1036,7 @@ struct journal_s
 	 * @j_revoke:
 	 *
 	 * The revoke table - maintains the list of revoked blocks in the
-	 * current transaction.
+	 * current transaction. [j_state_lock]
 	 */
 	struct jbd2_revoke_table_s *j_revoke;
 
-- 
2.20.1

