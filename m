From: Forrest Liu <forrestl@synology.com>
Subject: [PATCH] ext4: fix extent tree corruption that incurred by hole punch [V2]
Date: Thu, 13 Dec 2012 23:32:22 +0800
Message-ID: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35430 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2LMPcX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2012 10:32:23 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so4078598ieb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2012 07:32:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When depth of extent tree is greater than 1, logical start value
of interior node didn't updated correctly in ext4_ext_rm_idx.

Signed-off-by: Forrest Liu <forrestl@synology.com>
---
 fs/ext4/extents.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d3dd618..496952e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2190,13 +2190,14 @@ errout:
  * removes index from the index block.
  */
 static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
-			struct ext4_ext_path *path)
+			struct ext4_ext_path *path, int depth)
 {
 	int err;
 	ext4_fsblk_t leaf;

 	/* free index block */
-	path--;
+	depth--;
+	path = path + depth;
 	leaf = ext4_idx_pblock(path->p_idx);
 	if (unlikely(path->p_hdr->eh_entries == 0)) {
 		EXT4_ERROR_INODE(inode, "path->p_hdr->eh_entries == 0");
@@ -2221,6 +2222,19 @@ static int ext4_ext_rm_idx(handle_t *handle,
struct inode *inode,

 	ext4_free_blocks(handle, inode, NULL, leaf, 1,
 			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+
+	while (--depth >= 0) {
+		if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
+			break;
+		path--;
+		err = ext4_ext_get_access(handle, inode, path);
+		if (err)
+			break;
+		path->p_idx->ei_block = (path+1)->p_idx->ei_block;
+		err = ext4_ext_dirty(handle, inode, path);
+		if (err)
+			break;
+	}
 	return err;
 }

@@ -2557,7 +2571,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	/* if this leaf is free, then we should
 	 * remove it from index block above */
 	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
-		err = ext4_ext_rm_idx(handle, inode, path + depth);
+		err = ext4_ext_rm_idx(handle, inode, path, depth);

 out:
 	return err;
@@ -2760,7 +2774,7 @@ again:
 				/* index is empty, remove it;
 				 * handle must be already prepared by the
 				 * truncatei_leaf() */
-				err = ext4_ext_rm_idx(handle, inode, path + i);
+				err = ext4_ext_rm_idx(handle, inode, path, i);
 			}
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
-- 
1.7.9.5
