Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FD8C282C0
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 15:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15F50218A2
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 15:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfAYPJx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:09:53 -0500
Received: from smtprz14.163.net ([106.3.154.247]:57542 "EHLO smtp.tom.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726350AbfAYPJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 10:09:52 -0500
Received: from 172.25.16.148 (unknown [172.25.16.148])
        by freemail01.tom.com (Postfix) with ESMTP id B9C381C819FB
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2019 22:01:43 +0800 (CST)
Received: from 172.25.16.90 (HELO smtp.tom.com) ([172.25.16.90])
          by localhost (TOM SMTP Server) with SMTP ID -1495574103
          for <linux-ext4@vger.kernel.org>;
          Fri, 25 Jan 2019 22:01:43 +0800 (CST)
Received: from antispam1.tom.com (unknown [172.25.16.55])
        by freemail01.tom.com (Postfix) with ESMTP id AFF121C819AA
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2019 22:01:43 +0800 (CST)
Received: from antispam1.tom.com (antispam1.tom.com [127.0.0.1])
        by antispam1.tom.com (Postfix) with ESMTP id B08D310016C9
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2019 22:01:43 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at antispam1.tom.com
Received: from antispam1.tom.com ([127.0.0.1])
        by antispam1.tom.com (antispam1.tom.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mZ51eRuzwKdf for <linux-ext4@vger.kernel.org>;
        Fri, 25 Jan 2019 22:01:43 +0800 (CST)
Received: from localhost (unknown [222.209.19.163])
        by antispam1.tom.com (Postfix) with ESMTPA id A391C1000F35;
        Fri, 25 Jan 2019 22:01:42 +0800 (CST)
From:   Liu Xiang <liu.xiang6@zte.com.cn>
To:     jack@suse.com
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuxiang_1999@126.com, Liu Xiang <liu.xiang6@zte.com.cn>
Subject: [PATCH] ext2: Remove redundant check for finding no group
Date:   Fri, 25 Jan 2019 22:01:36 +0800
Message-Id: <1548424896-4692-1-git-send-email-liu.xiang6@zte.com.cn>
X-Mailer: git-send-email 1.9.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When best_desc keeps NULL, best_group keeps -1, too. So we can
return best_group directly.

Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>
---
 fs/ext2/ialloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 5c3d7b7..a0c5ea9 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -222,8 +222,6 @@ static int find_group_dir(struct super_block *sb, struct inode *parent)
 			best_desc = desc;
 		}
 	}
-	if (!best_desc)
-		return -1;
 
 	return best_group;
 }
-- 
1.9.1

