From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/6] ext4: move inode indepth shrink logic to didicated function
Date: Fri, 21 Oct 2011 01:08:55 +0400
Message-ID: <1319144939-28801-3-git-send-email-dmonakhov@openvz.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JTVIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 17:08:51 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so4002126bkb.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 14:08:50 -0700 (PDT)
In-Reply-To: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- add ext4_ext_try_shrink helper
- ext4_mark_inode_dirty() called externally in order to allow
  caller to butch several inode updates in to one mark_dirty call.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   59 ++++++++++++++++++++++------------------------------
 1 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8eb3656..315775e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2570,6 +2570,22 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
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
@@ -2577,7 +2593,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 	struct ext4_ext_path *path;
 	ext4_fsblk_t partial_cluster = 0;
 	handle_t *handle;
-	int i, err;
+	int i, err, err2;
 
 	ext_debug("truncate since %u\n", start);
 
@@ -2703,29 +2719,18 @@ again:
 				 EXT4_SB(sb)->s_cluster_ratio, flags);
 		partial_cluster = 0;
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
@@ -3965,22 +3970,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 					       &partial_cluster, map->m_lblk,
 					       map->m_lblk + punched_out);
 
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
