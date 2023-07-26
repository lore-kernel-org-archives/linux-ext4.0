Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A78EB64DD
	for <linux-ext4@archiver.kernel.org>; Wed, 26 Jul 2023 01:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjGZBcs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjGZBcr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jul 2023 21:32:47 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383B126A2;
        Tue, 25 Jul 2023 18:32:46 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R9btT1Rb3zLntF;
        Wed, 26 Jul 2023 09:30:09 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 26 Jul
 2023 09:32:43 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>
CC:     <lizetao1@huawei.com>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] ext4: NULL check before some freeing functions is not needed
Date:   Wed, 26 Jul 2023 09:33:30 +0000
Message-ID: <20230726093330.1389949-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Fix below warnings reported by coccicheck:
fs/ext4/super.c:2472:4-9: WARNING: NULL check before some freeing functions is not needed.
fs/ext4/super.c:2057:2-7: WARNING: NULL check before some freeing functions is not needed.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 fs/ext4/super.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b54c70e1a74e..27d5aea1f715 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2053,9 +2053,7 @@ static int unnote_qf_name(struct fs_context *fc, int qtype)
 {
 	struct ext4_fs_context *ctx = fc->fs_private;
 
-	if (ctx->s_qf_names[qtype])
-		kfree(ctx->s_qf_names[qtype]);
-
+	kfree(ctx->s_qf_names[qtype]);
 	ctx->s_qf_names[qtype] = NULL;
 	ctx->qname_spec |= 1 << qtype;
 	ctx->spec |= EXT4_SPEC_JQUOTA;
@@ -2468,8 +2466,7 @@ static int parse_options(struct fs_context *fc, char *options)
 			param.size = v_len;
 
 			ret = ext4_parse_param(fc, &param);
-			if (param.string)
-				kfree(param.string);
+			kfree(param.string);
 			if (ret < 0)
 				return ret;
 		}
-- 
2.34.1

