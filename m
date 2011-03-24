From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v1] ext3:Fix credits computing for ordered mode.
Date: Thu, 24 Mar 2011 08:48:39 +0800
Message-ID: <1300927719-27383-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57842 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab1CXAps (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 20:45:48 -0400
Received: by gxk21 with SMTP id 21so3639527gxk.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 17:45:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Orginal computing ignores indirects themselves in ordered mode.

Signed-off-by:Yongqiang Yang <xiaoqiangnk@gmail.com>
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

