From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix memory leakage in mext_check_coverage
Date: Mon, 18 Mar 2013 17:35:29 +0400
Message-ID: <1363613729-27282-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:5166 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3CRNfk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 09:35:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Regression was introduced by following commit 8c854473
TESTCASE (git://oss.sgi.com/xfs/cmds/xfstests.git):
#while true;do ./check 301 || break ;done

Also fix potential memory leakage in get_ext_path() once
ext4_ext_find_extent() have failed.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c1f15b2..bbae4ed 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -32,16 +32,18 @@
  */
 static inline int
 get_ext_path(struct inode *inode, ext4_lblk_t lblock,
-		struct ext4_ext_path **path)
+		struct ext4_ext_path **orig_path)
 {
 	int ret = 0;
+	struct ext4_ext_path *path;
 
-	*path = ext4_ext_find_extent(inode, lblock, *path);
-	if (IS_ERR(*path)) {
-		ret = PTR_ERR(*path);
-		*path = NULL;
-	} else if ((*path)[ext_depth(inode)].p_ext == NULL)
+	path = ext4_ext_find_extent(inode, lblock, *orig_path);
+	if (IS_ERR(path))
+		ret = PTR_ERR(path);
+	else if (path[ext_depth(inode)].p_ext == NULL)
 		ret = -ENODATA;
+	else
+		*orig_path = path;
 
 	return ret;
 }
@@ -611,24 +613,25 @@ mext_check_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent *ext;
+	int ret = 0;
 	ext4_lblk_t last = from + count;
 	while (from < last) {
 		*err = get_ext_path(inode, from, &path);
 		if (*err)
-			return 0;
+			goto out;
 		ext = path[ext_depth(inode)].p_ext;
-		if (!ext) {
-			ext4_ext_drop_refs(path);
-			return 0;
-		}
-		if (uninit != ext4_ext_is_uninitialized(ext)) {
-			ext4_ext_drop_refs(path);
-			return 0;
-		}
+		if (uninit != ext4_ext_is_uninitialized(ext))
+			goto out;
 		from += ext4_ext_get_actual_len(ext);
 		ext4_ext_drop_refs(path);
 	}
-	return 1;
+	ret = 1;
+out:
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+	return ret;
 }
 
 /**
-- 
1.7.1

