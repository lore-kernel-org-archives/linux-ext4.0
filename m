From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 1/3] filefrag: minor code fixes and cleanups
Date: Wed, 30 Jul 2014 14:25:49 -0600
Message-ID: <1406751951-23059-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, David Sterba <dsterba@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-03.shaw.ca ([64.59.136.139]:1790 "EHLO
	smtp-out-03.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaG3UZy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 16:25:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Print filefrag_fiemap() error message to stderr instead of stdout.

Only call ioctl(EXT3_IOC_GETFLAGS) for ext{2,3,4} filesystems to
decide if the ext2 indirect block allocation heuristic shold be used.

Properly handle the the force_bmap (-B) option.

Exit with a positive error number instead of a negative one.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/filefrag.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 2ce1b9b..d71bf43 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -226,9 +226,11 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
 		if (rc < 0) {
 			static int fiemap_incompat_printed;
+
 			rc = -errno;
 			if (rc == -EBADR && !fiemap_incompat_printed) {
-				printf("FIEMAP failed with unknown flags %#x\n",
+				fprintf(stderr, "FIEMAP failed with unknown "
+						"flags %x\n",
 				       fiemap->fm_flags);
 				fiemap_incompat_printed = 1;
 			}
@@ -360,7 +362,6 @@ static int frag_report(const char *filename)
 	int		num_extents = 1, expected = ~0;
 	int		is_ext2 = 0;
 	static dev_t	last_device;
-	unsigned int	flags;
 	int		width;
 	int		rc = 0;
 
@@ -398,12 +399,14 @@ static int frag_report(const char *filename)
 			       (unsigned long)fsinfo.f_type);
 	}
 	st.st_blksize = blksize;
-	if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
-		flags = 0;
-	if (!(flags & EXT4_EXTENTS_FL) &&
-	    ((fsinfo.f_type == 0xef51) || (fsinfo.f_type == 0xef52) ||
-	     (fsinfo.f_type == 0xef53)))
-		is_ext2++;
+	if (fsinfo.f_type == 0xef51 || fsinfo.f_type == 0xef52 ||
+	    fsinfo.f_type == 0xef53) {
+		unsigned int	flags;
+
+		if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) == 0 &&
+		    !(flags & EXT4_EXTENTS_FL))
+			is_ext2 = 1;
+	}
 
 	if (is_ext2) {
 		long cylgroups = div_ceil(fsinfo.f_blocks, blksize * 8);
@@ -441,7 +444,7 @@ static int frag_report(const char *filename)
 		expected = 0;
 	}
 
-	if (force_bmap || rc < 0) {
+	if (force_bmap || rc < 0) { /* FIEMAP failed, try FIBMAP instead */
 		expected = filefrag_fibmap(fd, blk_shift, &num_extents,
 					   &st, numblocks, is_ext2);
 		if (expected < 0) {
@@ -492,7 +495,7 @@ int main(int argc, char**argv)
 	char **cpp;
 	int rc = 0, c;
 
-	while ((c = getopt(argc, argv, "Bb::eksvxX")) != EOF)
+	while ((c = getopt(argc, argv, "Bb::eksvxX")) != EOF) {
 		switch (c) {
 		case 'B':
 			force_bmap++;
@@ -551,6 +554,7 @@ int main(int argc, char**argv)
 			usage(argv[0]);
 			break;
 		}
+	}
 
 	if (optind == argc)
 		usage(argv[0]);
@@ -562,6 +566,6 @@ int main(int argc, char**argv)
 			rc = rc2;
 	}
 
-	return rc;
+	return -rc;
 }
 #endif
-- 
1.7.3.4

