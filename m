From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] FLEX_BG Kernel support.
Date: Mon, 10 Sep 2007 16:22:24 -0500
Message-ID: <20070910212224.13310.54532.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59067 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbXIJVZf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2007 17:25:35 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8ALPYKp001866
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 17:25:34 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8ALPYRi496986
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 17:25:34 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8ALPYgL020360
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 17:25:34 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l8ALPYfr020352
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 17:25:34 -0400
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l8ALPXtK036746
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 16:25:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

FLEX_BG Kernel support.

This feature relaxes check restrictions on where each block groups meta data is 
located within the storage media.  This allows for the allocation of bitmaps or 
inode tables outside the block group boundaries in cases where bad blocks forces
us to look for new blocks which the owning block group can not satisfy.  This 
will also allow for new meta-data allocation schemes to improve performance and
scalability.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 fs/ext4/super.c         |    7 +++++--
 include/linux/ext4_fs.h |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4550b83..902e5c8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1254,7 +1254,8 @@ static int ext4_check_descriptors (struct super_block * sb)
 
 	for (i = 0; i < sbi->s_groups_count; i++)
 	{
-		if (i == sbi->s_groups_count - 1)
+		if (i == sbi->s_groups_count - 1 || EXT4_HAS_INCOMPAT_FEATURE(sb,
+					EXT4_FEATURE_INCOMPAT_FLEX_BG))
 			last_block = ext4_blocks_count(sbi->s_es) - 1;
 		else
 			last_block = first_block +
@@ -1291,7 +1292,9 @@ static int ext4_check_descriptors (struct super_block * sb)
 				    i, inode_table);
 			return 0;
 		}
-		first_block += EXT4_BLOCKS_PER_GROUP(sb);
+		if (!EXT4_HAS_INCOMPAT_FEATURE(sb,
+					       EXT4_FEATURE_INCOMPAT_FLEX_BG))
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
