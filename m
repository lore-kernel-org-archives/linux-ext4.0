From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/54] tune2fs: abort when trying to enable/disable
 metadata_csum on mounted fs
Date: Mon, 26 Jan 2015 23:36:38 -0800
Message-ID: <20150127073638.13308.31584.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33363 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0Hgm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:36:42 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Earlier, I tried to make tune2fs abort if the user tried to enable or
disable metadata_csum on a mounted FS, but forgot the exit() call.
Supply it now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index f01b05b..e33b0d3 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1110,9 +1110,11 @@ mmp_error:
 		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (check_fsck_needed(fs))
 			exit(1);
-		if (mount_flags & EXT2_MF_MOUNTED)
+		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("Cannot enable metadata_csum on a mounted "
 				"filesystem!\n"), stderr);
+			exit(1);
+		}
 		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				EXT3_FEATURE_INCOMPAT_EXTENTS))
 			printf("%s",
@@ -1152,9 +1154,11 @@ mmp_error:
 
 		if (check_fsck_needed(fs))
 			exit(1);
-		if (mount_flags & EXT2_MF_MOUNTED)
+		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("Cannot disable metadata_csum on a mounted "
 				"filesystem!\n"), stderr);
+			exit(1);
+		}
 		rewrite_checksums = 1;
 
 		/* Enable uninit_bg unless the user expressly turned it off */

