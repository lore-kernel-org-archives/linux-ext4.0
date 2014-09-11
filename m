From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 27/25] tune2fs: always check disable_uninit_bg() return code
Date: Thu, 11 Sep 2014 12:43:33 -0700
Message-ID: <20140911194333.GS10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: TR Reardon <thomas_reardon@hotmail.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41706 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaIKTnm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 15:43:42 -0400
Content-Disposition: inline
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enhance disable_uninit_bg() to return error codes -- if something goes
wrong, we want to flag the FS as needing a fsck and exit.  Mr. Reardon
discovered that tune2fs -O ^metadata_csum on a FS with a corrupt
bitmap would leave the FS in a weird state.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: TR Reardon <thomas_reardon@hotmail.com>
---
 misc/tune2fs.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 7292ab1..80debe7 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -839,7 +839,7 @@ out:
 	return retval;
 }
 
-static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
+static errcode_t disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 {
 	struct ext2_group_desc *gd;
 	dgrp_t i;
@@ -849,14 +849,15 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 	/* Load bitmaps to ensure that the uninit ones get written out */
 	fs->super->s_feature_ro_compat |= csum_feature_flag;
 	retval = ext2fs_read_bitmaps(fs);
+	fs->super->s_feature_ro_compat &= ~csum_feature_flag;
 	if (retval) {
 		com_err("disable_uninit_bg", retval,
 			"while reading bitmaps");
-		return;
+		request_fsck_afterwards(fs);
+		return retval;
 	}
 	ext2fs_mark_ib_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
-	fs->super->s_feature_ro_compat &= ~csum_feature_flag;
 
 	/* If we're only turning off uninit_bg, zero the inodes */
 	if (csum_feature_flag == EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
@@ -865,6 +866,7 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 			com_err("disable_uninit_bg", retval,
 				"while zeroing unused inodes");
 			request_fsck_afterwards(fs);
+			return retval;
 		}
 	}
 
@@ -895,6 +897,8 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 	}
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	ext2fs_mark_super_dirty(fs);
+
+	return 0;
 }
 
 /*
@@ -906,6 +910,7 @@ static int update_feature_set(ext2_filsys fs, char *features)
 	__u32		old_features[3];
 	int		type_err;
 	unsigned int	mask_err;
+	errcode_t	err;
 
 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
 				((&sb->s_feature_compat)[(type)] & (mask)))
@@ -1114,10 +1119,12 @@ mmp_error:
 		 * uninit_bg, rewrite group desc.
 		 */
 		if (!(fs->super->s_feature_ro_compat &
-		      EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-			disable_uninit_bg(fs,
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
-		else
+		      EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+			err = disable_uninit_bg(fs,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+			if (err)
+				return 1;
+		} else
 			/*
 			 * metadata_csum previously provided uninit_bg, so if
 			 * we're also setting the uninit_bg feature bit,
@@ -1140,9 +1147,12 @@ mmp_error:
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
-			EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		disable_uninit_bg(fs,
+			EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		err = disable_uninit_bg(fs,
 				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+		if (err)
+			return 1;
+	}
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
