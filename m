From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2image: Add support for qcow2 format
Date: Wed,  1 Dec 2010 18:41:49 +0100
Message-ID: <1291225309-10750-2-git-send-email-lczerner@redhat.com>
References: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
Cc: adilger@dilger.ca, sandeen@redhat.com, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab0LAS24 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Dec 2010 13:28:56 -0500
In-Reply-To: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds support for exporting filesystem into QCOW2 image
format. Like sparse format this saves space, by writing only necessary
(metadata blocks) into image. Unlike sparse image, QCOW2 image is NOT
sparse, hence does not change its size by copying with not-sparse-aware
tools.

New options '-q' has been added to tell the e2image to use QCOW2 as an
output image format. QCOW2 supports encryption and compression, however
e2image so far does no support such features, however you can still
scramble filenames with '-s' option.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/bitops.h  |    4 +
 lib/ext2fs/e2image.h |   59 +++++
 misc/e2image.c       |  587 +++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 599 insertions(+), 51 deletions(-)

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
index 4de2c8d..e5e76f5 100644
--- a/lib/ext2fs/e2image.h
+++ b/lib/ext2fs/e2image.h
@@ -12,6 +12,20 @@
  * %End-Header%
  */
 
+/* Number of l2 tables in memory before writeback */
+#define L2_CACHE_PREALLOC	256
+
+#define QCOW_MAGIC (('Q' << 24) | ('F' << 16) | ('I' << 8) | 0xfb)
+#define QCOW_VERSION 2
+
+/* Image types */
+#define IMAGE_RAW	1
+#define IMAGE_QCOW2	2
+
+/* Image flags */
+#define INSTALL_FLAG	1
+#define SCRAMBLE_FLAG	2
+
 
 struct ext2_image_hdr {
 	__u32	magic_number;	/* This must be EXT2_ET_MAGIC_E2IMAGE */
@@ -37,15 +51,60 @@ struct ext2_image_hdr {
 	__u32	offset_reserved[8];
 };
 
+struct ext2_qcow2_hdr {
+	__u32	magic;
+	__u32	version;
 
+	__u64	backing_file_offset;
+	__u32	backing_file_size;
 
+	__u32	cluster_bits;
+	__u64	size;
+	__u32	crypt_method;
 
+	__u32	l1_size;
+	__u64	l1_table_offset;
 
+	__u64	refcount_table_offset;
+	__u32	refcount_table_clusters;
 
+	__u32	nb_snapshots;
+	__u64	snapshots_offset;
+};
 
+typedef struct ext2_qcow2_l2_table L2_CACHE_HEAD;
 
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
+	unsigned int	free;
+	unsigned int	count;
+	unsigned int	written;
+};
 
+struct ext2_qcow2_image {
+	int	fd;
+	struct	ext2_qcow2_hdr		*hdr;
+	struct	ext2_qcow2_l2_cache	*l2_cache;
+	__u32	cluster_size;
+	__u32	cluster_bits;
 
+	__u32	l1_size;
+	__u32	l2_size;
 
+	__u64	*l1_table;
 
+	__u64	data_offset;
+	__u64	l2_offset;
+	__u64	refcount_table_offset;
+	__u64	l1_offset;
+};
 
diff --git a/misc/e2image.c b/misc/e2image.c
index 003ac5a..f7c0a0e 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -44,22 +44,89 @@ extern int optind;
 #include "../version.h"
 #include "nls-enable.h"
 
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
+	fprintf(stderr, _("Usage: %s [-rsIq] device image_file\n"),
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
@@ -69,21 +136,13 @@ static void write_header(int fd, struct ext2_image_hdr *hdr, int blocksize)
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
 
@@ -93,7 +152,7 @@ static void write_image_file(ext2_filsys fs, int fd)
 	struct stat		st;
 	errcode_t		retval;
 
-	write_header(fd, NULL, fs->blocksize);
+	write_header(fd, NULL, fs->blocksize, fs->blocksize);
 	memset(&hdr, 0, sizeof(struct ext2_image_hdr));
 
 	hdr.offset_super = lseek(fd, 0, SEEK_CUR);
@@ -142,7 +201,7 @@ static void write_image_file(ext2_filsys fs, int fd)
 	memcpy(hdr.fs_uuid, fs->super->s_uuid, sizeof(hdr.fs_uuid));
 
 	hdr.image_time = time(0);
-	write_header(fd, &hdr, fs->blocksize);
+	write_header(fd, &hdr, fs->blocksize, fs->blocksize);
 }
 
 /*
@@ -311,30 +370,20 @@ static int check_zero_block(char *buf, int blocksize)
 static void write_block(int fd, char *buf, int sparse_offset,
 			int blocksize, blk64_t block)
 {
-	int		count;
-	errcode_t	err;
+	int	ret = 0;
 
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
+	if (ret) {
+		perror("lseek");
+		exit(1);
 	}
+	generic_write(fd, buf, blocksize, block);
 }
 
 int name_id[256];
@@ -456,7 +505,427 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
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
+	/* Fill l1 table with l2 addresses */
+	addr = image->l2_offset;
+	for (i = 0; i < image->l1_size; i++, addr += image->cluster_size)
+		l1_table[i] = ext2fs_cpu_to_be64(addr);
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
+static void initialize_qcow2_image(int fd, ext2_filsys fs,
+			    struct ext2_qcow2_image *image)
+{
+	struct ext2_qcow2_hdr *header;
+	blk64_t total_size, offset;
+	int shift, l2_bits, header_size, l1_size;
+	int cluster_bits = get_bits_from_size(fs->blocksize);
+	struct ext2_super_block *sb = fs->super;
+
+	/* Allocate header */
+	header = malloc(sizeof(struct ext2_qcow2_hdr));
+	if (!header) {
+		com_err(program_name, ENOMEM, "while allocating qcow2 header");
+		exit(1);
+	}
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
+	offset += align_offset(l1_size * sizeof(blk64_t), image->cluster_size);
+
+	header->refcount_table_offset = ext2fs_cpu_to_be64(offset);
+	image->refcount_table_offset = offset;
+	header->refcount_table_clusters = ext2fs_cpu_to_be32(1);
+
+	offset += image->cluster_size;
+	image->l2_offset = offset;
+	offset += (image->l1_size * image->l2_size * sizeof(blk64_t));
+	image->data_offset = offset;
+
+	image->hdr = header;
+
+	init_l1_table(sb, image);
+	init_l2_cache(image);
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
+	put_l2_cache(img);
+
+	free(img);
+}
+
+/**
+ * Put table from used list (used_head) into free list (free_head).
+ * l2_table is used to return pointer to the next used table (used_head).
+ */
+static void put_used_table(struct ext2_qcow2_l2_cache *cache,
+			  struct ext2_qcow2_l2_table **l2_table)
+{
+	struct ext2_qcow2_l2_table *table;
+
+	table = cache->used_head;
+	cache->used_head = table->next;
+
+	if (!table->next)
+		cache->used_tail = NULL;
+
+	if (!table) {
+		fprintf(stderr, "Not allocated table in used list\n");
+		exit(1);
+	}
+
+	table->next = cache->free_head;
+	cache->free_head = table;
+
+	cache->free++;
+
+	*l2_table = cache->used_head;
+}
+
+/*
+ * We might need to write some zero l2 tables for the rest
+ * of the filesystem.
+ */
+static void write_l2_tail(struct ext2_qcow2_image *image)
+{
+	blk64_t seek, offset, off;
+	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
+	unsigned int count;
+	int fd = image->fd;
+
+	if (cache->written == image->l1_size)
+		return;
+
+	seek = image->l2_offset + (cache->written * image->cluster_size);
+	if (lseek(fd, seek, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+
+	count = (image->l1_size - cache->written);
+	generic_write(fd, NULL, count + image->cluster_size, 0);
+
+	return;
+}
+
+static void flush_l2_cache(struct ext2_qcow2_image *image)
+{
+	blk64_t seek, offset, off;
+	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
+	struct ext2_qcow2_l2_table *table = cache->used_head;
+	unsigned int index;
+	int fd = image->fd;
+
+	/* Store current position */
+	if ((offset = lseek(fd, 0, SEEK_CUR)) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+
+	seek = image->l2_offset + (cache->written * image->cluster_size);
+	if (lseek(fd, seek, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+
+	index = cache->written;
+	while (cache->free < cache->count) {
+		if (!table) {
+			fprintf(stderr, "Programming error, "
+					"table does not exist\n");
+			exit(1);
+		}
+
+		/* write zero tables */
+		if (index < table->l1_index) {
+			unsigned int size;
+			size = (table->l1_index - index) * image->cluster_size;
+			generic_write(fd, NULL, size, 0);
+			seek += size;
+			index += (table->l1_index - index);
+			continue;
+		}
+
+		if (index != table->l1_index) {
+			fprintf(stderr, "Programming error, index mismatch");
+			exit(1);
+		}
+
+		generic_write(fd, (char *)table->data, image->cluster_size , 0);
+		seek += (image->l2_size * sizeof(__u64));
+		put_used_table(cache, &table);
+		index++;
+	}
+	cache->written = index;
+
+	/* Restore current position */
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
+	cache->free_head = table->next;
+
+	if (!table) {
+		fprintf(stderr, "Programming error, no tables "
+				"in the free list\n");
+		exit(1);
+	}
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
+static void add_l2_item(struct ext2_qcow2_image *image, blk64_t l1_index,
+			blk64_t l2_index, blk64_t data)
+{
+	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
+	struct ext2_qcow2_l2_table *table = cache->used_tail;
+	blk64_t offset = image->l2_offset + (l1_index * image->cluster_size);
+
+	if (!table || (table->offset != offset)) {
+		get_free_table(image, &table);
+		table->l1_index = l1_index;
+		table->offset = offset;
+	}
+
+	table->data[l2_index] = ext2fs_cpu_to_be64(data);
+}
+
+/* IDEA: we can do defragmentation while creating data-included qcow2 image */
+
+static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
+{
+	errcode_t	retval;
+	blk64_t		blk, datablk, offset, size, actual;
+	char		*buf;
+	int		sparse = 0;
+	struct ext2_qcow2_image		*img;
+	struct ext2_super_block		*sb = fs->super;
+	unsigned int		header_size, l2_bits, i;
+	blk64_t		l1_index, l2_offset, l2_index;
+	char *buffer;
+	__u64 *l2_table;
+
+	/* allocate  struct ext2_qcow2_image */
+	img = malloc(sizeof(struct ext2_qcow2_image));
+	if (!img) {
+		com_err(program_name, ENOMEM, "while allocating"
+					      "ext2_qcow2_image");
+		exit(1);
+	}
+
+	initialize_qcow2_image(fd, fs, img);
+	header_size = align_offset(sizeof(struct ext2_qcow2_hdr),
+				   img->cluster_size);
+
+	write_header(fd, img->hdr, sizeof(struct ext2_qcow2_hdr), header_size);
+
+	/* Write l1_table*/
+	buffer = calloc(img->l1_size, sizeof(__u64));
+	size = img->l1_size * sizeof(__u64);
+	memcpy(buffer, img->l1_table, size);
+	generic_write(fd, buffer, size, 0);
+
+	if (lseek(fd, img->refcount_table_offset, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+
+	/* Write refcount table */
+	memset(buffer, 0, img->cluster_size);
+	generic_write(fd, buffer, img->cluster_size, 0);
+	free(buffer);
+
+	buf = malloc(fs->blocksize);
+	if (!buf) {
+		com_err(program_name, ENOMEM, "while allocating buffer");
+		exit(1);
+	}
+
+	offset = img->data_offset;
+	if (lseek(fd, offset, SEEK_SET) < 0) {
+		strerror(errno);
+		exit(1);
+	}
+
+	/* Write qcow2 data blocks */
+	for (blk = 0; blk < ext2fs_blocks_count(fs->super); blk++) {
+		blk64_t pos;
+		blk64_t cluster_offset;
+
+		pos = blk * img->cluster_size;
+		l2_bits = get_bits_from_size(img->l2_size);
+		l1_index = pos >> (l2_bits + img->cluster_bits);
+		l2_offset = ext2fs_be64_to_cpu(img->l1_table[l1_index]);
+		l2_index = (pos >> img->cluster_bits) & (img->l2_size - 1);
+
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
+			generic_write(fd, buf, fs->blocksize, 0);
+
+			add_l2_item(img, l1_index, l2_index, offset);
+			offset += fs->blocksize;
+		}
+	}
+	flush_l2_cache(img);
+	write_l2_tail(img);
+
+	free(buf);
+	free_qcow2_image(img);
+}
+
+static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 {
 	struct process_block_struct	pb;
 	struct ext2_inode		inode;
@@ -472,7 +941,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 		exit(1);
 	}
 
-	if (scramble_flag) {
+	if (flags & SCRAMBLE_FLAG) {
 		retval = ext2fs_allocate_block_bitmap(fs, "scramble block map",
 						      &scramble_block_map);
 		if (retval) {
@@ -551,11 +1020,20 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
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
@@ -564,8 +1042,9 @@ static void install_image(char *device, char *image_fn, int raw_flag)
 	io_manager	io_ptr;
 	io_channel	io, image_io;
 
-	if (raw_flag) {
-		com_err(program_name, 0, "Raw images cannot be installed");
+	if (type) {
+		com_err(program_name, 0, "Raw and qcow2 images cannot"
+			"be installed");
 		exit(1);
 	}
 
@@ -633,9 +1112,8 @@ int main (int argc, char ** argv)
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
@@ -649,16 +1127,23 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
-	while ((c = getopt (argc, argv, "rsI")) != EOF)
+	while ((c = getopt(argc, argv, "rsIq")) != EOF)
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
+		case 'q':
+			if (img_type)
+				usage();
+			img_type |= IMAGE_QCOW2;
 			break;
 		default:
 			usage();
@@ -668,8 +1153,8 @@ int main (int argc, char ** argv)
 	device_name = argv[optind];
 	image_fn = argv[optind+1];
 
-	if (install_flag) {
-		install_image(device_name, image_fn, raw_flag);
+	if (flags & INSTALL_FLAG) {
+		install_image(device_name, image_fn, img_type);
 		exit (0);
 	}
 
@@ -697,8 +1182,8 @@ int main (int argc, char ** argv)
 		}
 	}
 
-	if (raw_flag)
-		write_raw_image_file(fs, fd, scramble_flag);
+	if (img_type)
+		write_raw_image_file(fs, fd, img_type, flags);
 	else
 		write_image_file(fs, fd);
 
-- 
1.7.2.3

