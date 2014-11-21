From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 2/4] ext4: fix end of leaf partial cluster handling
Date: Fri, 21 Nov 2014 09:55:54 -0500
Message-ID: <20141121145554.GC30246@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:59177 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbaKUPEI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2014 10:04:08 -0500
Received: by mail-qc0-f176.google.com with SMTP id i17so3911886qcy.35
        for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2014 07:04:07 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The fix in commit ad6599ab3ac9 ("ext4: fix premature freeing of
partial clusters split across leaf blocks"), intended to avoid
dereferencing an invalid extent pointer when determining whether a
partial cluster should be freed, wasn't quite good enough.  Assure that
at least one extent remains at the start of the leaf once the hole has
been punched.  Otherwise, the pointer to the extent to the right of the
hole will be invalid and a partial cluster will be incorrectly freed.

Set partial_cluster to 0 when we can tell we've hit the left edge of
the punched region within the leaf.  This prevents incorrect freeing
of a partial cluster when ext4_ext_rm_leaf is called one last time
during extent tree traversal after the punched region has been removed.

Adjust comments to reflect code changes and a correction.  Remove a bit
of dead code.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57794a7..859ab37 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2574,15 +2574,16 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 
 /*
  * ext4_ext_rm_leaf() Removes the extents associated with the
- * blocks appearing between "start" and "end", and splits the extents
- * if "start" and "end" appear in the same extent
+ * blocks appearing between "start" and "end".  Both "start"
+ * and "end" must appear in the same extent or EIO is returned.
  *
  * @handle: The journal handle
  * @inode:  The files inode
  * @path:   The path to the leaf
  * @partial_cluster: The cluster which we'll have to free if all extents
- *                   has been released from it. It gets negative in case
- *                   that the cluster is still used.
+ *                   has been released from it.  However, if this value is
+ *                   negative, it's a cluster just to the right of the
+ *                   punched region and it must not be freed.
  * @start:  The first block to remove
  * @end:   The last block to remove
  */
@@ -2730,8 +2731,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 					sizeof(struct ext4_extent));
 			}
 			le16_add_cpu(&eh->eh_entries, -1);
-		} else if (*partial_cluster > 0)
-			*partial_cluster = 0;
+		}
 
 		err = ext4_ext_dirty(handle, inode, path + depth);
 		if (err)
@@ -2750,20 +2750,18 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	/*
 	 * If there's a partial cluster and at least one extent remains in
 	 * the leaf, free the partial cluster if it isn't shared with the
-	 * current extent.  If there's a partial cluster and no extents
-	 * remain in the leaf, it can't be freed here.  It can only be
-	 * freed when it's possible to determine if it's not shared with
-	 * any other extent - when the next leaf is processed or when space
-	 * removal is complete.
+	 * current extent.  If it is shared with the current extent
+	 * we zero partial_cluster because we've reached the start of the
+	 * truncated/punched region and we're done removing blocks.
 	 */
-	if (*partial_cluster > 0 && eh->eh_entries &&
-	    (EXT4_B2C(sbi, ext4_ext_pblock(ex) + ex_ee_len - 1) !=
-	     *partial_cluster)) {
-		int flags = get_default_free_blocks_flags(inode);
