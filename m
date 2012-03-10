From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 5/6] Rename de patch5 from de to se scheme
Date: Fri,  9 Mar 2012 21:41:24 -0700
Message-ID: <1331354485-18515-6-git-send-email-achender@linux.vnet.ibm.com>
References: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:55457 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2CJEkz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 23:40:55 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 21:40:55 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id DC73619D804A
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 21:40:46 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2A4eqZQ170000
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:52 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2A4epaV030579
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:52 -0700
In-Reply-To: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch renames changes introduced by patch
"[PATCH_V3_5_6\]_ext4_reimplement_fiemap_on_delayed_extent_tree"

All code referencing "delayed extents" or "de" are changed to
"status extents" or "se"

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 a8b382e... 3f76625... M	fs/ext4/extents.c
 fs/ext4/extents.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a8b382e..3f76625 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4363,7 +4363,7 @@ static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
-	struct delayed_extent de;
+	struct status_extent se;
 	__u64	logical;
 	__u64	physical;
 	__u64	length;
@@ -4373,9 +4373,9 @@ static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
 	struct fiemap_extent_info *fieinfo = data;
 	unsigned char blksize_bits;
 
-	de.start = newex->ec_block;
+	se.start = newex->ec_block;
 	down_read(&EXT4_I(inode)->i_data_sem);
-	next_del = ext4_de_find_extent(inode, &de);
+	next_del = ext4_se_find_extent(inode, &se);
 	up_read(&EXT4_I(inode)->i_data_sem);
 
 	next = min(next_del, next);
@@ -4384,19 +4384,19 @@ static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
 		 * No extent in extent-tree contains block @newex->ec_start,
 		 * then the block may stay in 1)a hole or 2)delayed-extent.
 		 */
-		if (de.len == 0)
+		if (se.len == 0)
 			/* A hole found. */
 			return EXT_CONTINUE;
 
-		if (de.start > newex->ec_block) {
+		if (se.start > newex->ec_block) {
 			/* A hole found. */
-			newex->ec_len = min(de.start - newex->ec_block,
+			newex->ec_len = min(se.start - newex->ec_block,
 					    newex->ec_len);
 			return EXT_CONTINUE;
 		}
 
 		flags |= FIEMAP_EXTENT_DELALLOC;
-		newex->ec_len = de.start + de.len - newex->ec_block;
+		newex->ec_len = se.start + se.len - newex->ec_block;
 	}
 
 	if (ex && ext4_ext_is_uninitialized(ex))
-- 
1.7.1

