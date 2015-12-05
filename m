From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/8] tune2fs: allow user to turn on saving the checksum seed
Date: Fri, 04 Dec 2015 18:44:29 -0800
Message-ID: <20151205024429.31087.44274.stgit@birch.djwong.org>
References: <20151205024416.31087.14808.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42713 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbLECoc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 21:44:32 -0500
In-Reply-To: <20151205024416.31087.14808.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 6 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4d57399..f9e654f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -149,7 +149,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
 		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT |
-		EXT4_FEATURE_INCOMPAT_ENCRYPT,
+		EXT4_FEATURE_INCOMPAT_ENCRYPT |
+		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -171,7 +172,8 @@ static __u32 clear_ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT,
+		EXT4_FEATURE_INCOMPAT_64BIT |
+		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -948,6 +950,15 @@ static errcode_t disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 	return 0;
 }
 
+static void
+try_confirm_csum_seed_support(void)
+{
+	if (access("/sys/fs/ext4/features/metadata_csum_seed", R_OK))
+		fputs(_("WARNING: Could not confirm kernel support for "
+			"metadata_csum_seed.\n  This requires Linux >= "
+			"v4.4.\n"), stderr);
+}
+
 /*
  * Update the feature set as provided by the user.
  */
@@ -1212,6 +1223,8 @@ mmp_error:
 			 */
 			old_features[E2P_FEATURE_RO_INCOMPAT] |=
 				EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		fs->super->s_checksum_seed = 0;
+		ext2fs_clear_feature_csum_seed(fs->super);
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
@@ -1294,6 +1307,37 @@ mmp_error:
 			EXT4_ENCRYPTION_MODE_AES_256_CTS;
 	}
 
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
+		EXT4_FEATURE_INCOMPAT_CSUM_SEED)) {
+		if (!ext2fs_has_feature_metadata_csum(sb)) {
+			fputs(_("Setting feature 'metadata_csum_seed' "
+				"is only supported\non filesystems with "
+				"the metadata_csum feature enabled.\n"),
+				stderr);
+			return 1;
+		}
+		try_confirm_csum_seed_support();
+		fs->super->s_checksum_seed = fs->csum_seed;
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
+		EXT4_FEATURE_INCOMPAT_CSUM_SEED)) {
+		__le32 uuid_seed;
+
+		uuid_seed = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+					sizeof(fs->super->s_uuid));
+		if (fs->super->s_checksum_seed != uuid_seed &&
+		    (mount_flags & EXT2_MF_MOUNTED)) {
+			fputs(_("UUID has changed since enabling "
+				"metadata_csum.  Filesystem must be unmounted "
+				"\nto safely rewrite all metadata to "
+				"match the new UUID.\n"), stderr);
+			return 1;
+		}
+
+		rewrite_checksums = 1;
+	}
+
 	if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
 	    (sb->s_feature_compat || sb->s_feature_ro_compat ||
 	     sb->s_feature_incompat))
@@ -2937,13 +2981,22 @@ retry_open:
 
 		if (ext2fs_has_group_desc_csum(fs)) {
 			/*
-			 * Changing the UUID requires rewriting all metadata,
-			 * which can race with a mounted fs.  Don't allow that.
+			 * Changing the UUID on a metadata_csum FS requires
+			 * rewriting all metadata, which can race with a
+			 * mounted fs.  Don't allow that unless we're saving
+			 * the checksum seed.
 			 */
-			if ((mount_flags & EXT2_MF_MOUNTED) && !f_flag) {
+			if ((mount_flags & EXT2_MF_MOUNTED) &&
+			    !ext2fs_has_feature_csum_seed(fs->super) &&
+			    ext2fs_has_feature_metadata_csum(fs->super)) {
 				fputs(_("The UUID may only be "
 					"changed when the filesystem is "
 					"unmounted.\n"), stderr);
+				fputs(_("If you only use kernels newer than "
+					"v4.4, run 'tune2fs -O "
+					"metadata_csum_seed' and re-run this "
+					"command.\n"), stderr);
+				try_confirm_csum_seed_support();
 				exit(1);
 			}
 			if (check_fsck_needed(fs))
@@ -3005,7 +3058,8 @@ retry_open:
 		}
 
 		ext2fs_mark_super_dirty(fs);
-		if (ext2fs_has_feature_metadata_csum(fs->super))
+		if (ext2fs_has_feature_metadata_csum(fs->super) &&
+		    !ext2fs_has_feature_csum_seed(fs->super))
 			rewrite_checksums = 1;
 	}
 

