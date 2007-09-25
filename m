From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 6/7] ext4: Convert ext4_extent_idx.ei_leaf  ext4_extent_idx.ei_leaf_lo
Date: Tue, 25 Sep 2007 23:50:08 +0530
Message-ID: <11907444273588-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907444091038-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444192997-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444213671-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444233981-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444242123-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38772 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXIYSUp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 14:20:45 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8PIKimB022204
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:44 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PIKi003580022
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:44 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PIKSBY026697
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:28 +1000
In-Reply-To: <11907444242123-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert ext4_extent_idx.ei_leaf  ext4_extent_idx.ei_leaf_lo
This helps in finding BUGs due to direct partial access of
these split 48 bit values.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |    4 ++--
 fs/ext4/migrate.c               |    2 +-
 include/linux/ext4_fs_extents.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e852c2c..4da0090 100644
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
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 3a597b5..3a306b8 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -375,7 +375,7 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
 {
 	ext4_fsblk_t block;
 
-	block = le32_to_cpu(ix->ei_leaf);
+	block = le32_to_cpu(ix->ei_leaf_lo);
 	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi) << 31) << 1;
 	return block;
 }
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 016977b..149fd4b 100644
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
1.5.3.1.91.gd3392-dirty
