From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/39] tune2fs: don't change metadata_csum on a mounted fs
Date: Sat, 25 Oct 2014 13:57:15 -0700
Message-ID: <20141025205714.532.67707.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43778 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaJYU5i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:38 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't let users change metadata_csum on a mounted filesystem because
there's no way to tell the kernel to turn on the feature; there's no
way to prevent the kernel from rewriting on-disk structures while
tune2fs is also rewriting them; and there's no way to tell the kernel
to reload them after tune2fs is finished.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ecbdea0..7fee870 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1110,6 +1110,9 @@ mmp_error:
 		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (check_fsck_needed(fs))
 			exit(1);
+		if (mount_flags & EXT2_MF_MOUNTED)
+			fputs(_("Cannot enable metadata_csum on a mounted "
+				"filesystem!\n"), stderr);
 		rewrite_checksums = 1;
 		/* metadata_csum supersedes uninit_bg */
 		fs->super->s_feature_ro_compat &=
@@ -1132,6 +1135,9 @@ mmp_error:
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (check_fsck_needed(fs))
 			exit(1);
+		if (mount_flags & EXT2_MF_MOUNTED)
+			fputs(_("Cannot disable metadata_csum on a mounted "
+				"filesystem!\n"), stderr);
 		rewrite_checksums = 1;
 		/*
 		 * If we're turning off metadata_csum and not turning on

