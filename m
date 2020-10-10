Return-Path: <SRS0=C6FY=DR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB582C2D0A4
	for <linux-ext4@archiver.kernel.org>; Sat, 10 Oct 2020 21:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B1A2078A
	for <linux-ext4@archiver.kernel.org>; Sat, 10 Oct 2020 21:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgJJVM2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 10 Oct 2020 17:12:28 -0400
Received: from smtp.h3c.com ([60.191.123.50]:54159 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731649AbgJJTfq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 10 Oct 2020 15:35:46 -0400
Received: from h3cspam02-ex.h3c.com (localhost [127.0.0.2] (may be forged))
        by h3cspam02-ex.h3c.com with ESMTP id 09A9tYf2054223;
        Sat, 10 Oct 2020 17:55:34 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([10.8.0.66])
        by h3cspam02-ex.h3c.com with ESMTPS id 09A9rAde051217
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 17:53:10 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from localhost.localdomain (10.99.212.201) by
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 10 Oct 2020 17:53:13 +0800
From:   Xianting Tian <tian.xianting@h3c.com>
To:     <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xianting Tian <tian.xianting@h3c.com>
Subject: [PATCH] ext2: Remove unnecessary blank
Date:   Sat, 10 Oct 2020 17:43:35 +0800
Message-ID: <20201010094335.39797-1-tian.xianting@h3c.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.99.212.201]
X-ClientProxiedBy: BJSMTP01-EX.srv.huawei-3com.com (10.63.20.132) To
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66)
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com 09A9rAde051217
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Remove unnecessary blank when calling kmalloc_array().

Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
---
 fs/ext2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7fab2b3b5..551e69755 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1070,7 +1070,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
 	db_count = (sbi->s_groups_count + EXT2_DESC_PER_BLOCK(sb) - 1) /
 		   EXT2_DESC_PER_BLOCK(sb);
-	sbi->s_group_desc = kmalloc_array (db_count,
+	sbi->s_group_desc = kmalloc_array(db_count,
 					   sizeof(struct buffer_head *),
 					   GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
-- 
2.17.1

