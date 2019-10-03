Return-Path: <SRS0=KV+B=X4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B56C32792
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Oct 2019 22:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5BC2215EA
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Oct 2019 22:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbfJCWFy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Oct 2019 18:05:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:49616 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbfJCWFx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Oct 2019 18:05:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 35054B090;
        Thu,  3 Oct 2019 22:05:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ED3B61E4811; Fri,  4 Oct 2019 00:06:13 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 01/22] jbd2: Fix possible overflow in jbd2_log_space_left()
Date:   Fri,  4 Oct 2019 00:05:47 +0200
Message-Id: <20191003220613.10791-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When number of free space in the journal is very low, the arithmetic in
jbd2_log_space_left() could underflow resulting in very high number of
free blocks and thus triggering assertion failure in transaction commit
code complaining there's not enough space in the journal:

J_ASSERT(journal->j_free > 1);

Properly check for the low number of free blocks.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/jbd2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 603fbc4e2f70..10e6049c0ba9 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1582,7 +1582,7 @@ static inline int jbd2_space_needed(journal_t *journal)
 static inline unsigned long jbd2_log_space_left(journal_t *journal)
 {
 	/* Allow for rounding errors */
-	unsigned long free = journal->j_free - 32;
+	long free = journal->j_free - 32;
 
 	if (journal->j_committing_transaction) {
 		unsigned long committing = atomic_read(&journal->
@@ -1591,7 +1591,7 @@ static inline unsigned long jbd2_log_space_left(journal_t *journal)
 		/* Transaction + control blocks */
 		free -= committing + (committing >> JBD2_CONTROL_BLOCKS_SHIFT);
 	}
-	return free;
+	return max_t(long, free, 0);
 }
 
 /*
-- 
2.16.4

