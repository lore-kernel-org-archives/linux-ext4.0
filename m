From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][26/28] e2fsprogs-fiemap.patch
Date: Sat, 02 Feb 2008 01:54:41 -0700
Message-ID: <20080202085441.GA31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49947 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbYBBIyo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:54:44 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128si7O021744
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:54:44 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00D01SL36C00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:54:44 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Add support for ioctl(FIEMAP) to filefrag.  If the kernel supports FIEMAP
the filefrag program prefers this more efficient mechanism to get extent
information instead of repeated FIBMAP calls.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.2/misc/filefrag.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/filefrag.c
+++ e2fsprogs-1.40.2/misc/filefrag.c
@@ -38,11 +38,47 @@ extern int optind;
 #include <sys/vfs.h>
 #include <sys/ioctl.h>
 #include <linux/fd.h>
+#include <ext2fs/ext2_types.h>
 
 int verbose = 0;
 
-#define FIBMAP	   _IO(0x00,1)	/* bmap access */
-#define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
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
+	__u64 fm_unused;
+	struct fiemap_extent fm_extents[0];
+};
+
+#define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
+#define FIEMAP_FLAG_HSM_READ    0x00000002 /* get data from HSM before map */
+#define FIEMAP_FLAG_NUM_EXTENTS 0x00000004 /* return only number of extents */
+#define FIEMAP_FLAG_INCOMPAT    0xff000000 /* error for unknown flags in here */
+
+#define FIEMAP_EXTENT_HOLE      0x00000001 /* has no data or space allocation */
+#define FIEMAP_EXTENT_UNWRITTEN 0x00000002 /* space allocated, but no data */
+#define FIEMAP_EXTENT_UNMAPPED  0x00000004 /* has data but no space allocation*/
+#define FIEMAP_EXTENT_ERROR     0x00000008 /* mapping error, errno in fe_start*/
+#define FIEMAP_EXTENT_NO_DIRECT 0x00000010 /* cannot access data directly */
+#define FIEMAP_EXTENT_LAST      0x00000020 /* last extent in the file */
+#define FIEMAP_EXTENT_DELALLOC  0x00000040 /* has data but not yet written,
+					      must have EXTENT_UNKNOWN set */
+#define FIEMAP_EXTENT_SECONDARY 0x00000080 /* data (also) in secondary storage,
+					      not in primary if EXTENT_UNKNOWN*/
+#define FIEMAP_EXTENT_EOF       0x00000100 /* if fm_start+fm_len is beyond EOF*/
+
+
+#define FIBMAP		_IO(0x00, 1)	/* bmap access */
+#define FIGETBSZ	_IO(0x00, 2)	/* get the block size used for bmap */
+#define EXT4_IOC_FIEMAP	_IOWR('f', 10, struct fiemap) /* get file  extent info*/
 
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define	EXT3_IOC_GETFLAGS		_IOR('f', 1, long)
@@ -71,6 +107,62 @@ static unsigned long get_bmap(int fd, un
 	return b;
 }
 
+int filefrag_fiemap(int fd, int bs, int *num_extents)
+{
+	char buf[4096] = "";
+	struct fiemap *fiemap = (struct fiemap *)buf;
+	int count = (sizeof(buf) - sizeof(*fiemap)) /
+			sizeof(struct fiemap_extent);
+	__u64 logical_blk = 0, last_blk = 0;
+	unsigned long flags;
+	int tot_extents = 0;
+	int eof = 0;
+	int i;
+	int rc;
+
+	memset(fiemap, 0, sizeof(struct fiemap));
+	fiemap->fm_extent_count = count;
+	fiemap->fm_length = ~0ULL;
+	if (!verbose)
+		flags |= FIEMAP_FLAG_NUM_EXTENTS;
+
+	do {
+		fiemap->fm_length = ~0ULL;
+		fiemap->fm_flags = flags;
+		fiemap->fm_extent_count = count;
+		rc = ioctl (fd, EXT4_IOC_FIEMAP, (unsigned long) fiemap);
+		if (rc)
+			return rc;
+
+		if (!verbose) {
+			*num_extents = fiemap->fm_extent_count;
+			goto out;
+		}
+
+		for (i = 0; i < fiemap->fm_extent_count; i++) {
+			__u64 phy_blk;
+			unsigned long ext_len;
+
+			phy_blk = fiemap->fm_extents[i].fe_offset / bs;
+			ext_len = fiemap->fm_extents[i].fe_length / bs;
+			if (logical_blk && (phy_blk != last_blk+1))
+				printf("Discontinuity: Block %llu is at %llu "
+				       "(was %llu)\n", logical_blk, phy_blk,
+				       last_blk);
+			logical_blk += ext_len;
+			last_blk = phy_blk + ext_len - 1;
+			if (fiemap->fm_extents[i].fe_flags & FIEMAP_EXTENT_EOF)
+				eof = 1;
+		}
+		fiemap->fm_start += fiemap->fm_length;
+		tot_extents += fiemap->fm_extent_count;
+	} while (0);
+
+	*num_extents = tot_extents;
+out:
+	return 0;
+}
+
 #define EXT2_DIRECT	12
 
 static void frag_report(const char *filename)
@@ -86,7 +178,7 @@ static void frag_report(const char *file
 	unsigned long	block, last_block = 0, numblocks, i;
 	long		bpib;	/* Blocks per indirect block */
 	long		cylgroups;
-	int		discont = 0, expected;
+	int		num_extents = 0, expected;
 	int		is_ext2 = 0;
 	unsigned int	flags;
 
@@ -135,7 +227,8 @@ static void frag_report(const char *file
 	if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
 		flags = 0;
 	if (flags & EXT4_EXTENTS_FL) {
-		printf("File is stored in extents format\n");
+		if (verbose)
+			printf("File is stored in extents format\n");
 		is_ext2 = 0;
 	}
 	if (verbose)
@@ -148,32 +241,36 @@ static void frag_report(const char *file
 		printf("First block: %lu\nLast block: %lu\n",
 		       get_bmap(fd, 0), get_bmap(fd, numblocks - 1));
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
+			block = get_bmap(fd, i);
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

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
