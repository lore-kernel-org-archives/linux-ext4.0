From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 36/47] libext2fs: Block group checksum should use
	metadata_csum algorithm (if feature flag set)
Date: Sat, 08 Oct 2011 00:37:06 -0700
Message-ID: <20111008073706.17888.29111.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:40068 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1JHHj7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:39:59 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987LFIx006462
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:21:15 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987b9Kj207728
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:37:09 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987b7ob018544
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:37:09 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change the block group algorithm to use the same algorithm as the rest of the
metadata_csum, if a certain incompat feature flag is set.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/csum.c    |   62 ++++++++++++++++++++++++++++++++++----------------
 lib/ext2fs/ext2_fs.h |    1 +
 lib/ext2fs/ext2fs.h  |    6 +++--
 4 files changed, 49 insertions(+), 22 deletions(-)


diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 63486f3..dc52ba7 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -85,6 +85,8 @@ static struct feature feature_list[] = {
 			"mmp" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
 			"flex_bg"},
+	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
+			"bg_use_meta_csum"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 9e4536e..9694185 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -711,32 +711,54 @@ STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 
 	desc = ext2fs_group_desc(fs, fs->group_desc, group);
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
-		size_t offset = offsetof(struct ext2_group_desc, bg_checksum);
-
 #ifdef WORDS_BIGENDIAN
-		struct ext4_group_desc swabdesc;
+	struct ext4_group_desc swabdesc;
 
-		/* Have to swab back to little-endian to do the checksum */
-		memcpy(&swabdesc, desc, size);
-		ext2fs_swap_group_desc2(fs,
-					(struct ext2_group_desc *) &swabdesc);
-		desc = (struct ext2_group_desc *) &swabdesc;
+	/* Have to swab back to little-endian to do the checksum */
+	memcpy(&swabdesc, desc, size);
+	ext2fs_swap_group_desc2(fs,
+				(struct ext2_group_desc *) &swabdesc);
+	desc = (struct ext2_group_desc *) &swabdesc;
 
-		group = ext2fs_swab32(group);
+	group = ext2fs_swab32(group);
 #endif
-		crc = ext2fs_crc16(~0, fs->super->s_uuid,
-				   sizeof(fs->super->s_uuid));
-		crc = ext2fs_crc16(crc, &group, sizeof(group));
-		crc = ext2fs_crc16(crc, desc, offset);
-		offset += sizeof(desc->bg_checksum); /* skip checksum */
-		/* for checksum of struct ext4_group_desc do the rest...*/
-		if (offset < size) {
-			crc = ext2fs_crc16(crc, (char *)desc + offset,
-					   size - offset);
-		}
+
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
+		/* new metadata csum code */
+		__u16 old_crc;
+		__u32 crc32;
+
+		old_crc = desc->bg_checksum;
+		desc->bg_checksum = 0;
+		crc32 = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+					 sizeof(fs->super->s_uuid));
+		crc32 = ext2fs_crc32c_le(crc32, (unsigned char *)&group,
+					 sizeof(group));
+		crc32 = ext2fs_crc32c_le(crc32, (unsigned char *)desc,
+					 size);
+		desc->bg_checksum = old_crc;
+
+		crc = crc32 & 0xFFFF;
+		goto out;
 	}
 
+	/* old crc16 code */
+	size_t offset = offsetof(struct ext2_group_desc, bg_checksum);
+	crc = ext2fs_crc16(~0, fs->super->s_uuid,
+			   sizeof(fs->super->s_uuid));
+	crc = ext2fs_crc16(crc, &group, sizeof(group));
+	crc = ext2fs_crc16(crc, desc, offset);
+	offset += sizeof(desc->bg_checksum); /* skip checksum */
+	/* for checksum of struct ext4_group_desc do the rest...*/
+	if (offset < size) {
+		crc = ext2fs_crc16(crc, (char *)desc + offset,
+				   size - offset);
+	}
+
+out:
 	return crc;
 }
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index d6cd6e0..709fc2f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -742,6 +742,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
+#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x2000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9311336..d4d4ecf 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -567,7 +567,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
@@ -576,7 +577,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\

