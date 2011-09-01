From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/37] tune2fs: Add inode checksum support
Date: Wed, 31 Aug 2011 17:36:02 -0700
Message-ID: <20110901003602.1176.24747.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47917 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244Ab1IAAgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:36:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810BukQ026372
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:11:56 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810a5Fu164824
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:36:05 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810a49k005006
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 21:36:05 -0300
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds to tune2fs the ability to toggle the metadata checksum rocompat
feature flag, which will rewrite the inode table with checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 75 insertions(+), 2 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 82833ad..283ad1d 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -82,6 +82,7 @@ static int stride_set, stripe_width_set;
 static char *extended_cmd;
 static unsigned long new_inode_size;
 static char *ext_mount_opts;
+static int rewrite_checksums;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -131,7 +132,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
-		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER
+		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
 static __u32 clear_ok_features[3] = {
@@ -147,7 +149,8 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
-		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
 /*
@@ -330,6 +333,16 @@ static void update_mntopts(ext2_filsys fs, char *mntopts)
 	ext2fs_mark_super_dirty(fs);
 }
 
+static int check_fsck_needed(ext2_filsys fs)
+{
+	if (fs->super->s_state & EXT2_VALID_FS)
+		return 0;
+	printf("\n%s\n", _(please_fsck));
+	if (mount_flags & EXT2_MF_READONLY)
+		printf(_("(and reboot afterwards!)\n"));
+	return 1;
+}
+
 static void request_fsck_afterwards(ext2_filsys fs)
 {
 	static int requested = 0;
@@ -343,6 +356,49 @@ static void request_fsck_afterwards(ext2_filsys fs)
 }
 
 /*
+ * Forcibly set checksums in all inodes.
+ */
+static void rewrite_inodes(ext2_filsys fs)
+{
+	struct ext2_inode_large inode;
+	ext2_inode_scan	scan;
+	errcode_t	retval;
+	ext2_ino_t	ino;
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX)
+		return;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval) {
+		com_err("set_csum", retval, "While opening inode scan");
+		exit(1);
+	}
+
+	do {
+		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		if (retval) {
+			com_err("set_csum", retval, "while getting next inode");
+			exit(1);
+		}
+		if (!ino)
+			break;
+		retval = ext2fs_write_inode(fs, ino, &inode);
+		if (retval) {
+			com_err("set_csum", retval, "while writing inode");
+			exit(1);
+		}
+	} while (ino);
+	ext2fs_close_inode_scan(scan);
+}
+
+static void rewrite_metadata_checksums(ext2_filsys fs)
+{
+	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	rewrite_inodes(fs);
+	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+}
+
+/*
  * Update the feature set as provided by the user.
  */
 static void update_feature_set(ext2_filsys fs, char *features)
@@ -448,6 +504,20 @@ static void update_feature_set(ext2_filsys fs, char *features)
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
+		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		if (check_fsck_needed(fs))
+			exit(1);
+		rewrite_checksums = 1;
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		if (check_fsck_needed(fs))
+			exit(1);
+		rewrite_checksums = 1;
+	}
+
+	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
 		for (i = 0; i < fs->group_desc_count; i++) {
 			gd = ext2fs_group_desc(fs, fs->group_desc, i);
@@ -1824,7 +1894,10 @@ retry_open:
 			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 		}
 		ext2fs_mark_super_dirty(fs);
+		rewrite_checksums = 1;
 	}
+	if (rewrite_checksums)
+		rewrite_metadata_checksums(fs);
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "

