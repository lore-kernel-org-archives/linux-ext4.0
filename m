Return-Path: <SRS0=GoW3=3L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572C7C2D0DB
	for <linux-ext4@archiver.kernel.org>; Wed, 22 Jan 2020 09:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3816320704
	for <linux-ext4@archiver.kernel.org>; Wed, 22 Jan 2020 09:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgAVJzS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 22 Jan 2020 04:55:18 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:46786 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730377AbgAVJdO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 22 Jan 2020 04:33:14 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E3C529708B054E010687;
        Wed, 22 Jan 2020 17:33:11 +0800 (CST)
Received: from [127.0.0.1] (10.133.208.128) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Wed, 22 Jan 2020
 17:33:10 +0800
To:     <tytso@mit.edu>, <jack@suse.com>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   wangyan <wangyan122@huawei.com>
Subject: [PATCH] jbd2: delete the duplicated words in the comments
Message-ID: <12087f77-ab4d-c7ba-53b4-893dbf0026f0@huawei.com>
Date:   Wed, 22 Jan 2020 17:33:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.208.128]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Delete the duplicated words "is" in the comments

Signed-off-by: Yan Wang <wangyan122@huawei.com>
---
 fs/jbd2/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 27b9f9dee434..5c3abbaccb57 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -525,7 +525,7 @@ EXPORT_SYMBOL(jbd2__journal_start);
  * modified buffers in the log.  We block until the log can guarantee
  * that much space. Additionally, if rsv_blocks > 0, we also create another
  * handle with rsv_blocks reserved blocks in the journal. This handle is
- * is stored in h_rsv_handle. It is not attached to any particular transaction
+ * stored in h_rsv_handle. It is not attached to any particular transaction
  * and thus doesn't block transaction commit. If the caller uses this reserved
  * handle, it has to set h_rsv_handle to NULL as otherwise jbd2_journal_stop()
  * on the parent handle will dispose the reserved one. Reserved handle has to
-- 
2.19.1

