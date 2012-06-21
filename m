From: Haibo <haiboliu6@gmail.com>
Subject: [PATCH][v2] ext4: delete a no useful sentence
Date: Fri, 22 Jun 2012 02:31:06 +0800
Message-ID: <1340303466-7967-1-git-send-email-HaiboLiu6@gmail.com>
Cc: Haibo Liu <HaiboLiu6@gmai.com>, Haibo Liu <HaiboLiu6@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56054 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2FUSbP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 14:31:15 -0400
Received: by dady13 with SMTP id y13so1233107dad.19
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2012 11:31:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Haibo Liu <HaiboLiu6@gmai.com>

In this patch, the sentence "poff = block % blocks_per_page"
in ext4_mb_get_buddy_page_lock has no effect.
So we should delete it to save cpu.

v1->v2: update the patch subject and the patch comment.

Signed-off-by: Haibo Liu <HaiboLiu6@gmail.com>
---
 fs/ext4/mballoc.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cb990b2..7223bd4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1016,7 +1016,6 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 
 	block++;
 	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
 	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
 	if (!page)
 		return -EIO;
-- 
1.7.9.5

