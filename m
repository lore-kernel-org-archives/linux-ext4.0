From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 38/50] tune2fs: Rewrite block group checksums when changing
	bg_use_meta_csum feature
Date: Mon, 28 Nov 2011 16:32:18 -0800
Message-ID: <20111129003218.17953.80128.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44729 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1K2AcY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:32:24 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:32:24 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0WKPP329036
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:32:20 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0WJIJ016789
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:32:20 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When toggling the bg_use_meta_csum feature, we should rewrite the block groups
with the desired checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 47 insertions(+), 2 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 7299ad6..8301927 100644
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
@@ -692,7 +695,11 @@ static void rewrite_inodes(ext2_filsys fs)
 
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
@@ -708,6 +715,28 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
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
@@ -879,6 +908,20 @@ mmp_error:
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
@@ -2540,6 +2583,8 @@ retry_open:
 	}
 	if (rewrite_checksums)
 		rewrite_metadata_checksums(fs);
+	else if (rewrite_bgs_for_checksum)
+		rewrite_bg_checksums(fs);
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "

