From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 5/7] ext4: Convert ext4_extent.ee_start to ext4_extent.ee_start_lo
Date: Tue, 25 Sep 2007 23:50:07 +0530
Message-ID: <11907444242123-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907444091038-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444192997-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444213671-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444233981-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40821 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbXIYSUo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 14:20:44 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8PIKiKt027278
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:44 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PIOGZh273836
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:24:16 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PIKQ1M026639
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:26 +1000
In-Reply-To: <11907444233981-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert ext4_extent.ee_start to ext4_extent.ee_start_lo
This helps in finding BUGs due to direct partial access of
these split 48 bit values

Also fix direct partial access in ext4 code

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |    8 +++-----
 fs/ext4/migrate.c               |    2 +-
 include/linux/ext4_fs_extents.h |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9ccdb85..e852c2c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -52,7 +52,7 @@ static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
 {
 	ext4_fsblk_t block;
 
-	block = le32_to_cpu(ex->ee_start);
+	block = le32_to_cpu(ex->ee_start_lo);
 	block |= ((ext4_fsblk_t) le16_to_cpu(ex->ee_start_hi) << 31) << 1;
 	return block;
 }
@@ -77,7 +77,7 @@ static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
  */
 static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
 {
-	ex->ee_start = cpu_to_le32((unsigned long) (pb & 0xffffffff));
+	ex->ee_start_lo = cpu_to_le32((unsigned long) (pb & 0xffffffff));
 	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
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
index 5efcdd0..3a597b5 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -24,7 +24,7 @@ struct list_blocks_struct {
 /* will go away */
 static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
 {
-	ex->ee_start = cpu_to_le32((unsigned long) (pb & 0xffffffff));
+	ex->ee_start_lo = cpu_to_le32((unsigned long) (pb & 0xffffffff));
 	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 5ed0891..016977b 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -74,7 +74,7 @@ struct ext4_extent {
 	__le32	ee_block;	/* first logical block extent covers */
 	__le16	ee_len;		/* number of blocks covered by extent */
 	__le16	ee_start_hi;	/* high 16 bits of physical block */
-	__le32	ee_start;	/* low 32 bits of physical block */
+	__le32	ee_start_lo;	/* low 32 bits of physical block */
 };
 
 /*
-- 
1.5.3.1.91.gd3392-dirty
