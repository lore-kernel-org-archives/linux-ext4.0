Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A992FC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 18:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 745A92077B
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 18:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="m4PycWOT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfCRSnR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 14:43:17 -0400
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:59758 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfCRSnR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 14:43:17 -0400
Received: from ios.cs.uni-dortmund.de (ios.cs.uni-dortmund.de [129.217.43.100])
        (authenticated bits=0)
        by unimail.uni-dortmund.de (8.16.0.29/8.16.0.41) with ESMTPSA id x2IIgbsb013809
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Mar 2019 19:42:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
        s=unimail; t=1552934561;
        bh=dS+Iu0nU7v8R5JF6Pu8kqpuUTNJYAEvRwGOMhzRBqPQ=;
        h=From:To:Cc:Subject:Date;
        b=m4PycWOTX+zaMfX/QktT5IPL7j5snUs2DFAbkWAGFpl6sHLH3RTrUoGqxSMedOCxg
         dmisCnSHmz6HCs1moLBT+cHp9pQL5NWBa0jadUIwysSWtSlugndCYrhH6jEVkB2ZK/
         mdcgIAeC5KofZkai1LWjaBg9Zp+t2UYFf46PaKxE=
From:   Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc:     Alexander Lochmann <alexander.lochmann@tu-dortmund.de>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Updated locking documentation for transaction_t
Date:   Mon, 18 Mar 2019 19:42:37 +0100
Message-Id: <20190318184237.20677-1-alexander.lochmann@tu-dortmund.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We used LockDoc to derive locking rules for each member
of struct transaction_t.
Based on those results, we extended the existing documentation
by more members of struct inode, and updated the existing
documentation.

Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
---
 include/linux/jbd2.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5fe84f..72f689746340 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -534,6 +534,7 @@ struct transaction_chp_stats_s {
  * The transaction keeps track of all of the buffers modified by a
  * running transaction, and all of the buffers committed but not yet
  * flushed to home for finished transactions.
+ * (Locking Documentation improved by LockDoc)
  */
 
 /*
@@ -585,7 +586,8 @@ struct transaction_s
 	}			t_state;
 
 	/*
-	 * Where in the log does this transaction's commit start? [no locking]
+	 * Where in the log does this transaction's commit start?
+	 * [journal_t.j_state_lock]
 	 */
 	unsigned long		t_log_start;
 
@@ -647,17 +649,17 @@ struct transaction_s
 	unsigned long		t_max_wait;
 
 	/*
-	 * When transaction started
+	 * When transaction started [journal_t.j_state_lock]
 	 */
 	unsigned long		t_start;
 
 	/*
-	 * When commit was requested
+	 * When commit was requested [journal_t.j_state_lock]
 	 */
 	unsigned long		t_requested;
 
 	/*
-	 * Checkpointing stats [j_checkpoint_sem]
+	 * Checkpointing stats [journal_t.j_list_lock]
 	 */
 	struct transaction_chp_stats_s t_chp_stats;
 
-- 
2.20.1

