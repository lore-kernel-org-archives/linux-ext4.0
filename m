From: akpm@osdl.org
Subject: [patch 201/354] ext4_ext_split(): remove dead code
Date: Wed, 06 Dec 2006 20:37:25 -0800
Message-ID: <200612070437.kB74bPIj029669@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, bunk@stusta.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46995 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968747AbWLGEhw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:37:52 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

The Coverity checker noted that this was dead code, since in all places
above in this function, "err" is immediately checked.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/extents.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ext4/extents.c~ext4_ext_split-remove-dead-code fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4_ext_split-remove-dead-code
+++ a/fs/ext4/extents.c
@@ -800,9 +800,6 @@ static int ext4_ext_split(handle_t *hand
 	}
 
 	/* insert new index */
-	if (err)
-		goto cleanup;
-
 	err = ext4_ext_insert_index(handle, inode, path + at,
 				    le32_to_cpu(border), newblock);
 
_
