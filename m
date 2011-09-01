From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/37] mke2fs: Allow metadata checksums to be turned on at
	mkfs time
Date: Wed, 31 Aug 2011 17:36:15 -0700
Message-ID: <20110901003615.1176.76957.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59059 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab1IAAgT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:36:19 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p81066nu031935
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:06:06 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810aI2m190308
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:36:18 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810aGFi024432
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:36:18 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Write out checksummed inodes even when writing out a zeroed table.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 2d57d09..bbc0533 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -309,6 +309,8 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 	dgrp_t		i;
 	int		num;
 	struct ext2fs_numeric_progress_struct progress;
+	ext2_ino_t	ino;
+	struct ext2_inode_large inode;
 
 	ext2fs_numeric_progress_init(fs, &progress,
 				     _("Writing inode tables: "),
@@ -330,12 +332,32 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
 			ext2fs_group_desc_csum_set(fs, i);
 		}
-		retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
-		if (retval) {
-			fprintf(stderr, _("\nCould not write %d "
-				  "blocks in inode table starting at %llu: %s\n"),
-				num, blk, error_message(retval));
-			exit(1);
+		if (fs->super->s_creator_os == EXT2_OS_LINUX &&
+		    fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+			bzero(&inode, sizeof(inode));
+			for (ino = fs->super->s_inodes_per_group * i;
+			     ino < fs->super->s_inodes_per_group * (i + 1);
+			     ino++) {
+				if (!ino)
+					continue;
+				retval = ext2fs_write_inode(fs, ino, &inode);
+				if (retval) {
+					com_err("inode_init", retval,
+						"while writing inode %d\n",
+						ino);
+					exit(1);
+				}
+			}
+		} else {
+			retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
+			if (retval) {
+				fprintf(stderr, _("\nCould not write %d "
+					"blocks in inode table starting "
+					"at %llu: %s\n"),
+					num, blk, error_message(retval));
+				exit(1);
+			}
 		}
 		if (sync_kludge) {
 			if (sync_kludge == 1)
@@ -829,7 +851,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
-		EXT4_FEATURE_RO_COMPAT_BIGALLOC
+		EXT4_FEATURE_RO_COMPAT_BIGALLOC|
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
 

