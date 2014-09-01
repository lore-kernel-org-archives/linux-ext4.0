From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/10] ext4: teach ext4_ext_find_extent() to realloc path if necessary
Date: Mon,  1 Sep 2014 00:06:48 -0400
Message-ID: <1409544411-31544-8-git-send-email-tytso@mit.edu>
References: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58469 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaIAEG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 00:06:56 -0400
In-Reply-To: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds additional safety in case for some reason we end reusing a
path structure which isn't big enough for current depth of the inode.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4_extents.h |  1 +
 fs/ext4/extents.c      | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index a867f5c..3c93815 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -123,6 +123,7 @@ find_ext4_extent_tail(struct ext4_extent_header *eh)
 struct ext4_ext_path {
 	ext4_fsblk_t			p_block;
 	__u16				p_depth;
+	__u16				p_maxdepth;
 	struct ext4_extent		*p_ext;
 	struct ext4_extent_idx		*p_idx;
 	struct ext4_extent_header	*p_hdr;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 17a1f6f..fd840e9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -861,14 +861,20 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
 
-	if (path)
+	if (path) {
 		ext4_ext_drop_refs(path);
-	else {
+		if (depth > path[0].p_maxdepth) {
+			kfree(path);
+			*orig_path = path = NULL;
+		}
+	}
+	if (!path) {
 		/* account possible depth increase */
 		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 2),
 				GFP_NOFS);
 		if (unlikely(!path))
 			return ERR_PTR(-ENOMEM);
+		path[0].p_maxdepth = depth + 1;
 	}
 	path[0].p_hdr = eh;
 	path[0].p_bh = NULL;
@@ -1812,6 +1818,7 @@ static void ext4_ext_try_to_merge_up(handle_t *handle,
 		sizeof(struct ext4_extent_idx);
 	s += sizeof(struct ext4_extent_header);
 
+	path[1].p_maxdepth = path[0].p_maxdepth;
 	memcpy(path[0].p_hdr, path[1].p_hdr, s);
 	path[0].p_depth = 0;
 	path[0].p_ext = EXT_FIRST_EXTENT(path[0].p_hdr) +
@@ -2142,12 +2149,6 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
 
-		if (path && ext_depth(inode) != depth) {
-			/* depth was changed. we have to realloc path */
-			kfree(path);
-			path = NULL;
-		}
