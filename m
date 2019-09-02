Return-Path: <SRS0=PIre=W5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15A7C3A59E
	for <linux-ext4@archiver.kernel.org>; Mon,  2 Sep 2019 14:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B96A2173E
	for <linux-ext4@archiver.kernel.org>; Mon,  2 Sep 2019 14:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbfIBO4N (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 2 Sep 2019 10:56:13 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:51379 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731544AbfIBO4N (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Sep 2019 10:56:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0TbBPty-_1567436145;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TbBPty-_1567436145)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Sep 2019 22:55:47 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-ext4@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 2/2] jbd2: add new tracepoint jbd2_wait_on_transaction_locked
Date:   Mon,  2 Sep 2019 22:54:42 +0800
Message-Id: <20190902145442.1921-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190902145442.1921-1-xiaoguang.wang@linux.alibaba.com>
References: <20190902145442.1921-1-xiaoguang.wang@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Sometimes process will be stalled in wait_transaction_locked() for a while,
also add a new tracepoint to track this delay.

Trace info likes below:
fsstress-1672  [009] ....   184.663043: jbd2_wait_on_transaction_locked: dev 254,17 wait 0
fsstress-1674  [002] ....   184.771556: jbd2_wait_on_transaction_locked: dev 254,17 wait 42
fsstress-1676  [005] ....   184.771562: jbd2_wait_on_transaction_locked: dev 254,17 wait 100
fsstress-1677  [003] ....   184.771567: jbd2_wait_on_transaction_locked: dev 254,17 wait 102
kworker/13:1-160   [013] ....   184.771619: jbd2_wait_on_transaction_locked: dev 254,17 wait 102
fsstress-1673  [003] ....   184.771675: jbd2_wait_on_transaction_locked: dev 254,17 wait 95

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/jbd2/transaction.c       |  3 +++
 include/trace/events/jbd2.h | 21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 84974fb9d4f9..43f4f7fadaec 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -148,6 +148,7 @@ static void wait_transaction_locked(journal_t *journal)
 	DEFINE_WAIT(wait);
 	int need_to_start;
 	tid_t tid = journal->j_running_transaction->t_tid;
+	unsigned long start = jiffies;
 
 	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
 			TASK_UNINTERRUPTIBLE);
@@ -158,6 +159,8 @@ static void wait_transaction_locked(journal_t *journal)
 	jbd2_might_wait_for_commit(journal);
 	schedule();
 	finish_wait(&journal->j_wait_transaction_locked, &wait);
+	trace_jbd2_wait_on_transaction_locked(journal->j_fs_dev->bd_dev,
+		jiffies_to_msecs(jiffies - start));
 }
 
 /*
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 2f048fdb63c6..6f091f901223 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -401,6 +401,27 @@ TRACE_EVENT(jbd2_sleep_on_shadow,
 		__entry->stall_ms)
 );
 
+TRACE_EVENT(jbd2_wait_on_transaction_locked,
+
+	TP_PROTO(dev_t dev, unsigned long stall_ms),
+
+	TP_ARGS(dev, stall_ms),
+
+	TP_STRUCT__entry(
+		__field(        dev_t, dev	)
+		__field(unsigned long, stall_ms	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= dev;
+		__entry->stall_ms	= stall_ms;
+	),
+
+	TP_printk("dev %d,%d wait %lu",
+		MAJOR(__entry->dev), MINOR(__entry->dev),
+		__entry->stall_ms)
+);
+
 #endif /* _TRACE_JBD2_H */
 
 /* This part must be outside protection */
-- 
2.17.2

