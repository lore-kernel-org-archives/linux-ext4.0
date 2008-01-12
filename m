From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: use ext4_ext_get_actual_len instead of directly
	using ext4_extent.ee_len
Date: Sat, 12 Jan 2008 23:44:00 +0530
Message-ID: <20080112181400.GB6546@skywalker>
References: <4787D498.1050202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53280 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbYALSOH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2008 13:14:07 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0CIEreM022540
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2008 05:14:53 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0CIE6Aa2220224
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2008 05:14:06 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0CIE5bd001775
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2008 05:14:05 +1100
Content-Disposition: inline
In-Reply-To: <4787D498.1050202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext4 use the extent len for encoding whether the extent is intialized or
not. The helper function ext4_ext_get_actual_len should be used to get the
actual length of the extent.

Fix the below kernel BUG
http://bugzilla.kernel.org/show_bug.cgi?id=9732

kernel BUG at fs/ext4/extents.c:1056!
....
Call Trace:
[<ffffffff88366073>] :ext4dev:ext4_ext_get_blocks+0x5ba/0x8c1
[<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
[<ffffffff812748f6>] _spin_unlock+0x17/0x20
[<ffffffff883400a6>] :jbd2:start_this_handle+0x4e0/0x4fe
[<ffffffff88366564>] :ext4dev:ext4_fallocate+0x175/0x39a
[<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
[<ffffffff81056480>] __lock_acquire+0x4e7/0xc4d
[<ffffffff81053c91>] lock_release_holdtime+0x27/0x49
[<ffffffff810a8de7>] sys_fallocate+0xe4/0x10d
[<ffffffff8100c043>] tracesys+0xd5/0xda


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 81bce98..4269cc6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1029,7 +1029,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 {
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
-	int depth;
+	int depth, ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1043,6 +1043,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
+	ee_len = ext4_ext_get_actual_len(ex);
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
 		while (--depth >= 0) {
@@ -1052,10 +1053,10 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 		return 0;
 	}
 
-	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+	BUG_ON(*logical < (le32_to_cpu(ex->ee_block) + ee_len));
 
-	*logical = le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len) - 1;
-	*phys = ext_pblock(ex) + le16_to_cpu(ex->ee_len) - 1;
+	*logical = le32_to_cpu(ex->ee_block) + ee_len - 1;
+	*phys = ext_pblock(ex) + ee_len - 1;
 	return 0;
 }
 
@@ -1075,7 +1076,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
 	ext4_fsblk_t block;
-	int depth;
+	int depth, ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1089,6 +1090,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	 * first one in the file */
 
 	ex = path[depth].p_ext;
+	ee_len = ext4_ext_get_actual_len(ex);
 	if (*logical < le32_to_cpu(ex->ee_block)) {
 		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
 		while (--depth >= 0) {
@@ -1100,7 +1102,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 		return 0;
 	}
 
-	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+	BUG_ON(*logical < (le32_to_cpu(ex->ee_block) + ee_len));
 
 	if (ex != EXT_LAST_EXTENT(path[depth].p_hdr)) {
 		/* next allocated block in this leaf */
@@ -1315,7 +1317,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	if (ext1_ee_len + ext2_ee_len > max_len)
 		return 0;
 #ifdef AGGRESSIVE_TEST
-	if (le16_to_cpu(ex1->ee_len) >= 4)
+	if (ext1_ee_len >= 4)
 		return 0;
 #endif
 
@@ -1555,7 +1557,7 @@ has_space:
 	nearex = path[depth].p_ext;
 	nearex->ee_block = newext->ee_block;
 	ext4_ext_store_pblock(nearex, ext_pblock(newext));
-	nearex->ee_len = newext->ee_len;
+	nearex->ee_len = ext4_ext_get_actual_len(newext);
 
 merge:
 	/* try to merge extents to the right */
@@ -2310,7 +2312,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				   - le32_to_cpu(newex.ee_block)
 				   + ext_pblock(&newex);
 			/* number of remaining blocks in the extent */
-			allocated = le16_to_cpu(newex.ee_len) -
+			allocated = ext4_ext_get_actual_len(&newex) -
 					(iblock - le32_to_cpu(newex.ee_block));
 			goto out;
 		} else {
@@ -2426,7 +2428,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	newex.ee_len = cpu_to_le16(max_blocks);
 	err = ext4_ext_check_overlap(inode, &newex, path);
 	if (err)
-		allocated = le16_to_cpu(newex.ee_len);
+		allocated = ext4_ext_get_actual_len(&newex);
 	else
 		allocated = max_blocks;
 
@@ -2458,7 +2460,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		 * but otherwise we'd need to call it every free() */
 		ext4_mb_discard_inode_preallocations(inode);
 		ext4_free_blocks(handle, inode, ext_pblock(&newex),
-					le16_to_cpu(newex.ee_len), 0);
+					ext4_ext_get_actual_len(&newex), 0);
 		goto out2;
 	}
 
@@ -2467,7 +2469,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
-	allocated = le16_to_cpu(newex.ee_len);
+	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
 	__set_bit(BH_New, &bh_result->b_state);
 
-- 
1.5.4.rc2.60.gb2e62-dirty
