From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/47] tune2fs: enable uninit_bg when disabling metadata_csum
Date: Fri, 07 Nov 2014 13:53:03 -0800
Message-ID: <20141107215303.883.11462.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45782 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaKGVxH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:53:07 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're disabling metadata_csum and the user doesn't provide explicit
instructions to enable or disable uninit_bg, assume that they want
uninit_bg to be turned on by default.  Otherwise, we lose all block
group flags and unused inode count, which is a big hit to performance.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6feaab1..1c83d09 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1141,12 +1141,26 @@ mmp_error:
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		__u32	test_features[3];
+
 		if (check_fsck_needed(fs))
 			exit(1);
 		if (mount_flags & EXT2_MF_MOUNTED)
 			fputs(_("Cannot disable metadata_csum on a mounted "
 				"filesystem!\n"), stderr);
 		rewrite_checksums = 1;
+
+		/* Enable uninit_bg unless the user expressly turned it off */
+		memcpy(test_features, old_features, sizeof(test_features));
+		test_features[E2P_FEATURE_RO_INCOMPAT] |=
+						EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		e2p_edit_feature2(features, test_features, ok_features,
+				  clear_ok_features, NULL, NULL);
+		if (test_features[E2P_FEATURE_RO_INCOMPAT] &
+						EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
+			fs->super->s_feature_ro_compat |=
+						EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+
 		/*
 		 * If we're turning off metadata_csum and not turning on
 		 * uninit_bg, rewrite group desc.

