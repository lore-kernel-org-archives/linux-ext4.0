From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] ext4: FLEX_BG Kernel support v2.
Date: Fri, 21 Sep 2007 09:06:49 -0500
Message-ID: <20070921140649.4352.30055.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:42701 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbXIUOKE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 10:10:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

ext4: FLEX_BG Kernel support v2.

This feature relaxes check restrictions on where each block groups meta data is 
located within the storage media.  This allows for the allocation of bitmaps or 
inode tables outside the block group boundaries in cases where bad blocks forces
us to look for new blocks which the owning block group can not satisfy.  This 
will also allow for new meta-data allocation schemes to improve performance and
scalability.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 fs/ext4/super.c         |    9 +++++++--
 include/linux/ext4_fs.h |    4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4550b83..dbce81d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1248,13 +1248,17 @@ static int ext4_check_descriptors (struct super_block * sb)
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
@@ -1291,7 +1295,8 @@ static int ext4_check_descriptors (struct super_block * sb)
 				    i, inode_table);
 			return 0;
 		}
-		first_block += EXT4_BLOCKS_PER_GROUP(sb);
+		if (!flexbg_flag)
+			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 		gdp = (struct ext4_group_desc *)
 			((__u8 *)gdp + EXT4_DESC_SIZE(sb));
 	}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index cdee7aa..d53e167 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -702,13 +702,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
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
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
