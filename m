From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] delete unused nodes in ext2fs_extent_delete
Date: Tue, 20 May 2008 16:13:41 -0500
Message-ID: <48333F05.6080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053AbYETVNo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 17:13:44 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4KLDhPI012574
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 17:13:43 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KLDg8o013487
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 17:13:42 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KLDffc024971
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 17:13:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch causes ext2fs_extent_delete to remove an
extent node if the last record in it has been deleted.

The parent node is also updated, and the inode block count
is decremented.

Passing in the EXT2_EXTENT_DELETE_KEEP_EMPTY flag will
allow the empty node to remain.

(A bit of a quick hack but seems to work for me)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c6ac317..d237bd3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -336,6 +336,10 @@ typedef struct ext2_extent_path *ext2_extent_path_t;
 #define EXT2_EXTENT_INSERT_NOSPLIT	0x0002 /* insert may not cause split */
 
 /*
+ * Flags used by ext2fs_extent_delete()
+ */
+#define EXT2_EXTENT_DELETE_KEEP_EMPTY	0x001 /* keep node if last extnt gone */
+/*
  * Data structure returned by ext2fs_extent_get_info()
  */
 struct ext2_extent_info {
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 357ca34..f86bf0d 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1169,8 +1169,7 @@ done:
 	return retval;
 }
 
-errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, 
-			       int flags EXT2FS_ATTR((unused)))
+errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 {
 	struct extent_path		*path;
 	char 				*cp;
@@ -1201,13 +1200,31 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle,
 		path->curr = ix;
 	}
 	path->entries--;
-	if (path->entries == 0)
+	/* if non-root node has no entries left, remove it & parent ptr to it */
+	if (path->entries == 0 && handle->level) {
 		path->curr = 0;
 
-	eh = (struct ext3_extent_header *) path->buf;
-	eh->eh_entries = ext2fs_cpu_to_le16(path->entries);
+		if (!(flags & EXT2_EXTENT_DELETE_KEEP_EMPTY)) {
+			struct ext2fs_extent	extent;
 
-	retval = update_path(handle);
+			retval = ext2fs_extent_get(handle, EXT2_EXTENT_UP,
+								&extent);
+			if (retval)
+				return retval;
+
+			retval = ext2fs_extent_delete(handle, 0);
+			handle->inode->i_blocks -= handle->fs->blocksize / 512;
+			retval = ext2fs_write_inode_full(handle->fs,
+					handle->ino, handle->inode,
+					EXT2_INODE_SIZE(handle->fs->super));
+			ext2fs_block_alloc_stats(handle->fs, extent.e_pblk, -1);
+		}
+	} else {
+		eh = (struct ext3_extent_header *) path->buf;
+		eh->eh_entries = ext2fs_cpu_to_le16(path->entries);
+
+		retval = update_path(handle);
+	}
 
 	return retval;
 }

