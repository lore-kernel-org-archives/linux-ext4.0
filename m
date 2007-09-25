From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 6/7] ext4: Convert ext4_extent_idx.ei_leaf and ei_leaf_hi to le32_t and le16_t
Date: Tue, 25 Sep 2007 14:33:51 +0530
Message-ID: <11907111281402-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110501570-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110613446-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110772723-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907111031099-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:48484 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbXIYJGD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 05:06:03 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8P95eoV021537
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:40 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P99Cjn212256
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:09:13 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P95cu9017733
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:38 +1000
In-Reply-To: <11907111031099-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert ext4_extent_idx.ei_leaf and ei_leaf_hi to le32_t and le16_t
This helps in finding BUGs due to direct partial access of
these split 48 bit values

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |    8 ++++----
 fs/ext4/migrate.c               |    4 ++--
 include/linux/ext4_fs_extents.h |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a7e70d8..858997b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -65,8 +65,8 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
 {
 	ext4_fsblk_t block;
 
-	block = le32_to_cpu(ix->ei_leaf);
-	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi) << 31) << 1;
+	block = le32_to_cpu(ix->ei_leaf.value);
+	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi.value) << 31) << 1;
 	return block;
 }
 
@@ -88,8 +88,8 @@ static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
  */
 static void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
 {
-	ix->ei_leaf = cpu_to_le32((unsigned long) (pb & 0xffffffff));
-	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
+	ix->ei_leaf.value = cpu_to_le32((unsigned long) (pb & 0xffffffff));
+	ix->ei_leaf_hi.value = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
 static handle_t *ext4_ext_journal_restart(handle_t *handle, int needed)
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 2e9a807..6a4de2c 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -375,8 +375,8 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
 {
 	ext4_fsblk_t block;
 
-	block = le32_to_cpu(ix->ei_leaf);
-	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi) << 31) << 1;
+	block = le32_to_cpu(ix->ei_leaf.value);
+	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi.value) << 31) << 1;
 	return block;
 }
 
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 112926e..2930120 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -83,9 +83,9 @@ struct ext4_extent {
  */
 struct ext4_extent_idx {
 	__le32	ei_block;	/* index covers logical blocks from 'block' */
-	__le32	ei_leaf;	/* pointer to the physical block of the next *
+	le32_t	ei_leaf;	/* pointer to the physical block of the next *
 				 * level. leaf or next index could be there */
-	__le16	ei_leaf_hi;	/* high 16 bits of physical block */
+	le16_t	ei_leaf_hi;	/* high 16 bits of physical block */
 	__u16	ei_unused;
 };
 
-- 
1.5.3.1.91.gd3392-dirty
