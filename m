From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] filefrag: improvements to filefrag FIEMAP handling
Date: Thu, 22 Nov 2012 18:06:12 -0700
Message-ID: <1353632772-18664-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63009 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab2KWBPu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2012 20:15:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update the filefrag program to allow displaying the extents in
some different formats.  Try and stay within 80 columns.
* add -k option to print extents in kB-sized units (like df -k)
* add -b {blocksize} to print extents in blocksize units
* add -e option to print extent format, even when FIBMAP is used
* add -X option to print extents in hexadecimal format

Internally, the FIBMAP handling code has been moved into its own
function like FIEMAP, so that the code is more modular.  Extent
offsets are now handled in bytes instead of in blocks, to allow
printing extents with arbitrary block sizes.  The extent header
printing also moved into its own function so that it can be shared
between the FIEMAP and FIBMAP handling routines, since it got more
complex with the different output options.

Only print error about FIBMAP being root-only a single time.
Print the filesystem type if it changes between specified files.
Add fsync() for FIBMAP if "-s" is given.

Add support for filesystems that have multiple backing devices
so that extents stored on different devices can be disinguished
from each other.  This is enabled by default for Lustre, but
can be selected for other filesystems if desired/supported with
the "-l" option.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/fiemap.h |    6 +-
 misc/filefrag.8.in  |   28 +++-
 misc/filefrag.c     |  413 +++++++++++++++++++++++++++++++++++----------------
 3 files changed, 315 insertions(+), 132 deletions(-)

diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
index 30bf555..a0c87b5 100644
--- a/lib/ext2fs/fiemap.h
+++ b/lib/ext2fs/fiemap.h
@@ -19,7 +19,8 @@ struct fiemap_extent {
 	__u64 fe_length;   /* length in bytes for this extent */
 	__u64 fe_reserved64[2];
 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
-	__u32 fe_reserved[3];
+	__u32 fe_device;   /* device number (fs-specific if FIEMAP_EXTENT_NET)*/
+	__u32 fe_reserved[2];
 };
 
 struct fiemap {
@@ -42,6 +43,7 @@ struct fiemap {
 
 #define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
 #define FIEMAP_FLAG_XATTR	0x00000002 /* map extended attribute tree */
+#define FIEMAP_FLAG_DEVICE_ORDER 0x40000000 /* return device ordered mapping */
 
 #define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
 
@@ -65,4 +67,6 @@ struct fiemap {
 						    * support extents. Result
 						    * merged for efficiency. */
 
+#define FIEMAP_EXTENT_NET		0x80000000 /* Data stored remotely. */
+
 #endif /* _LINUX_FIEMAP_H */
diff --git a/misc/filefrag.8.in b/misc/filefrag.8.in
index 463f731..b0639a3 100644
--- a/misc/filefrag.8.in
+++ b/misc/filefrag.8.in
@@ -5,7 +5,10 @@ filefrag \- report on file fragmentation
 .SH SYNOPSIS
 .B filefrag
 [
-.B \-Bbsvx
+.BI \-b blocksize
+]
+[
+.B \-BeklsvxX
 ]
 [
 .I files...
@@ -27,8 +30,24 @@ If FIEMAP is not supported then filefrag will fall back to using FIBMAP.
 Force the use of the older FIBMAP ioctl instead of the FIEMAP ioctl for
 testing purposes.
 .TP
-.B \-b
-Use 1024 byte blocksize for the output.
+.BI \-b blocksize
+Use
+.I blocksize
+in bytes for output instead of the filesystem blocksize.
+For compatibility with earlier versions of
+.BR filefrag ,
+if
+.I blocksize
+is unspecified it defaults to 1024 bytes.
+.TP
+.B \-e
+Print output in extent format, even for block-mapped files.
+.TP
+.BI \-k
+Use 1024\-byte blocksize for output (identical to '\-b 1024').
+.TP
+.B \-l
+Extents are displayed in device-logical offset order.
 .TP
 .B \-s
 Sync the file before requesting the mapping.
@@ -38,6 +57,9 @@ Be verbose when checking for file fragmentation.
 .TP
 .B \-x
 Display mapping of extended attributes.
+.TP
+.B \-X
+Display extent block numbers in hexadecimal format.
 .SH AUTHOR
 .B filefrag
 was written by Theodore Ts'o <tytso@mit.edu>.
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 3ec788f..ea420bd 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -16,8 +16,8 @@
 #include <unistd.h>
 
 int main(void) {
-    fputs("This program is only supported on Linux!\n", stderr);
-    exit(EXIT_FAILURE);
+	fputs("This program is only supported on Linux!\n", stderr);
+	exit(EXIT_FAILURE);
 }
 #else
 #define _LARGEFILE64_SOURCE
@@ -40,23 +40,30 @@ extern int optind;
 #include <sys/vfs.h>
 #include <sys/ioctl.h>
 #include <linux/fd.h>
+#include <ext2fs/ext2fs.h>
 #include <ext2fs/ext2_types.h>
 #include <ext2fs/fiemap.h>
 
 int verbose = 0;
-int no_bs = 0;		/* Don't use the files blocksize, use 1K blocksize */
+int blocksize;		/* Use specified blocksize (default 1kB) */
 int sync_file = 0;	/* fsync file before getting the mapping */
 int xattr_map = 0;	/* get xattr mapping */
-int force_bmap = 0;
-int logical_width = 12;
-int physical_width = 14;
-unsigned long long filesize;
+int force_bmap;	/* force use of FIBMAP instead of FIEMAP */
+int force_extent;	/* print output in extent format always */
+int device_order;	/* extents report device-relative offsets */
+int logical_width = 8;
+int physical_width = 10;
+char *ext_fmt = "%4d: %*llu..%*llu: %*llu..%*llu: %6llu: %s\n";
+char *hex_fmt = "%4d: %*llx..%*llx: %*llx..%*llx: %6llx: %s\n";
 
-#define FILEFRAG_FIEMAP_FLAGS_COMPAT (FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
+#define FILEFRAG_FIEMAP_FLAGS_COMPAT (FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR |\
+				      FIEMAP_FLAG_DEVICE_ORDER)
 
 #define FIBMAP		_IO(0x00, 1)	/* bmap access */
 #define FIGETBSZ	_IO(0x00, 2)	/* get the block size used for bmap */
 
+#define LUSTRE_SUPER_MAGIC 0x0BD00BD0
+
 #define	EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define	EXT3_IOC_GETFLAGS		_IOR('f', 1, long)
 
@@ -102,30 +109,49 @@ static int get_bmap(int fd, unsigned long block, unsigned long *phy_blk)
 		if (errno == EPERM) {
 			fprintf(stderr, "No permission to use FIBMAP ioctl; "
 				"must have root privileges\n");
-			exit(1);
 		}
-		perror("FIBMAP");
 	}
 	*phy_blk = b;
 
 	return ret;
 }
 
+static void print_extent_header(void)
+{
+	printf(" ext: %*s %*s length: %*s flags:\n",
+	       logical_width * 2 + 3,
+	       device_order ? "device_logical:" : "logical_offset:",
+	       physical_width * 2 + 3, "physical_offset:",
+	       device_order ? 5 : physical_width + 1,
+	       device_order ? " dev:" : "expected:");
+}
+
 static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
-			      unsigned long long expected, int blk_shift)
+			      unsigned long long expected, int blk_shift,
+			      ext2fs_struct_stat *st)
 {
-	__u64 phy_blk;
+	unsigned long long physical_blk;
 	unsigned long long logical_blk;
-	unsigned long ext_len;
+	unsigned long long ext_len;
+	unsigned long long ext_blks;
 	char flags[256] = "";
 
-	/* For inline data all offsets should be in terms of bytes, not blocks */
+	/* For inline data all offsets should be in bytes, not blocks */
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
 		blk_shift = 0;
 
 	ext_len = fm_extent->fe_length >> blk_shift;
+	ext_blks = (fm_extent->fe_length - 1) >> blk_shift;
 	logical_blk = fm_extent->fe_logical >> blk_shift;
-	phy_blk = fm_extent->fe_physical >> blk_shift;
+	physical_blk = fm_extent->fe_physical >> blk_shift;
+
+	if (device_order)
+		sprintf(flags, "%04x: ", fm_extent->fe_device);
+	else if (expected)
+		sprintf(flags, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
+			physical_width, expected >> blk_shift);
+	else
+		sprintf(flags, "%.*s  ", physical_width, "                   ");
 
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN)
 		strcat(flags, "unknown,");
@@ -143,29 +169,27 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 		strcat(flags, "unwritten,");
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_MERGED)
 		strcat(flags, "merged,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_NET)
+		strcat(flags, "network,");
 
-	if (fm_extent->fe_logical + fm_extent->fe_length >= filesize)
+	if (fm_extent->fe_logical + fm_extent->fe_length >= st->st_size)
 		strcat(flags, "eof,");
 
 	/* Remove trailing comma, if any */
 	if (flags[0])
 		flags[strlen(flags) - 1] = '\0';
 
-	if (expected)
-		printf("%4d %*llu %*llu %*llu %6lu %s\n",
-		       cur_ex, logical_width, logical_blk,
-		       physical_width, phy_blk, physical_width, expected,
-		       ext_len, flags);
-	else
-		printf("%4d %*llu %*llu %*s %6lu %s\n",
-		       cur_ex, logical_width, logical_blk,
-		       physical_width, phy_blk, physical_width, "",
-		       ext_len, flags);
+	printf(ext_fmt, cur_ex, logical_width, logical_blk,
+	       logical_width, logical_blk + ext_blks,
+	       physical_width, physical_blk,
+	       physical_width, physical_blk + ext_blks,
+	       ext_len, flags);
 }
 
-static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
+static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
+			   ext2fs_struct_stat *st)
 {
-	char buf[4096] = "";
+	char buf[16384];
 	struct fiemap *fiemap = (struct fiemap *)buf;
 	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
 	int count = (sizeof(buf) - sizeof(*fiemap)) /
@@ -176,6 +200,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	static int fiemap_incompat_printed;
 	int fiemap_header_printed = 0;
 	int tot_extents = 0, n = 0;
+	int previous_device = 0;
 	int last = 0;
 	int rc;
 
@@ -187,6 +212,12 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	if (xattr_map)
 		flags |= FIEMAP_FLAG_XATTR;
 
+	if (device_order) {
+		flags |= FIEMAP_FLAG_DEVICE_ORDER;
+		memset(fm_ext, 0, sizeof(struct fiemap_extent));
+	}
+
+retry_wo_device_order:
 	do {
 		fiemap->fm_length = ~0ULL;
 		fiemap->fm_flags = flags;
@@ -197,6 +228,10 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 				printf("FIEMAP failed with unsupported "
 				       "flags %x\n", fiemap->fm_flags);
 				fiemap_incompat_printed = 1;
+			} else if (rc == EBADR && (fiemap->fm_flags &
+						   FIEMAP_FLAG_DEVICE_ORDER)) {
+				flags &= ~FIEMAP_FLAG_DEVICE_ORDER;
+				goto retry_wo_device_order;
 			}
 			return rc;
 		}
@@ -206,21 +241,16 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 			break;
 
 		if (verbose && !fiemap_header_printed) {
-			printf(" ext %*s %*s %*s length flags\n", logical_width,
-			       "logical", physical_width, "physical",
-			       physical_width, "expected");
+			print_extent_header();
 			fiemap_header_printed = 1;
 		}
 
 		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
-			__u64 phy_blk, logical_blk;
-			unsigned long ext_len;
+			if (previous_device != fm_ext[i].fe_device)
+				previous_device = fm_ext[i].fe_device;
 
-			phy_blk = fm_ext[i].fe_physical >> blk_shift;
-			ext_len = fm_ext[i].fe_length >> blk_shift;
-			logical_blk = fm_ext[i].fe_logical >> blk_shift;
-
-			if (logical_blk && phy_blk != expected) {
+			if (fm_ext[i].fe_logical != 0 &&
+			    fm_ext[i].fe_physical != expected) {
 				tot_extents++;
 			} else {
 				expected = 0;
@@ -229,45 +259,125 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 			}
 			if (verbose)
 				print_extent_info(&fm_ext[i], n, expected,
-						  blk_shift);
+						  blk_shift, st);
 
-			expected = phy_blk + ext_len;
+			expected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
 			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
 				last = 1;
 			n++;
 		}
 
-		fiemap->fm_start = (fm_ext[i-1].fe_logical +
-				    fm_ext[i-1].fe_length);
+		/* For DEVICE_ORDER mappings, if EXTENT_LAST not yet found then
+		 * fm_start needs to be the same as it was for earlier ioctl.
+		 * The first extent is used to pass the end offset and device
+		 * of the previous FIEMAP call.  Otherwise, we ask for extents
+		 * starting from where the last mapping ended. */
+		if (flags & FIEMAP_FLAG_DEVICE_ORDER) {
+			fm_ext[0].fe_logical =	fm_ext[i - 1].fe_logical +
+						fm_ext[i - 1].fe_length;
+			fm_ext[0].fe_device =	fm_ext[i - 1].fe_device;
+			fiemap->fm_start =	0;
+		} else {
+			fiemap->fm_start =	fm_ext[i - 1].fe_logical +
+						fm_ext[i - 1].fe_length;
+		}
 	} while (last == 0);
 
 	*num_extents = tot_extents;
-out:
 	return 0;
 }
 
 #define EXT2_DIRECT	12
 
+static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
+			   ext2fs_struct_stat *st,
+			   unsigned long numblocks, int is_ext2)
+{
+	struct fiemap_extent	fm_ext;
+	unsigned long		i, last_block;
+	unsigned long long	logical;
+				/* Blocks per indirect block */
+	const long		bpib = st->st_blksize / 4;
+	int			count;
+
+	if (force_extent) {
+		memset(&fm_ext, 0, sizeof(fm_ext));
+		fm_ext.fe_device = st->st_dev;
+		fm_ext.fe_flags = FIEMAP_EXTENT_MERGED;
+	}
+
+	if (sync_file)
+		fsync(fd);
+
+	for (i = 0, logical = 0, *num_extents = 0, count = last_block = 0;
+	     i < numblocks;
+	     i++, logical += st->st_blksize) {
+		unsigned long block = 0;
+		int rc;
+
+		if (is_ext2 && last_block) {
+			if (((i - EXT2_DIRECT) % bpib) == 0)
+				last_block++;
+			if (((i - EXT2_DIRECT - bpib) % (bpib * bpib)) == 0)
+				last_block++;
+			if (((i - EXT2_DIRECT - bpib - bpib * bpib) %
+			     (((unsigned long long)bpib) * bpib * bpib)) == 0)
+				last_block++;
+		}
+		rc = get_bmap(fd, i, &block);
+		if (rc < 0)
+			return rc;
+		if (block == 0)
+			continue;
+		if (*num_extents == 0) {
+			(*num_extents)++;
+			if (force_extent) {
+				print_extent_header();
+				fm_ext.fe_physical = block * st->st_blksize;
+			}
+		}
+		count++;
+		if (force_extent && last_block != 0 &&
+		    (block != last_block + 1 ||
+		     fm_ext.fe_logical + fm_ext.fe_length != logical)) {
+			print_extent_info(&fm_ext, *num_extents - 1,
+					  (last_block + 1) * st->st_blksize,
+					  blk_shift, st);
+			fm_ext.fe_logical = logical;
+			fm_ext.fe_physical = block * st->st_blksize;
+			fm_ext.fe_length = 0;
+			(*num_extents)++;
+		} else if (verbose && last_block && (block != last_block + 1)) {
+			printf("Discontinuity: Block %ld is at %lu (was %lu)\n",
+			       i, block, last_block + 1);
+			(*num_extents)++;
+		}
+		fm_ext.fe_length += st->st_blksize;
+		last_block = block;
+	}
+
+	if (force_extent)
+		print_extent_info(&fm_ext, *num_extents - 1,
+				  last_block * st->st_blksize, blk_shift, st);
+
+	return count;
+}
+
 static void frag_report(const char *filename)
 {
-	struct statfs	fsinfo;
-#ifdef HAVE_FSTAT64
-	struct stat64	fileinfo;
-#else
-	struct stat	fileinfo;
-#endif
-	int		bs;
+	static struct statfs fsinfo;
+	ext2fs_struct_stat st;
+	int		blk_shift;
 	long		fd;
-	unsigned long	block, last_block = 0, numblocks, i, count = 0;
-	long		bpib;	/* Blocks per indirect block */
-	long		cylgroups;
-	int		num_extents = 0, expected;
+	unsigned long	numblocks;
+	int		data_blocks_per_cyl = 1;
+	int		num_extents = 1, expected = ~0;
 	int		is_ext2 = 0;
-	static int	once = 1;
+	static dev_t	last_device;
 	unsigned int	flags;
-	int rc;
+	int		width;
 
-#ifdef HAVE_OPEN64
+#if defined(HAVE_OPEN64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 	fd = open64(filename, O_RDONLY);
 #else
 	fd = open(filename, O_RDONLY);
@@ -277,103 +387,107 @@ static void frag_report(const char *filename)
 		return;
 	}
 
-	if (statfs(filename, &fsinfo) < 0) {
-		perror("statfs");
-		return;
-	}
-#ifdef HAVE_FSTAT64
-	if (stat64(filename, &fileinfo) < 0) {
+#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+	if (fstat64(fd, &st) < 0) {
 #else
-	if (stat(filename, &fileinfo) < 0) {
+	if (fstat(fd, &st) < 0) {
 #endif
 		perror("stat");
 		return;
 	}
+
+	if (last_device != st.st_dev) {
+		if (fstatfs(fd, &fsinfo) < 0) {
+			perror("fstatfs");
+			return;
+		}
+		if (verbose)
+			printf("Filesystem type is: %lx\n",
+			       (unsigned long) fsinfo.f_type);
+	}
+	st.st_blksize = fsinfo.f_bsize;
 	if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
 		flags = 0;
 	if (!(flags & EXT4_EXTENTS_FL) &&
 	    ((fsinfo.f_type == 0xef51) || (fsinfo.f_type == 0xef52) ||
 	     (fsinfo.f_type == 0xef53)))
 		is_ext2++;
-	if (verbose && once)
-		printf("Filesystem type is: %lx\n",
-		       (unsigned long) fsinfo.f_type);
-
-	cylgroups = div_ceil(fsinfo.f_blocks, fsinfo.f_bsize*8);
-	if (verbose && is_ext2 && once)
-		printf("Filesystem cylinder groups is approximately %ld\n",
-		       cylgroups);
-
-	physical_width = int_log10(fsinfo.f_blocks);
-	if (physical_width < 8)
-		physical_width = 8;
-
-	if (ioctl(fd, FIGETBSZ, &bs) < 0) { /* FIGETBSZ takes an int */
-		perror("FIGETBSZ");
-		close(fd);
-		return;
+
+	/* Check if filesystem is Lustre.  Always print in extent format
+	 * with 1kB blocks, using the device-relative logical offsets. */
+	if (fsinfo.f_type == LUSTRE_SUPER_MAGIC) {
+		is_ext2 = 0;
+		force_extent = 1;
+		device_order = 1;
+		blocksize = blocksize ?: 1024;
 	}
 
-	if (no_bs)
-		bs = 1024;
+	if (is_ext2) {
+		long cylgroups = div_ceil(fsinfo.f_blocks, fsinfo.f_bsize * 8);
+
+		if (verbose && last_device != st.st_dev)
+			printf("Filesystem cylinder groups approximately %ld\n",
+			       cylgroups);
+
+		data_blocks_per_cyl = fsinfo.f_bsize * 8 -
+					(fsinfo.f_files / 8 / cylgroups) - 3;
+	}
+	last_device = st.st_dev;
+
+	width = int_log10(fsinfo.f_blocks);
+	if (width > physical_width)
+		physical_width = width;
+
+	numblocks = (st.st_size + fsinfo.f_bsize - 1) / fsinfo.f_bsize;
+	if (blocksize != 0)
+		blk_shift = int_log2(blocksize);
+	else
+		blk_shift = int_log2(fsinfo.f_bsize);
 
-	bpib = bs / 4;
-	numblocks = (fileinfo.st_size + (bs-1)) / bs;
-	logical_width = int_log10(numblocks);
-	if (logical_width < 7)
-		logical_width = 7;
-	filesize = (long long)fileinfo.st_size;
+	width = int_log10(numblocks);
+	if (width > logical_width)
+		logical_width = width;
 	if (verbose)
-		printf("File size of %s is %lld (%ld block%s, blocksize %d)\n",
-		       filename, (long long) fileinfo.st_size, numblocks,
-		       numblocks == 1 ? "" : "s", bs);
+		printf("File size of %s is %llu (%lu block%s of %d bytes)\n",
+		       filename, (unsigned long long)st.st_size,
+		       numblocks * fsinfo.f_bsize >> blk_shift,
+		       numblocks == 1 ? "" : "s", 1 << blk_shift);
+
 	if (force_bmap ||
-	    filefrag_fiemap(fd, int_log2(bs), &num_extents) != 0) {
-		for (i = 0, count = 0; i < numblocks; i++) {
-			if (is_ext2 && last_block) {
-				if (((i-EXT2_DIRECT) % bpib) == 0)
-					last_block++;
-				if (((i-EXT2_DIRECT-bpib) % (bpib*bpib)) == 0)
-					last_block++;
-				if (((i-EXT2_DIRECT-bpib-bpib*bpib) %
-				     (((__u64) bpib)*bpib*bpib)) == 0)
-					last_block++;
-			}
-			rc = get_bmap(fd, i, &block);
-			if (block == 0)
-				continue;
-			if (!num_extents)
-				num_extents++;
-			count++;
-			if (last_block && (block != last_block+1) ) {
-				if (verbose)
-					printf("Discontinuity: Block %ld is at "
-					       "%lu (was %lu)\n",
-					       i, block, last_block+1);
-				num_extents++;
+	    filefrag_fiemap(fd, blk_shift, &num_extents, &st) != 0) {
+		expected = filefrag_fibmap(fd, blk_shift, &num_extents,
+					   &st, numblocks, is_ext2);
+		if (expected < 0) {
+			if (errno == EINVAL || errno == ENOTTY) {
+				fprintf(stderr, "%s: FIBMAP unsupported\n",
+					filename);
+			} else if (errno != EPERM) {
+				fprintf(stderr, "%s: FIBMAP error: %s",
+					filename, strerror(errno));
 			}
-			last_block = block;
+			goto out_close;
 		}
+		expected = expected / data_blocks_per_cyl + 1;
 	}
+
 	if (num_extents == 1)
 		printf("%s: 1 extent found", filename);
 	else
 		printf("%s: %d extents found", filename, num_extents);
 	/* count, and thus expected, only set for indirect FIBMAP'd files */
-	if (is_ext2) {
-		expected = (count/((bs*8)-(fsinfo.f_files/8/cylgroups)-3))+1;
-		if (expected && expected < num_extents)
-			printf(", perfection would be %d extent%s\n", expected,
-				(expected>1) ? "s" : "");
-	} else
+	if (is_ext2 && expected && expected < num_extents)
+		printf(", perfection would be %d extent%s\n", expected,
+			(expected > 1) ? "s" : "");
+	else
 		fputc('\n', stdout);
+out_close:
 	close(fd);
-	once = 0;
 }
 
 static void usage(const char *progname)
 {
-	fprintf(stderr, "Usage: %s [-Bbvsx] file ...\n", progname);
+	fprintf(stderr, "Usage: %s [-b{blocksize}] [-BeklsvxX] file ...\n",
+		progname);
 	exit(1);
 }
 
@@ -382,23 +496,66 @@ int main(int argc, char**argv)
 	char **cpp;
 	int c;
 
-	while ((c = getopt(argc, argv, "Bbsvx")) != EOF)
+	while ((c = getopt(argc, argv, "Bb::eklsvxX")) != EOF)
 		switch (c) {
 		case 'B':
 			force_bmap++;
+			force_extent = 0;
 			break;
 		case 'b':
-			no_bs++;
+			if (optarg) {
+				char *end;
+				blocksize = strtoul(optarg, &end, 0);
+				if (end) {
+					switch (end[0]) {
+					case 'g':
+					case 'G':
+						blocksize *= 1024;
+						/* no break */
+					case 'm':
+					case 'M':
+						blocksize *= 1024;
+						/* no break */
+					case 'k':
+					case 'K':
+						blocksize *= 1024;
+						break;
+					default:
+						break;
+					}
+				}
+			} else { /* Allow -b without argument for compat. Remove
+				  * this eventually so "-b {blocksize}" works */
+				fprintf(stderr, "%s: -b needs a blocksize "
+					"option, assuming 1024-byte blocks.\n",
+					argv[0]);
+				blocksize = 1024;
+			}
 			break;
-		case 'v':
-			verbose++;
+		case 'e':
+			force_extent++;
+			if (!verbose)
+				verbose++;
+			force_bmap = 0;
+			break;
+		case 'k':
+			blocksize = 1024;
+			break;
+		case 'l':
+			device_order++;
 			break;
 		case 's':
 			sync_file++;
 			break;
+		case 'v':
+			verbose++;
+			break;
 		case 'x':
 			xattr_map++;
 			break;
+		case 'X':
+			ext_fmt = hex_fmt;
+			break;
 		default:
 			usage(argv[0]);
 			break;
-- 
1.7.3.4

