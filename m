Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AA7C11F6C
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A27261D05
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhF3Iab (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jun 2021 04:30:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9435 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbhF3Iaa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2021 04:30:30 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GFDsx6GRyzZns0;
        Wed, 30 Jun 2021 16:24:53 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme752-chm.china.huawei.com
 (10.3.19.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 30
 Jun 2021 16:27:59 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <yi.zhang@huawei.com>, <yukuai3@huawei.com>
Subject: [PATCH] jbd2: fix jbd2_journal_[un]register_shrinker undefined error
Date:   Wed, 30 Jun 2021 16:36:38 +0800
Message-ID: <20210630083638.140218-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme752-chm.china.huawei.com (10.3.19.98)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Export jbd2_journal_unregister_shrinker() and
jbd2_journal_register_shrinker() to fix below error:

 ERROR: modpost: "jbd2_journal_unregister_shrinker" undefined!
 ERROR: modpost: "jbd2_journal_register_shrinker" undefined!

Fixes: 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to release checkpointed buffers")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/jbd2/journal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7c52feb6f753..152880c298ca 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2122,6 +2122,7 @@ int jbd2_journal_register_shrinker(journal_t *journal)
 
 	return 0;
 }
+EXPORT_SYMBOL(jbd2_journal_register_shrinker);
 
 /**
  * jbd2_journal_unregister_shrinker()
@@ -2134,6 +2135,7 @@ void jbd2_journal_unregister_shrinker(journal_t *journal)
 	percpu_counter_destroy(&journal->j_jh_shrink_count);
 	unregister_shrinker(&journal->j_shrinker);
 }
+EXPORT_SYMBOL(jbd2_journal_unregister_shrinker);
 
 /**
  * jbd2_journal_destroy() - Release a journal_t structure.
-- 
2.31.1

