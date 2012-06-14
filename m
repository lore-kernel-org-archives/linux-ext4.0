From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH v2] ext4: fix hole punch failure when depth is greater than 0
Date: Thu, 14 Jun 2012 07:23:56 +0530
Message-ID: <1339638836-19990-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51127 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2FNBzs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 21:55:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The current implementation of hole punch uses the same code path as for
truncate in which the block removal starts from the end of the file and
continue backwards removing extents and in the process decreases the
count of valid entries in the extent header of extent index.
If all the extents under current extent index are removed than this index
is also removed and the number of valid entries in the "depth -1"
extent header is decreased by 1.

Whether to continue removing extents or not is decided by the return value
of function ext4_ext_more_to_rm() which checks 2 conditions:
a) if there are no more indexes to process.
b) if the number of entries are decreased in the header of "depth -1".

In case of hole punch, if the last block to be removed is not part of the
last extent index than this index will not be deleted, hence the number of
valid entries in the extent header of "depth - 1" will remain as it is and
ext4_ext_more_to_rm will return 0 although the required blocks are not
yet removed.

This patch fixes the above mentioned problem as instead of removing the
extents from the end of file, it starts removing the blocks from the
particular extent from which removing blocks is actually required and
continue backward until done.

Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/ext4/extents.c |   43 +++++++++++++++++++++++++++----------------
 1 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..27c3a30 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2570,10 +2570,10 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
-	struct ext4_ext_path *path;
+	struct ext4_ext_path *path = NULL;
 	ext4_fsblk_t partial_cluster = 0;
 	handle_t *handle;
-	int i, err;
+	int i = 0, err;
 
 	ext_debug("truncate since %u to %u\n", start, end);
 
@@ -2606,8 +2606,12 @@ again:
 		}
 		depth = ext_depth(inode);
 		ex = path[depth].p_ext;
-		if (!ex)
+		if (!ex) {
+			ext4_ext_drop_refs(path);
+			kfree(path);
+			path = NULL;
 			goto cont;
+		}
 
 		ee_block = le32_to_cpu(ex->ee_block);
 
@@ -2637,8 +2641,6 @@ again:
 			if (err < 0)
 				goto out;
 		}
-		ext4_ext_drop_refs(path);
-		kfree(path);
 	}
 cont:
 
@@ -2647,19 +2649,27 @@ cont:
 	 * after i_size and walking into the tree depth-wise.
 	 */
 	depth = ext_depth(inode);
-	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
-	if (path == NULL) {
-		ext4_journal_stop(handle);
-		return -ENOMEM;
-	}
-	path[0].p_depth = depth;
-	path[0].p_hdr = ext_inode_hdr(inode);
+	if (path) {
+		int k = i = depth;
+		while (--k >= 0)
+			path[k].p_block =
+			le16_to_cpu(path[k].p_hdr->eh_entries)+1;
+	} else {
+		path =
+		kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
+		if (path == NULL) {
+			ext4_journal_stop(handle);
+			return -ENOMEM;
+		}
+		path[0].p_depth = depth;
+		path[0].p_hdr = ext_inode_hdr(inode);
 
-	if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
-		err = -EIO;
-		goto out;
+		if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
+			err = -EIO;
+			goto out;
+		}
 	}
-	i = err = 0;
+	err = 0;
 
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
@@ -2773,6 +2783,7 @@ cont:
 out:
 	ext4_ext_drop_refs(path);
 	kfree(path);
+	path = NULL;
 	if (err == -EAGAIN)
 		goto again;
 	ext4_journal_stop(handle);
-- 
1.7.2.3

