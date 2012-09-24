From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 10/10] ext4: fix ext_remove_space for punch_hole case
Date: Mon, 24 Sep 2012 15:44:20 +0400
Message-ID: <1348487060-19598-11-git-send-email-dmonakhov@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61353 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2IXLoq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:46 -0400
Received: by lbbgj3 with SMTP id gj3so6549720lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:44 -0700 (PDT)
In-Reply-To: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode is allowed to have empty leaf only if it this is blockless inode
i.e. (depth == 0).

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2d58f4c..57d6438 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2648,12 +2648,15 @@ again:
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

