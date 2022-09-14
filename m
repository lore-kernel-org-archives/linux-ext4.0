Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76DAC6FA86
	for <linux-ext4@archiver.kernel.org>; Wed, 14 Sep 2022 09:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiINJ5h (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 14 Sep 2022 05:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiINJ5Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2022 05:57:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4277F6A48B;
        Wed, 14 Sep 2022 02:57:19 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MSFzw1dRkznVCd;
        Wed, 14 Sep 2022 17:54:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 17:57:17 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next 2/2] jbd2: fix potential use-after-free in jbd2_fc_wait_bufs
Date:   Wed, 14 Sep 2022 18:08:12 +0800
Message-ID: <20220914100812.1414768-3-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220914100812.1414768-1-yebin10@huawei.com>
References: <20220914100812.1414768-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In 'jbd2_fc_wait_bufs' use 'bh' after put buffer head reference count
which may lead to use-after-free.
So judge buffer if uptodate before put buffer head reference count.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/jbd2/journal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 1c833d8cb0fe..4d49f629d06b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -923,16 +923,16 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
 	for (i = j_fc_off - 1; i >= j_fc_off - num_blks; i--) {
 		bh = journal->j_fc_wbuf[i];
 		wait_on_buffer(bh);
-		put_bh(bh);
-		journal->j_fc_wbuf[i] = NULL;
 		/*
 		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
 		 * buffer head.
 		 */
 		if (unlikely(!buffer_uptodate(bh))) {
-			journal->j_fc_off = i;
+			journal->j_fc_off = i + 1;
 			return -EIO;
 		}
+		put_bh(bh);
+		journal->j_fc_wbuf[i] = NULL;
 	}
 
 	return 0;
-- 
2.31.1

