From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/47] tune2fs: warn if extents are not enabled when turning
 on metadata_csum
Date: Fri, 07 Nov 2014 13:52:57 -0800
Message-ID: <20141107215257.883.38333.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36055 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaKGVxC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:53:02 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Warn the user if we're trying to enable metadata_csum on a FS that
doesn't support extents (since block maps cannot contain checksums).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 7fee870..6feaab1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1113,6 +1113,14 @@ mmp_error:
 		if (mount_flags & EXT2_MF_MOUNTED)
 			fputs(_("Cannot enable metadata_csum on a mounted "
 				"filesystem!\n"), stderr);
+		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT3_FEATURE_INCOMPAT_EXTENTS))
+			printf("%s",
+			       _("Extents are not enabled.  The file extent "
+				 "tree can be checksummed, whereas block maps "
+				 "cannot.  Not enabling extents reduces the "
+				 "coverage of metadata checksumming.  "
+				 "Re-run with -O extent to rectify.\n"));
 		rewrite_checksums = 1;
 		/* metadata_csum supersedes uninit_bg */
 		fs->super->s_feature_ro_compat &=

