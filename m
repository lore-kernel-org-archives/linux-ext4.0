From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 8/9] ext4: fix ext_remove_space for punch_hole case
Date: Thu, 13 Sep 2012 19:01:13 +0400
Message-ID: <1347548474-31897-9-git-send-email-dmonakhov@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44132 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327Ab2IMPBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 11:01:31 -0400
Received: by mail-lpp01m010-f46.google.com with SMTP id y9so1991567lag.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:31 -0700 (PDT)
In-Reply-To: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode is allowed to have empty leaf only if it this is blockless inode
i.e. (depth == 0).

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0e94485..af2cc76 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2649,12 +2649,15 @@ again:
 			return PTR_ERR(path);
 		}
 		depth = ext_depth(inode);
+		/* Leaf not may not exist only if inode has no blocks at all */
 		ex = path[depth].p_ext;
 		if (!ex) {
-			ext4_ext_drop_refs(path);
-			kfree(path);
-			path = NULL;
-			goto cont;
+			if (depth) {
+				EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL",
+						 depth);
+				err = -EIO;
+			}
+			goto out;
 		}
 
 		ee_block = le32_to_cpu(ex->ee_block);
-- 
1.7.7.6

