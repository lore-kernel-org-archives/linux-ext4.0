From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext3:Fix credits computing for ordered mode.
Date: Thu, 24 Mar 2011 08:35:41 +0800
Message-ID: <1300926941-27304-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39290 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab1CXAcw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 20:32:52 -0400
Received: by iwn34 with SMTP id 34so9117618iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 17:32:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 Please enter the commit message for your changes. Lines starting
---
 fs/ext3/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ae94f6d..7f5db46 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3294,7 +3294,7 @@ static int ext3_writepage_trans_blocks(struct inode *inode)
 	if (ext3_should_journal_data(inode))
 		ret = 3 * (bpp + indirects) + 2;
 	else
-		ret = 2 * (bpp + indirects) + 2;
+		ret = 2 * (bpp + indirects) + indirects + 2;
 
 #ifdef CONFIG_QUOTA
 	/* We know that structure was already allocated during dquot_initialize so
-- 
1.7.4

