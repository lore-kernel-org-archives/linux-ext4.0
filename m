From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] e2fsprogs: Fix tst_extents output on bigendian machine.
Date: Fri, 18 Jul 2008 17:35:40 +0530
Message-ID: <1216382740-24369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:52022 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751197AbYGRMFq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 08:05:46 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6IC5jKW032494
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 17:35:45 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6IC5i4i983064
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 17:35:44 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6IC5if8004306
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 17:35:44 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add type __le16, __le32, and __le64 to indicate that
the variables need to be byteswaped when using.
Also fix the header priting on powerpc machine.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 lib/ext2fs/ext3_extents.h |   30 +++++++++++++++++-------------
 lib/ext2fs/extent.c       |   20 +++++++++++++++-----
 2 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index 3b373c7..4018bd4 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -19,6 +19,10 @@
 #ifndef _LINUX_EXT3_EXTENTS
 #define _LINUX_EXT3_EXTENTS
 
+typedef __u16	__le16;
+typedef	__u32	__le32;
+typedef	__u64	__le64;
+
 /*
  * ext3_inode has i_block array (total 60 bytes)
  * first 4 bytes are used to store:
@@ -31,10 +35,10 @@
  * it's used at the bottom of the tree
  */
 struct ext3_extent {
-	__u32	ee_block;	/* first logical block extent covers */
-	__u16	ee_len;		/* number of blocks covered by extent */
-	__u16	ee_start_hi;	/* high 16 bits of physical block */
-	__u32	ee_start;	/* low 32 bigs of physical block */
+	__le32	ee_block;	/* first logical block extent covers */
+	__le16	ee_len;		/* number of blocks covered by extent */
+	__le16	ee_start_hi;	/* high 16 bits of physical block */
+	__le32	ee_start;	/* low 32 bigs of physical block */
 };
 
 /*
@@ -42,22 +46,22 @@ struct ext3_extent {
  * it's used at all the levels, but the bottom
  */
 struct ext3_extent_idx {
-	__u32	ei_block;	/* index covers logical blocks from 'block' */
-	__u32	ei_leaf;	/* pointer to the physical block of the next *
+	__le32	ei_block;	/* index covers logical blocks from 'block' */
+	__le32	ei_leaf;	/* pointer to the physical block of the next *
 				 * level. leaf or next index could bet here */
-	__u16	ei_leaf_hi;	/* high 16 bits of physical block */
-	__u16	ei_unused;
+	__le16	ei_leaf_hi;	/* high 16 bits of physical block */
+	__le16	ei_unused;
 };
 
 /*
  * each block (leaves and indexes), even inode-stored has header
  */
 struct ext3_extent_header {
-	__u16	eh_magic;	/* probably will support different formats */
-	__u16	eh_entries;	/* number of valid entries */
-	__u16	eh_max;		/* capacity of store in entries */
-	__u16	eh_depth;	/* has tree real underlaying blocks? */
-	__u32	eh_generation;	/* generation of the tree */
+	__le16	eh_magic;	/* probably will support different formats */
+	__le16	eh_entries;	/* number of valid entries */
+	__le16	eh_max;		/* capacity of store in entries */
+	__le16	eh_depth;	/* has tree real underlaying blocks? */
+	__le32	eh_generation;	/* generation of the tree */
 };
 
 #define EXT3_EXT_MAGIC		0xf30a
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index a409252..44d7d9b 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -73,21 +73,31 @@ struct ext2_extent_path {
 static void dbg_show_header(struct ext3_extent_header *eh)
 {
 	printf("header: magic=%x entries=%u max=%u depth=%u generation=%u\n",
-	       eh->eh_magic, eh->eh_entries, eh->eh_max, eh->eh_depth,
-	       eh->eh_generation);
+			ext2fs_le16_to_cpu(eh->eh_magic),
+			ext2fs_le16_to_cpu(eh->eh_entries),
+			ext2fs_le16_to_cpu(eh->eh_max),
+			ext2fs_le16_to_cpu(eh->eh_depth),
+			ext2fs_le32_to_cpu(eh->eh_generation));
 }
 
 static void dbg_show_index(struct ext3_extent_idx *ix)
 {
 	printf("index: block=%u leaf=%u leaf_hi=%u unused=%u\n",
-	       ix->ei_block, ix->ei_leaf, ix->ei_leaf_hi, ix->ei_unused);
+			ext2fs_le32_to_cpu(ix->ei_block),
+			ext2fs_le32_to_cpu(ix->ei_leaf),
+			ext2fs_le16_to_cpu(ix->ei_leaf_hi),
+			ext2fs_le16_to_cpu(ix->ei_unused));
 }
 
 static void dbg_show_extent(struct ext3_extent *ex)
 {
 	printf("extent: block=%u-%u len=%u start=%u start_hi=%u\n",
-	       ex->ee_block, ex->ee_block + ex->ee_len - 1,
-	       ex->ee_len, ex->ee_start, ex->ee_start_hi);
+			ext2fs_le32_to_cpu(ex->ee_block),
+			ext2fs_le32_to_cpu(ex->ee_block) +
+			ext2fs_le16_to_cpu(ex->ee_len) - 1,
+			ext2fs_le16_to_cpu(ex->ee_len),
+			ext2fs_le32_to_cpu(ex->ee_start),
+			ext2fs_le16_to_cpu(ex->ee_start_hi));
 }
 
 static void dbg_print_extent(char *desc, struct ext2fs_extent *extent)
-- 
1.5.6.3.439.g1e10.dirty

