From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/19] dumpe2fs: complain when checksum verification fails
Date: Fri, 01 Aug 2014 11:12:06 -0700
Message-ID: <20140801181206.12496.84778.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33000 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaHASMM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:12 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Warn the user to run e2fsck if the superblock or bitmaps fails
checksum verification.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/dumpe2fs.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 0b84ece..7cbb99b 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -620,7 +620,7 @@ int main (int argc, char ** argv)
 		flags |= EXT2_FLAG_FORCE;
 	if (image_dump)
 		flags |= EXT2_FLAG_IMAGE_FILE;
-
+try_open_again:
 	if (use_superblock && !use_blocksize) {
 		for (use_blocksize = EXT2_MIN_BLOCK_SIZE;
 		     use_blocksize <= EXT2_MAX_BLOCK_SIZE;
@@ -635,6 +635,13 @@ int main (int argc, char ** argv)
 	} else
 		retval = ext2fs_open (device_name, flags, use_superblock,
 				      use_blocksize, unix_io_manager, &fs);
+	if (retval && !(flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
+		flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		goto try_open_again;
+	}
+	if (!retval && (fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS))
+		printf("%s", _("\n*** Checksum errors detected in filesystem!  Run e2fsck now!\n\n"));
+	flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (retval) {
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
@@ -663,7 +670,15 @@ int main (int argc, char ** argv)
 			ext2fs_close_free(&fs);
 			exit (0);
 		}
+		fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+try_bitmaps_again:
 		retval = ext2fs_read_bitmaps (fs);
+		if (retval && !(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
+			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			goto try_bitmaps_again;
+		}
+		if (!retval && (fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS))
+			printf("%s", _("\n*** Checksum errors detected in bitmaps!  Run e2fsck now!\n\n"));
 		list_desc (fs);
 		if (retval) {
 			printf(_("\n%s: %s: error reading bitmaps: %s\n"),

