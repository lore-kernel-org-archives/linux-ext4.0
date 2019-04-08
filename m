Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF002C282DD
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 08:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE8720880
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 08:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="bPOtHBlA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfDHIfR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:35:17 -0400
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:54283 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfDHIfR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 04:35:17 -0400
Received: from ios.cs.uni-dortmund.de (ios.cs.uni-dortmund.de [129.217.43.100])
        (authenticated bits=0)
        by unimail.uni-dortmund.de (8.16.0.41/8.16.0.41) with ESMTPSA id x388Z04q016387
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 8 Apr 2019 10:35:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
        s=unimail; t=1554712504;
        bh=x27WdPJIvTASEktR14WEHuD39tiDkGt0trZKznQVjgc=;
        h=From:To:Cc:Subject:Date;
        b=bPOtHBlA6mMk/blHk8rN6mRrKRB7NNhc5XU7G0UE6jGX0ycgfw0y6WIK0S7JQmpVB
         ZkYsUPjRbU47c7ItCGsMDhwANCBG6Quxq0FI5SZa0uS1ETGw30lKfvJiSXfCgUNyXX
         UsalZbKNw+WjeC/aMYoWsdOGvvxeYOCAmwAiqbXw=
From:   Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To:     tytso@mit.edu
Cc:     Alexander Lochmann <alexander.lochmann@tu-dortmund.de>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] Updated locking documentation for transaction_t
Date:   Mon,  8 Apr 2019 10:35:00 +0200
Message-Id: <20190408083500.66759-1-alexander.lochmann@tu-dortmund.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We used LockDoc to derive locking rules for each member
of struct transaction_t.
Based on those results, we extended the existing documentation
by more members of struct transaction_t, and updated the existing
documentation.

Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
---
 include/linux/jbd2.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5fe84f..34b728e2b702 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -534,6 +534,7 @@ struct transaction_chp_stats_s {
  * The transaction keeps track of all of the buffers modified by a
  * running transaction, and all of the buffers committed but not yet
  * flushed to home for finished transactions.
+ * (Locking Documentation improved by LockDoc)
  */
 
 /*
@@ -652,12 +653,12 @@ struct transaction_s
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

