Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AB0C169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 14:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD25720989
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 14:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfA2Oeu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 09:34:50 -0500
Received: from smtprz15.163.net ([106.3.154.248]:18621 "EHLO smtp.tom.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725769AbfA2Oeu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 09:34:50 -0500
Received: from 172.25.16.148 (unknown [172.25.16.148])
        by freemail01.tom.com (Postfix) with ESMTP id 828511C81B6C
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 20:39:54 +0800 (CST)
Received: from 172.25.16.90 (HELO smtp.tom.com) ([172.25.16.90])
          by localhost (TOM SMTP Server) with SMTP ID -1328089285
          for <linux-ext4@vger.kernel.org>;
          Tue, 29 Jan 2019 20:39:54 +0800 (CST)
Received: from antispam1.tom.com (unknown [172.25.16.55])
        by freemail01.tom.com (Postfix) with ESMTP id B48AA1C81BCE
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 20:39:53 +0800 (CST)
Received: from antispam1.tom.com (antispam1.tom.com [127.0.0.1])
        by antispam1.tom.com (Postfix) with ESMTP id 9E4A31001741
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 20:39:53 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at antispam1.tom.com
Received: from antispam1.tom.com ([127.0.0.1])
        by antispam1.tom.com (antispam1.tom.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CIaYwXCenDGv for <linux-ext4@vger.kernel.org>;
        Tue, 29 Jan 2019 20:39:52 +0800 (CST)
Received: from localhost (unknown [222.209.19.163])
        by antispam1.tom.com (Postfix) with ESMTPA id 6F1D81001589;
        Tue, 29 Jan 2019 20:39:52 +0800 (CST)
From:   Liu Xiang <liu.xiang6@zte.com.cn>
To:     jack@suse.com
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuxiang_1999@126.com, Liu Xiang <liu.xiang6@zte.com.cn>
Subject: [PATCH] ext2: Fix a typo in comment
Date:   Tue, 29 Jan 2019 20:39:49 +0800
Message-Id: <1548765589-2920-1-git-send-email-liu.xiang6@zte.com.cn>
X-Mailer: git-send-email 1.9.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Fix a typo in ext2_get_blocks comment.

Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>
---
 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e4bb938..11da3fb 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -717,7 +717,7 @@ static int ext2_get_blocks(struct inode *inode,
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
 	/*
-	 * Next look up the indirect map to count the totoal number of
+	 * Next look up the indirect map to count the total number of
 	 * direct blocks to allocate for this branch.
 	 */
 	count = ext2_blks_to_allocate(partial, indirect_blks,
-- 
1.9.1

