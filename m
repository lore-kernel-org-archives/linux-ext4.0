Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC49C282C0
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 18:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D097F218B0
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 18:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbfAYSJs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 13:09:48 -0500
Received: from smtprz14.163.net ([106.3.154.247]:1728 "EHLO smtp.tom.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729129AbfAYSJr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 13:09:47 -0500
Received: from 172.25.16.148 (unknown [172.25.16.148])
        by freemail01.tom.com (Postfix) with ESMTP id BDB6C1C819B2
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2019 22:01:11 +0800 (CST)
Received: from 172.25.16.90 (HELO smtp.tom.com) ([172.25.16.90])
          by localhost (TOM SMTP Server) with SMTP ID 1352252021
          for <linux-ext4@vger.kernel.org>;
          Fri, 25 Jan 2019 22:01:11 +0800 (CST)
Received: from antispam1.tom.com (unknown [172.25.16.55])
        by freemail01.tom.com (Postfix) with ESMTP id A04221C819AA
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2019 22:01:11 +0800 (CST)
Received: from antispam1.tom.com (antispam1.tom.com [127.0.0.1])
        by antispam1.tom.com (Postfix) with ESMTP id A13DC10016C2
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2019 22:01:11 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at antispam1.tom.com
Received: from antispam1.tom.com ([127.0.0.1])
        by antispam1.tom.com (antispam1.tom.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UyupXL4DP_6W for <linux-ext4@vger.kernel.org>;
        Fri, 25 Jan 2019 22:01:10 +0800 (CST)
Received: from localhost (unknown [222.209.19.163])
        by antispam1.tom.com (Postfix) with ESMTPA id 58B691001670;
        Fri, 25 Jan 2019 22:01:10 +0800 (CST)
From:   Liu Xiang <liu.xiang6@zte.com.cn>
To:     jack@suse.com
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuxiang_1999@126.com, Liu Xiang <liu.xiang6@zte.com.cn>
Subject: [PATCH] ext2: Remove useless reset code
Date:   Fri, 25 Jan 2019 22:01:04 +0800
Message-Id: <1548424864-4647-1-git-send-email-liu.xiang6@zte.com.cn>
X-Mailer: git-send-email 1.9.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If ((char *)de == dir_end) is true, the name_len will not be used
in the subsequent routine. So the reset code can be removed.

Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>
---
 fs/ext2/dir.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 3b8114d..5ec497f 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -517,7 +517,6 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 		while ((char *)de <= kaddr) {
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
-				name_len = 0;
 				rec_len = chunk_size;
 				de->rec_len = ext2_rec_len_to_disk(chunk_size);
 				de->inode = 0;
-- 
1.9.1

