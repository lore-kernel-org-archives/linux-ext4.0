From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 2/2] ext4: make extents.c/ext4_ext_try_to_merge return 1 on
 merged
Date: Fri, 06 Jul 2012 14:27:44 +0800
Message-ID: <4FF68560.7040102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35196 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GFG1v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jul 2012 02:27:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the old version, ext4_ext_try_to_merge would return 0 if
merge left or no merge, and return 1 if merge right.
Here make ext4_ext_try_to_merge return 1 on merged, and return
0 if no merge.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/extents.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6c2a37d..7f6fb48 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1657,7 +1657,7 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
 
 /*
  * This function tries to merge the @ex extent to neighbours in the tree.
- * return 1 if merge left else 0.
+ * return 1 if merged else 0.
  */
 static int ext4_ext_try_to_merge(struct inode *inode,
 				  struct ext4_ext_path *path,
@@ -1665,7 +1665,6 @@ static int ext4_ext_try_to_merge(struct inode *inode,
 	struct ext4_extent_header *eh;
 	unsigned int depth;
 	int merge_done = 0;
-	int ret = 0;
 
 	depth = ext_depth(inode);
 	BUG_ON(path[depth].p_hdr == NULL);
@@ -1675,9 +1674,9 @@ static int ext4_ext_try_to_merge(struct inode *inode,
 		merge_done = ext4_ext_try_to_merge_right(inode, path, ex - 1);
 
 	if (!merge_done)
-		ret = ext4_ext_try_to_merge_right(inode, path, ex);
+		merge_done = ext4_ext_try_to_merge_right(inode, path, ex);
 
-	return ret;
+	return merge_done;
 }
 
 /*
-- 
1.7.1
