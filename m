From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/54] tune2fs: call out to resize2fs for 64bit conversion
Date: Mon, 26 Jan 2015 23:36:44 -0800
Message-ID: <20150127073644.13308.74437.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45678 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0Hgt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:36:49 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the user tries to enable or disable the 64bit feature via tune2fs,
tell them how to use resize2fs to effect the conversion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index e33b0d3..258121f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -97,6 +97,8 @@ static unsigned long new_inode_size;
 static char *ext_mount_opts;
 static int usrquota, grpquota;
 static int rewrite_checksums;
+static int feature_64bit;
+static int fsck_requested;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -146,7 +148,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -168,7 +171,8 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -418,6 +422,7 @@ static void request_dir_fsck_afterwards(ext2_filsys fs)
 
 	if (requested++)
 		return;
+	fsck_requested++;
 	fs->super->s_state &= ~EXT2_VALID_FS;
 	printf("\n%s\n", _(please_dir_fsck));
 	if (mount_flags & EXT2_MF_READONLY)
@@ -430,12 +435,40 @@ static void request_fsck_afterwards(ext2_filsys fs)
 
 	if (requested++)
 		return;
+	fsck_requested++;
 	fs->super->s_state &= ~EXT2_VALID_FS;
 	printf("\n%s\n", _(please_fsck));
 	if (mount_flags & EXT2_MF_READONLY)
 		printf("%s", _("(and reboot afterwards!)\n"));
 }
 
+static void convert_64bit(ext2_filsys fs, int direction)
+{
+	if (!direction)
+		return;
+
+	/*
+	 * Is resize2fs going to demand a fsck run? Might as well tell the
+	 * user now.
+	 */
+	if (!fsck_requested &&
+	    ((fs->super->s_state & EXT2_ERROR_FS) ||
+	     !(fs->super->s_state & EXT2_VALID_FS) ||
+	     fs->super->s_lastcheck < fs->super->s_mtime))
+		request_fsck_afterwards(fs);
+	if (fsck_requested)
+		fprintf(stderr, _("After running e2fsck, please run `resize2fs %s %s"),
+			direction > 0 ? "-b" : "-s", fs->device_name);
+	else
+		fprintf(stderr, _("Please run `resize2fs %s %s"),
+			direction > 0 ? "-b" : "-s", fs->device_name);
+
+	if (direction > 0)
+		fprintf(stderr, _("' to enable 64-bit mode.\n"));
+	else
+		fprintf(stderr, _("' to disable 64-bit mode.\n"));
+}
+
 /* Rewrite extents */
 static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino,
 				 struct ext2_inode *inode)
@@ -1212,6 +1245,32 @@ mmp_error:
 			return 1;
 	}
 
+	/*
+	 * We don't actually toggle 64bit; resize2fs does that.  But this
+	 * must come after the metadata_csum feature_on so that it won't
+	 * complain about the lack of 64bit.
+	 */
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
+		       EXT4_FEATURE_INCOMPAT_64BIT)) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fprintf(stderr, _("Cannot enable 64-bit mode "
+					  "while mounted!\n"));
+			exit(1);
+		}
+		sb->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_64BIT;
+		feature_64bit = 1;
+	}
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
+			EXT4_FEATURE_INCOMPAT_64BIT)) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fprintf(stderr, _("Cannot disable 64-bit mode "
+					  "while mounted!\n"));
+			exit(1);
+		}
+		sb->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
+		feature_64bit = -1;
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 		/*
@@ -3015,5 +3074,6 @@ closefs:
 		exit(1);
 	}
 
+	convert_64bit(fs, feature_64bit);
 	return (ext2fs_close_free(&fs) ? 1 : 0);
 }

