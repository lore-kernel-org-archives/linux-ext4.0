From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 06/50] tune2fs: Add inode checksum support
Date: Mon, 28 Nov 2011 16:28:36 -0800
Message-ID: <20111129002836.17953.40960.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:41985 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1K2Aae (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 19:30:34 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:30:34 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0SgYT116916
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:28:42 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0SbeP029838
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:28:41 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds to tune2fs the ability to toggle the metadata checksum rocompat
feature flag, which will rewrite the inode table with checksums.  Disallow
changing the UUID while the fs is mounted, because rewriting the metadata
objects is racy.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 104 insertions(+), 2 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 74a0489..260b040 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -91,6 +91,7 @@ static char *extended_cmd;
 static unsigned long new_inode_size;
 static char *ext_mount_opts;
 static int usrquota, grpquota;
+static int rewrite_checksums;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -142,7 +143,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |
-		EXT4_FEATURE_RO_COMPAT_QUOTA
+		EXT4_FEATURE_RO_COMPAT_QUOTA |
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
 static __u32 clear_ok_features[3] = {
@@ -160,7 +162,8 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
-		EXT4_FEATURE_RO_COMPAT_QUOTA
+		EXT4_FEATURE_RO_COMPAT_QUOTA |
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
 /*
@@ -351,6 +354,16 @@ static int update_mntopts(ext2_filsys fs, char *mntopts)
 	return 0;
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
@@ -364,6 +377,59 @@ static void request_fsck_afterwards(ext2_filsys fs)
 }
 
 /*
+ * Forcibly set checksums in all inodes.
+ */
+static void rewrite_inodes(ext2_filsys fs)
+{
+	int length = EXT2_INODE_SIZE(fs->super);
+	struct ext2_inode *inode;
+	ext2_inode_scan	scan;
+	errcode_t	retval;
+	ext2_ino_t	ino;
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX)
+		return;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval) {
+		com_err("set_csum", retval, "while opening inode scan");
+		exit(1);
+	}
+
+	retval = ext2fs_get_mem(length, &inode);
+	if (retval) {
+		com_err("set_csum", retval, "while allocating memory");
+		exit(1);
+	}
+
+	do {
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode, length);
+		if (retval) {
+			com_err("set_csum", retval, "while getting next inode");
+			exit(1);
+		}
+		if (!ino)
+			break;
+
+		retval = ext2fs_write_inode_full(fs, ino, inode, length);
+		if (retval) {
+			com_err("set_csum", retval, "while writing inode");
+			exit(1);
+		}
+	} while (ino);
+
+	ext2fs_free_mem(&inode);
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
 static int update_feature_set(ext2_filsys fs, char *features)
@@ -536,6 +602,20 @@ mmp_error:
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
@@ -2128,6 +2208,23 @@ retry_open:
 		int set_csum = 0;
 		dgrp_t i;
 
+		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+			/*
+			 * Changing the UUID requires rewriting all metadata,
+			 * which can race with a mounted fs.  Don't allow that.
+			 */
+			if (mount_flags & EXT2_MF_MOUNTED) {
+				fputs(_("The UUID may only be "
+					"changed when the filesystem is "
+					"unmounted.\n"), stderr);
+				exit(1);
+			}
+
+			if (check_fsck_needed(fs))
+				exit(1);
+		}
+
 		if (sb->s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
 			/*
@@ -2159,7 +2256,12 @@ retry_open:
 			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 		}
 		ext2fs_mark_super_dirty(fs);
+		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+			rewrite_checksums = 1;
 	}
+	if (rewrite_checksums)
+		rewrite_metadata_checksums(fs);
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "

