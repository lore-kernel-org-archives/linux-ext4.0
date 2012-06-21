From: haiboliu6@gmail.com
Subject: [PATCH][v2] ext4: change a comment on fs/ext4/extents.c
Date: Thu, 21 Jun 2012 21:23:14 +0800
Message-ID: <4fe32049.28d5440a.3265.ffffb61a@mx.google.com>
References: <y>
Cc: HaiboLiu <HaiboLiu6@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33171 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759608Ab2FUNXW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 09:23:22 -0400
Received: by dady13 with SMTP id y13so872512dad.19
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2012 06:23:22 -0700 (PDT)
In-Reply-To: <y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: HaiboLiu <HaiboLiu6@gmail.com>

In this patch, ext4_ext_try_to_merge has been change to merge 
an extent both left and right. So we need to update the comment
in here.

v1->v2: update the subject and the patch comment.

Signed-off-by: HaiboLiu <HaiboLiu6@gmail.com>
---
 fs/ext4/extents.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..db671b9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1807,11 +1807,10 @@ has_space:
 	nearex->ee_len = newext->ee_len;
 
 merge:
-	/* try to merge extents to the right */
+	/* try to merge extents */
 	if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
 		ext4_ext_try_to_merge(inode, path, nearex);
 
-	/* try to merge extents to the left */
 
 	/* time to correct all indexes above */
 	err = ext4_ext_correct_indexes(handle, inode, path);
-- 
1.7.9.5

