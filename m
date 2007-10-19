From: akpm@linux-foundation.org
Subject: - ext4-flex_bg-kernel-support-v2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:48:25 -0700
Message-ID: <200710190348.l9J3mPDA013543@imap1.linux-foundation.org>
To: jrs@us.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660AbXJSDtB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 23:49:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: FLEX_BG Kernel support
has been removed from the -mm tree.  Its filename was
     ext4-flex_bg-kernel-support-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: FLEX_BG Kernel support
From: Jose R. Santos <jrs@us.ibm.com>

This feature relaxes check restrictions on where each block groups meta
data is located within the storage media.  This allows for the allocation
of bitmaps or inode tables outside the block group boundaries in cases
where bad blocks forces us to look for new blocks which the owning block
group can not satisfy.  This will also allow for new meta-data allocation
schemes to improve performance and scalability.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c         |    9 +++++++--
 include/linux/ext4_fs.h |    4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/ext4/super.c~ext4-flex_bg-kernel-support-v2 fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-flex_bg-kernel-support-v2
+++ a/fs/ext4/super.c
@@ -1358,13 +1358,17 @@ static int ext4_check_descriptors (struc
 	ext4_fsblk_t inode_table;
 	struct ext4_group_desc * gdp = NULL;
 	int desc_block = 0;
+	int flexbg_flag = 0;
 	int i;
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		flexbg_flag = 1;
+
 	ext4_debug ("Checking group descriptors");
 
 	for (i = 0; i < sbi->s_groups_count; i++)
 	{
-		if (i == sbi->s_groups_count - 1)
+		if (i == sbi->s_groups_count - 1 || flexbg_flag)
 			last_block = ext4_blocks_count(sbi->s_es) - 1;
 		else
 			last_block = first_block +
@@ -1409,7 +1413,8 @@ static int ext4_check_descriptors (struc
 				   le16_to_cpu(gdp->bg_checksum));
 			return 0;
 		}
-		first_block += EXT4_BLOCKS_PER_GROUP(sb);
+		if (!flexbg_flag)
+			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 		gdp = (struct ext4_group_desc *)
 			((__u8 *)gdp + EXT4_DESC_SIZE(sb));
 	}
diff -puN include/linux/ext4_fs.h~ext4-flex_bg-kernel-support-v2 include/linux/ext4_fs.h
--- a/include/linux/ext4_fs.h~ext4-flex_bg-kernel-support-v2
+++ a/include/linux/ext4_fs.h
@@ -682,13 +682,15 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT| \
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
_

Patches currently in -mm which might be from jrs@us.ibm.com are

origin.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
jbd-fix-jbd-warnings-when-compiling-with-config_jbd_debug.patch
