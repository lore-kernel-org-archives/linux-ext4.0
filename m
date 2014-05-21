From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] filefrag: exit with error code if an error is hit
Date: Wed, 21 May 2014 15:17:23 -0600
Message-ID: <1400707043-13122-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:41799 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaEUVRZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2014 17:17:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an error is hit during filefrag operation, it will continue to run
(if multiple files are specified on the command-line), but will exit
with a non-zero value, so that callers can determine that some error
was hit.

Clean up the printing of FIEMAP flags and print some newer flags that
were missing.  Also print unknown flags as hex values.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/filefrag.c |  129 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 83 insertions(+), 46 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 929a33b..2d3a74f 100644
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
@@ -124,6 +120,15 @@ static void print_extent_header(void)
 	       "expected:");
 }
 
+static void print_flag(__u32 *flags, __u32 mask, char *buf, const char *name)
+{
+	if ((*flags & mask) == 0)
+		return;
+
+	strcat(buf, name);
+	*flags &= ~mask;
+}
+
 static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 			      unsigned long long expected, int blk_shift,
 			      ext2fs_struct_stat *st)
@@ -132,6 +137,7 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	unsigned long long logical_blk;
 	unsigned long long ext_len;
 	unsigned long long ext_blks;
+	__u32 fe_flags, mask;
 	char flags[256] = "";
 
 	/* For inline data all offsets should be in bytes, not blocks */
@@ -141,7 +147,11 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	ext_len = fm_extent->fe_length >> blk_shift;
 	ext_blks = (fm_extent->fe_length - 1) >> blk_shift;
 	logical_blk = fm_extent->fe_logical >> blk_shift;
-	physical_blk = fm_extent->fe_physical >> blk_shift;
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN) {
+		physical_blk = 0;
+	} else {
+		physical_blk = fm_extent->fe_physical >> blk_shift;
+	}
 
 	if (expected)
 		sprintf(flags, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
@@ -149,31 +159,34 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	else
 		sprintf(flags, "%.*s  ", physical_width, "                   ");
 
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN)
-		strcat(flags, "unknown,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DELALLOC)
-		strcat(flags, "delalloc,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_ENCRYPTED)
-		strcat(flags, "encrypted,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_NOT_ALIGNED)
-		strcat(flags, "not_aligned,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
-		strcat(flags, "inline,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_TAIL)
-		strcat(flags, "tail_packed,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
-		strcat(flags, "unwritten,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_MERGED)
-		strcat(flags, "merged,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_SHARED)
-		strcat(flags, "shared,");
-
-	if (fm_extent->fe_logical + fm_extent->fe_length >= (__u64) st->st_size)
+	fe_flags = fm_extent->fe_flags;
+	print_flag(&fe_flags, FIEMAP_EXTENT_LAST, flags, "last,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_UNKNOWN, flags, "unknown_loc,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_DELALLOC, flags, "delalloc,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_ENCODED, flags, "encoded,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_ENCRYPTED, flags,"encrypted,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_NOT_ALIGNED, flags, "not_aligned,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_INLINE, flags, "inline,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_TAIL, flags, "tail_packed,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_UNWRITTEN, flags, "unwritten,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_MERGED, flags, "merged,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_SHARED, flags, "shared,");
+	/* print any unknown flags as hex values */
+	for (mask = 1; fe_flags != 0 && mask != 0; mask <<= 1) {
+		char hex[6];
+
+		if (fe_flags & mask == 0)
+			continue;
+		sprintf(hex, "%#04x,", mask);
+		print_flag(&fe_flags, mask, flags, hex);
+	}
+
+	if (fm_extent->fe_logical + fm_extent->fe_length >= st->st_size)
 		strcat(flags, "eof,");
 
 	/* Remove trailing comma, if any */
-	if (flags[0])
-		flags[strlen(flags) - 1] = '\0';
+	if (flags[0] != '\0')
+		flags[strnlen(flags, sizeof(flags)) - 1] = '\0';
 
 	printf(ext_fmt, cur_ex, logical_width, logical_blk,
 	       logical_width, logical_blk + ext_blks,
@@ -193,7 +206,6 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 	unsigned long long expected = 0;
 	unsigned long flags = 0;
 	unsigned int i;
-	static int fiemap_incompat_printed;
 	int fiemap_header_printed = 0;
 	int tot_extents = 0, n = 0;
 	int last = 0;
@@ -213,9 +225,11 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 		fiemap->fm_extent_count = count;
 		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
 		if (rc < 0) {
-			if (errno == EBADR && fiemap_incompat_printed == 0) {
-				printf("FIEMAP failed with unsupported "
-				       "flags %x\n", fiemap->fm_flags);
+			static int fiemap_incompat_printed;
+			rc = -errno;
+			if (rc == -EBADR && !fiemap_incompat_printed) {
+				printf("FIEMAP failed with unknown flags %#x\n",
+				       fiemap->fm_flags);
 				fiemap_incompat_printed = 1;
 			}
 			return rc;
@@ -333,7 +347,7 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 	return count;
 }
 
-static void frag_report(const char *filename)
+static int frag_report(const char *filename)
 {
 	static struct statfs fsinfo;
 	ext2fs_struct_stat st;
@@ -346,6 +360,7 @@ static void frag_report(const char *filename)
 	static dev_t	last_device;
 	unsigned int	flags;
 	int		width;
+	int		rc = 0;
 
 #if defined(HAVE_OPEN64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 	fd = open64(filename, O_RDONLY);
@@ -353,8 +368,9 @@ static void frag_report(const char *filename)
 	fd = open(filename, O_RDONLY);
 #endif
 	if (fd < 0) {
+		rc = -errno;
 		perror("open");
-		return;
+		return rc;
 	}
 
 #if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
@@ -363,8 +379,9 @@ static void frag_report(const char *filename)
 	if (fstat(fd, &st) < 0) {
 #endif
 		close(fd);
+		rc = -errno;
 		perror("stat");
-		return;
+		return rc;
 	}
 
 	if (last_device != st.st_dev) {
@@ -375,7 +392,7 @@ static void frag_report(const char *filename)
 		}
 		if (verbose)
 			printf("Filesystem type is: %lx\n",
-			       (unsigned long) fsinfo.f_type);
+			       (unsigned long)fsinfo.f_type);
 	}
 	st.st_blksize = fsinfo.f_bsize;
 	if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
@@ -416,19 +433,30 @@ static void frag_report(const char *filename)
 		       numblocks * fsinfo.f_bsize >> blk_shift,
 		       numblocks == 1 ? "" : "s", 1 << blk_shift);
 
-	if (force_bmap ||
-	    filefrag_fiemap(fd, blk_shift, &num_extents, &st) != 0) {
+	if (!force_bmap) {
+		rc = filefrag_fiemap(fd, blk_shift, &num_extents, &st);
+		expected = 0;
+	}
+
+	if (rc < 0) {
 		expected = filefrag_fibmap(fd, blk_shift, &num_extents,
 					   &st, numblocks, is_ext2);
 		if (expected < 0) {
-			if (errno == EINVAL || errno == ENOTTY) {
+			if (expected == -EINVAL || expected == -ENOTTY) {
 				fprintf(stderr, "%s: FIBMAP unsupported\n",
 					filename);
-			} else if (errno != EPERM) {
+			} else if (expected == -EPERM) {
+				fprintf(stderr,
+					"%s: FIBMAP requires root privileges\n",
+					filename);
+			} else {
 				fprintf(stderr, "%s: FIBMAP error: %s",
-					filename, strerror(errno));
+					filename, strerror(expected));
 			}
+			rc = expected;
 			goto out_close;
+		} else {
+			rc = 0;
 		}
 		expected = expected / data_blocks_per_cyl + 1;
 	}
@@ -445,6 +473,8 @@ static void frag_report(const char *filename)
 		fputc('\n', stdout);
 out_close:
 	close(fd);
+
+	return rc;
 }
 
 static void usage(const char *progname)
@@ -457,7 +487,7 @@ static void usage(const char *progname)
 int main(int argc, char**argv)
 {
 	char **cpp;
-	int c;
+	int rc = 0, c;
 
 	while ((c = getopt(argc, argv, "Bb::eksvxX")) != EOF)
 		switch (c) {
@@ -518,10 +548,17 @@ int main(int argc, char**argv)
 			usage(argv[0]);
 			break;
 		}
+
 	if (optind == argc)
 		usage(argv[0]);
-	for (cpp=argv+optind; *cpp; cpp++)
-		frag_report(*cpp);
-	return 0;
+
+	for (cpp = argv + optind; *cpp != '\0'; cpp++) {
+		int rc2 = frag_report(*cpp);
+
+		if (rc2 < 0 && rc == 0)
+			rc == rc2;
+	}
+
+	return rc;
 }
 #endif
-- 
1.7.3.4

