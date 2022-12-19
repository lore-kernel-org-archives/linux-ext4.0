Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC25C4167B
	for <linux-ext4@archiver.kernel.org>; Mon, 19 Dec 2022 01:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiLSBvd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 18 Dec 2022 20:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLSBvc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2022 20:51:32 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3B05F82
        for <linux-ext4@vger.kernel.org>; Sun, 18 Dec 2022 17:51:31 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Nb2hw6Tmpz16LfS
        for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2022 09:50:24 +0800 (CST)
Received: from huawei.com (10.113.189.238) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 19 Dec
 2022 09:51:28 +0800
From:   Wang Jianjian <wangjianjian3@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <zhangzhikang1@huawei.com>, <wangqiang62@huawei.com>,
        <zhengbowen7@huawei.com>
Subject: [PATCH 1/1] ext4: Don't show commit interval if it is zero
Date:   Mon, 19 Dec 2022 09:51:28 +0800
Message-ID: <20221219015128.876717-1-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.113.189.238]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If commit interval is 0, it means using default value.

Fixes: 6e47a3cc68fc ("ext4: get rid of super block and sbi from handle_mount_ops()")
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 16a343e8047d..b93911d80cd9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2146,7 +2146,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		return 0;
 	case Opt_commit:
 		if (result.uint_32 == 0)
-			ctx->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE;
+			result.uint_32 = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		else if (result.uint_32 > INT_MAX / HZ) {
 			ext4_msg(NULL, KERN_ERR,
 				 "Invalid commit interval %d, "
-- 
2.32.0

