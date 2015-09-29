From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] tune2fs: don't change UUID on a mounted metadata_csum fs
Date: Tue, 29 Sep 2015 08:31:22 -0700
Message-ID: <20150929153122.GJ10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28554 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934005AbbI2Pb0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Sep 2015 11:31:26 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's not safe to change the UUID on a mounted filesystem when the
metadata_csum feature is enabled because there's (currently) no
way to update the kernel's CRC seeds, which precompute the UUID
component of the checksum for all metadata blocks.  Not to mention
that we'd have to rewrite /all/ metadata blocks, and any kernel disk
accesses will race with tune2fs, thus destroying the filesystem.

Note that it's fine to do the online UUID update if *only* group
descriptor checksums are enabled.

This is a regression introduced by 2334bd3a ("tune2fs: allow changing
the UUID mounted file systems with the -f option") which does not
seem to have been reviewed on the mailing list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2f27d6f..ad833de 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2960,7 +2960,9 @@ retry_open:
 			 * Changing the UUID requires rewriting all metadata,
 			 * which can race with a mounted fs.  Don't allow that.
 			 */
-			if ((mount_flags & EXT2_MF_MOUNTED) && !f_flag) {
+			if ((mount_flags & EXT2_MF_MOUNTED) && (!f_flag ||
+			     EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))) {
 				fputs(_("The UUID may only be "
 					"changed when the filesystem is "
 					"unmounted.\n"), stderr);
