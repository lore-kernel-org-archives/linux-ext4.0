From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH e2fsprogs] filefrag using FIEMAP
Date: Tue, 13 Nov 2007 02:38:58 +0530
Message-ID: <1194901738.12045.25.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@Sun.COM>, TheodoreTso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Fasheh <mark.fasheh@oracle.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:38576 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXKLVIq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Nov 2007 16:08:46 -0500
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id lACL8ihf012007
	for <linux-ext4@vger.kernel.org>; Mon, 12 Nov 2007 21:08:44 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0JRE00001VWPC300@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Tue,
 13 Nov 2007 05:08:43 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds FIEMAP support to the filefrag utility. It also changes the output format of filefrag by adding a "-e" option. This would make the output more readable and easy for scripting.

For cluster filesystems like Lustre, the extent information will be displayed in lun offset order.

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Kalpak Shah <kalpak.shah@sun.com> 

Index: e2fsprogs-1.40.2/misc/filefrag.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/filefrag.c
+++ e2fsprogs-1.40.2/misc/filefrag.c
@@ -38,13 +38,24 @@ extern int optind;
 #include <sys/vfs.h>
 #include <sys/ioctl.h>
 #include <linux/fd.h>
+#include <ext2fs/ext2_types.h>
+#include <ext2fs/fiemap.h>
 
-int verbose = 0;
+#define LUSTRE_SUPER_MAGIC 0x0BD00BD0
 
-#define FIBMAP	   _IO(0x00,1)	/* bmap access */
-#define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+int verbose = 0;
+int extent_format = 0; /* Print output in extent format */
+int is_lustre = 0; /* Indicates lustre filesystem */
+int lun_offset = 0; /* extents are in lun offset order */
+
+#define FILEFRAG_FIEMAP_INCOMPAT_UNSUPP  (FIEMAP_FLAG_INCOMPAT &	\
+					  ~(FIEMAP_FLAG_LUN_OFFSET))
+
+#define FIBMAP		_IO(0x00, 1)	/* bmap access */
+#define FIGETBSZ	_IO(0x00, 2)	/* get the block size used for bmap */
+#define EXT4_IOC_FIEMAP	_IOWR('f', 10, struct fiemap) /* get file extent info*/
 
-#define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define	EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define	EXT3_IOC_GETFLAGS		_IOR('f', 1, long)
 
 static unsigned int div_ceil(unsigned int a, unsigned int b)
@@ -54,21 +65,168 @@ static unsigned int div_ceil(unsigned in
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
+			      unsigned long long logical_blk, int bs)
+{
+	__u64 phy_blk;
+	unsigned long ext_len;
+	char flags[256] = "";
+
+	phy_blk = fm_extent->fe_offset / bs;
+	ext_len = fm_extent->fe_length / bs;
+
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_HOLE)
+		strcat(flags, "hole,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_EOF)
+		strcat(flags, "eof,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_DELALLOC)
+		strcat(flags, "delalloc,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
+		strcat(flags, "unwritten,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNMAPPED)
+		strcat(flags, "unmapped,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_SECONDARY)
+		strcat(flags, "secondary,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_NO_DIRECT)
+		strcat(flags, "no_direct,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_ERROR)
+		strcat(flags, "mapping_error");
+
+	/* Remove trailing comma, if any */
+	if (strlen(flags))
+		flags[strlen(flags) - 1] = '\0';
+
+	printf("%5d:%10llu..%10llu:%10llu..%10llu:%10lu:%3d:   %s\n",
+	       cur_ex, logical_blk, logical_blk + ext_len - 1,
+	       phy_blk, phy_blk ? phy_blk + ext_len : 0, ext_len,
+	       fm_extent->fe_lun, flags);
+}
+
+int filefrag_fiemap(int fd, int bs, int *num_extents)
+{
+	char buf[4096] = "";
+	struct fiemap *fiemap = (struct fiemap *)buf;
+	int count = (sizeof(buf) - sizeof(*fiemap)) /
+			sizeof(struct fiemap_extent);
+	unsigned long long logical_blk = 0, last_blk = 0;
+	unsigned long flags = 0;
+	int lun_offset_tried = 0;
+	int tot_extents = 0, previous_lun = 0;
+	int last = 0, eof = 0;
+	int i, rc;
+
+	memset(fiemap, 0, sizeof(struct fiemap));
+	fiemap->fm_extent_count = count;
+	fiemap->fm_length = ~0ULL;
+
+	if (lun_offset)
+		flags |= FIEMAP_FLAG_LUN_OFFSET;
+
+	if (!verbose)
+		flags |= FIEMAP_FLAG_NUM_EXTENTS;
+
+	if (extent_format && verbose)
+		printf("  ext:\t    logical: start..end  physical: start..end:  "
+		       "length: lun: flags:\n");
+
+retry_wo_lun_offset:
+	do {
+		fiemap->fm_length = ~0ULL;
+		fiemap->fm_flags = flags;
+		fiemap->fm_extent_count = count = 1;
+		rc = ioctl (fd, EXT4_IOC_FIEMAP, (unsigned long) fiemap);
+		if (rc == -EOPNOTSUPP && (flags & FIEMAP_FLAG_LUN_OFFSET)) {
+			flags &= ~FIEMAP_FLAG_LUN_OFFSET;
+			goto retry_wo_lun_offset;
+		}
+		if (rc)
+			return rc;
+
+		if (!verbose) {
+			*num_extents = fiemap->fm_extent_count;
+			goto out;
+		}
+
+		if (fiemap->fm_flags & FILEFRAG_FIEMAP_INCOMPAT_UNSUPP) {
+			static int fiemap_incompat_printed;
+
+			if (fiemap_incompat_printed == 0) {
+				fprintf(stderr, "\nFIEMAP failed with "
+					"incompatible feature %x\n",
+					fiemap->fm_flags &
+					FILEFRAG_FIEMAP_INCOMPAT_UNSUPP);
+				fiemap_incompat_printed = 1;
+			}
+			return -EOPNOTSUPP;
+		}
+
+
+		/* If 0 extents are returned, then more ioctls are not needed */
+		if (fiemap->fm_extent_count == 0)
+			break;
+
+		for (i = 0; i < fiemap->fm_extent_count; i++) {
+			__u64 phy_blk, phy_start;
+			unsigned long ext_len;
+
+			phy_blk = fiemap->fm_extents[i].fe_offset / bs;
+			ext_len = fiemap->fm_extents[i].fe_length / bs;
+
+			if (previous_lun != fiemap->fm_extents[i].fe_lun) {
+				if (flags & FIEMAP_FLAG_LUN_OFFSET)
+					logical_blk = 0;
+				previous_lun = fiemap->fm_extents[i].fe_lun;
+			}
+
+			if (extent_format) {
+				print_extent_info(&fiemap->fm_extents[i],
+						  tot_extents, logical_blk, bs);
+			} else if (logical_blk && phy_blk != last_blk+1) {
+				printf("Discontinuity: Block %llu is at %llu "
+				       "(was %llu)\n", logical_blk, phy_blk,
+				       last_blk);
+			}
+
+			logical_blk += ext_len;
+			last_blk = phy_blk + ext_len - 1;
+			if (fiemap->fm_extents[i].fe_flags & FIEMAP_EXTENT_LAST)
+				last = 1;
+			tot_extents++;
+		}
+
+		/* For LUN_OFFSET mappings, if EXTENT_LAST is not yet found then
+		 * fm_start needs to be the same as it was for earlier ioctl.
+		 * Else we ask for extents starting from where the last mapping
+		 * ended. */
+		if (flags & FIEMAP_FLAG_LUN_OFFSET)
+			fiemap->fm_start = 0;
+		else
+			fiemap->fm_start += fiemap->fm_length;
+	} while (last == 0);
+
+	*num_extents = tot_extents;
+out:
+	return 0;
 }
 
 #define EXT2_DIRECT	12
@@ -86,9 +244,11 @@ static void frag_report(const char *file
 	unsigned long	block, last_block = 0, numblocks, i;
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
@@ -113,6 +273,15 @@ static void frag_report(const char *file
 		printf("Filesystem type is: %lx\n", 
 		       (unsigned long) fsinfo.f_type);
 	}
+
+	/* Check if filesystem is lustre */
+	if (fsinfo.f_type == LUSTRE_SUPER_MAGIC) {
+		is_lustre = 1;
+		/* For lustre fs we will always display in extent format */
+		extent_format++;
+		lun_offset++;
+	}
+
 	cylgroups = div_ceil(fsinfo.f_blocks, fsinfo.f_bsize*8);
 	if (verbose) {
 		printf("Filesystem cylinder groups is approximately %ld\n", 
@@ -135,7 +304,8 @@ static void frag_report(const char *file
 	if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
 		flags = 0;
 	if (flags & EXT4_EXTENTS_FL) {
-		printf("File is stored in extents format\n");
+		if (verbose)
+			printf("File is stored in extents format\n");
 		is_ext2 = 0;
 	}
 	if (verbose)
@@ -143,37 +313,48 @@ static void frag_report(const char *file
 	bpib = bs / 4;
 	numblocks = (fileinfo.st_size + (bs-1)) / bs;
 	if (verbose) {
+		int rc1, rc2;
+
 		printf("File size of %s is %lld (%ld blocks)\n", filename, 
 		       (long long) fileinfo.st_size, numblocks);
-		printf("First block: %lu\nLast block: %lu\n",
-		       get_bmap(fd, 0), get_bmap(fd, numblocks - 1));
+		if (extent_format == 0) {
+			rc1 = get_bmap(fd, 0, &first_blk);
+			rc2 = get_bmap(fd, numblocks - 1, &last_blk);
+			if (rc1 == 0 && rc2 == 0)
+				printf("First block: %lu\nLast block: %lu\n",
+				       first_blk, last_blk);
+		}
 	}
-	for (i=0; i < numblocks; i++) {
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
-		if (last_block && (block != last_block +1) ) {
-			if (verbose)
-				printf("Discontinuity: Block %ld is at %lu (was %lu)\n",
-				       i, block, last_block);
-			discont++;
+	if (is_ext2 || (filefrag_fiemap(fd, bs, &num_extents) != 0)) {
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
+		printf("%s: %d extents found", filename, num_extents);
 	expected = (numblocks/((bs*8)-(fsinfo.f_files/8/cylgroups)-3))+1;
-	if (is_ext2 && expected != discont+1)
+	if (is_ext2 && expected != num_extents)
 		printf(", perfection would be %d extent%s\n", expected,
 			(expected>1) ? "s" : "");
 	else
@@ -183,7 +364,7 @@ static void frag_report(const char *file
 
 static void usage(const char *progname)
 {
-	fprintf(stderr, "Usage: %s [-v] file ...\n", progname);
+	fprintf(stderr, "Usage: %s [-vel] file ...\n", progname);
 	exit(1);
 }
 
@@ -192,11 +373,17 @@ int main(int argc, char**argv)
 	char **cpp;
 	int c;
 
-	while ((c = getopt(argc, argv, "v")) != EOF)
+	while ((c = getopt(argc, argv, "vel")) != EOF)
 		switch (c) {
 		case 'v':
 			verbose++;
 			break;
+		case 'e':
+			extent_format++;
+			break;
+		case 'l':
+			lun_offset++;
+			break;
 		default:
 			usage(argv[0]);
 			break;
Index: e2fsprogs-1.40.2/lib/ext2fs/fiemap.h
===================================================================
--- /dev/null
+++ e2fsprogs-1.40.2/lib/ext2fs/fiemap.h
@@ -0,0 +1,49 @@
+/*
+ * lib/ext2fs/fiemap.h
+ *
+ * Copyright (C) 2007 Cluster File Systems, Inc
+ *
+ * Author: Kalpak Shah <kalpak.shah@sun.com>
+ *	   Andreas Dilger <adilger@sun.com>
+ */
+
+#ifndef _EXT2FS_FIEMAP_H
+#define _EXT2FS_FIEMAP_H
+
+struct fiemap_extent {
+	__u64 fe_offset; /* offset in bytes for the start of the extent */
+	__u64 fe_length; /* length in bytes for the extent */
+	__u32 fe_flags;  /* returned FIEMAP_EXTENT_* flags for the extent */
+	__u32 fe_lun;    /* logical device number for extent (starting at 0) */
+};
+
+struct fiemap {
+	__u64 fm_start;	 	/* logical starting byte offset (in/out) */
+	__u64 fm_length;	/* logical length of map (in/out) */
+	__u32 fm_flags;	 	/* FIEMAP_FLAG_* flags for request (in/out) */
+	__u32 fm_extent_count;  /* number of extents in fm_extents (in/out) */
+	__u64 fm_end_offset;	/* logical offset of end of mapping in last ioctl */
+	struct fiemap_extent fm_extents[0];
+};
+
+#define	FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
+#define	FIEMAP_FLAG_HSM_READ	0x00000002 /* get data from HSM before map */
+#define	FIEMAP_FLAG_NUM_EXTENTS	0x00000004 /* return only number of extents */
+#define	FIEMAP_FLAG_INCOMPAT	0xff000000 /* error for unknown flags in here */
+#define	FIEMAP_FLAG_LUN_OFFSET	0x01000000 /* use lun offsets, instead of
+					    * logical file offsets */
+
+#define	FIEMAP_EXTENT_HOLE	0x00000001 /* has no data or space allocation */
+#define	FIEMAP_EXTENT_UNWRITTEN	0x00000002 /* space allocated, but no data */
+#define	FIEMAP_EXTENT_UNMAPPED	0x00000004 /* has data but no space allocation*/
+#define	FIEMAP_EXTENT_ERROR	0x00000008 /* mapping error, errno in fe_start*/
+#define	FIEMAP_EXTENT_NO_DIRECT	0x00000010 /* cannot access data directly */
+#define	FIEMAP_EXTENT_LAST	0x00000020 /* last extent in the file */
+#define	FIEMAP_EXTENT_DELALLOC	0x00000040 /* has data but not yet written,
+					      must have EXTENT_UNKNOWN set */
+#define	FIEMAP_EXTENT_SECONDARY	0x00000080 /* data (also) in secondary storage,
+					      not in primary if EXTENT_UNKNOWN*/
+#define	FIEMAP_EXTENT_EOF	0x00000100 /* if fm_start+fm_len is beyond EOF*/
+
+#endif /* _EXT2FS_FIEMAP_H */
+
