From: haiboliu6@gmail.com
Subject: [PATCH] change a comment on fs/ext4/extents.c
Date: Tue, 19 Jun 2012 23:35:47 +0800
Message-ID: <4fe09c5f.4ad3440a.5cc5.7bac@mx.google.com>
References: <y>
Cc: HaiboLiu <HaiboLiu6@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53161 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2FSPgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2012 11:36:00 -0400
Received: by pbbrp8 with SMTP id rp8so9805431pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Jun 2012 08:36:00 -0700 (PDT)
In-Reply-To: <y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: HaiboLiu <HaiboLiu6@gmail.com>

May be it's better.

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

