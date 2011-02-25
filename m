From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/4] e2image: Add support for qcow2 format
Date: Fri, 25 Feb 2011 13:49:30 +0100
Message-ID: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1BYMtm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Feb 2011 07:49:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds support for exporting filesystem into QCOW2 image
format. Like sparse format this saves space, by writing only necessary
(metadata blocks) into image. Unlike sparse image, QCOW2 image is NOT
sparse, hence does not change its size by copying with not-sparse-aware
tools.

New options '-Q' has been added to tell the e2image to use QCOW2 as an
output image format. QCOW2 supports encryption and compression, however
e2image so far does no support such features, however you can still
scramble filenames with '-s' option.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/Makefile.in |    4 +-
 lib/ext2fs/bitops.h    |    4 +
 lib/ext2fs/e2image.h   |   21 +-
 lib/ext2fs/qcow2.c     |  227 +++++++++++++++
 lib/ext2fs/qcow2.h     |   94 +++++++
 misc/e2image.8.in      |   47 +++-
 misc/e2image.c         |  723 ++++++++++++++++++++++++++++++++++++++++++++----
 7 files changed, 1048 insertions(+), 72 deletions(-)
 create mode 100644 lib/ext2fs/qcow2.c
 create mode 100644 lib/ext2fs/qcow2.h

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 763694d..72a5331 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -70,6 +70,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	openfs.o \
 	progress.o \
 	punch.o \
+	qcow2.o \
 	read_bb.o \
 	read_bb_file.o \
 	res_gdt.o \
@@ -138,6 +139,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/openfs.c \
 	$(srcdir)/progress.c \
 	$(srcdir)/punch.c \
+	$(srcdir)/qcow2.c \
 	$(srcdir)/read_bb.c \
 	$(srcdir)/read_bb_file.c \
 	$(srcdir)/res_gdt.c \
@@ -158,7 +160,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/write_bb_file.c
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
-	tdb.h
+	tdb.h qcow2.h
 HFILES_IN=  ext2_err.h ext2_types.h
 
 LIBRARY= libext2fs
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 3ded002..83a01e4 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -31,6 +31,8 @@ extern __u64 ext2fs_swab64(__u64 val);
 #define ext2fs_le32_to_cpu(x) ext2fs_swab32((x))
 #define ext2fs_cpu_to_le16(x) ext2fs_swab16((x))
 #define ext2fs_le16_to_cpu(x) ext2fs_swab16((x))
+#define ext2fs_cpu_to_be64(x) ((__u64)(x))
+#define ext2fs_be64_to_cpu(x) ((__u64)(x))
 #define ext2fs_cpu_to_be32(x) ((__u32)(x))
 #define ext2fs_be32_to_cpu(x) ((__u32)(x))
 #define ext2fs_cpu_to_be16(x) ((__u16)(x))
@@ -42,6 +44,8 @@ extern __u64 ext2fs_swab64(__u64 val);
 #define ext2fs_le32_to_cpu(x) ((__u32)(x))
 #define ext2fs_cpu_to_le16(x) ((__u16)(x))
 #define ext2fs_le16_to_cpu(x) ((__u16)(x))
+#define ext2fs_cpu_to_be64(x) ext2fs_swab64((x))
+#define ext2fs_be64_to_cpu(x) ext2fs_swab64((x))
 #define ext2fs_cpu_to_be32(x) ext2fs_swab32((x))
 #define ext2fs_be32_to_cpu(x) ext2fs_swab32((x))
 #define ext2fs_cpu_to_be16(x) ext2fs_swab16((x))
diff --git a/lib/ext2fs/e2image.h b/lib/ext2fs/e2image.h
index 4de2c8d..a47f9e6 100644
--- a/lib/ext2fs/e2image.h
+++ b/lib/ext2fs/e2image.h
@@ -12,6 +12,14 @@
  * %End-Header%
  */
 
+/* Image types */
+#define IMAGE_RAW	1
+#define IMAGE_QCOW2	2
+
+/* Image flags */
+#define INSTALL_FLAG	1
+#define SCRAMBLE_FLAG	2
+#define IS_QCOW2_FLAG	3
 
 struct ext2_image_hdr {
 	__u32	magic_number;	/* This must be EXT2_ET_MAGIC_E2IMAGE */
@@ -36,16 +44,3 @@ struct ext2_image_hdr {
 	__u32	offset_blockmap; /* Byte offset of the inode bitmaps */
 	__u32	offset_reserved[8];
 };
-
-
-
-
-
-
-
-
-
-
-
-
-
diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
new file mode 100644
index 0000000..17eab38
--- /dev/null
+++ b/lib/ext2fs/qcow2.c
@@ -0,0 +1,227 @@
+/*
+ * qcow2.c --- Set of qcow2 related functions
+ *
+ * Copyright (C) 2010 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#define _LARGEFILE_SOURCE
+#define _LARGEFILE64_SOURCE
+
+#include <fcntl.h>
+#include <grp.h>
+#include <pwd.h>
+#include <stdio.h>
+#ifdef HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+#include <string.h>
+#include <time.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <assert.h>
+
+#include "ext2fs/ext2fs.h"
+#include "qcow2.h"
+
+/* Functions for converting qcow2 image into raw image */
+
+struct ext2_qcow2_hdr *qcow2_read_header(int fd, char *fname)
+{
+	void *buffer = NULL;
+	struct ext2_qcow2_hdr *hdr = NULL;
+	size_t size;
+
+	buffer = malloc(sizeof(struct ext2_qcow2_hdr));
+	if (!buffer)
+		return NULL;
+	memset(buffer, 0, sizeof(struct ext2_qcow2_hdr));
+
+	if (lseek(fd, 0, SEEK_SET) < 0)
+		return NULL;
+
+	size = read(fd, buffer, sizeof(struct ext2_qcow2_hdr));
+	if (size != sizeof(struct ext2_qcow2_hdr)) {
+		free(buffer);
+		return NULL;
+	}
+
+	hdr = (struct ext2_qcow2_hdr *)(buffer);
+
+	if ((ext2fs_be32_to_cpu(hdr->magic) != QCOW_MAGIC) ||
+	    (ext2fs_be32_to_cpu(hdr->version) != 2)) {
+		free(hdr);
+		return NULL;
+	}
+
+	return hdr;
+}
+
+static int qcow2_read_l1_table(struct ext2_qcow2_image *img)
+{
+	int fd = img->fd;
+	size_t size, l1_size = img->l1_size * sizeof(__u64);
+	__u64 *table;
+
+	table = calloc(1, l1_size);
+	if (!table)
+		return errno;
+
+	if (lseek(fd, img->l1_offset, SEEK_SET) < 0)
+		return errno;
+
+	size = read(fd, table, l1_size);
+	if (size != l1_size) {
+		free(table);
+		return errno;
+	}
+
+	img->l1_table = table;
+
+	return 0;
+}
+
+static int qcow2_read_l2_table(struct ext2_qcow2_image *img, off_t offset,
+			    __u64 **l2_table)
+{
+	int fd = img->fd;
+	size_t size;
+
+	assert(*l2_table);
+
+	if (lseek(fd, offset, SEEK_SET) < 0)
+		return errno;
+
+	size = read(fd, *l2_table, img->cluster_size);
+	if (size != img->cluster_size)
+		return errno;
+
+	return 0;
+}
+
+static int qcow2_copy_data(int fdin, int fdout, off_t off_in, off_t off_out,
+			       void *buf, size_t count)
+{
+	size_t size;
+
+	assert(buf);
+
+	if (lseek(fdout, off_out, SEEK_SET) < 0)
+		return errno;
+
+	if (lseek(fdin, off_in, SEEK_SET) < 0)
+		return errno;
+
+	size = read(fdin, buf, count);
+	if (size != count)
+		return errno;
+
+	size = write(fdout, buf, count);
+	if (size != count)
+		return errno;
+
+	return 0;
+}
+
+
+int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
+			      struct ext2_qcow2_hdr *hdr)
+{
+	struct ext2_qcow2_image img;
+	int ret = 0;
+	unsigned int l1_index, l2_index;
+	off_t offset;
+	__u64 *l1_table, *l2_table;
+	void *copy_buf = NULL;
+	size_t size;
+
+	img.fd = qcow2_fd;
+	img.hdr = hdr;
+	img.l2_cache = NULL;
+	img.l1_table = NULL;
+	img.cluster_bits = ext2fs_be32_to_cpu(hdr->cluster_bits);
+	img.cluster_size = 1 << img.cluster_bits;
+	img.l1_size = ext2fs_be32_to_cpu(hdr->l1_size);
+	img.l1_offset = ext2fs_be64_to_cpu(hdr->l1_table_offset);
+	img.l2_size = 1 << (img.cluster_bits - 3);
+	img.image_size = ext2fs_be64_to_cpu(hdr->size);
+
+	l2_table = calloc(1, img.cluster_size);
+	if (!l2_table) {
+		ret = errno;
+		goto out;
+	}
+
+	copy_buf = calloc(1, 1 << img.cluster_bits);
+	if (!copy_buf) {
+		ret = errno;
+		goto out;
+	}
+
+	if (lseek(raw_fd, 0, SEEK_SET) < 0) {
+		ret = errno;
+		goto out;
+	}
+
+	ret = qcow2_read_l1_table(&img);
+	if (ret)
+		goto out;
+
+	l1_table = img.l1_table;
+	/* Walk through l1 table */
+	for (l1_index = 0; l1_index < img.l1_size; l1_index++) {
+		off_t off_out;
+
+		offset = ext2fs_be64_to_cpu(l1_table[l1_index]) &
+			 ~QCOW_OFLAG_COPIED;
+
+		if ((offset > img.image_size) ||
+		    (offset <= 0))
+			continue;
+
+		ret = qcow2_read_l2_table(&img, offset, &l2_table);
+		if (ret)
+			break;
+
+		/* Walk through l2 table and copy data blocks into raw image */
+		for (l2_index = 0; l2_index < img.l2_size; l2_index++) {
+			offset = ext2fs_be64_to_cpu(l2_table[l2_index]) &
+				 ~QCOW_OFLAG_COPIED;
+
+			if (offset == 0)
+				continue;
+
+			off_out = (l1_index * img.l2_size) +
+				  l2_index;
+			off_out <<= img.cluster_bits;
+			ret = qcow2_copy_data(qcow2_fd, raw_fd, offset,
+					off_out, copy_buf, img.cluster_size);
+			if (ret)
+				goto out;
+		}
+	}
+
+	/* Resize the output image to the filesystem size */
+	if (lseek(raw_fd, img.image_size, SEEK_SET) < 0)
+		return errno;
+
+	size = write(raw_fd, copy_buf, 1);
+	if (size != 1)
+		return errno;
+
+out:
+	if (copy_buf)
+		free(copy_buf);
+	if (img.l1_table)
+		free(img.l1_table);
+	if (l2_table)
+		free(l2_table);
+	return ret;
+}
diff --git a/lib/ext2fs/qcow2.h b/lib/ext2fs/qcow2.h
new file mode 100644
index 0000000..28eaac5
--- /dev/null
+++ b/lib/ext2fs/qcow2.h
@@ -0,0 +1,94 @@
+/*
+ * e2qcow.h --- 
+ *
+ * Copyright
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+/* Number of l2 tables in memory before writeback */
+#define L2_CACHE_PREALLOC	512
+
+
+#define QCOW_MAGIC (('Q' << 24) | ('F' << 16) | ('I' << 8) | 0xfb)
+#define QCOW_VERSION 2
+#define QCOW_OFLAG_COPIED     (1LL << 63)
+
+struct ext2_qcow2_hdr {
+	__u32	magic;
+	__u32	version;
+
+	__u64	backing_file_offset;
+	__u32	backing_file_size;
+
+	__u32	cluster_bits;
+	__u64	size;
+	__u32	crypt_method;
+
+	__u32	l1_size;
+	__u64	l1_table_offset;
+
+	__u64	refcount_table_offset;
+	__u32	refcount_table_clusters;
+
+	__u32	nb_snapshots;
+	__u64	snapshots_offset;
+};
+
+typedef struct ext2_qcow2_l2_table L2_CACHE_HEAD;
+
+struct ext2_qcow2_l2_table {
+	__u32		l1_index;
+	__u64		offset;
+	__u64		*data;
+	L2_CACHE_HEAD	*next;
+};
+
+struct ext2_qcow2_l2_cache {
+	L2_CACHE_HEAD	*used_head;
+	L2_CACHE_HEAD	*used_tail;
+	L2_CACHE_HEAD	*free_head;
+	__u32		free;
+	__u32		count;
+	__u64		next_offset;
+};
+
+struct ext2_qcow2_refcount {
+	__u64	*refcount_table;
+	__u64	refcount_table_offset;
+	__u64	refcount_block_offset;
+
+	__u32	refcount_table_clusters;
+	__u32	refcount_table_index;
+	__u32	refcount_block_index;
+
+	__u16	*refcount_block;
+};
+
+struct ext2_qcow2_image {
+	int	fd;
+	struct	ext2_qcow2_hdr		*hdr;
+	struct	ext2_qcow2_l2_cache	*l2_cache;
+	struct	ext2_qcow2_refcount	refcount;
+	__u32	cluster_size;
+	__u32	cluster_bits;
+	__u32	l1_size;
+	__u32	l2_size;
+
+	__u64	*l1_table;
+	__u64	l2_offset;
+	__u64	l1_offset;
+	__u64	image_size;
+};
+
+/* Function prototypes */
+
+/* qcow2.c */
+
+/* Functions for converting qcow2 image into raw image */
+struct ext2_qcow2_hdr *qcow2_read_header(int, char *);
+int qcow2_write_raw_image(int, int, struct ext2_qcow2_hdr *);
+
diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index e18a30b..4a28580 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -40,7 +40,8 @@ another program, such as
 (Note that this is currently only supported when
 creating a raw image file using the 
 .B \-r
-option, since the process of creating a normal image file currently
+option, since the process of creating a normal image file, or QCOW2
+image currently
 requires random access to the file, which cannot be done using a
 pipe.  This restriction will hopefully be lifted in a future version of
 .BR e2image .)
@@ -56,13 +57,14 @@ accessible in the case where the filesystem has been badly damaged.
 .PP
 To save disk space, 
 .B e2image
-creates the image file as a sparse file.  
-Hence, if the image file
+creates the image file as a sparse file, or in QCOW2 format.  
+Hence, if the sparse image file
 needs to be copied to another location, it should
 either be compressed first or copied using the 
 .B \-\-sparse=always
 option to the GNU version of 
-.BR cp .  
+.BR cp .
+This does not apply to the QCOW2 image, which is not sparse.
 .PP
 The size of an ext2 image file depends primarily on the size of the
 filesystems and how many inodes are in use.  For a typical 10 gigabyte
@@ -129,6 +131,43 @@ the
 option will prevent analysis of problems related to hash-tree indexed
 directories.
 .PP
+.SH QCOW2 IMAGE FILES
+The 
+.B \-Q
+option will create a QCOW2 image file instead of a normal, or raw image file.
+A QCOW2 image contains all the information the raw image does, however unlike
+the raw image it is not sparse. The QCOW2 image minimize the amount of disk
+space by storing data in special format with pack data closely together, hence
+avoiding holes while still minimizing size.
+.PP
+In order to send filesystem to the maintainer as a part of bug report to
+e2fsprogs, use following commands (replace hda1 with the appropriate device):
+.PP
+.br
+\	\fBe2image \-Q /dev/hda1 hda1.qcow2\fR
+.br
+\	\fBbzip2 -z hda1.qcow2\fR
+.PP
+This will only send the metadata information, without any data blocks.  
+However, the filenames in the directory blocks can still reveal
+information about the contents of the filesystem that the bug reporter
+may wish to keep confidential.  To address this concern, the
+.B \-s
+option can be specified.  This will cause
+.B e2image 
+to scramble directory entries and zero out any unused portions
+of the directory blocks before writing the image file.  However,
+the 
+.B \-s
+option will prevent analysis of problems related to hash-tree indexed
+directories.
+.PP
+Note that QCOW2 image created by
+.B e2image 
+is regular QCOW2 image and can be processed by tools aware of QCOW2 format
+such as for example
+.BR qemu-img .
+.PP
 .SH AUTHOR
 .B e2image 
 was written by Theodore Ts'o (tytso@mit.edu).
diff --git a/misc/e2image.c b/misc/e2image.c
index 003ac5a..6dc78d3 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -33,6 +33,7 @@ extern int optind;
 #include <errno.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <assert.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
@@ -40,26 +41,96 @@ extern int optind;
 #include "uuid/uuid.h"
 #include "e2p/e2p.h"
 #include "ext2fs/e2image.h"
+#include "ext2fs/qcow2.h"
 
 #include "../version.h"
 #include "nls-enable.h"
 
+#define QCOW_OFLAG_COPIED     (1LL << 63)
+
+
 const char * program_name = "e2image";
 char * device_name = NULL;
 
+static blk64_t align_offset(blk64_t offset, int n)
+{
+	return (offset + n - 1) & ~(n - 1);
+}
+
+static int get_bits_from_size(size_t size)
+{
+	int res = 0;
+
+	if (size == 0)
+		return -1;
+
+	while (size != 1) {
+		/* Not a power of two */
+		if (size & 1)
+			return -1;
+
+		size >>= 1;
+		res++;
+	}
+	return res;
+}
+
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-rsI] device image_file\n"),
+	fprintf(stderr, _("Usage: %s [-rsIQ] device image_file\n"),
 		program_name);
 	exit (1);
 }
 
-static void write_header(int fd, struct ext2_image_hdr *hdr, int blocksize)
+static void generic_write(int fd, char *buf, int blocksize, blk64_t block)
+{
+	int count, free_buf = 0;
+	errcode_t err;
+	blk64_t offset;
+
+	if (!blocksize)
+		return;
+
+	if (!buf) {
+		free_buf = 1;
+		buf = calloc(1, blocksize);
+		if (!buf) {
+			com_err(program_name, ENOMEM, "while allocating buffer");
+			exit(1);
+		}
+	}
+
+	count = write(fd, buf, blocksize);
+	if (count != blocksize) {
+		if (count == -1)
+			err = errno;
+		else
+			err = 0;
+
+		if (block)
+			com_err(program_name, err, "error writing block %llu",
+				block);
+		else
+			com_err(program_name, err, "error in write()");
+
+		exit(1);
+	}
+	if (free_buf)
+		free(buf);
+}
+
+static void write_header(int fd, void *hdr, int hdr_size, int wrt_size)
 {
 	char *header_buf;
 	int actual;
 
-	header_buf = malloc(blocksize);
+	/* Sanity check */
+	if (hdr_size > wrt_size) {
+		fprintf(stderr, _("Error: header size is bigger than "
+				  "wrt_size\n"));
+	}
+
+	header_buf = malloc(wrt_size);
 	if (!header_buf) {
 		fputs(_("Couldn't allocate header buffer\n"), stderr);
 		exit(1);
@@ -69,21 +140,13 @@ static void write_header(int fd, struct ext2_image_hdr *hdr, int blocksize)
 		perror("lseek while writing header");
 		exit(1);
 	}
-	memset(header_buf, 0, blocksize);
+	memset(header_buf, 0, wrt_size);
 
 	if (hdr)
-		memcpy(header_buf, hdr, sizeof(struct ext2_image_hdr));
+		memcpy(header_buf, hdr, hdr_size);
+
+	generic_write(fd, header_buf, wrt_size, 0);
 
-	actual = write(fd, header_buf, blocksize);
-	if (actual < 0) {
-		perror("write header");
-		exit(1);
-	}
-	if (actual != blocksize) {
-		fprintf(stderr, _("short write (only %d bytes) for "
-				  "writing image header"), actual);
-		exit(1);
-	}
 	free(header_buf);
 }
 
@@ -93,7 +156,7 @@ static void write_image_file(ext2_filsys fs, int fd)
 	struct stat		st;
 	errcode_t		retval;
 
-	write_header(fd, NULL, fs->blocksize);
+	write_header(fd, NULL, fs->blocksize, fs->blocksize);
 	memset(&hdr, 0, sizeof(struct ext2_image_hdr));
 
 	hdr.offset_super = lseek(fd, 0, SEEK_CUR);
@@ -142,7 +205,7 @@ static void write_image_file(ext2_filsys fs, int fd)
 	memcpy(hdr.fs_uuid, fs->super->s_uuid, sizeof(hdr.fs_uuid));
 
 	hdr.image_time = time(0);
-	write_header(fd, &hdr, fs->blocksize);
+	write_header(fd, &hdr, fs->blocksize, fs->blocksize);
 }
 
 /*
@@ -150,6 +213,7 @@ static void write_image_file(ext2_filsys fs, int fd)
  */
 ext2fs_block_bitmap meta_block_map;
 ext2fs_block_bitmap scramble_block_map;	/* Directory blocks to be scrambled */
+blk64_t meta_blocks_count;
 
 struct process_block_struct {
 	ext2_ino_t	ino;
@@ -226,6 +290,7 @@ static int process_dir_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	p = (struct process_block_struct *) priv_data;
 
 	ext2fs_mark_block_bitmap2(meta_block_map, *block_nr);
+	meta_blocks_count++;
 	if (scramble_block_map && p->is_dir && blockcnt >= 0)
 		ext2fs_mark_block_bitmap2(scramble_block_map, *block_nr);
 	return 0;
@@ -240,6 +305,7 @@ static int process_file_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 {
 	if (blockcnt < 0) {
 		ext2fs_mark_block_bitmap2(meta_block_map, *block_nr);
+		meta_blocks_count++;
 	}
 	return 0;
 }
@@ -254,6 +320,7 @@ static void mark_table_blocks(ext2_filsys fs)
 	 * Mark primary superblock
 	 */
 	ext2fs_mark_block_bitmap2(meta_block_map, first_block);
+	meta_blocks_count++;
 
 	/*
 	 * Mark the primary superblock descriptors
@@ -262,6 +329,7 @@ static void mark_table_blocks(ext2_filsys fs)
 		ext2fs_mark_block_bitmap2(meta_block_map,
 			 ext2fs_descriptor_block_loc2(fs, first_block, j));
 	}
+	meta_blocks_count += fs->desc_blocks;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		/*
@@ -272,6 +340,7 @@ static void mark_table_blocks(ext2_filsys fs)
 			     j < (unsigned) fs->inode_blocks_per_group;
 			     j++, b++)
 				ext2fs_mark_block_bitmap2(meta_block_map, b);
+			meta_blocks_count += fs->inode_blocks_per_group;
 		}
 
 		/*
@@ -280,6 +349,7 @@ static void mark_table_blocks(ext2_filsys fs)
 		if (ext2fs_block_bitmap_loc(fs, i)) {
 			ext2fs_mark_block_bitmap2(meta_block_map,
 				     ext2fs_block_bitmap_loc(fs, i));
+			meta_blocks_count++;
 		}
 
 		/*
@@ -288,6 +358,7 @@ static void mark_table_blocks(ext2_filsys fs)
 		if (ext2fs_inode_bitmap_loc(fs, i)) {
 			ext2fs_mark_block_bitmap2(meta_block_map,
 				 ext2fs_inode_bitmap_loc(fs, i));
+			meta_blocks_count++;
 		}
 	}
 }
@@ -311,30 +382,20 @@ static int check_zero_block(char *buf, int blocksize)
 static void write_block(int fd, char *buf, int sparse_offset,
 			int blocksize, blk64_t block)
 {
-	int		count;
-	errcode_t	err;
+	off_t	ret = 0;
 
 	if (sparse_offset) {
 #ifdef HAVE_LSEEK64
-		if (lseek64(fd, sparse_offset, SEEK_CUR) < 0)
-			perror("lseek");
+		ret = lseek64(fd, sparse_offset, SEEK_CUR);
 #else
-		if (lseek(fd, sparse_offset, SEEK_CUR) < 0)
-			perror("lseek");
+		ret = lseek(fd, sparse_offset, SEEK_CUR);
 #endif
 	}
-	if (blocksize) {
-		count = write(fd, buf, blocksize);
-		if (count != blocksize) {
-			if (count == -1)
-				err = errno;
-			else
-				err = 0;
-			com_err(program_name, err, "error writing block %llu",
-				block);
-			exit(1);
-		}
+	if (ret < 0) {
+		strerror(errno);
+		exit(1);
 	}
+	generic_write(fd, buf, blocksize, block);
 }
 
 int name_id[256];
@@ -445,6 +506,7 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 			}
 			sparse += fs->blocksize;
 			if (sparse >= 1024*1024) {
+
 				write_block(fd, 0, sparse, 0, 0);
 				sparse = 0;
 			}
@@ -456,7 +518,538 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 	free(buf);
 }
 
-static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
+static void init_l1_table(struct ext2_super_block *sb, struct ext2_qcow2_image *image)
+{
+	blk64_t entries, sector_count, total_size;
+	int cluster_size, shift, l2_size, ret, header_size;
+	int i;
+	__u64 *l1_table, addr;
+
+	l1_table = calloc(image->l1_size, sizeof(__u64));
+	if (!l1_table) {
+		com_err(program_name, ENOMEM, "while allocating l1 table");
+		exit(1);
+	}
+
+	image->l1_table = l1_table;
+}
+
+static void init_l2_cache(struct ext2_qcow2_image *image)
+{
+	unsigned int count, i;
+	struct ext2_qcow2_l2_cache *cache;
+	struct ext2_qcow2_l2_table *table;
+
+	cache = calloc(1, sizeof(struct ext2_qcow2_l2_cache));
+	if (!cache)
+		goto alloc_err;
+
+	count = (image->l1_size > L2_CACHE_PREALLOC) ? L2_CACHE_PREALLOC :
+		 image->l1_size;
+
+	cache->count = count;
+	cache->free = count;
+	cache->next_offset = image->l2_offset;
+
+	for (i = 0; i < count; i++) {
+		table = calloc(1, sizeof(struct ext2_qcow2_l2_table));
+		if (!table)
+			goto alloc_err;
+
+		table->data = calloc(image->l2_size, sizeof(__u64));
+		if (!table->data)
+			goto alloc_err;
+
+		table->next = cache->free_head;
+		cache->free_head = table;
+	}
+
+	image->l2_cache = cache;
+	return;
+
+alloc_err:
+	com_err(program_name, ENOMEM, "while allocating l2 cache");
+	exit(1);
+}
+
+static void put_l2_cache(struct ext2_qcow2_image *image)
+{
+	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
+	struct ext2_qcow2_l2_table *tmp, *table;
+
+	if (!cache)
+		return;
+
+	table = cache->free_head;
+	cache->free_head = NULL;
+again:
+	while (table) {
+		tmp = table;
+		table = table->next;
+		free(tmp->data);
+		free(tmp);
+	}
+
+	if (cache->free != cache->count) {
+		fprintf(stderr, "Warning: There are still tables in the "
+				"cache while putting the cache, data will "
+				"be lost so the image may not be valid.\n");
+		table = cache->used_head;
+		cache->used_head = NULL;
+		goto again;
+	}
+
+	free(cache);
+}
+
+static int init_refcount(struct ext2_qcow2_image *img, blk64_t table_offset)
+{
+	struct	ext2_qcow2_refcount	*ref;
+	blk64_t table_clusters;
+
+	ref = &(img->refcount);
+
+	/*
+	 * One refcount block addresses 2048 clusters, one refcount table
+	 * addresses cluster/sizeof(__u64) refcount blocks, and we need
+	 * to address meta_blocks_count clusters + qcow2 metadata clusters
+	 * in the worst case.
+	 */
+	table_clusters = meta_blocks_count + (table_offset >> img->cluster_bits);
+	table_clusters >>= (img->cluster_bits + 6 - 1);
+	table_clusters = (table_clusters == 0) ? 1 : table_clusters;
+
+	ref->refcount_table_offset = table_offset;
+	ref->refcount_table_clusters = table_clusters;
+	ref->refcount_table_index = 0;
+	ref->refcount_block_index = 0;
+
+	/* Allocate refcount table */
+	ref->refcount_table = calloc(ref->refcount_table_clusters,
+					img->cluster_size);
+	if (!ref->refcount_table)
+		return -ENOMEM;
+
+	/* Allocate refcount block */
+	ref->refcount_block = calloc(1, img->cluster_size);
+	if (!ref->refcount_block)
+		return -ENOMEM;
+	
+	return 0;
+}
+
+static int initialize_qcow2_image(int fd, ext2_filsys fs,
+			    struct ext2_qcow2_image *image)
+{
+	struct ext2_qcow2_hdr *header;
+	blk64_t total_size, offset;
+	int shift, l2_bits, header_size, l1_size, ret;
+	int cluster_bits = get_bits_from_size(fs->blocksize);
+	struct ext2_super_block *sb = fs->super;
+
+	/* Allocate header */
+	header = malloc(sizeof(struct ext2_qcow2_hdr));
+	if (!header)
+		return errno;
+	memset(header, 0, sizeof(struct ext2_qcow2_hdr));
+
+	total_size = ext2fs_blocks_count(sb) << cluster_bits;
+	image->cluster_size = 1 << cluster_bits;
+	image->l2_size = 1 << (cluster_bits - 3);
+	image->cluster_bits = cluster_bits;
+	image->fd = fd;
+
+	header->magic = ext2fs_cpu_to_be32(QCOW_MAGIC);
+	header->version = ext2fs_cpu_to_be32(QCOW_VERSION);
+	header->size = ext2fs_cpu_to_be64(total_size);
+	header->cluster_bits = ext2fs_cpu_to_be32(cluster_bits);
+
+	header_size = (sizeof(struct ext2_qcow2_hdr) + 7) & ~7;
+	offset = align_offset(header_size, image->cluster_size);
+
+	header->l1_table_offset = ext2fs_cpu_to_be64(offset);
+	image->l1_offset = offset;
+
+	l2_bits = cluster_bits - 3;
+	shift = cluster_bits + l2_bits;
+	l1_size = ((total_size + (1LL << shift) - 1) >> shift);
+	header->l1_size = ext2fs_cpu_to_be32(l1_size);
+	image->l1_size = l1_size;
+
+	/* Make space for L1 table */
+	offset += align_offset(l1_size * sizeof(blk64_t), image->cluster_size);
+
+	/* Initialize refcounting */
+	ret = init_refcount(image, offset);
+	if (ret)
+		return ret;
+	header->refcount_table_offset = ext2fs_cpu_to_be64(offset);
+	header->refcount_table_clusters =
+		ext2fs_cpu_to_be32(image->refcount.refcount_table_clusters);
+	offset += image->cluster_size;
+	offset += image->refcount.refcount_table_clusters << image->cluster_bits;
+
+	/* Make space for L2 tables */
+	image->l2_offset = offset;
+	offset += image->cluster_size;
+
+	/* Make space for first refcount block */
+	image->refcount.refcount_block_offset = offset;
+
+	image->hdr = header;
+	/* Initialize l1 and l2 tables */
+	init_l1_table(sb, image);
+	init_l2_cache(image);
+
+	return 0;
+}
+
+static void free_qcow2_image(struct ext2_qcow2_image *img)
+{
+	unsigned int i;
+
+	if (!img)
+		return;
+
+	if (img->hdr)
+		free(img->hdr);
+
+	if (img->l1_table)
+		free(img->l1_table);
+	
+	if (img->refcount.refcount_table)
+		free(img->refcount.refcount_table);
+	if (img->refcount.refcount_block)
+		free(img->refcount.refcount_block);
+
+	put_l2_cache(img);
+
+	free(img);
+}
+
+/**
+ * Put table from used list (used_head) into free list (free_head).
+ * l2_table is used to return pointer to the next used table (used_head).
+ */
+static void put_used_table(struct ext2_qcow2_image *img,
+			  struct ext2_qcow2_l2_table **l2_table)
+{
+	struct ext2_qcow2_l2_cache *cache = img->l2_cache;
+	struct ext2_qcow2_l2_table *table;
+
+	table = cache->used_head;
+	cache->used_head = table->next;
+
+	assert(table);
+	if (!table->next)
+		cache->used_tail = NULL;
+
+	/* Clean the table for case we will need to use it again */
+	memset(table->data, 0, img->cluster_size);
+	table->next = cache->free_head;
+	cache->free_head = table;
+
+	cache->free++;
+
+	*l2_table = cache->used_head;
+}
+
+static void flush_l2_cache(struct ext2_qcow2_image *image)
+{
+	blk64_t offset, seek = 0;
+	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
+	struct ext2_qcow2_l2_table *table = cache->used_head;
+	int fd = image->fd;
+
+	/* Store current position */
+	if ((offset = lseek(fd, 0, SEEK_CUR)) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+
+	while (cache->free < cache->count) {
+		assert(table);
+
+		if (seek != table->offset) {
+			if (lseek(fd, table->offset, SEEK_SET) < 0) {
+				strerror(errno);
+				exit(1);
+			}
+			seek = table->offset;
+		}
+
+		generic_write(fd, (char *)table->data, image->cluster_size , 0);
+		put_used_table(image, &table);
+		seek += image->cluster_size;
+	}
+
+	/* Restore previous position */
+	if (lseek(fd, offset, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+}
+
+/**
+ * Get first free table (from free_head) and put it into tail of used list
+ * (to used_tail).
+ * l2_table is used to return pointer to moved table.
+ * Returns 1 if the cache is full, 0 otherwise.
+ */
+static void get_free_table(struct ext2_qcow2_image *image,
+			  struct ext2_qcow2_l2_table **l2_table)
+{
+	struct ext2_qcow2_l2_table *table;
+	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
+
+	if (0 == cache->free)
+		flush_l2_cache(image);
+
+	table = cache->free_head;
+	assert(table);
+	cache->free_head = table->next;
+
+	if (cache->used_tail)
+		cache->used_tail->next = table;
+	else
+		/* First item in the used list */
+		cache->used_head = table;
+
+	cache->used_tail = table;
+	cache->free--;
+
+	*l2_table = table;
+}
+
+static int add_l2_item(struct ext2_qcow2_image *img, blk64_t blk,
+		       blk64_t data, blk64_t next)
+{
+	struct ext2_qcow2_l2_cache *cache = img->l2_cache;
+	struct ext2_qcow2_l2_table *table = cache->used_tail;
+	blk64_t l1_index = blk / img->l2_size;
+	blk64_t l2_index = blk & (img->l2_size - 1);
+	int ret = 0;
+
+	/*
+	 * Need to create new table if it does not exist,
+	 * or if it is full
+	 * */
+	if (!table || (table->l1_index != l1_index)) {
+		get_free_table(img, &table);
+		table->l1_index = l1_index;
+		table->offset = cache->next_offset;
+		cache->next_offset = next;
+		img->l1_table[l1_index] =
+			ext2fs_cpu_to_be64(table->offset | QCOW_OFLAG_COPIED);
+		ret++;
+	}
+
+	table->data[l2_index] = ext2fs_cpu_to_be64(data | QCOW_OFLAG_COPIED);
+	return ret;
+}
+
+static int update_refcount(int fd, struct ext2_qcow2_image *img,
+			   blk64_t offset, blk64_t rfblk_pos)
+{
+	struct	ext2_qcow2_refcount	*ref;
+	__u32	table_index;
+	int ret = 0;
+
+	ref = &(img->refcount);
+	table_index = offset >> (2 * img->cluster_bits - 1);
+
+	/*
+	 * Need to create new refcount block when the offset addresses
+	 * another item in the refcount table
+	 */
+	if (table_index != ref->refcount_table_index) {
+
+		if (lseek(fd, ref->refcount_block_offset, SEEK_SET) < 0) {
+			strerror(errno);
+			exit(1);
+		}
+
+		generic_write(fd, (char *)ref->refcount_block,
+			      img->cluster_size, 0);
+		memset((char *)ref->refcount_block, 0, img->cluster_size);
+
+		ref->refcount_table[ref->refcount_table_index] =
+			ext2fs_cpu_to_be64(ref->refcount_block_offset);
+		ref->refcount_block_offset = rfblk_pos;
+		ref->refcount_block_index = 0;
+		ref->refcount_table_index = table_index;
+		ret++;
+	}
+	
+	/*
+	 * We are relying on the fact that we are creating the qcow2
+	 * image sequentially, hence we will always allocate refcount
+	 * block items sequentialy.
+	 */
+	ref->refcount_block[ref->refcount_block_index] = ext2fs_cpu_to_be16(1);
+	ref->refcount_block_index++;
+	return ret;
+}
+
+static int sync_refcount(int fd, struct ext2_qcow2_image *img)
+{
+	struct	ext2_qcow2_refcount	*ref;
+
+	ref = &(img->refcount);
+
+	ref->refcount_table[ref->refcount_table_index] =
+		ext2fs_cpu_to_be64(ref->refcount_block_offset);
+	if (lseek(fd, ref->refcount_table_offset, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+	generic_write(fd, (char *)ref->refcount_table,
+		ref->refcount_table_clusters << img->cluster_bits, 0);
+
+	if (lseek(fd, ref->refcount_block_offset, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+	generic_write(fd, (char *)ref->refcount_block, img->cluster_size, 0);
+	return 0;
+}
+
+static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
+{
+	errcode_t	retval;
+	blk64_t		blk, datablk, offset, size, actual, end;
+	char		*buf;
+	int		sparse = 0;
+	struct ext2_qcow2_image		*img;
+	unsigned int		header_size, i;
+	blk64_t		l1_index, l2_offset, l2_index;
+	char *buffer;
+	__u64 *l2_table;
+
+	/* allocate  struct ext2_qcow2_image */
+	img = malloc(sizeof(struct ext2_qcow2_image));
+	if (!img) {
+		com_err(program_name, ENOMEM, "while allocating "
+					      "ext2_qcow2_image");
+		exit(1);
+	}
+
+	retval = initialize_qcow2_image(fd, fs, img);
+	if (retval) {
+		com_err(program_name, retval, "while allocating initializing "
+					   "ext2_qcow2_image");
+		exit(1);
+	}
+	header_size = align_offset(sizeof(struct ext2_qcow2_hdr),
+				   img->cluster_size);
+	write_header(fd, img->hdr, sizeof(struct ext2_qcow2_hdr), header_size);
+
+	/* Refcount all qcow2 related metadata up to refcount_block_offset */
+	end = img->refcount.refcount_block_offset;
+	if (lseek(fd, end, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+	blk = end + img->cluster_size;
+	for (offset = 0; offset <= end; offset += img->cluster_size) {
+		if (update_refcount(fd, img, offset, blk)) {
+			blk += img->cluster_size;
+			/*
+			 * If we create new refcount block, we need to refcount
+			 * it as well.
+			 */
+			end += img->cluster_size;
+		}
+	}
+	if (lseek(fd, offset, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+
+	buf = malloc(fs->blocksize);
+	if (!buf) {
+		com_err(program_name, errno, "while allocating buffer");
+		exit(1);
+	}
+	/* Write qcow2 data blocks */
+	for (blk = 0; blk < ext2fs_blocks_count(fs->super); blk++) {
+		if ((blk >= fs->super->s_first_data_block) &&
+		    ext2fs_test_block_bitmap2(meta_block_map, blk)) {
+			retval = io_channel_read_blk64(fs->io, blk, 1, buf);
+			if (retval) {
+				com_err(program_name, retval,
+					"error reading block %llu", blk);
+			}
+			if (scramble_block_map &&
+			    ext2fs_test_block_bitmap2(scramble_block_map, blk))
+				scramble_dir_block(fs, blk, buf);
+			if (check_zero_block(buf, fs->blocksize))
+				continue;
+
+			if (update_refcount(fd, img, offset, offset)) {
+				/* Make space for another refcount block */
+				offset += img->cluster_size;
+				if (lseek(fd, offset, SEEK_SET) < 0) {
+					strerror(errno);
+					exit(1);
+				}
+				/*
+				 * We have created the new refcount block, this
+				 * means that we need to refcount it as well.So
+				 * the prefious update_refcount refcounted the
+				 * block itself and now we are going to create
+				 * refcount for data. New refcount block should
+				 * not be created!
+				 */
+				if (update_refcount(fd, img, offset, offset)) {
+					fprintf(stderr, "Programming error\n");
+					exit(1);
+				}
+			}
+
+			generic_write(fd, buf, fs->blocksize, 0);
+
+			if (add_l2_item(img, blk, offset,
+					offset + img->cluster_size)) {
+				offset += img->cluster_size;
+				if (update_refcount(fd, img, offset,
+					offset + img->cluster_size)) {
+					offset += img->cluster_size;
+					if (update_refcount(fd, img, offset,
+							    offset)) {
+						fprintf(stderr, "Programming"
+								"error\n");
+						exit(1);
+					}
+				}
+				offset += img->cluster_size;
+				if (lseek(fd, offset, SEEK_SET) < 0) {
+					strerror(errno);
+					exit(1);
+				}
+				continue;
+			}
+
+			offset += img->cluster_size;
+		}
+	}
+	update_refcount(fd, img, offset, offset);
+	flush_l2_cache(img);
+	sync_refcount(fd, img);
+
+	/* Write l1_table*/
+	if (lseek(fd, img->l1_offset, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+	size = img->l1_size * sizeof(__u64);
+	generic_write(fd, (char *)img->l1_table, size, 0);
+
+	free(buf);
+	free_qcow2_image(img);
+}
+
+static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 {
 	struct process_block_struct	pb;
 	struct ext2_inode		inode;
@@ -465,6 +1058,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 	errcode_t			retval;
 	char *				block_buf;
 
+	meta_blocks_count = 0;
 	retval = ext2fs_allocate_block_bitmap(fs, "in-use block map",
 					      &meta_block_map);
 	if (retval) {
@@ -472,7 +1066,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 		exit(1);
 	}
 
-	if (scramble_flag) {
+	if (flags & SCRAMBLE_FLAG) {
 		retval = ext2fs_allocate_block_bitmap(fs, "scramble block map",
 						      &scramble_block_map);
 		if (retval) {
@@ -514,6 +1108,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 		if (ext2fs_file_acl_block(&inode)) {
 			ext2fs_mark_block_bitmap2(meta_block_map,
 						 ext2fs_file_acl_block(&inode));
+			meta_blocks_count++;
 		}
 		if (!ext2fs_inode_has_valid_blocks(&inode))
 			continue;
@@ -551,21 +1146,31 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 		}
 	}
 	use_inode_shortcuts(fs, 0);
-	output_meta_data_blocks(fs, fd);
+
+	if (type & IMAGE_QCOW2)
+		output_qcow2_meta_data_blocks(fs, fd);
+	else
+		output_meta_data_blocks(fs, fd);
+
 	free(block_buf);
+	ext2fs_close_inode_scan(scan);
+	ext2fs_free_block_bitmap(meta_block_map);
+	if (type & SCRAMBLE_FLAG)
+		ext2fs_free_block_bitmap(scramble_block_map);
 }
 
-static void install_image(char *device, char *image_fn, int raw_flag)
+static void install_image(char *device, char *image_fn, int type)
 {
 	errcode_t retval;
 	ext2_filsys fs;
 	int open_flag = EXT2_FLAG_IMAGE_FILE;
 	int fd = 0;
 	io_manager	io_ptr;
-	io_channel	io, image_io;
+	io_channel	io;
 
-	if (raw_flag) {
-		com_err(program_name, 0, "Raw images cannot be installed");
+	if (type) {
+		com_err(program_name, 0, "Raw and qcow2 images cannot"
+			"be installed");
 		exit(1);
 	}
 
@@ -607,8 +1212,6 @@ static void install_image(char *device, char *image_fn, int raw_flag)
 		exit(1);
 	}
 
-	image_io = fs->io;
-
 	ext2fs_rewrite_to_io(fs, io);
 
 	if (lseek(fd, fs->image_header->offset_inode, SEEK_SET) < 0) {
@@ -633,9 +1236,8 @@ int main (int argc, char ** argv)
 	ext2_filsys fs;
 	char *image_fn;
 	int open_flag = EXT2_FLAG_64BITS;
-	int raw_flag = 0;
-	int install_flag = 0;
-	int scramble_flag = 0;
+	int img_type = 0;
+	int flags = 0;
 	int fd = 0;
 
 #ifdef ENABLE_NLS
@@ -649,16 +1251,23 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt (argc, argv, "rsI")) != EOF)
+	while ((c = getopt(argc, argv, "rsIQ")) != EOF)
 		switch (c) {
 		case 'r':
-			raw_flag++;
+			if (img_type)
+				usage();
+			img_type |= IMAGE_RAW;
 			break;
 		case 's':
-			scramble_flag++;
+			flags |= SCRAMBLE_FLAG;
 			break;
 		case 'I':
-			install_flag++;
+			flags |= INSTALL_FLAG;
+			break;
+		case 'Q':
+			if (img_type)
+				usage();
+			img_type |= IMAGE_QCOW2;
 			break;
 		default:
 			usage();
@@ -668,8 +1277,8 @@ int main (int argc, char ** argv)
 	device_name = argv[optind];
 	image_fn = argv[optind+1];
 
-	if (install_flag) {
-		install_image(device_name, image_fn, raw_flag);
+	if (flags & INSTALL_FLAG) {
+		install_image(device_name, image_fn, img_type);
 		exit (0);
 	}
 
@@ -697,8 +1306,14 @@ int main (int argc, char ** argv)
 		}
 	}
 
-	if (raw_flag)
-		write_raw_image_file(fs, fd, scramble_flag);
+	if ((img_type & IMAGE_QCOW2) && (fd == 1)) {
+		com_err(program_name, 0, "QCOW2 image can not be written to "
+					 "the stdout!\n");
+		exit(1);
+	}
+
+	if (img_type)
+		write_raw_image_file(fs, fd, img_type, flags);
 	else
 		write_image_file(fs, fd);
 
-- 
1.7.4

