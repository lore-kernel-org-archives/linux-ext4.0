From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ext4: move inode indepth shrink logic to didicated function
Date: Tue, 20 Sep 2011 18:49:28 +0400
Message-ID: <1316530170-3965-3-git-send-email-dmonakhov@openvz.org>
References: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39267 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1ITOtO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 10:49:14 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so535159bkb.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Sep 2011 07:49:13 -0700 (PDT)
In-Reply-To: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- Add ext4_ext_try_shrink() helper
- ext4_mark_inode_dirty() called externally in order to allow
  caller to butch several inode updates in to one mark_dirty call.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   62 +++++++++++++++++++++-------------------------------
 1 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b3a08f0..9032214 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2497,13 +2497,29 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 
+static int ext4_ext_try_shrink(handle_t *handle, struct inode *inode)
+{
+	/* TODO: flexible tree reduction should be here */
+	if (ext_depth(inode) && ext_inode_hdr(inode)->eh_entries == 0) {
+		/*
+		 * truncate to zero freed all the tree,
+		 * so we need to correct eh_depth
+		 */
+		ext_inode_hdr(inode)->eh_depth = 0;
+		ext_inode_hdr(inode)->eh_max =
+			cpu_to_le16(ext4_ext_space_root(inode, 0));
+		return 1;
+	}
+	return 0;
+}
+
 static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
 	struct ext4_ext_path *path;
 	handle_t *handle;
-	int i, err;
+	int i, err, err2;
 
 	ext_debug("truncate since %u\n", start);
 
@@ -2608,29 +2624,18 @@ again:
 			ext_debug("return to level %d\n", i);
 		}
 	}
-
-	/* TODO: flexible tree reduction should be here */
-	if (path->p_hdr->eh_entries == 0) {
-		/*
-		 * truncate to zero freed all the tree,
-		 * so we need to correct eh_depth
-		 */
-		err = ext4_ext_get_access(handle, inode, path);
-		if (err == 0) {
-			ext_inode_hdr(inode)->eh_depth = 0;
-			ext_inode_hdr(inode)->eh_max =
-				cpu_to_le16(ext4_ext_space_root(inode, 0));
-			err = ext4_ext_dirty(handle, inode, path);
-		}
-	}
+	if(ext4_ext_try_shrink(handle, inode))
+		err2 = ext4_mark_inode_dirty(handle, inode);
+	if (!err)
+		err = err2;
 out:
 	ext4_ext_drop_refs(path);
 	kfree(path);
 	if (err == -EAGAIN)
 		goto again;
-	ext4_journal_stop(handle);
+	err2 = ext4_journal_stop(handle);
 
-	return err;
+	return err ? err : err2;
 }
 
 /*
@@ -3456,28 +3461,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			}
 
 			ext4_ext_mark_uninitialized(ex);
-
 			ext4_ext_invalidate_cache(inode);
-
 			err = ext4_ext_rm_leaf(handle, inode, path,
 				map->m_lblk, map->m_lblk + punched_out);
-
-			if (!err && path->p_hdr->eh_entries == 0) {
-				/*
-				 * Punch hole freed all of this sub tree,
-				 * so we need to correct eh_depth
-				 */
-				err = ext4_ext_get_access(handle, inode, path);
-				if (err == 0) {
-					ext_inode_hdr(inode)->eh_depth = 0;
-					ext_inode_hdr(inode)->eh_max =
-					cpu_to_le16(ext4_ext_space_root(
-						inode, 0));
