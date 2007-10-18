From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 2/6] ext4: code cleanup
Date: Thu, 18 Oct 2007 15:59:32 +0530
Message-ID: <1192703376-20594-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1192703376-20594-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59186 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761271AbXJRK3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2007 06:29:51 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9IATgHi004739
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:29:42 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9IATgQw975064
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:29:42 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9IATfAl003572
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:29:42 +1000
In-Reply-To: <1192703376-20594-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix sparse warnings.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c       |    6 +++---
 fs/ext4/inode.c         |   14 ++++++++------
 include/linux/ext4_fs.h |    2 ++
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 392b76e..ce58d45 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1230,7 +1230,7 @@ static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
  * then we have to correct all indexes above.
  * TODO: do we need to correct tree in all cases?
  */
-int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
+static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path)
 {
 	struct ext4_extent_header *eh;
@@ -1677,7 +1677,7 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
  * It's used in truncate case only, thus all requests are for
  * last index in the block only.
  */
-int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
+static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path)
 {
 	struct buffer_head *bh;
@@ -1947,7 +1947,7 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 
-int ext4_ext_remove_space(struct inode *inode, unsigned long start)
+static int ext4_ext_remove_space(struct inode *inode, unsigned long start)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a557c5c..8908ab3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2159,11 +2159,11 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
 	for (p = first; p < last; p++) {
 		u32 nr = le32_to_cpu(*p);
 		if (nr) {
-			struct buffer_head *bh;
+			struct buffer_head *tbh;
 
 			*p = 0;
-			bh = sb_find_get_block(inode->i_sb, nr);
-			ext4_forget(handle, 0, inode, bh, nr);
+			tbh = sb_find_get_block(inode->i_sb, nr);
+			ext4_forget(handle, 0, inode, tbh, nr);
 		}
 	}
 
@@ -2431,8 +2431,10 @@ void ext4_truncate(struct inode *inode)
 			return;
 	}
 
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_truncate(inode, page);
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		ext4_ext_truncate(inode, page);
+		return;
+	}
 
 	handle = start_transaction(inode);
 	if (IS_ERR(handle)) {
@@ -3283,7 +3285,7 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
  * Expand an inode by new_extra_isize bytes.
  * Returns 0 on success or negative error number on failure.
  */
-int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
+static int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
 			struct ext4_iloc iloc, handle_t *handle)
 {
 	struct ext4_inode *raw_inode;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index f6d4b4c..514464d 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -928,6 +928,8 @@ extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int *errp);
 extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern ext4_fsblk_t ext4_new_blocks_old (handle_t *handle, struct inode *inode,
+			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
-- 
1.5.3.4.206.g58ba4-dirty
