Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from smtprz15.163.net ([106.3.154.248]:38250 "EHLO smtp.tom.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728566AbfAORP1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 15 Jan 2019 12:15:27 -0500
Received: from 172.25.16.148 (unknown [172.25.16.148])
        by freemail02.tom.com (Postfix) with ESMTP id AB724B00DCD
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 22:10:50 +0800 (CST)
Received: from 172.25.16.91 (HELO smtp.tom.com) ([172.25.16.91])
          by localhost (TOM SMTP Server) with SMTP ID -1959878928
          for <linux-ext4@vger.kernel.org>;
          Tue, 15 Jan 2019 22:10:50 +0800 (CST)
Received: from antispam2.tom.com (unknown [172.25.16.56])
        by freemail02.tom.com (Postfix) with ESMTP id 93F46B00DAA
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 22:10:49 +0800 (CST)
Received: from antispam2.tom.com (antispam2.tom.com [127.0.0.1])
        by antispam2.tom.com (Postfix) with ESMTP id 877828162C
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 22:10:49 +0800 (CST)
Received: from antispam2.tom.com ([127.0.0.1])
        by antispam2.tom.com (antispam2.tom.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Cvli00mdV7Wi for <linux-ext4@vger.kernel.org>;
        Tue, 15 Jan 2019 22:10:48 +0800 (CST)
From: Liu Xiang <liu.xiang6@zte.com.cn>
To: linux-ext4@vger.kernel.org
Cc: jack@suse.com, linux-kernel@vger.kernel.org, liuxiang_1999@126.com,
        Liu Xiang <liu.xiang6@zte.com.cn>
Subject: [PATCH] ext2: Remove redundant check on s_inode_size
Date: Tue, 15 Jan 2019 22:10:43 +0800
Message-Id: <1547561443-3411-1-git-send-email-liu.xiang6@zte.com.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The case of (EXT2_INODE_SIZE(sb) == 0) is included in
(sbi->s_inode_size < EXT2_GOOD_OLD_INODE_SIZE).
So there is no need to check again.

Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>
---
 fs/ext2/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 73b2d52..c71c2e3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1024,8 +1024,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
 
-	if (EXT2_INODE_SIZE(sb) == 0)
-		goto cantfind_ext2;
 	sbi->s_inodes_per_block = sb->s_blocksize / EXT2_INODE_SIZE(sb);
 	if (sbi->s_inodes_per_block == 0 || sbi->s_inodes_per_group == 0)
 		goto cantfind_ext2;
-- 
1.9.1
