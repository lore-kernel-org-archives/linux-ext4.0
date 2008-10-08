From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: Re: [PATCH][0/15] Lustre e2fsprogs patch series
Date: Wed, 08 Oct 2008 17:08:46 +0530
Message-ID: <1223465926.4007.142.camel@localhost>
References: <1223287812.4007.55.camel@localhost> <20081007142221.GC7311@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_NHFlCnRJPvjYPiOzbu+QlA)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:39851 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYJHLij (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Oct 2008 07:38:39 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m98BcZYX024142
	for <linux-ext4@vger.kernel.org>; Wed, 8 Oct 2008 11:38:35 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8F00L0148HK500@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Wed,
 08 Oct 2008 19:38:35 +0800 (SGT)
In-reply-to: <20081007142221.GC7311@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_NHFlCnRJPvjYPiOzbu+QlA)
Content-type: text/plain
Content-transfer-encoding: 7BIT

On Tue, 2008-10-07 at 10:22 -0400, Theodore Tso wrote:
> On Mon, Oct 06, 2008 at 03:40:12PM +0530, Kalpak Shah wrote:
> > 
> > This is the patchset containing the e2fsprogs patches that are used for
> > Lustre e2fsprogs. The patches are based on e2fsprogs-1.41.2.
> > 
> 
> Um, are you sure that the patches are based on e2fsprogs 1.41.2?  I
> just tried applying e2fsprogs-fiemap.patch, and it did not apply
> cleanly.  Looking at the rejects, it looks like part of the problem
> was that patch was apparently against the version of filefrag that was
> in v1.41.0, not v1.41.1 or v1.41.2?

The patch series is against v1.41.2. I attached an older version of the
fiemap patch, sorry.

Attached is the e2fsprogs-fiemap.patch for v1.41.2.

Thanks,
Kalpak

--Boundary_(ID_NHFlCnRJPvjYPiOzbu+QlA)
Content-type: text/x-patch; charset=utf-8; name=e2fsprogs-fiemap.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-fiemap.patch

Index: e2fsprogs-1.41.2/misc/filefrag.c
===================================================================
--- e2fsprogs-1.41.2.orig/misc/filefrag.c
+++ e2fsprogs-1.41.2/misc/filefrag.c
@@ -12,6 +12,7 @@
 #ifndef __linux__
 #include <stdio.h>
 #include <stdlib.h>
+#include <unistd.h>
 
 int main(void) {
     fputs("This program is only supported on Linux!\n", stderr);
@@ -38,13 +39,23 @@ extern int optind;
 #include <sys/vfs.h>
 #include <sys/ioctl.h>
 #include <linux/fd.h>
+#include <ext2fs/ext2_types.h>
+#include <ext2fs/fiemap.h>
 
 int verbose = 0;
+int extent_format = 0;	/* Print output in extent format */
+int no_bs = 0;		/* Don't use the files blocksize, use 1K blocksize */
+int sync_file = 0;	/* fsync file before getting the mapping */
+int xattr_map = 0;	/* get xattr mapping */
+unsigned long long filesize;
+
+#define FILEFRAG_FIEMAP_FLAGS_COMPAT (FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
+
+#define FIBMAP		_IO(0x00, 1)	/* bmap access */
+#define FIGETBSZ	_IO(0x00, 2)	/* get the block size used for bmap */
+#define FS_IOC_FIEMAP	_IOWR('f', 11, struct fiemap)
 
-#define FIBMAP	   _IO(0x00,1)	/* bmap access */
-#define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
-
-#define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define	EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define	EXT3_IOC_GETFLAGS		_IOR('f', 1, long)
 
 static unsigned int div_ceil(unsigned int a, unsigned int b)
@@ -54,21 +65,177 @@ static unsigned int div_ceil(unsigned in
 	return ((a - 1) / b) + 1;
 }
 
-static unsigned long get_bmap(int fd, unsigned long block)
+static int get_bmap(int fd, unsigned long block, unsigned long *phy_blk)
 {
 	int	ret;
 	unsigned int b;
 
 	b = block;
-	ret = ioctl(fd, FIBMAP, &b); /* FIBMAP takes a pointer to an integer */
+	ret = ioctl(fd, FIBMAP, &b); /* FIBMAP takes pointer to integer */
 	if (ret < 0) {
 		if (errno == EPERM) {
-			fprintf(stderr, "No permission to use FIBMAP ioctl; must have root privileges\n");
+			fprintf(stderr, "No permission to use FIBMAP ioctl; "
+				"must have root privileges\n");
 			exit(1);
 		}
 		perror("FIBMAP");
 	}
-	return b;
+	*phy_blk = b;
+
+	return ret;
+}
+
+static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
+			      int blk_shift)
+{
+	__u64 phy_blk;
+	unsigned long long logical_blk;
+	unsigned long ext_len;
+	char flags[256] = "";
+
+	/* For inline data all offsets should be in terms of bytes, not blocks */
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
+		blk_shift = 0;
+
+	ext_len = fm_extent->fe_length >> blk_shift;
+	logical_blk = fm_extent->fe_logical >> blk_shift;
+	phy_blk = fm_extent->fe_physical >> blk_shift;
+
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN)
+		strcat(flags, "unknown,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DELALLOC)
+		strcat(flags, "delalloc,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_NO_DIRECT)
+		strcat(flags, "no_direct,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_SECONDARY)
+		strcat(flags, "secondary,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_NET)
+		strcat(flags, "remote,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_COMPRESSED)
+		strcat(flags, "compressed,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_ENCRYPTED)
+		strcat(flags, "encrypted,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_NOT_ALIGNED)
+		strcat(flags, "not_aligned,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
+		strcat(flags, "inline,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_TAIL)
+		strcat(flags, "tail_packed,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
+		strcat(flags, "unwritten,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_MERGED)
+		strcat(flags, "merged,");
+
+	if (fm_extent->fe_logical + fm_extent->fe_length >= filesize)
+		strcat(flags, "eof,");
+
+	/* Remove trailing comma, if any */
+	if (flags[0])
+		flags[strlen(flags) - 1] = '\0';
+
+	printf("%5d:%12llu..%12llu:%12llu..%12llu:%12lu:   %4d:     %s\n",
+	       cur_ex, logical_blk, logical_blk + ext_len - 1,
+	       phy_blk, phy_blk ? phy_blk + ext_len : 0, ext_len,
+	       fm_extent->fe_device, flags);
+}
+
+int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
+{
+	char buf[4096] = "";
+	struct fiemap *fiemap = (struct fiemap *)buf;
+	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
+	int count = (sizeof(buf) - sizeof(*fiemap)) /
+			sizeof(struct fiemap_extent);
+	unsigned long long logical_blk = 0, last_blk = 0;
+	unsigned long flags = 0;
+	static int fiemap_incompat_printed;
+	int tot_extents = 0;
+	int last = 0, eof = 0;
+	int i, rc;
+
+	fiemap->fm_length = ~0ULL;
+
+	memset(fiemap, 0, sizeof(struct fiemap));
+
+	if (!verbose)
+		count = 0;
+
+	if (sync_file)
+		flags |= FIEMAP_FLAG_SYNC;
+
+	if (xattr_map)
+		flags |= FIEMAP_FLAG_XATTR;
+
+	if (extent_format && verbose)
+		printf("  ext:\t     %s:  start..end      physical: start..end:\t  "
+		       "length:  device:   flags:\n", "logical");
+
+	do {
+		fiemap->fm_length = ~0ULL;
+		fiemap->fm_flags = flags;
+		fiemap->fm_extent_count = count;
+		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
+		if (rc == -EBADR) {
+			if (fiemap_incompat_printed == 0) {
+				printf("%s: FIEMAP failed with unsupported "
+				       "flags %x\n", fiemap->fm_flags);
+				fiemap_incompat_printed = 1;
+			}
+		}
+		if (rc)
+			return rc;
+
+		if (!verbose) {
+			*num_extents = fiemap->fm_mapped_extents;
+			goto out;
+		}
+
+		/* If 0 extents are returned, then more ioctls are not needed */
+		if (fiemap->fm_mapped_extents == 0)
+			break;
+
+		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			__u64 phy_blk, phy_start, logical_blk;
+			unsigned long ext_len;
+
+			phy_blk = fm_ext[i].fe_physical >> blk_shift;
+			ext_len = fm_ext[i].fe_length >> blk_shift;
+			logical_blk = fm_ext[i].fe_logical >> blk_shift;
+
+			if (extent_format) {
+				print_extent_info(&fm_ext[i], tot_extents,
+						  blk_shift);
+			} else if (logical_blk && phy_blk != last_blk + 1) {
+				printf("Discontinuity: Block %llu is at %llu "
+				       "(was %llu)\n", logical_blk, phy_blk,
+				       last_blk);
+			}
+
+			last_blk = phy_blk + ext_len - 1;
+			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
+				last = 1;
+			tot_extents++;
+		}
+
+		fiemap->fm_start += fm_ext[i-1].fe_logical +
+							fm_ext[i-1].fe_length;
+	} while (last == 0);
+
+	*num_extents = tot_extents;
+out:
+	return 0;
+}
+
+static int int_log2(int arg)
+{
+	int     l = 0;
+
+	arg >>= 1;
+	while (arg) {
+		l++;
+		arg >>= 1;
+	}
+	return l;
 }
 
 #define EXT2_DIRECT	12
@@ -86,9 +253,11 @@ static void frag_report(const char *file
 	unsigned long	block, last_block = 0, numblocks, i, count;
 	long		bpib;	/* Blocks per indirect block */
 	long		cylgroups;
-	int		discont = 0, expected;
+	int		num_extents = 0, expected;
 	int		is_ext2 = 0;
 	unsigned int	flags;
+	unsigned long	first_blk, last_blk;
+	int rc;
 
 	if (statfs(filename, &fsinfo) < 0) {
 		perror("statfs");
@@ -113,6 +282,7 @@ static void frag_report(const char *file
 		printf("Filesystem type is: %lx\n",
 		       (unsigned long) fsinfo.f_type);
 	}
+
 	cylgroups = div_ceil(fsinfo.f_blocks, fsinfo.f_bsize*8);
 	if (verbose) {
 		printf("Filesystem cylinder groups is approximately %ld\n",
@@ -132,6 +302,10 @@ static void frag_report(const char *file
 		close(fd);
 		return;
 	}
+
+	if (no_bs)
+		bs = 1024;
+
 	if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
 		flags = 0;
 	if (flags & EXT4_EXTENTS_FL) {
@@ -143,39 +317,49 @@ static void frag_report(const char *file
 		printf("Blocksize of file %s is %d\n", filename, bs);
 	bpib = bs / 4;
 	numblocks = (fileinfo.st_size + (bs-1)) / bs;
+	filesize = (long long)fileinfo.st_size;
 	if (verbose) {
+		int rc1, rc2;
 		printf("File size of %s is %lld (%ld blocks)\n", filename,
-		       (long long) fileinfo.st_size, numblocks);
-		printf("First block: %lu\nLast block: %lu\n",
-		       get_bmap(fd, 0), get_bmap(fd, numblocks - 1));
-	}
-	for (i=0, count=0; i < numblocks; i++) {
-		if (is_ext2 && last_block) {
-			if (((i-EXT2_DIRECT) % bpib) == 0)
-				last_block++;
-			if (((i-EXT2_DIRECT-bpib) % (bpib*bpib)) == 0)
-				last_block++;
-			if (((i-EXT2_DIRECT-bpib-bpib*bpib) % (bpib*bpib*bpib)) == 0)
-				last_block++;
-		}
-		block = get_bmap(fd, i);
-		if (block == 0)
-			continue;
-		count++;
-		if (last_block && (block != last_block +1) ) {
-			if (verbose)
-				printf("Discontinuity: Block %ld is at %lu (was %lu)\n",
-				       i, block, last_block);
-			discont++;
+		       filesize, numblocks);
+		if (extent_format == 0) {
+			rc1 = get_bmap(fd, 0, &first_blk);
+			rc2 = get_bmap(fd, numblocks - 1, &last_blk);
+			if (rc1 == 0 && rc2 == 0)
+				printf("First block: %lu\nLast block: %lu\n",
+				       first_blk, last_blk);
+		}
+	}
+	if (is_ext2 || (filefrag_fiemap(fd, int_log2(bs), &num_extents) != 0)) {
+		for (i = 0; i < numblocks; i++) {
+			if (is_ext2 && last_block) {
+				if (((i-EXT2_DIRECT) % bpib) == 0)
+					last_block++;
+				if (((i-EXT2_DIRECT-bpib) % (bpib*bpib)) == 0)
+					last_block++;
+				if (((i-EXT2_DIRECT-bpib-bpib*bpib) %
+							(bpib*bpib*bpib)) == 0)
+					last_block++;
+			}
+			rc = get_bmap(fd, i, &block);
+			if (block == 0)
+				continue;
+			if (last_block && (block != last_block+1) ) {
+				if (verbose)
+					printf("Discontinuity: Block %ld is at "
+					       "%lu (was %lu)\n",
+					       i, block, last_block+1);
+				num_extents++;
+			}
+			last_block = block;
 		}
-		last_block = block;
 	}
-	if (discont==0)
+	if (num_extents == 1)
 		printf("%s: 1 extent found", filename);
 	else
-		printf("%s: %d extents found", filename, discont+1);
-	expected = (count/((bs*8)-(fsinfo.f_files/8/cylgroups)-3))+1;
-	if (is_ext2 && expected < discont+1)
+		printf("%s: %d extents found", filename, num_extents);
+	expected = (num_extents/((bs*8)-(fsinfo.f_files/8/cylgroups)-3))+1;
+	if (is_ext2 && expected < num_extents)
 		printf(", perfection would be %d extent%s\n", expected,
 			(expected>1) ? "s" : "");
 	else
@@ -185,7 +369,7 @@ static void frag_report(const char *file
 
 static void usage(const char *progname)
 {
-	fprintf(stderr, "Usage: %s [-v] file ...\n", progname);
+	fprintf(stderr, "Usage: %s [-bevsx] file ...\n", progname);
 	exit(1);
 }
 
@@ -193,12 +377,26 @@ int main(int argc, char**argv)
 {
 	char **cpp;
 	int c;
+	int ret;
 
-	while ((c = getopt(argc, argv, "v")) != EOF)
+	while ((c = getopt(argc, argv, "besvx")) != EOF)
 		switch (c) {
+		case 'b':
+			no_bs++;
+			break;
 		case 'v':
 			verbose++;
 			break;
+		case 'e':
+			extent_format++;
+			break;
+		case 's':
+			sync_file++;
+			break;
+		case 'x':
+			xattr_map++;
+			extent_format++;
+			break;
 		default:
 			usage(argv[0]);
 			break;
Index: e2fsprogs-1.41.2/lib/ext2fs/fiemap.h
===================================================================
--- /dev/null
+++ e2fsprogs-1.41.2/lib/ext2fs/fiemap.h
@@ -0,0 +1,66 @@
+/*
+ * lib/ext2fs/fiemap.h
+ *
+ * Some portions copyright (C) 2007 Cluster File Systems, Inc
+ *
+ * Authors: Mark Fasheh <mfasheh@suse.com>
+ * 	    Kalpak Shah <kalpak.shah@sun.com>
+ *	    Andreas Dilger <adilger@sun.com>
+ */
+
+#ifndef _EXT2FS_FIEMAP_H
+#define _EXT2FS_FIEMAP_H
+
+struct fiemap_extent {
+	__u64 fe_logical;  /* logical offset in bytes for the start of
+			    * the extent from the beginning of the file */
+	__u64 fe_physical; /* physical offset in bytes for the start
+			    * of the extent from the beginning of the disk */
+	__u64 fe_length;   /* length in bytes for this extent */
+	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
+	__u32 fe_device;   /* device number for this extent */
+};
+
+struct fiemap {
+	__u64 fm_start;		/* logical offset (inclusive) at
+				 * which to start mapping (in) */
+	__u64 fm_length;	/* logical length of mapping which
+				 * userspace wants (in) */
+	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
+	__u32 fm_mapped_extents;/* number of extents that were mapped (out) */
+	__u32 fm_extent_count;	/* size of fm_extents array (in) */
+	__u32 fm_reserved;
+	struct fiemap_extent fm_extents[0]; /* array of mapped extents (out) */
+};
+
+#define	FIEMAP_FLAG_SYNC	 0x00000001 /* sync file data before map */
+#define	FIEMAP_FLAG_XATTR	 0x00000002 /* map extended attribute tree */
+
+#define FIEMAP_FLAGS_COMPAT (FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
+
+#define	FIEMAP_EXTENT_LAST		0x00000001 /* Last extent in file. */
+#define	FIEMAP_EXTENT_UNKNOWN		0x00000002 /* Data location unknown. */
+#define	FIEMAP_EXTENT_DELALLOC		0x00000004 /* Location still pending.
+						    * Sets EXTENT_UNKNOWN. */
+#define	FIEMAP_EXTENT_NO_DIRECT		0x00000008 /* Data mapping undefined */
+#define	FIEMAP_EXTENT_SECONDARY		0x00000010 /* Data copied offline. May
+						    * set EXTENT_NO_DIRECT. */
+#define	FIEMAP_EXTENT_NET		0x00000020 /* Data stored remotely.
+						    * Sets EXTENT_NO_DIRECT. */
+#define	FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is compressed by fs.
+						    * Sets EXTENT_NO_DIRECT. */
+#define	FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.
+						    * Sets EXTENT_NO_DIRECT. */
+#define	FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may not be
+						    * block aligned. */
+#define	FIEMAP_EXTENT_DATA_INLINE	0x00000200 /* Data mixed with metadata.
+						    * Sets EXTENT_NOT_ALIGNED.*/
+#define	FIEMAP_EXTENT_DATA_TAIL		0x00000400 /* Multiple files in block.
+						    * Sets EXTENT_NOT_ALIGNED.*/
+#define	FIEMAP_EXTENT_UNWRITTEN		0x00000800 /* Space allocated, but
+						    * no data (i.e. zero). */
+#define	FIEMAP_EXTENT_MERGED		0x00001000 /* File does not natively
+						    * support extents. Result
+						    * merged for efficiency. */
+
+#endif /* _EXT2FS_FIEMAP_H */
Index: e2fsprogs-1.41.2/misc/filefrag.8.in
===================================================================
--- e2fsprogs-1.41.2.orig/misc/filefrag.8.in
+++ e2fsprogs-1.41.2/misc/filefrag.8.in
@@ -5,7 +5,7 @@ filefrag \- report on file fragmentation
 .SH SYNOPSIS
 .B filefrag
 [
-.B \-v
+.B \-besvx
 ]
 [
 .I files...
@@ -14,11 +14,25 @@ filefrag \- report on file fragmentation
 .B filefrag
 reports on how badly fragmented a particular file might be.  It makes 
 allowances for indirect blocks for ext2 and ext3 filesystems, but can be
-used on files for any filesystem.
+used on files for any filesystem. filefrag initially attempts to get the
+extent information using FIEMAP ioctl which is more efficient and faster.
+If FIEMAP is not supported then filefrag defaults to using FIBMAP.
 .SH OPTIONS
 .TP
+.B \-b
+Use 1024 byte blocksize for the output.
+.TP
+.B \-e
+Use extent format while printing the output.
+.TP
+.B \-s
+Sync the file before requesting the mapping.
+.TP
 .B \-v
 Be verbose when checking for file fragmentation.
+.TP
+.B \-x
+Display mapping of extended attributes.
 .SH AUTHOR
 .B filefrag
 was written by Theodore Ts'o <tytso@mit.edu>.

--Boundary_(ID_NHFlCnRJPvjYPiOzbu+QlA)--
