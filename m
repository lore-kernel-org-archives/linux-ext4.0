From: akpm@linux-foundation.org
Subject: + ext4-flex_bg-kernel-support-v2.patch added to -mm tree
Date: Fri, 21 Sep 2007 12:58:14 -0700
Message-ID: <200709211958.l8LJwEvh020007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jrs@us.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: FLEX_BG Kernel support
has been added to the -mm tree.  Its filename is
     ext4-flex_bg-kernel-support-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1386,13 +1386,17 @@ static int ext4_check_descriptors (struc
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
@@ -1437,7 +1441,8 @@ static int ext4_check_descriptors (struc
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
@@ -694,13 +694,15 @@ static inline int ext4_valid_inum(struct
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

ext4-flex_bg-kernel-support-v2.patch
