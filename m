From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 36/51] libext2fs: Block group checksum should use
	metadata_csum algorithm (if feature flag set)
Date: Tue, 13 Dec 2011 17:17:17 -0800
Message-ID: <20111214011717.20947.73708.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53037 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab1LNBRY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:17:24 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:17:23 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1HKAS310036
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:17:20 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1HJQW019928
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:17:20 -0500
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change the block group algorithm to use the same algorithm as the rest of the
metadata_csum, if a certain incompat feature flag is set.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/e2p/feature.c |    2 ++
 lib/ext2fs/csum.c |   62 ++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 44 insertions(+), 20 deletions(-)


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
index 00a1d6a..f938c83 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -721,32 +721,54 @@ STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 
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
 

