From: akpm@osdl.org
Subject: + ext4-kmalloc-to-kzalloc.patch added to -mm tree
Date: Mon, 27 Nov 2006 17:29:41 -0800
Message-ID: <200611280129.kAS1TfFL022523@shell0.pdx.osdl.net>
Cc: mathur@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60823 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S933603AbWK1B3w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Nov 2006 20:29:52 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: kmalloc to kzalloc
has been added to the -mm tree.  Its filename is
     ext4-kmalloc-to-kzalloc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: kmalloc to kzalloc
From: Avantika Mathur <mathur@us.ibm.com>

Performs kmalloc to kzalloc conversion

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/extents.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/ext4/extents.c~ext4-kmalloc-to-kzalloc fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-kmalloc-to-kzalloc
+++ a/fs/ext4/extents.c
@@ -477,13 +477,12 @@ ext4_ext_find_extent(struct inode *inode
 
 	/* account possible depth increase */
 	if (!path) {
-		path = kmalloc(sizeof(struct ext4_ext_path) * (depth + 2),
+		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 2),
 				GFP_NOFS);
 		if (!path)
 			return ERR_PTR(-ENOMEM);
 		alloc = 1;
 	}
-	memset(path, 0, sizeof(struct ext4_ext_path) * (depth + 1));
 	path[0].p_hdr = eh;
 
 	/* walk through the tree */
@@ -643,10 +642,9 @@ static int ext4_ext_split(handle_t *hand
 	 * We need this to handle errors and free blocks
 	 * upon them.
 	 */
-	ablocks = kmalloc(sizeof(ext4_fsblk_t) * depth, GFP_NOFS);
+	ablocks = kzalloc(sizeof(ext4_fsblk_t) * depth, GFP_NOFS);
 	if (!ablocks)
 		return -ENOMEM;
-	memset(ablocks, 0, sizeof(ext4_fsblk_t) * depth);
 
 	/* allocate all needed blocks */
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
@@ -1772,12 +1770,11 @@ int ext4_ext_remove_space(struct inode *
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
-	path = kmalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_KERNEL);
+	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_KERNEL);
 	if (path == NULL) {
 		ext4_journal_stop(handle);
 		return -ENOMEM;
 	}
-	memset(path, 0, sizeof(struct ext4_ext_path) * (depth + 1));
 	path[0].p_hdr = ext_inode_hdr(inode);
 	if (ext4_ext_check_header(__FUNCTION__, inode, path[0].p_hdr)) {
 		err = -EIO;
_

Patches currently in -mm which might be from mathur@us.ibm.com are

ext4-if-expression-format.patch
ext4-kmalloc-to-kzalloc.patch
ext4-eliminate-inline-functions.patch
