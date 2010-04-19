From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: fix eofblock flag handling
Date: Mon, 19 Apr 2010 18:32:17 +0400
Message-ID: <1271687537-15655-2-git-send-email-dmonakhov@openvz.org>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:61079 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0DSOcZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 10:32:25 -0400
Received: by bwz25 with SMTP id 25so5659989bwz.28
        for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 07:32:24 -0700 (PDT)
In-Reply-To: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- Fix NULL pointer deference on error path
- Extent header we found may be not latest node of the inode. In order to
  find latest extent we have to traverse a path from very beginning.

https://bugzilla.kernel.org/show_bug.cgi?id=15792

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   50 +++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7c7b1d5..13758c3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3327,7 +3327,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent_header *eh;
-	struct ext4_extent newex, *ex, *last_ex;
+	struct ext4_extent newex, *ex;
 	ext4_fsblk_t newblock;
 	int err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
@@ -3510,17 +3510,38 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	if (unlikely(ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
-		if (unlikely(!eh->eh_entries)) {
-			EXT4_ERROR_INODE(inode,
-					 "eh->eh_entries == 0 ee_block %d",
-					 ex->ee_block);
-			err = -EIO;
-			goto out2;
-		}
-		last_ex = EXT_LAST_EXTENT(eh);
+		struct ext4_extent *last_ex = EXT_LAST_EXTENT(eh);
+		/*
+		 * Optimization: Extent header we found may not be the latest
+		 * extent of the inode, but it is already in-core memory.
+		 * Let's test against this EH to avoid unecessery IO.
+		*/
+		if (unlikely(!eh->eh_entries))
+			goto bad_eh;
 		if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
-		    + ext4_ext_get_actual_len(last_ex))
-			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
+			+ ext4_ext_get_actual_len(last_ex)) {
+			struct ext4_ext_path *path2;
+			struct ext4_extent_header *eh2;
+			/* Real search of the latests extent is necessery */
+			path2 = ext4_ext_find_extent(inode, EXT_MAX_BLOCK, NULL);
+			eh2 = path2[depth].p_hdr;
+			if (IS_ERR(path2)) {
+				err = PTR_ERR(path2);
+				goto out2;
+			}
+			last_ex = path2[depth].p_ext;
+			if (unlikely(!eh2->eh_entries || !last_ex)) {
+				ext4_ext_drop_refs(path2);
+				kfree(path2);
+				goto bad_eh;
+			}
+			if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
+				+ ext4_ext_get_actual_len(last_ex))
+				ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
+			ext4_ext_drop_refs(path2);
+			kfree(path2);
+		}
+
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
@@ -3570,6 +3591,12 @@ out2:
 		kfree(path);
 	}
 	return err ? err : allocated;
+
+bad_eh:
+	EXT4_ERROR_INODE(inode, "eh->eh_entries == 0, i_flags = %lx iblock = %u"
+			, EXT4_I(inode)->i_flags, iblock);
+	err = -EIO;
+	goto out2;
 }
 
 void ext4_ext_truncate(struct inode *inode)
@@ -3580,6 +3607,7 @@ void ext4_ext_truncate(struct inode *inode)
 	handle_t *handle;
 	int err = 0;
 
+	BUG_ON(ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS));
 	/*
 	 * probably first extent we're gonna free will be last in block
 	 */
-- 
1.6.6.1

