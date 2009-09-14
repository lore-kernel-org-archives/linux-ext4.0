From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 3/4]ext4: Add null extent check to ext_get_path()
Date: Mon, 14 Sep 2009 17:17:23 +0900
Message-ID: <4AADFC13.4070101@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64901 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbZINITM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Sep 2009 04:19:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Add null extent check to ext_get_path

From: Akira Fujita <a-fujita@rs.jp.nec.com>

There is the possibility that path structure which is taken
by ext4_ext_find_extent() indicates null extents.
Because during data block exchanging in ext4_move_extents(),
constitution of an extent tree may be changed.
As a solution, the patch adds null extent check
to ext_get_path().

Reported-by: Peng Tao　<bergwolf@gmail.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 6d126d0..7c26c74 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -39,7 +39,9 @@ get_ext_path(struct inode *inode, ext4_lblk_t lblock,
 	if (IS_ERR(*path)) {
 		ret = PTR_ERR(*path);
 		*path = NULL;
-	}
+	} else if ((*path)[ext_depth(inode)].p_ext == NULL)
+		ret = -ENODATA;
+
 	return ret;
 }

@@ -316,7 +318,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,

 	if (new_flag) {
 		err = get_ext_path(orig_inode, eblock, &orig_path);
-		if (orig_path == NULL)
+		if (err)
 			goto out;

 		if (ext4_ext_insert_extent(handle, orig_inode,
@@ -327,7 +329,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
 	if (end_flag) {
 		err = get_ext_path(orig_inode,
 				le32_to_cpu(end_ext->ee_block) - 1, &orig_path);
-		if (orig_path == NULL)
+		if (err)
 			goto out;

 		if (ext4_ext_insert_extent(handle, orig_inode,
@@ -673,12 +675,12 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,

 	/* Get the original extent for the block "orig_off" */
 	err = get_ext_path(orig_inode, orig_off, &orig_path);
-	if (orig_path == NULL)
+	if (err)
 		goto out;

 	/* Get the donor extent for the head */
 	err = get_ext_path(donor_inode, donor_off, &donor_path);
-	if (donor_path == NULL)
+	if (err)
 		goto out;
 	depth = ext_depth(orig_inode);
 	oext = orig_path[depth].p_ext;
@@ -733,7 +735,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
 		err = get_ext_path(orig_inode, orig_off, &orig_path);
-		if (orig_path == NULL)
+		if (err)
 			goto out;
 		depth = ext_depth(orig_inode);
 		oext = orig_path[depth].p_ext;
@@ -747,7 +749,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 		if (donor_path)
 			ext4_ext_drop_refs(donor_path);
 		err = get_ext_path(donor_inode, donor_off, &donor_path);
-		if (donor_path == NULL)
+		if (err)
 			goto out;
 		depth = ext_depth(donor_inode);
 		dext = donor_path[depth].p_ext;
@@ -1230,20 +1232,16 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		len -= block_end - file_end;

 	ret1 = get_ext_path(orig_inode, block_start, &orig_path);
-	if (orig_path == NULL)
+	if (ret1)
 		goto out2;

 	/* Get path structure to check the hole */
 	ret1 = get_ext_path(orig_inode, block_start, &holecheck_path);
-	if (holecheck_path == NULL)
+	if (ret1)
 		goto out;

 	depth = ext_depth(orig_inode);
 	ext_cur = holecheck_path[depth].p_ext;
-	if (ext_cur == NULL) {
-		ret1 = -EINVAL;
-		goto out;
-	}

 	/*
 	 * Get proper extent whose ee_block is beyond block_start
@@ -1372,7 +1370,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		if (holecheck_path)
 			ext4_ext_drop_refs(holecheck_path);
 		ret1 = get_ext_path(orig_inode, seq_start, &holecheck_path);
-		if (holecheck_path == NULL)
+		if (ret1)
 			break;
 		depth = holecheck_path->p_depth;

@@ -1380,7 +1378,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
 		ret1 = get_ext_path(orig_inode, seq_start, &orig_path);
-		if (orig_path == NULL)
+		if (ret1)
 			break;

 		ext_cur = holecheck_path[depth].p_ext;
