From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 1/4] filefrag: exit with error code on failure
Date: Mon, 16 Dec 2013 18:05:28 -0700
Message-ID: <1387242331-29227-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:25965 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3LQBPJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 20:15:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an error is hit during filefrag operation, it should continue to
run if multiple files are specified on the command-line, but exit
with a non-zero value, so that callers can determine that some error
was hit during file processing, similar to tar and other utilities.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/filefrag.c |  102 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index a050a22..18dc1e5 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -103,12 +103,8 @@ static int get_bmap(int fd, unsigned long block, unsigned long *phy_blk)
 
 	b = block;
 	ret = ioctl(fd, FIBMAP, &b); /* FIBMAP takes pointer to integer */
-	if (ret < 0) {
-		if (errno == EPERM) {
-			fprintf(stderr, "No permission to use FIBMAP ioctl; "
-				"must have root privileges\n");
-		}
-	}
+	if (ret < 0)
+		return -errno;
 	*phy_blk = b;
 
 	return ret;
@@ -191,7 +187,6 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 	unsigned long long expected = 0;
 	unsigned long flags = 0;
 	unsigned int i;
-	static int fiemap_incompat_printed;
 	int fiemap_header_printed = 0;
 	int tot_extents = 0, n = 0;
 	int last = 0;
@@ -211,9 +206,13 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 		fiemap->fm_extent_count = count;
 		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
 		if (rc < 0) {
-			if (errno == EBADR && fiemap_incompat_printed == 0) {
-				printf("FIEMAP failed with unsupported "
-				       "flags %x\n", fiemap->fm_flags);
+			static int fiemap_incompat_printed;
+
+			rc = -errno;
+			if (rc == -EBADR && !fiemap_incompat_printed) {
+				fprintf(stderr, "FIEMAP failed with unknown "
+						"flags %x\n",
+				       fiemap->fm_flags);
 				fiemap_incompat_printed = 1;
 			}
 			return rc;
@@ -293,8 +292,23 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 				last_block++;
 		}
 		rc = get_bmap(fd, i, &block);
-		if (rc < 0)
+		if (rc < 0) {
+			if (rc == -EINVAL || rc == -ENOTTY) {
+				fprintf(stderr, "FIBMAP unsupported\n");
+			} else if (rc == -EPERM) {
+				static int fibmap_perm_printed;
+
+				if (!fibmap_perm_printed) {
+					fprintf(stderr, "FIBMAP requires "
+							"root privileges\n");
+					fibmap_perm_printed = 1;
+				}
+			} else {
+				fprintf(stderr, "FIBMAP error: %s",
+					strerror(errno));
+			}
 			return rc;
+		}
 		if (block == 0)
 			continue;
 		if (*num_extents == 0) {
@@ -331,7 +345,7 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 	return count;
 }
 
-static void frag_report(const char *filename)
+static int frag_report(const char *filename)
 {
 	static struct statfs fsinfo;
 	ext2fs_struct_stat st;
@@ -342,8 +356,8 @@ static void frag_report(const char *filename)
 	int		num_extents = 1, expected = ~0;
 	int		is_ext2 = 0;
 	static dev_t	last_device;
-	unsigned int	flags;
 	int		width;
+	int		rc = 0;
 
 #if defined(HAVE_OPEN64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 	fd = open64(filename, O_RDONLY);
@@ -351,8 +365,10 @@ static void frag_report(const char *filename)
 	fd = open(filename, O_RDONLY);
 #endif
 	if (fd < 0) {
+		rc = -errno;
 		perror("open");
-		return;
+
+		return rc;
 	}
 
 #if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
@@ -360,28 +376,34 @@ static void frag_report(const char *filename)
 #else
 	if (fstat(fd, &st) < 0) {
 #endif
+		rc = -errno;
 		close(fd);
 		perror("stat");
-		return;
+
+		return rc;
 	}
 
 	if (last_device != st.st_dev) {
 		if (fstatfs(fd, &fsinfo) < 0) {
+			rc = -errno;
 			close(fd);
 			perror("fstatfs");
-			return;
+
+			return rc;
 		}
 		if (verbose)
 			printf("Filesystem type is: %lx\n",
 			       (unsigned long) fsinfo.f_type);
 	}
 	st.st_blksize = fsinfo.f_bsize;
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
 		long cylgroups = div_ceil(fsinfo.f_blocks, fsinfo.f_bsize * 8);
@@ -414,19 +436,19 @@ static void frag_report(const char *filename)
 		       numblocks * fsinfo.f_bsize >> blk_shift,
 		       numblocks == 1 ? "" : "s", 1 << blk_shift);
 
-	if (force_bmap ||
-	    filefrag_fiemap(fd, blk_shift, &num_extents, &st) != 0) {
+	if (!force_bmap) {
+		rc = filefrag_fiemap(fd, blk_shift, &num_extents, &st);
+		expected = 0;
+	}
+
+	if (force_bmap || rc < 0) { /* FIEMAP failed, try FIBMAP instead */
 		expected = filefrag_fibmap(fd, blk_shift, &num_extents,
 					   &st, numblocks, is_ext2);
 		if (expected < 0) {
-			if (errno == EINVAL || errno == ENOTTY) {
-				fprintf(stderr, "%s: FIBMAP unsupported\n",
-					filename);
-			} else if (errno != EPERM) {
-				fprintf(stderr, "%s: FIBMAP error: %s",
-					filename, strerror(errno));
-			}
+			rc = expected;
 			goto out_close;
+		} else {
+			rc = 0;
 		}
 		expected = expected / data_blocks_per_cyl + 1;
 	}
@@ -443,6 +465,8 @@ static void frag_report(const char *filename)
 		fputc('\n', stdout);
 out_close:
 	close(fd);
+
+	return rc;
 }
 
 static void usage(const char *progname)
@@ -455,9 +479,10 @@ static void usage(const char *progname)
 int main(int argc, char**argv)
 {
 	char **cpp;
+	int rc = 0;
 	int c;
 
-	while ((c = getopt(argc, argv, "Bb::eksvxX")) != EOF)
+	while ((c = getopt(argc, argv, "Bb::eksvxX")) != EOF) {
 		switch (c) {
 		case 'B':
 			force_bmap++;
@@ -516,10 +541,17 @@ int main(int argc, char**argv)
 			usage(argv[0]);
 			break;
 		}
+	}
+
 	if (optind == argc)
 		usage(argv[0]);
-	for (cpp=argv+optind; *cpp; cpp++)
-		frag_report(*cpp);
-	return 0;
+
+	for (cpp = argv + optind; *cpp; cpp++) {
+		int rc2 = frag_report(*cpp);
+		if (rc2 < 0 && rc == 0)
+			rc = rc2;
+	}
+
+	return -rc;
 }
 #endif
-- 
1.7.3.4

