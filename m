From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] ext4_ext_split(): remove dead code
Date: Mon, 6 Nov 2006 11:05:54 +0100
Message-ID: <20061106100554.GH5778__43320.6092603088$1162808239$gmane$org@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:17165 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1423696AbWKFKQg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Nov 2006 05:16:36 -0500
To: ext2-devel@lists.sourceforge.net
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The Coverity checker noted that this was dead code, since in all places 
above in this function, "err" is immediately checked.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6/fs/ext4/extents.c.old	2006-11-06 11:02:09.000000000 +0100
+++ linux-2.6/fs/ext4/extents.c	2006-11-06 11:02:29.000000000 +0100
@@ -800,9 +800,6 @@ static int ext4_ext_split(handle_t *hand
 	}
 
 	/* insert new index */
-	if (err)
-		goto cleanup;
-
 	err = ext4_ext_insert_index(handle, inode, path + at,
 				    le32_to_cpu(border), newblock);
 
