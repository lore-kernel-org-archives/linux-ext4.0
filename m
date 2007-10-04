From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Convert ext4_extent_idx.ei_leaf to ext4_extent_idx.ei_leaf_lo
Date: Thu,  4 Oct 2007 01:50:58 -0400
Message-ID: <1191477059-5357-24-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
 <1191477059-5357-6-git-send-email-tytso@mit.edu>
 <1191477059-5357-7-git-send-email-tytso@mit.edu>
 <1191477059-5357-8-git-send-email-tytso@mit.edu>
 <1191477059-5357-9-git-send-email-tytso@mit.edu>
 <1191477059-5357-10-git-send-email-tytso@mit.edu>
 <1191477059-5357-11-git-send-email-tytso@mit.edu>
 <1191477059-5357-12-git-send-email-tytso@mit.edu>
 <1191477059-5357-13-git-send-email-tytso@mit.edu>
 <1191477059-5357-14-git-send-email-tytso@mit.edu>
 <1191477059-5357-15-git-send-email-tytso@mit.edu>
 <1191477059-5357-16-git-send-email-tytso@mit.edu>
 <1191477059-5357-17-git-send-email-tytso@mit.edu>
 <1191477059-5357-18-git-send-email-tytso@mit.edu>
 <1191477059-5357-19-git-send-email-tytso@mit.edu>
 <1191477059-5357-20-git-send-email-tytso@mit.edu>
 <1191477059-5357-21-git-send-email-tytso@mit.edu>
 <1191477059-5357-22-git-send-email-tytso@mit.edu>
 <1191477059-5357-23-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44805 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbXJDFvJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:09 -0400
In-Reply-To: <1191477059-5357-23-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Convert ext4_extent_idx.ei_leaf  ext4_extent_idx.ei_leaf_lo
This helps in finding BUGs due to direct partial access of
these split 48 bit values.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |    4 ++--
 include/linux/ext4_fs_extents.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c03056a..8528774 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -65,7 +65,7 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
 {
 	ext4_fsblk_t block;
 
-	block = le32_to_cpu(ix->ei_leaf);
+	block = le32_to_cpu(ix->ei_leaf_lo);
 	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi) << 31) << 1;
 	return block;
 }
@@ -88,7 +88,7 @@ static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
  */
 static void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
 {
-	ix->ei_leaf = cpu_to_le32((unsigned long) (pb & 0xffffffff));
+	ix->ei_leaf_lo = cpu_to_le32((unsigned long) (pb & 0xffffffff));
 	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index cb2dfbb..d2045a2 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -83,7 +83,7 @@ struct ext4_extent {
  */
 struct ext4_extent_idx {
 	__le32	ei_block;	/* index covers logical blocks from 'block' */
-	__le32	ei_leaf;	/* pointer to the physical block of the next *
+	__le32	ei_leaf_lo;	/* pointer to the physical block of the next *
 				 * level. leaf or next index could be there */
 	__le16	ei_leaf_hi;	/* high 16 bits of physical block */
 	__u16	ei_unused;
-- 
1.5.3.2.81.g17ed
