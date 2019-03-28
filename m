Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8218CC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 09:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C1402173C
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 09:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfC1JSU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 05:18:20 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:43244 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbfC1JSU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Mar 2019 05:18:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04389;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TNqWOH2_1553764694;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0TNqWOH2_1553764694)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Mar 2019 17:18:15 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, jack@suse.cz, renzhen@linux.alibaba.com
Subject: [PATCH] jbd2: check superblock mapped prior to committing
Date:   Thu, 28 Mar 2019 17:18:14 +0800
Message-Id: <20190328091814.46168-1-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.856.g8858448bb
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
before unmounting ext4 filesystem.

The typical chain of events leading to the BUG:
jbd2_write_superblock
  submit_bh
    submit_bh_wbc
      BUG_ON(!buffer_mapped(bh));

The block device is removed and all the pages are invalidated. JBD2
was trying to write journal superblock to the block device which is
no longer present.

Fix this by checking the journal superblock's buffer head prior to
submitting.

Cc: stable@kernel.org
Reported-by: Eric Ren <renzhen@linux.alibaba.com>
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/jbd2/journal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 382c030cc78b..90fd3ed0a232 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1350,6 +1350,9 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
+	if (!buffer_mapped(bh))
+		return -EIO;
+
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
-- 
2.19.1.856.g8858448bb

