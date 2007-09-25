From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 5/7] ext4: Convert ext4_extent.ee_start and ee_start_hi to le32_t and le16_t
Date: Tue, 25 Sep 2007 14:33:50 +0530
Message-ID: <11907111031099-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110501570-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110613446-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110772723-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:41398 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXIYJFp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 05:05:45 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8P95Vpt021288
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:31 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P95TAi3973366
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:29 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P95SvB017180
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:29 +1000
In-Reply-To: <11907110772723-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert ext4_extent.ee_start and ee_start_hi to le32_t and le16_t
This helps in finding BUGs due to direct partial access of
these split 48 bit values

Also fix direct partial access in ext4 code

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |   12 +++++-------
 fs/ext4/migrate.c               |    4 ++--
 include/linux/ext4_fs_extents.h |    4 ++--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9ccdb85..a7e70d8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -52,8 +52,8 @@ static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
 {
 	ext4_fsblk_t block;
 
-	block = le32_to_cpu(ex->ee_start);
-	block |= ((ext4_fsblk_t) le16_to_cpu(ex->ee_start_hi) << 31) << 1;
+	block = le32_to_cpu(ex->ee_start.value);
+	block |= ((ext4_fsblk_t) le16_to_cpu(ex->ee_start_hi.value) << 31) << 1;
 	return block;
 }
 
@@ -77,8 +77,8 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
  */
 static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
 {
-	ex->ee_start = cpu_to_le32((unsigned long) (pb & 0xffffffff));
-	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
+	ex->ee_start.value = cpu_to_le32((unsigned long) (pb & 0xffffffff));
+	ex->ee_start_hi.value = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
 /*
@@ -1551,8 +1551,7 @@ has_space:
 	eh->eh_entries = cpu_to_le16(le16_to_cpu(eh->eh_entries)+1);
 	nearex = path[depth].p_ext;
 	nearex->ee_block = newext->ee_block;
-	nearex->ee_start = newext->ee_start;
-	nearex->ee_start_hi = newext->ee_start_hi;
+	ext4_ext_store_pblock(nearex, ext_pblock(newext));
 	nearex->ee_len = newext->ee_len;
 
 merge:
@@ -2321,7 +2320,6 @@ int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 	}
 	/* ex2: iblock to iblock + maxblocks-1 : initialised */
 	ex2->ee_block = cpu_to_le32(iblock);
-	ex2->ee_start = cpu_to_le32(newblock);
 	ext4_ext_store_pblock(ex2, newblock);
 	ex2->ee_len = cpu_to_le16(allocated);
 	if (ex2 != ex)
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5efcdd0..2e9a807 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -24,8 +24,8 @@ struct list_blocks_struct {
 /* will go away */
 static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
 {
-	ex->ee_start = cpu_to_le32((unsigned long) (pb & 0xffffffff));
-	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
+	ex->ee_start.value = cpu_to_le32((unsigned long) (pb & 0xffffffff));
+	ex->ee_start_hi.value = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
 static int finish_range(handle_t *handle, struct inode *inode,
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 5ed0891..112926e 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -73,8 +73,8 @@
 struct ext4_extent {
 	__le32	ee_block;	/* first logical block extent covers */
 	__le16	ee_len;		/* number of blocks covered by extent */
-	__le16	ee_start_hi;	/* high 16 bits of physical block */
-	__le32	ee_start;	/* low 32 bits of physical block */
+	le16_t	ee_start_hi;	/* high 16 bits of physical block */
+	le32_t	ee_start;	/* low 32 bits of physical block */
 };
 
 /*
-- 
1.5.3.1.91.gd3392-dirty
