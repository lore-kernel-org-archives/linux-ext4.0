From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 37/47] tune2fs: Rewrite block group checksums when changing
	bg_use_meta_csum feature
Date: Sat, 08 Oct 2011 00:37:12 -0700
Message-ID: <20111008073712.17888.20983.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49662 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1JHHjR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:39:17 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:39:16 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987bFAS267340
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:37:15 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987bD7B011690
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:37:15 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When toggling the bg_use_meta_csum feature, we should rewrite the block groups
with the desired checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 47 insertions(+), 2 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 708bc20..4f02905 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -92,6 +92,7 @@ static unsigned long new_inode_size;
 static char *ext_mount_opts;
 static int usrquota, grpquota;
 static int rewrite_checksums;
+static int rewrite_bgs_for_checksum;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -137,7 +138,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -157,7 +159,8 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -693,7 +696,11 @@ static void rewrite_inodes(ext2_filsys fs)
 
 static void rewrite_metadata_checksums(ext2_filsys fs)
 {
+	int i;
+
 	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	for (i = 0; i < fs->group_desc_count; i++)
+		ext2fs_group_desc_csum_set(fs, i);
 	rewrite_inodes(fs);
 	ext2fs_read_bitmaps(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -709,6 +716,28 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 }
 
 /*
+ * Rewrite just the block group checksums.  Only call this function if
+ * you're _not_ calling rewrite_metadata_checksums; this function exists
+ * to handle the case that you're changing bg_use_meta_csum and NOT changing
+ * either gdt_csum or metadata_csum.
+ */
+static void rewrite_bg_checksums(ext2_filsys fs)
+{
+	int i;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
+	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	for (i = 0; i < fs->group_desc_count; i++)
+		ext2fs_group_desc_csum_set(fs, i);
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_super_dirty(fs);
+}
+
+/*
  * Update the feature set as provided by the user.
  */
 static int update_feature_set(ext2_filsys fs, char *features)
@@ -880,6 +909,20 @@ mmp_error:
 		}
 	}
 
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
+		       EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
+		if (check_fsck_needed(fs))
+			exit(1);
+		rewrite_bgs_for_checksum = 1;
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
+			EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
+		if (check_fsck_needed(fs))
+			exit(1);
+		rewrite_bgs_for_checksum = 1;
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (check_fsck_needed(fs))
@@ -2525,6 +2568,8 @@ retry_open:
 	}
 	if (rewrite_checksums)
 		rewrite_metadata_checksums(fs);
+	else if (rewrite_bgs_for_checksum)
+		rewrite_bg_checksums(fs);
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "

