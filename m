Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD79C433FE
	for <linux-ext4@archiver.kernel.org>; Fri, 20 May 2022 02:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344720AbiETCXA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 May 2022 22:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiETCW6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2022 22:22:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0638D1312B0;
        Thu, 19 May 2022 19:22:57 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L49T850zgz1JCH4;
        Fri, 20 May 2022 10:21:32 +0800 (CST)
Received: from huawei.com (10.113.189.238) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 20 May
 2022 10:22:55 +0800
From:   Wang Jianjian <wangjianjian3@huawei.com>
To:     <linux-ext4@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH 1/2] ext4: Fix incorrect comment
Date:   Fri, 20 May 2022 10:22:54 +0800
Message-ID: <20220520022255.2120576-1-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.113.189.238]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
 fs/ext4/page-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 8385939eeb48..97fa7b4c645f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -465,7 +465,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	/*
 	 * In the first loop we prepare and mark buffers to submit. We have to
 	 * mark all buffers in the page before submitting so that
-	 * end_page_writeback() cannot be called from ext4_end_io_end() when IO
+	 * end_page_writeback() cannot be called from ext4_end_bio() when IO
 	 * on the first buffer finishes and we are still working on submitting
 	 * the second buffer.
 	 */
-- 
2.32.0

