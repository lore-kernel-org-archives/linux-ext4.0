From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 38/54] tune2fs: Rewrite block group checksums when changing
 checksumming feature flags
Date: Tue, 06 Mar 2012 16:01:53 -0800
Message-ID: <20120307000153.11945.22919.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e38.co.us.ibm.com ([32.97.110.159]:48621 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031593Ab2CGACq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:02:46 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:02:45 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 79987C40004
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 17:02:14 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q27023li168050
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:02:04 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2701wtp016702
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:02:03 -0700
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When toggling the metadata_csum and uninit_bg feature flags, we should rewrite
the block groups with the desired checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |  116 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 90 insertions(+), 26 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ac5e945..79b49d9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -693,8 +693,12 @@ static void rewrite_inodes(ext2_filsys fs)
 
 static void rewrite_metadata_checksums(ext2_filsys fs)
 {
+	int i;
+
 	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ext2fs_init_csum_seed(fs);
+	for (i = 0; i < fs->group_desc_count; i++)
+		ext2fs_group_desc_csum_set(fs, i);
 	rewrite_inodes(fs);
 	ext2fs_read_bitmaps(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -709,6 +713,49 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_mark_super_dirty(fs);
 }
 
+static void enable_uninit_bg(ext2_filsys fs)
+{
+	struct ext2_group_desc *gd;
+	int i;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		gd = ext2fs_group_desc(fs, fs->group_desc, i);
+		gd->bg_itable_unused = 0;
+		gd->bg_flags = EXT2_BG_INODE_ZEROED;
+		ext2fs_group_desc_csum_set(fs, i);
+	}
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+}
+
+static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
+{
+	struct ext2_group_desc *gd;
+	int i;
+
+	/* Load bitmaps to ensure that the uninit ones get written out */
+	fs->super->s_feature_ro_compat |= csum_feature_flag;
+	ext2fs_read_bitmaps(fs);
+	ext2fs_mark_ib_dirty(fs);
+	ext2fs_mark_bb_dirty(fs);
+	fs->super->s_feature_ro_compat &= ~csum_feature_flag;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		gd = ext2fs_group_desc(fs, fs->group_desc, i);
+		if ((gd->bg_flags & EXT2_BG_INODE_ZEROED) == 0) {
+			/*
+			 * XXX what we really should do is zap
+			 * uninitialized inode tables instead.
+			 */
+			request_fsck_afterwards(fs);
+			break;
+		}
+		gd->bg_itable_unused = 0;
+		gd->bg_flags = 0;
+		ext2fs_group_desc_csum_set(fs, i);
+	}
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+}
+
 /*
  * Update the feature set as provided by the user.
  */
@@ -886,6 +933,21 @@ mmp_error:
 		if (check_fsck_needed(fs))
 			exit(1);
 		rewrite_checksums = 1;
+		/* metadata_csum supersedes uninit_bg */
+		fs->super->s_feature_ro_compat &=
+			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+
+		/* if uninit_bg was previously off, rewrite group desc */
+		if (!(old_features[E2P_FEATURE_RO_INCOMPAT] &
+		      EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			enable_uninit_bg(fs);
+
+		/*
+		 * Since metadata_csum supersedes uninit_bg, pretend like
+		 * uninit_bg has been off all along.
+		 */
+		old_features[E2P_FEATURE_RO_INCOMPAT] &=
+			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
@@ -893,37 +955,40 @@ mmp_error:
 		if (check_fsck_needed(fs))
 			exit(1);
 		rewrite_checksums = 1;
+		/*
+		 * If we're turning off metadata_csum and not turning on
+		 * uninit_bg, rewrite group desc.
+		 */
+		if (!(fs->super->s_feature_ro_compat &
+		      EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			disable_uninit_bg(fs,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+		else
+			/*
+			 * metadata_csum previously provided uninit_bg, so if
+			 * we're also setting the uninit_bg feature bit,
+			 * pretend like it was previously enabled.  Checksums
+			 * will be rewritten with crc16 later.
+			 */
+			old_features[E2P_FEATURE_RO_INCOMPAT] |=
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		for (i = 0; i < fs->group_desc_count; i++) {
-			gd = ext2fs_group_desc(fs, fs->group_desc, i);
-			gd->bg_itable_unused = 0;
-			gd->bg_flags = EXT2_BG_INODE_ZEROED;
-			ext2fs_group_desc_csum_set(fs, i);
-		}
-		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+		/* Do not enable uninit_bg when metadata_csum enabled */
+		if (fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+			fs->super->s_feature_ro_compat &=
+				~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		else
+			enable_uninit_bg(fs);
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
-			EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		for (i = 0; i < fs->group_desc_count; i++) {
-			gd = ext2fs_group_desc(fs, fs->group_desc, i);
-			if ((gd->bg_flags & EXT2_BG_INODE_ZEROED) == 0) {
-				/* 
-				 * XXX what we really should do is zap
-				 * uninitialized inode tables instead.
-				 */
-				request_fsck_afterwards(fs);
-				break;
-			}
-			gd->bg_itable_unused = 0;
-			gd->bg_flags = 0;
-			gd->bg_checksum = 0;
-		}
-		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-	}
+			EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		disable_uninit_bg(fs,
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
@@ -2505,8 +2570,7 @@ retry_open:
 				exit(1);
 		}
 
-		if (sb->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		if (ext2fs_has_group_desc_csum(fs)) {
 			/*
 			 * Determine if the block group checksums are
 			 * correct so we know whether or not to set

