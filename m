From: Avantika Mathur <mathur@us.ibm.com>
Subject: [PATCH 2/3] kmalloc to kzalloc
Date: Mon, 27 Nov 2006 16:09:04 -0800
Message-ID: <1164672544.10750.19.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:63384 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S933597AbWK1AK3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Nov 2006 19:10:29 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAS0ATR4004268
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:29 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAS0AS8q241816
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:28 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAS0ASYZ001386
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:28 -0500
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Avantika Mathur <mathur@us.ibm.com>

Performs kmalloc to kzalloc conversion

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---
 fs/ext4/extents.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6.19-rc6-mm1/fs/ext4/extents.c
===================================================================
--- linux-2.6.19-rc6-mm1.orig/fs/ext4/extents.c
+++ linux-2.6.19-rc6-mm1/fs/ext4/extents.c
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
