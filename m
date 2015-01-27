From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 33/54] e2undo: ditch tdb file,
 write everything to a flat file
Date: Mon, 26 Jan 2015 23:39:09 -0800
Message-ID: <20150127073909.13308.12295.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34717 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbbA0HjP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:39:15 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The existing undo file format (which is based on tdb) has many
problems.  First, its comparison of superblock fields is ineffective,
since the last mount time is only written by the kernel, not the tools
(which means that undo files can be applied out of order, thus
corrupting the filesystem); block numbers are written in CPU byte
order, which will cause silent failures if an undo file is moved from
one type of system to another; using the tdb database costs us an
enormous amount of CPU overhead to maintain the key data structure,
and finally, the tdb database is unable to deal with databases larger
than 2GB.  (Upstream tdb 1.2.12 can handle 4GB, but upgrading a 2TB FS
to 64bit,metadata_csum easily produces 2.9GB of undo files, so we
might as well move off of tdb now.)

The last problem is fatal if you want to use tune2fs to turn on
metadata checksumming, since that rewrites every block on the
filesystem, which can easily produce a many-gigabyte undo file, which
of course is unreadable and therefore the operation cannot be undone.

Therefore, rip all of that out in favor of writing to a flat file.
Old blocks are appended to a file and the index is written to the end
when we're done.  This implementation is much faster than wasting a
considerable amount of time trying to maintain a hash index, which
drops the runtime overhead of tune2fs -O metadata_csum from ~45min
to ~20 seconds on a 2TB filesystem.

I have a few reasons that factored in my decision not to repurpose the
jbd2 file format for undo files.  First, undo files are limited to
2^32 blocks (16TB) which some day might not serve us well.  Second,
the journal block size is tied to the file system block size, but
mke2fs wants to be able to back up big chunks of old device contents.
This would require large changes to the e2fsck journal replay code,
which itself is derived from the kernel jbd2 driver, which I'd rather
not destabilize.  Third, I want to require undo files to store the FS
superblock at the end of undo file creation so that e2undo can be
reasonably sure that an undo file is supposed to apply against the
given block device, and doing so would require changes to the jbd2
format.  Fourth, it didn't seem like a good idea that external
journals should resemble undo files so closely.

v2: Provide a state bit that is only set when the undo channel is
closed correctly so we can warn the user about potentially incomplete
undo files.  Straighten out the superblock handling so that undo files
won't be confused for real ext* FS images.  Record multi-block runs in
each block key to reduce overhead even further.  Support reopening an
undo file so that we can combine multiple FS operations into one
(overall smaller) transaction file, which will be easier to manage.
Flush the undo index data if the program should terminate
unexpectedly.  Update the ext4 superblock bits if errors or -f is
found to encourage fsck to do a full run the next time it's invoked.
Enable undoing the undo.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_err.et.in |    6 
 lib/ext2fs/undo_io.c      |  550 ++++++++++++++++++++++++++++++++++++--------
 misc/e2undo.8.in          |   17 +
 misc/e2undo.c             |  560 +++++++++++++++++++++++++++++++++++++--------
 4 files changed, 923 insertions(+), 210 deletions(-)


diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 790d135..894789e 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -524,4 +524,10 @@ ec	EXT2_ET_EA_BAD_VALUE_OFFSET,
 ec	EXT2_ET_JOURNAL_FLAGS_WRONG,
 	"Journal flags inconsistent"
 
+ec	EXT2_ET_UNDO_FILE_CORRUPT,
+	"Undo file corrupt"
+
+ec	EXT2_ET_UNDO_FILE_WRONG,
+	"Wrong undo file for this filesystem"
+
 	end
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 9a01e30..f1c107a 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -39,8 +39,6 @@
 #endif
 #include <limits.h>
 
-#include "tdb.h"
-
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
@@ -50,22 +48,86 @@
 #define ATTR(x)
 #endif
 
+#undef DEBUG
+
+#ifdef DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
 /*
  * For checking structure magic numbers...
  */
 
 #define EXT2_CHECK_MAGIC(struct, code) \
 	  if ((struct)->magic != (code)) return (code)
+/*
+ * Undo file format: The file is cut up into undo_header.block_size blocks.
+ * The first block contains the header.
+ * The second block contains the superblock.
+ * There is then a repeating series of blocks as follows:
+ *   A key block, which contains undo_keys to map the following data blocks.
+ *   Data blocks
+ * (Note that there are pointers to the first key block and the sb, so this
+ * order isn't strictly necessary.)
+ */
+#define E2UNDO_MAGIC "E2UNDO02"
+#define KEYBLOCK_MAGIC 0xCADECADE
+
+#define E2UNDO_STATE_FINISHED	0x1	/* undo file is complete */
+
+#define E2UNDO_MIN_BLOCK_SIZE	1024	/* undo blocks are no less than 1KB */
+#define E2UNDO_MAX_BLOCK_SIZE	1048576	/* undo blocks are no more than 1MB */
+
+struct undo_header {
+	char magic[8];		/* "E2UNDO02" */
+	__le64 num_keys;	/* how many keys? */
+	__le64 super_offset;	/* where in the file is the superblock copy? */
+	__le64 key_offset;	/* where do the key/data block chunks start? */
+	__le32 block_size;	/* block size of the undo file */
+	__le32 fs_block_size;	/* block size of the target device */
+	__le32 sb_crc;		/* crc32c of the superblock */
+	__le32 state;		/* e2undo state flags */
+	__le32 f_compat;	/* compatible features (none so far) */
+	__le32 f_incompat;	/* incompatible features (none so far) */
+	__le32 f_rocompat;	/* ro compatible features (none so far) */
+	__u8 padding[448];	/* padding */
+	__le32 header_crc;	/* crc32c of this header (but not this field) */
+};
+
+#define E2UNDO_MAX_EXTENT_BLOCKS	512	/* max extent size, in blocks */
+
+struct undo_key {
+	__le64 fsblk;		/* where in the fs does the block go */
+	__le32 blk_crc;		/* crc32c of the block */
+	__le32 size;		/* how many bytes in this block? */
+};
+
+struct undo_key_block {
+	__le32 magic;		/* KEYBLOCK_MAGIC number */
+	__le32 crc;		/* block checksum */
+	__le64 reserved;	/* zero */
+
+	struct undo_key keys[0];	/* keys, which come immediately after */
+};
 
 struct undo_private_data {
 	int	magic;
-	TDB_CONTEXT *tdb;
-	char *tdb_file;
+
+	/* the undo file io channel */
+	io_channel undo_file;
+	blk64_t undo_blk_num;			/* next free block */
+	blk64_t key_blk_num;			/* current key block location */
+	blk64_t super_blk_num;			/* superblock location */
+	blk64_t first_key_blk;			/* first key block location */
+	struct undo_key_block *keyb;
+	size_t num_keys, keys_in_block;
 
 	/* The backing io channel */
 	io_channel real;
 
-	int tdb_data_size;
+	unsigned long long tdb_data_size;
 	int tdb_written;
 
 	/* to support offset in unix I/O manager */
@@ -73,16 +135,15 @@ struct undo_private_data {
 
 	ext2fs_block_bitmap written_block_map;
 	struct struct_ext2_filsys fake_fs;
+
+	struct undo_header hdr;
 };
+#define KEYS_PER_BLOCK(d) (((d)->tdb_data_size / sizeof(struct undo_key)) - 1)
 
 static io_manager undo_io_backing_manager;
 static char *tdb_file;
 static int actual_size;
 
-static unsigned char mtime_key[] = "filesystem MTIME";
-static unsigned char blksize_key[] = "filesystem BLKSIZE";
-static unsigned char uuid_key[] = "filesystem UUID";
-
 errcode_t set_undo_io_backing_manager(io_manager manager)
 {
 	/*
@@ -103,17 +164,34 @@ errcode_t set_undo_io_backup_file(char *file_name)
 	return 0;
 }
 
-static errcode_t write_file_system_identity(io_channel undo_channel,
-							TDB_CONTEXT *tdb)
+static errcode_t write_undo_indexes(struct undo_private_data *data)
 {
 	errcode_t retval;
 	struct ext2_super_block super;
-	TDB_DATA tdb_key, tdb_data;
-	struct undo_private_data *data;
 	io_channel channel;
-	int block_size ;
+	int block_size;
+	__u32 sb_crc, hdr_crc;
+
+	/* Spit out a key block, if there's any data */
+	if (data->keys_in_block) {
+		data->keyb->magic = ext2fs_cpu_to_le32(KEYBLOCK_MAGIC);
+		data->keyb->crc = 0;
+		data->keyb->crc = ext2fs_cpu_to_le32(
+					 ext2fs_crc32c_le(~0,
+					 (unsigned char *)data->keyb,
+					 data->tdb_data_size));
+		dbg_printf("Writing keyblock to blk %llu\n", data->key_blk_num);
+		retval = io_channel_write_blk64(data->undo_file,
+						data->key_blk_num,
+						1, data->keyb);
+		if (retval)
+			return retval;
+		memset(data->keyb, 0, data->tdb_data_size);
+		data->keys_in_block = 0;
+		data->key_blk_num = data->undo_blk_num;
+	}
 
-	data = (struct undo_private_data *) undo_channel->private_data;
+	/* Prepare superblock for write */
 	channel = data->real;
 	block_size = channel->block_size;
 
@@ -121,54 +199,45 @@ static errcode_t write_file_system_identity(io_channel undo_channel,
 	retval = io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, &super);
 	if (retval)
 		goto err_out;
-
-	/* Write to tdb file in the file system byte order */
-	tdb_key.dptr = mtime_key;
-	tdb_key.dsize = sizeof(mtime_key);
-	tdb_data.dptr = (unsigned char *) &(super.s_mtime);
-	tdb_data.dsize = sizeof(super.s_mtime);
-
-	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
-	if (retval == -1) {
-		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
+	sb_crc = ext2fs_crc32c_le(~0, (unsigned char *)&super, SUPERBLOCK_SIZE);
+	super.s_magic = ~super.s_magic;
+
+	/* Write the undo header to disk. */
+	memcpy(data->hdr.magic, E2UNDO_MAGIC, sizeof(data->hdr.magic));
+	data->hdr.num_keys = ext2fs_cpu_to_le64(data->num_keys);
+	data->hdr.super_offset = ext2fs_cpu_to_le64(data->super_blk_num);
+	data->hdr.key_offset = ext2fs_cpu_to_le64(data->first_key_blk);
+	data->hdr.fs_block_size = ext2fs_cpu_to_le32(block_size);
+	data->hdr.sb_crc = ext2fs_cpu_to_le32(sb_crc);
+	hdr_crc = ext2fs_crc32c_le(~0, (unsigned char *)&data->hdr,
+				   sizeof(data->hdr) -
+				   sizeof(data->hdr.header_crc));
+	data->hdr.header_crc = ext2fs_cpu_to_le32(hdr_crc);
+	retval = io_channel_write_blk64(data->undo_file, 0,
+					-(int)sizeof(data->hdr),
+					&data->hdr);
+	if (retval)
 		goto err_out;
-	}
 
-	tdb_key.dptr = uuid_key;
-	tdb_key.dsize = sizeof(uuid_key);
-	tdb_data.dptr = (unsigned char *)&(super.s_uuid);
-	tdb_data.dsize = sizeof(super.s_uuid);
-
-	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
-	if (retval == -1) {
-		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-	}
+	/*
+	 * Record the entire superblock (in FS byte order) so that we can't
+	 * apply e2undo files to the wrong FS or out of order.
+	 */
+	dbg_printf("Writing superblock to block %llu\n", data->super_blk_num);
+	retval = io_channel_write_blk64(data->undo_file, data->super_blk_num,
+					-SUPERBLOCK_SIZE, &super);
+	if (retval)
+		goto err_out;
 
+	retval = io_channel_flush(data->undo_file);
 err_out:
 	io_channel_set_blksize(channel, block_size);
 	return retval;
 }
 
-static errcode_t write_block_size(TDB_CONTEXT *tdb, int block_size)
-{
-	errcode_t retval;
-	TDB_DATA tdb_key, tdb_data;
-
-	tdb_key.dptr = blksize_key;
-	tdb_key.dsize = sizeof(blksize_key);
-	tdb_data.dptr = (unsigned char *)&(block_size);
-	tdb_data.dsize = sizeof(block_size);
-
-	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
-	if (retval == -1) {
-		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-	}
-
-	return retval;
-}
-
 static errcode_t undo_setup_tdb(struct undo_private_data *data)
 {
+	int i;
 	errcode_t retval;
 
 	if (data->tdb_written == 1)
@@ -187,15 +256,33 @@ static errcode_t undo_setup_tdb(struct undo_private_data *data)
 	if (retval)
 		return retval;
 
-	/* Write the blocksize to tdb file */
-	tdb_transaction_start(data->tdb);
-	retval = write_block_size(data->tdb,
-				  data->tdb_data_size);
-	if (retval) {
-		tdb_transaction_cancel(data->tdb);
-		return EXT2_ET_TDB_ERR_IO;
+	/* Allocate key block */
+	retval = ext2fs_get_mem(data->tdb_data_size, &data->keyb);
+	if (retval)
+		return retval;
+	data->key_blk_num = data->undo_blk_num;
+
+	/* Record block size */
+	dbg_printf("Undo block size %llu\n", data->tdb_data_size);
+	dbg_printf("Keys per block %llu\n", KEYS_PER_BLOCK(data));
+	data->hdr.block_size = ext2fs_cpu_to_le32(data->tdb_data_size);
+	io_channel_set_blksize(data->undo_file, data->tdb_data_size);
+
+	/* Ensure that we have space for header blocks */
+	for (i = 0; i <= 2; i++) {
+		retval = io_channel_read_blk64(data->undo_file, i, 1,
+					       data->keyb);
+		if (retval)
+			memset(data->keyb, 0, data->tdb_data_size);
+		retval = io_channel_write_blk64(data->undo_file, i, 1,
+						data->keyb);
+		if (retval)
+			return retval;
+		retval = io_channel_flush(data->undo_file);
+		if (retval)
+			return retval;
 	}
-	tdb_transaction_commit(data->tdb);
+	memset(data->keyb, 0, data->tdb_data_size);
 	return 0;
 }
 
@@ -208,13 +295,16 @@ static errcode_t undo_write_tdb(io_channel channel,
 	errcode_t retval = 0;
 	ext2_loff_t offset;
 	struct undo_private_data *data;
-	TDB_DATA tdb_key, tdb_data;
 	unsigned char *read_ptr;
 	unsigned long long end_block;
+	unsigned long long data_size;
+	void *data_ptr;
+	struct undo_key *key;
+	__u32 blk_crc;
 
 	data = (struct undo_private_data *) channel->private_data;
 
-	if (data->tdb == NULL) {
+	if (data->undo_file == NULL) {
 		/*
 		 * Transaction database not initialized
 		 */
@@ -241,13 +331,11 @@ static errcode_t undo_write_tdb(io_channel channel,
 	 */
 	offset = (block * channel->block_size) + data->offset ;
 	block_num = offset / data->tdb_data_size;
-	end_block = (offset + size) / data->tdb_data_size;
+	end_block = (offset + size - 1) / data->tdb_data_size;
 
-	tdb_transaction_start(data->tdb);
-	while (block_num <= end_block ) {
+	while (block_num <= end_block) {
+		__u32 keysz;
 
-		tdb_key.dptr = (unsigned char *)&block_num;
-		tdb_key.dsize = sizeof(block_num);
 		/*
 		 * Check if we have the record already
 		 */
@@ -259,6 +347,22 @@ static errcode_t undo_write_tdb(io_channel channel,
 		}
 		ext2fs_mark_block_bitmap2(data->written_block_map, block_num);
 
+		/* Spit out a key block */
+		if (data->keys_in_block == KEYS_PER_BLOCK(data)) {
+			retval = write_undo_indexes(data);
+			if (retval)
+				return retval;
+			retval = io_channel_write_blk64(data->undo_file,
+							data->key_blk_num, 1,
+							data->keyb);
+			if (retval)
+				return retval;
+		}
+
+		/* Allocate new key block */
+		if (data->keys_in_block == 0)
+			data->undo_blk_num++;
+
 		/*
 		 * Read one block using the backing I/O manager
 		 * The backing I/O manager block size may be
@@ -273,7 +377,6 @@ static errcode_t undo_write_tdb(io_channel channel,
 				((offset - data->offset) % channel->block_size);
 		retval = ext2fs_get_mem(count, &read_ptr);
 		if (retval) {
-			tdb_transaction_cancel(data->tdb);
 			return retval;
 		}
 
@@ -288,41 +391,75 @@ static errcode_t undo_write_tdb(io_channel channel,
 		if (retval) {
 			if (retval != EXT2_ET_SHORT_READ) {
 				free(read_ptr);
-				tdb_transaction_cancel(data->tdb);
 				return retval;
 			}
 			/*
 			 * short read so update the record size
 			 * accordingly
 			 */
-			tdb_data.dsize = actual_size;
+			data_size = actual_size;
 		} else {
-			tdb_data.dsize = data->tdb_data_size;
+			data_size = data->tdb_data_size;
 		}
-		tdb_data.dptr = read_ptr +
-				((offset - data->offset) % channel->block_size);
-#ifdef DEBUG
-		printf("Printing with key %lld data %x and size %d\n",
+		if (data_size == 0) {
+			free(read_ptr);
+			block_num++;
+			continue;
+		}
+		dbg_printf("Read %llu bytes from FS block %llu (blk=%llu cnt=%u)\n",
+		       data_size, backing_blk_num, block, count);
+		if ((data_size % data->undo_file->block_size) == 0)
+			sz = data_size / data->undo_file->block_size;
+		else
+			sz = -actual_size;
+		data_ptr = read_ptr + ((offset - data->offset) %
+				       data->undo_file->block_size);
+		/* extend this key? */
+		if (data->keys_in_block) {
+			key = data->keyb->keys + data->keys_in_block - 1;
+			keysz = ext2fs_le32_to_cpu(key->size);
+		} else {
+			key = NULL;
+			keysz = 0;
+		}
+		if (key != NULL &&
+		    ext2fs_le64_to_cpu(key->fsblk) +
+		    ((keysz + data->tdb_data_size - 1) /
+		     data->tdb_data_size) == backing_blk_num &&
+		    E2UNDO_MAX_EXTENT_BLOCKS * data->tdb_data_size >
+		    keysz + sz) {
+			blk_crc = ext2fs_le32_to_cpu(key->blk_crc);
+			blk_crc = ext2fs_crc32c_le(blk_crc,
+						   (unsigned char *)data_ptr,
+						   data_size);
+			key->blk_crc = ext2fs_cpu_to_le32(blk_crc);
+			key->size = ext2fs_cpu_to_le32(keysz + data_size);
+		} else {
+			data->num_keys++;
+			key = data->keyb->keys + data->keys_in_block;
+			data->keys_in_block++;
+			key->fsblk = ext2fs_cpu_to_le64(backing_blk_num);
+			blk_crc = ext2fs_crc32c_le(~0,
+						   (unsigned char *)data_ptr,
+						   data_size);
+			key->blk_crc = ext2fs_cpu_to_le32(blk_crc);
+			key->size = ext2fs_cpu_to_le32(data_size);
+		}
+		dbg_printf("Writing block %llu to offset %llu size %d key %zu\n",
 		       block_num,
-		       tdb_data.dptr,
-		       tdb_data.dsize);
-#endif
-		retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_REPLACE);
-		if (retval == -1) {
-			/*
-			 * TDB_ERR_EXISTS cannot happen because we
-			 * have already verified it doesn't exist
-			 */
-			tdb_transaction_cancel(data->tdb);
-			retval = EXT2_ET_TDB_ERR_IO;
+		       data->undo_blk_num,
+		       sz, data->num_keys - 1);
+		retval = io_channel_write_blk64(data->undo_file,
+					data->undo_blk_num, sz, data_ptr);
+		if (retval) {
 			free(read_ptr);
 			return retval;
 		}
+		data->undo_blk_num++;
 		free(read_ptr);
 		/* Next block */
 		block_num++;
 	}
-	tdb_transaction_commit(data->tdb);
 
 	return retval;
 }
@@ -344,10 +481,192 @@ static void undo_err_handler_init(io_channel channel)
 	channel->read_error = undo_io_read_error;
 }
 
+static int check_filesystem(struct undo_header *hdr, io_channel undo_file,
+			    unsigned int blocksize, blk64_t super_block,
+			    io_channel channel)
+{
+	struct ext2_super_block super, *sb;
+	char *buf;
+	__u32 sb_crc;
+	errcode_t retval;
+
+	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
+	retval = io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, &super);
+	if (retval)
+		return retval;
+
+	/*
+	 * Compare the FS and the undo file superblock so that we don't
+	 * append to something that doesn't match this FS.
+	 */
+	retval = ext2fs_get_mem(blocksize, &buf);
+	if (retval)
+		return retval;
+	retval = io_channel_read_blk64(undo_file, super_block,
+				       -SUPERBLOCK_SIZE, buf);
+	if (retval)
+		goto out;
+	sb = (struct ext2_super_block *)buf;
+	sb->s_magic = ~sb->s_magic;
+	if (memcmp(&super, buf, sizeof(super))) {
+		retval = -1;
+		goto out;
+	}
+	sb_crc = ext2fs_crc32c_le(~0, (unsigned char *)buf, SUPERBLOCK_SIZE);
+	if (ext2fs_le32_to_cpu(hdr->sb_crc) != sb_crc) {
+		retval = -1;
+		goto out;
+	}
+
+out:
+	ext2fs_free_mem(&buf);
+	return retval;
+}
+
+/*
+ * Try to re-open the undo file, so that we can resume where we left off.
+ * That way, the user can pass the same undo file to various programs as
+ * part of an FS upgrade instead of having to create multiple files and
+ * then apply them in correct order.
+ */
+static errcode_t try_reopen_undo_file(int undo_fd,
+				      struct undo_private_data *data)
+{
+	struct undo_header hdr;
+	struct undo_key *dkey;
+	ext2fs_struct_stat statbuf;
+	unsigned int blocksize, fs_blocksize;
+	blk64_t super_block, lblk;
+	size_t num_keys, keys_per_block, i;
+	__u32 hdr_crc, key_crc;
+	errcode_t retval;
+
+	/* Zero size already? */
+	retval = ext2fs_fstat(undo_fd, &statbuf);
+	if (retval)
+		goto bad_file;
+	if (statbuf.st_size == 0)
+		goto out;
+
+	/* check the file header */
+	retval = io_channel_read_blk64(data->undo_file, 0, -(int)sizeof(hdr),
+				       &hdr);
+	if (retval)
+		goto bad_file;
+
+	if (memcmp(hdr.magic, E2UNDO_MAGIC,
+		    sizeof(hdr.magic)))
+		goto bad_file;
+	hdr_crc = ext2fs_crc32c_le(~0, (unsigned char *)&hdr,
+				   sizeof(struct undo_header) -
+				   sizeof(__u32));
+	if (ext2fs_le32_to_cpu(hdr.header_crc) != hdr_crc)
+		goto bad_file;
+	blocksize = ext2fs_le32_to_cpu(hdr.block_size);
+	fs_blocksize = ext2fs_le32_to_cpu(hdr.fs_block_size);
+	if (blocksize > E2UNDO_MAX_BLOCK_SIZE ||
+	    blocksize < E2UNDO_MIN_BLOCK_SIZE ||
+	    !blocksize || !fs_blocksize)
+		goto bad_file;
+	super_block = ext2fs_le64_to_cpu(hdr.super_offset);
+	num_keys = ext2fs_le64_to_cpu(hdr.num_keys);
+	io_channel_set_blksize(data->undo_file, blocksize);
+	if (hdr.f_compat || hdr.f_incompat || hdr.f_rocompat)
+		goto bad_file;
+
+	/* Superblock matches this FS? */
+	if (check_filesystem(&hdr, data->undo_file, blocksize, super_block,
+			     data->real) != 0) {
+		retval = EXT2_ET_UNDO_FILE_WRONG;
+		goto out;
+	}
+
+	/* Try to set ourselves up */
+	data->tdb_data_size = blocksize;
+	retval = undo_setup_tdb(data);
+	if (retval)
+		goto bad_file;
+	data->num_keys = num_keys;
+	data->super_blk_num = super_block;
+	data->first_key_blk = ext2fs_le64_to_cpu(hdr.key_offset);
+
+	/* load the written block map */
+	keys_per_block = KEYS_PER_BLOCK(data);
+	lblk = data->first_key_blk;
+	dbg_printf("nr_keys=%lu, kpb=%zu, blksz=%u\n",
+		   num_keys, keys_per_block, blocksize);
+	for (i = 0; i < num_keys; i += keys_per_block) {
+		size_t j, max_j;
+		__le32 crc;
+
+		data->key_blk_num = lblk;
+		retval = io_channel_read_blk64(data->undo_file,
+					       lblk, 1, data->keyb);
+		if (retval)
+			goto bad_key_replay;
+
+		/* check keys */
+		if (ext2fs_le32_to_cpu(data->keyb->magic) != KEYBLOCK_MAGIC) {
+			retval = EXT2_ET_UNDO_FILE_CORRUPT;
+			goto bad_key_replay;
+		}
+		crc = data->keyb->crc;
+		data->keyb->crc = 0;
+		key_crc = ext2fs_crc32c_le(~0, (unsigned char *)data->keyb,
+					   blocksize);
+		if (ext2fs_le32_to_cpu(crc) != key_crc) {
+			retval = EXT2_ET_UNDO_FILE_CORRUPT;
+			goto bad_key_replay;
+		}
+
+		/* load keys from key block */
+		lblk++;
+		max_j = data->num_keys - i;
+		if (max_j > keys_per_block)
+			max_j = keys_per_block;
+		for (j = 0, dkey = data->keyb->keys;
+		     j < max_j;
+		     j++, dkey++) {
+			blk64_t fsblk = ext2fs_le64_to_cpu(dkey->fsblk);
+			blk64_t undo_blk = fsblk * fs_blocksize / blocksize;
+			size_t size = ext2fs_le32_to_cpu(dkey->size);
+
+			ext2fs_mark_block_bitmap_range2(data->written_block_map,
+					 undo_blk,
+					(size + blocksize - 1) / blocksize);
+			lblk += (size + blocksize - 1) / blocksize;
+			data->undo_blk_num = lblk;
+			data->keys_in_block = j + 1;
+		}
+	}
+	dbg_printf("Reopen undo, keyblk=%llu undoblk=%llu nrkeys=%zu kib=%zu\n",
+		   data->key_blk_num, data->undo_blk_num, data->num_keys,
+		   data->keys_in_block);
+
+	data->hdr.state = hdr.state & ~E2UNDO_STATE_FINISHED;
+	data->hdr.f_compat = hdr.f_compat;
+	data->hdr.f_incompat = hdr.f_incompat;
+	data->hdr.f_rocompat = hdr.f_rocompat;
+	return retval;
+
+bad_key_replay:
+	data->key_blk_num = data->undo_blk_num = 0;
+	data->keys_in_block = 0;
+	ext2fs_free_mem(&data->keyb);
+	ext2fs_free_generic_bitmap(data->written_block_map);
+	data->tdb_written = 0;
+	goto out;
+bad_file:
+	retval = EXT2_ET_UNDO_FILE_CORRUPT;
+out:
+	return retval;
+}
+
 static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 {
 	io_channel	io = NULL;
 	struct undo_private_data *data = NULL;
+	int		undo_fd = -1;
 	errcode_t	retval;
 
 	if (name == 0)
@@ -375,29 +694,32 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 
 	memset(data, 0, sizeof(struct undo_private_data));
 	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
-	data->written_block_map = NULL;
+	data->super_blk_num = 1;
+	data->undo_blk_num = data->first_key_blk = 2;
 
 	if (undo_io_backing_manager) {
 		retval = undo_io_backing_manager->open(name, flags,
 						       &data->real);
 		if (retval)
 			goto cleanup;
+
+		undo_fd = ext2fs_open_file(tdb_file, O_RDWR | O_CREAT, 0600);
+		if (undo_fd < 0)
+			goto cleanup;
+
+		retval = undo_io_backing_manager->open(tdb_file, IO_FLAG_RW,
+						       &data->undo_file);
+		if (retval)
+			goto cleanup;
 	} else {
-		data->real = 0;
+		data->real = NULL;
+		data->undo_file = NULL;
 	}
 
 	if (data->real)
 		io->flags = (io->flags & ~CHANNEL_FLAGS_DISCARD_ZEROES) |
 			    (data->real->flags & CHANNEL_FLAGS_DISCARD_ZEROES);
 
-	/* setup the tdb file */
-	data->tdb = tdb_open(tdb_file, 0, TDB_CLEAR_IF_FIRST | TDB_NOLOCK | TDB_NOSYNC,
-			     O_RDWR | O_CREAT | O_TRUNC | O_EXCL, 0600);
-	if (!data->tdb) {
-		retval = errno;
-		goto cleanup;
-	}
-
 	/*
 	 * setup err handler for read so that we know
 	 * when the backing manager fails do short read
@@ -405,10 +727,22 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 	if (data->real)
 		undo_err_handler_init(data->real);
 
+	if (data->undo_file) {
+		retval = try_reopen_undo_file(undo_fd, data);
+		if (retval)
+			goto cleanup;
+	}
+
 	*channel = io;
-	return 0;
+	if (undo_fd >= 0)
+		close(undo_fd);
+	return retval;
 
 cleanup:
+	if (undo_fd >= 0)
+		close(undo_fd);
+	if (data && data->undo_file)
+		io_channel_close(data->undo_file);
 	if (data && data->real)
 		io_channel_close(data->real);
 	if (data)
@@ -430,13 +764,14 @@ static errcode_t undo_close(io_channel channel)
 	if (--channel->refcount > 0)
 		return 0;
 	/* Before closing write the file system identity */
-	err = write_file_system_identity(channel, data->tdb);
+	if (!getenv("UNDO_IO_SIMULATE_UNFINISHED"))
+		data->hdr.state = ext2fs_cpu_to_le32(E2UNDO_STATE_FINISHED);
+	err = write_undo_indexes(data);
 	if (data->real)
 		retval = io_channel_close(data->real);
-	if (data->tdb) {
-		tdb_flush(data->tdb);
-		tdb_close(data->tdb);
-	}
+	if (data->undo_file)
+		io_channel_close(data->undo_file);
+	ext2fs_free_mem(&data->keyb);
 	if (data->written_block_map)
 		ext2fs_free_generic_bitmap(data->written_block_map);
 	ext2fs_free_mem(&channel->private_data);
@@ -458,6 +793,9 @@ static errcode_t undo_set_blksize(io_channel channel, int blksize)
 	data = (struct undo_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
+	if (blksize > E2UNDO_MAX_BLOCK_SIZE || blksize < E2UNDO_MIN_BLOCK_SIZE)
+		return EXT2_ET_INVALID_ARGUMENT;
+
 	if (data->real)
 		retval = io_channel_set_blksize(data->real, blksize);
 	/*
@@ -632,8 +970,6 @@ static errcode_t undo_flush(io_channel channel)
 	data = (struct undo_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
-	if (data->tdb)
-		tdb_flush(data->tdb);
 	if (data->real)
 		retval = io_channel_flush(data->real);
 
@@ -659,6 +995,8 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
 		tmp = strtoul(arg, &end, 0);
 		if (*end)
 			return EXT2_ET_INVALID_ARGUMENT;
+		if (tmp > E2UNDO_MAX_BLOCK_SIZE || tmp < E2UNDO_MIN_BLOCK_SIZE)
+			return EXT2_ET_INVALID_ARGUMENT;
 		if (!data->tdb_data_size || !data->tdb_written) {
 			data->tdb_written = -1;
 			data->tdb_data_size = tmp;
diff --git a/misc/e2undo.8.in b/misc/e2undo.8.in
index 4bf0798..71e8a7b 100644
--- a/misc/e2undo.8.in
+++ b/misc/e2undo.8.in
@@ -10,6 +10,12 @@ e2undo \- Replay an undo log for an ext2/ext3/ext4 filesystem
 [
 .B \-f
 ]
+[
+.B \-n
+]
+[
+.B \-v
+]
 .I undo_log device
 .SH DESCRIPTION
 .B e2undo
@@ -24,13 +30,18 @@ used to undo a failed operation by an e2fsprogs program.
 .B \-f
 Normally,
 .B e2undo
-will check the filesystem UUID and last modified time to make sure the
-undo log matches with the filesystem on the device.  If they do not
-match,
+will check the filesystem superblock to make sure the undo log matches
+with the filesystem on the device.  If they do not match,
 .B e2undo
 will refuse to apply the undo log as a safety mechanism.  The
 .B \-f
 option disables this safety mechanism.
+.TP
+.B \-n
+Dry-run; do not actually write blocks back to the filesystem.
+.TP
+.B \-v
+Report which block we're currently replaying.
 .SH AUTHOR
 .B e2undo
 was written by Aneesh Kumar K.V. (aneesh.kumar@linux.vnet.ibm.com)
diff --git a/misc/e2undo.c b/misc/e2undo.c
index d828d3b..3f312c6 100644
--- a/misc/e2undo.c
+++ b/misc/e2undo.c
@@ -20,30 +20,132 @@
 #if HAVE_ERRNO_H
 #include <errno.h>
 #endif
-#include "ext2fs/tdb.h"
+#include <unistd.h>
 #include "ext2fs/ext2fs.h"
 #include "nls-enable.h"
 
-static unsigned char mtime_key[] = "filesystem MTIME";
-static unsigned char uuid_key[] = "filesystem UUID";
-static unsigned char blksize_key[] = "filesystem BLKSIZE";
+#undef DEBUG
+
+#ifdef DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
+/*
+ * Undo file format: The file is cut up into undo_header.block_size blocks.
+ * The first block contains the header.
+ * The second block contains the superblock.
+ * There is then a repeating series of blocks as follows:
+ *   A key block, which contains undo_keys to map the following data blocks.
+ *   Data blocks
+ * (Note that there are pointers to the first key block and the sb, so this
+ * order isn't strictly necessary.)
+ */
+#define E2UNDO_MAGIC "E2UNDO02"
+#define KEYBLOCK_MAGIC 0xCADECADE
+
+#define E2UNDO_STATE_FINISHED	0x1	/* undo file is complete */
+
+#define E2UNDO_MIN_BLOCK_SIZE	1024	/* undo blocks are no less than 1KB */
+#define E2UNDO_MAX_BLOCK_SIZE	1048576	/* undo blocks are no more than 1MB */
+
+struct undo_header {
+	char magic[8];		/* "E2UNDO02" */
+	__le64 num_keys;	/* how many keys? */
+	__le64 super_offset;	/* where in the file is the superblock copy? */
+	__le64 key_offset;	/* where do the key/data block chunks start? */
+	__le32 block_size;	/* block size of the undo file */
+	__le32 fs_block_size;	/* block size of the target device */
+	__le32 sb_crc;		/* crc32c of the superblock */
+	__le32 state;		/* e2undo state flags */
+	__le32 f_compat;	/* compatible features (none so far) */
+	__le32 f_incompat;	/* incompatible features (none so far) */
+	__le32 f_rocompat;	/* ro compatible features (none so far) */
+	__u8 padding[448];	/* padding */
+	__le32 header_crc;	/* crc32c of the header (but not this field) */
+};
+
+#define E2UNDO_MAX_EXTENT_BLOCKS	512	/* max extent size, in blocks */
+
+struct undo_key {
+	__le64 fsblk;		/* where in the fs does the block go */
+	__le32 blk_crc;		/* crc32c of the block */
+	__le32 size;		/* how many bytes in this block? */
+};
+
+struct undo_key_block {
+	__le32 magic;		/* KEYBLOCK_MAGIC number */
+	__le32 crc;		/* block checksum */
+	__le64 reserved;	/* zero */
+
+	struct undo_key keys[0];	/* keys, which come immediately after */
+};
+
+struct undo_key_info {
+	blk64_t fsblk;
+	blk64_t fileblk;
+	__u32 blk_crc;
+	unsigned int size;
+};
+
+struct undo_context {
+	struct undo_header hdr;
+	io_channel undo_file;
+	unsigned int blocksize, fs_blocksize;
+	blk64_t super_block;
+	size_t num_keys;
+	struct undo_key_info *keys;
+};
+#define KEYS_PER_BLOCK(d) (((d)->blocksize / sizeof(struct undo_key)) - 1)
 
 static char *prg_name;
+static char *undo_file;
 
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s <transaction file> <filesystem>\n"), prg_name);
+		_("Usage: %s [-f] [-h] [-n] [-v] <transaction file> <filesystem>\n"), prg_name);
 	exit(1);
 }
 
-static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
+static void dump_header(struct undo_header *hdr)
+{
+	printf("nr keys:\t%llu\n", ext2fs_le64_to_cpu(hdr->num_keys));
+	printf("super block:\t%llu\n", ext2fs_le64_to_cpu(hdr->super_offset));
+	printf("key block:\t%llu\n", ext2fs_le64_to_cpu(hdr->key_offset));
+	printf("block size:\t%u\n", ext2fs_le32_to_cpu(hdr->block_size));
+	printf("fs block size:\t%u\n", ext2fs_le32_to_cpu(hdr->fs_block_size));
+	printf("super crc:\t0x%x\n", ext2fs_le32_to_cpu(hdr->sb_crc));
+	printf("state:\t\t0x%x\n", ext2fs_le32_to_cpu(hdr->state));
+	printf("compat:\t\t0x%x\n", ext2fs_le32_to_cpu(hdr->f_compat));
+	printf("incompat:\t0x%x\n", ext2fs_le32_to_cpu(hdr->f_incompat));
+	printf("rocompat:\t0x%x\n", ext2fs_le32_to_cpu(hdr->f_rocompat));
+	printf("header crc:\t0x%x\n", ext2fs_le32_to_cpu(hdr->header_crc));
+}
+
+static void print_undo_mismatch(struct ext2_super_block *fs_super,
+				struct ext2_super_block *undo_super)
+{
+	printf("%s",
+	       _("The file system superblock doesn't match the undo file.\n"));
+	if (memcmp(fs_super->s_uuid, undo_super->s_uuid,
+		   sizeof(fs_super->s_uuid)))
+		printf("%s", _("UUID does not match.\n"));
+	if (fs_super->s_mtime != undo_super->s_mtime)
+		printf("%s", _("Last mount time does not match.\n"));
+	if (fs_super->s_wtime != undo_super->s_wtime)
+		printf("%s", _("Last write time does not match.\n"));
+	if (fs_super->s_kbytes_written != undo_super->s_kbytes_written)
+		printf("%s", _("Lifetime write counter does not match.\n"));
+}
+
+static int check_filesystem(struct undo_context *ctx, io_channel channel)
 {
-	__u32   s_mtime;
-	__u8    s_uuid[16];
+	struct ext2_super_block super, *sb;
+	char *buf;
+	__u32 sb_crc;
 	errcode_t retval;
-	TDB_DATA tdb_key, tdb_data;
-	struct ext2_super_block super;
 
 	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
 	retval = io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, &super);
@@ -53,83 +155,127 @@ static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
 		return retval;
 	}
 
-	tdb_key.dptr = mtime_key;
-	tdb_key.dsize = sizeof(mtime_key);
-	tdb_data = tdb_fetch(tdb, tdb_key);
-	if (!tdb_data.dptr) {
-		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-		com_err(prg_name, retval, "%s",
-			_("while fetching last mount time."));
+	/*
+	 * Compare the FS and the undo file superblock so that we can't apply
+	 * e2undo "patches" out of order.
+	 */
+	retval = ext2fs_get_mem(ctx->blocksize, &buf);
+	if (retval) {
+		com_err(prg_name, retval, "%s", _("while allocating memory"));
 		return retval;
 	}
+	retval = io_channel_read_blk64(ctx->undo_file, ctx->super_block,
+				       -SUPERBLOCK_SIZE, buf);
+	if (retval) {
+		com_err(prg_name, retval, "%s", _("while fetching superblock"));
+		goto out;
+	}
+	sb = (struct ext2_super_block *)buf;
+	sb->s_magic = ~sb->s_magic;
+	if (memcmp(&super, buf, sizeof(super))) {
+		print_undo_mismatch(&super, (struct ext2_super_block *)buf);
+		retval = -1;
+		goto out;
+	}
+	sb_crc = ext2fs_crc32c_le(~0, (unsigned char *)buf, SUPERBLOCK_SIZE);
+	if (ext2fs_le32_to_cpu(ctx->hdr.sb_crc) != sb_crc) {
+		fprintf(stderr,
+			_("Undo file superblock checksum doesn't match.\n"));
+		retval = -1;
+		goto out;
+	}
 
-	s_mtime = *(__u32 *)tdb_data.dptr;
-	free(tdb_data.dptr);
-	if (super.s_mtime != s_mtime) {
-		com_err(prg_name, 0,
-			_("The filesystem last mount time didn't match %u."),
-			s_mtime);
+out:
+	ext2fs_free_mem(&buf);
+	return retval;
+}
 
-		return  -1;
-	}
+static int key_compare(const void *a, const void *b)
+{
+	const struct undo_key_info *ka, *kb;
 
+	ka = a;
+	kb = b;
+	return ext2fs_le64_to_cpu(ka->fsblk) -
+	       ext2fs_le64_to_cpu(kb->fsblk);
+}
+
+static int e2undo_setup_tdb(const char *name, io_manager *io_ptr)
+{
+	errcode_t retval = 0;
+	const char *tdb_dir;
+	char *tdb_file;
+	char *dev_name, *tmp_name;
 
-	tdb_key.dptr = uuid_key;
-	tdb_key.dsize = sizeof(uuid_key);
-	tdb_data = tdb_fetch(tdb, tdb_key);
-	if (!tdb_data.dptr) {
-		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-		com_err(prg_name, retval, "%s", _("while fetching UUID"));
+	/* (re)open a specific undo file */
+	if (undo_file && undo_file[0] != 0) {
+		set_undo_io_backing_manager(*io_ptr);
+		*io_ptr = undo_io_manager;
+		set_undo_io_backup_file(undo_file);
+		printf(_("To undo the e2undo operation please run "
+			 "the command\n    e2undo %s %s\n\n"),
+			 undo_file, name);
 		return retval;
 	}
-	memcpy(s_uuid, tdb_data.dptr, sizeof(s_uuid));
-	free(tdb_data.dptr);
-	if (memcmp(s_uuid, super.s_uuid, sizeof(s_uuid))) {
-		com_err(prg_name, 0, "%s",
-			_("The filesystem UUID didn't match."));
-		return -1;
+
+	tmp_name = strdup(name);
+	if (!tmp_name) {
+	alloc_fn_fail:
+		com_err(prg_name, ENOMEM, "%s",
+			_("Couldn't allocate memory for tdb filename\n"));
+		return ENOMEM;
 	}
+	dev_name = basename(tmp_name);
 
-	return 0;
-}
+	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
+	if (!tdb_dir)
+		tdb_dir = "/var/lib/e2fsprogs";
 
-static int set_blk_size(TDB_CONTEXT *tdb, io_channel channel)
-{
-	int block_size;
-	errcode_t retval;
-	TDB_DATA tdb_key, tdb_data;
-
-	tdb_key.dptr = blksize_key;
-	tdb_key.dsize = sizeof(blksize_key);
-	tdb_data = tdb_fetch(tdb, tdb_key);
-	if (!tdb_data.dptr) {
-		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-		com_err(prg_name, retval, "%s", _("while fetching block size"));
+	if (!strcmp(tdb_dir, "none") || (tdb_dir[0] == 0) ||
+	    access(tdb_dir, W_OK))
+		return 0;
+
+	tdb_file = malloc(strlen(tdb_dir) + 9 + strlen(dev_name) + 7 + 1);
+	if (!tdb_file)
+		goto alloc_fn_fail;
+	sprintf(tdb_file, "%s/e2undo-%s.e2undo", tdb_dir, dev_name);
+
+	if ((unlink(tdb_file) < 0) && (errno != ENOENT)) {
+		retval = errno;
+		com_err(prg_name, retval,
+			_("while trying to delete %s"), tdb_file);
+		free(tdb_file);
 		return retval;
 	}
 
-	block_size = *(int *)tdb_data.dptr;
-	free(tdb_data.dptr);
-#ifdef DEBUG
-	printf("Block size %d\n", block_size);
-#endif
-	io_channel_set_blksize(channel, block_size);
-
-	return 0;
+	set_undo_io_backing_manager(*io_ptr);
+	*io_ptr = undo_io_manager;
+	set_undo_io_backup_file(tdb_file);
+	printf(_("To undo the e2undo operation please run "
+		 "the command\n    e2undo %s %s\n\n"),
+		 tdb_file, name);
+	free(tdb_file);
+	free(tmp_name);
+	return retval;
 }
 
 int main(int argc, char *argv[])
 {
-	int c,force = 0;
-	TDB_CONTEXT *tdb;
-	TDB_DATA key, data;
+	int c, force = 0, dry_run = 0, verbose = 0, dump = 0;
 	io_channel channel;
 	errcode_t retval;
-	int  mount_flags;
-	blk64_t  blk_num;
+	int mount_flags, csum_error = 0, io_error = 0;
+	size_t i, keys_per_block;
 	char *device_name, *tdb_file;
 	io_manager manager = unix_io_manager;
-	void *old_dptr = NULL;
+	struct undo_context undo_ctx;
+	char *buf;
+	struct undo_key_block *keyb;
+	struct undo_key *dkey;
+	struct undo_key_info *ikey;
+	__u32 key_crc, blk_crc, hdr_crc;
+	blk64_t lblk;
+	ext2_filsys fs;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -141,13 +287,25 @@ int main(int argc, char *argv[])
 	add_error_table(&et_ext2_error_table);
 
 	prg_name = argv[0];
-	while((c = getopt(argc, argv, "f")) != EOF) {
+	while ((c = getopt(argc, argv, "fhnvz:")) != EOF) {
 		switch (c) {
-			case 'f':
-				force = 1;
-				break;
-			default:
-				usage();
+		case 'f':
+			force = 1;
+			break;
+		case 'h':
+			dump = 1;
+			break;
+		case 'n':
+			dry_run = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'z':
+			undo_file = optarg;
+			break;
+		default:
+			usage();
 		}
 	}
 
@@ -157,14 +315,70 @@ int main(int argc, char *argv[])
 	tdb_file = argv[optind];
 	device_name = argv[optind+1];
 
-	tdb = tdb_open(tdb_file, 0, 0, O_RDONLY, 0600);
+	if (undo_file && strcmp(tdb_file, undo_file) == 0) {
+		printf(_("Will not write to an undo file while replaying it.\n"));
+		exit(1);
+	}
 
-	if (!tdb) {
+	/* Interpret the undo file */
+	retval = manager->open(tdb_file, IO_FLAG_EXCLUSIVE,
+			       &undo_ctx.undo_file);
+	if (retval) {
 		com_err(prg_name, errno,
 				_("while opening undo file `%s'\n"), tdb_file);
 		exit(1);
 	}
+	retval = io_channel_read_blk64(undo_ctx.undo_file, 0,
+				       -(int)sizeof(undo_ctx.hdr),
+				       &undo_ctx.hdr);
+	if (retval) {
+		com_err(prg_name, retval, _("while reading undo file"));
+		exit(1);
+	}
+	if (memcmp(undo_ctx.hdr.magic, E2UNDO_MAGIC,
+		    sizeof(undo_ctx.hdr.magic))) {
+		fprintf(stderr, _("%s: Not an undo file.\n"), tdb_file);
+		exit(1);
+	}
+	if (dump) {
+		dump_header(&undo_ctx.hdr);
+		exit(1);
+	}
+	hdr_crc = ext2fs_crc32c_le(~0, (unsigned char *)&undo_ctx.hdr,
+				   sizeof(struct undo_header) -
+				   sizeof(__u32));
+	if (!force && ext2fs_le32_to_cpu(undo_ctx.hdr.header_crc) != hdr_crc) {
+		fprintf(stderr, _("%s: Header checksum doesn't match.\n"),
+			tdb_file);
+		exit(1);
+	}
+	undo_ctx.blocksize = ext2fs_le32_to_cpu(undo_ctx.hdr.block_size);
+	undo_ctx.fs_blocksize = ext2fs_le32_to_cpu(undo_ctx.hdr.fs_block_size);
+	if (undo_ctx.blocksize == 0 || undo_ctx.fs_blocksize == 0) {
+		fprintf(stderr, _("%s: Corrupt undo file header.\n"), tdb_file);
+		exit(1);
+	}
+	if (!force && undo_ctx.blocksize > E2UNDO_MAX_BLOCK_SIZE) {
+		fprintf(stderr, _("%s: Undo block size too large.\n"),
+			tdb_file);
+		exit(1);
+	}
+	if (!force && undo_ctx.blocksize < E2UNDO_MIN_BLOCK_SIZE) {
+		fprintf(stderr, _("%s: Undo block size too small.\n"),
+			tdb_file);
+		exit(1);
+	}
+	undo_ctx.super_block = ext2fs_le64_to_cpu(undo_ctx.hdr.super_offset);
+	undo_ctx.num_keys = ext2fs_le64_to_cpu(undo_ctx.hdr.num_keys);
+	io_channel_set_blksize(undo_ctx.undo_file, undo_ctx.blocksize);
+	if (!force && (undo_ctx.hdr.f_compat || undo_ctx.hdr.f_incompat ||
+		       undo_ctx.hdr.f_rocompat)) {
+		fprintf(stderr, _("%s: Unknown undo file feature set.\n"),
+			tdb_file);
+		exit(1);
+	}
 
+	/* open the fs */
 	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
 	if (retval) {
 		com_err(prg_name, retval, _("Error while determining whether "
@@ -178,53 +392,197 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
+	if (undo_file) {
+		retval = e2undo_setup_tdb(device_name, &manager);
+		if (retval)
+			exit(1);
+	}
+
 	retval = manager->open(device_name,
-				IO_FLAG_EXCLUSIVE | IO_FLAG_RW,  &channel);
+			       IO_FLAG_EXCLUSIVE | (dry_run ? 0 : IO_FLAG_RW),
+			       &channel);
 	if (retval) {
 		com_err(prg_name, retval,
 				_("while opening `%s'"), device_name);
 		exit(1);
 	}
 
-	if (!force && check_filesystem(tdb, channel)) {
+	if (!force && check_filesystem(&undo_ctx, channel))
 		exit(1);
-	}
 
-	if (set_blk_size(tdb, channel)) {
+	/* prepare to read keys */
+	retval = ext2fs_get_mem(sizeof(struct undo_key_info) * undo_ctx.num_keys,
+				&undo_ctx.keys);
+	if (retval) {
+		com_err(prg_name, retval, "%s", _("while allocating memory"));
+		exit(1);
+	}
+	ikey = undo_ctx.keys;
+	retval = ext2fs_get_mem(undo_ctx.blocksize, &keyb);
+	if (retval) {
+		com_err(prg_name, retval, "%s", _("while allocating memory"));
+		exit(1);
+	}
+	retval = ext2fs_get_mem(E2UNDO_MAX_EXTENT_BLOCKS * undo_ctx.blocksize,
+				&buf);
+	if (retval) {
+		com_err(prg_name, retval, "%s", _("while allocating memory"));
 		exit(1);
 	}
 
-	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
-		free(old_dptr);
-		old_dptr = key.dptr;
-		if (!strcmp((char *) key.dptr, (char *) mtime_key) ||
-		    !strcmp((char *) key.dptr, (char *) uuid_key) ||
-		    !strcmp((char *) key.dptr, (char *) blksize_key)) {
-			continue;
+	/* load keys */
+	keys_per_block = KEYS_PER_BLOCK(&undo_ctx);
+	lblk = ext2fs_le64_to_cpu(undo_ctx.hdr.key_offset);
+	dbg_printf("nr_keys=%lu, kpb=%zu, blksz=%u\n",
+		   undo_ctx.num_keys, keys_per_block, undo_ctx.blocksize);
+	for (i = 0; i < undo_ctx.num_keys; i += keys_per_block) {
+		size_t j, max_j;
+		__le32 crc;
+
+		retval = io_channel_read_blk64(undo_ctx.undo_file,
+					       lblk, 1, keyb);
+		if (retval) {
+			com_err(prg_name, retval, "%s", _("while reading keys"));
+			if (force) {
+				io_error = 1;
+				undo_ctx.num_keys = i - 1;
+				break;
+			}
+			exit(1);
 		}
 
-		blk_num = *(blk64_t *)key.dptr;
-		data = tdb_fetch(tdb, key);
-		if (!data.dptr) {
-			retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
-			com_err(prg_name, retval,
-				_("while fetching block %llu."), blk_num);
+		/* check keys */
+		if (!force &&
+		    ext2fs_le32_to_cpu(keyb->magic) != KEYBLOCK_MAGIC) {
+			fprintf(stderr, _("%s: wrong key magic at %llu\n"),
+				tdb_file, lblk);
 			exit(1);
 		}
-		printf(_("Replayed transaction of size %zd at location %llu\n"),
-							data.dsize, blk_num);
-		retval = io_channel_write_blk64(channel, blk_num,
-						-data.dsize, data.dptr);
-		free(data.dptr);
-		if (retval == -1) {
-			com_err(prg_name, retval,
-				_("while writing block %llu."), blk_num);
+		crc = keyb->crc;
+		keyb->crc = 0;
+		key_crc = ext2fs_crc32c_le(~0, (unsigned char *)keyb,
+					   undo_ctx.blocksize);
+		if (!force && ext2fs_le32_to_cpu(crc) != key_crc) {
+			fprintf(stderr,
+				_("%s: key block checksum error at %llu.\n"),
+				tdb_file, lblk);
 			exit(1);
 		}
+
+		/* load keys from key block */
+		lblk++;
+		max_j = undo_ctx.num_keys - i;
+		if (max_j > keys_per_block)
+			max_j = keys_per_block;
+		for (j = 0, dkey = keyb->keys;
+		     j < max_j;
+		     j++, ikey++, dkey++) {
+			ikey->fsblk = ext2fs_le64_to_cpu(dkey->fsblk);
+			ikey->fileblk = lblk;
+			ikey->blk_crc = ext2fs_le32_to_cpu(dkey->blk_crc);
+			ikey->size = ext2fs_le32_to_cpu(dkey->size);
+			lblk += (ikey->size + undo_ctx.blocksize - 1) /
+				undo_ctx.blocksize;
+
+			if (E2UNDO_MAX_EXTENT_BLOCKS * undo_ctx.blocksize <
+			    ikey->size) {
+				com_err(prg_name, retval,
+					_("%s: block %llu is too long."),
+					tdb_file, ikey->fsblk);
+				exit(1);
+			}
+
+			/* check each block's crc */
+			retval = io_channel_read_blk64(undo_ctx.undo_file,
+						       ikey->fileblk,
+						       -(int)ikey->size,
+						       buf);
+			if (retval) {
+				com_err(prg_name, retval,
+					_("while fetching block %llu."),
+					ikey->fileblk);
+				if (!force)
+					exit(1);
+				io_error = 1;
+				continue;
+			}
+
+			blk_crc = ext2fs_crc32c_le(~0, (unsigned char *)buf,
+						   ikey->size);
+			if (blk_crc != ikey->blk_crc) {
+				fprintf(stderr,
+					_("checksum error in filesystem block "
+					  "%llu (undo blk %llu)\n"),
+					ikey->fsblk, ikey->fileblk);
+				if (!force)
+					exit(1);
+				csum_error = 1;
+			}
+		}
 	}
-	free(old_dptr);
+	ext2fs_free_mem(&keyb);
+
+	/* sort keys in fs block order */
+	qsort(undo_ctx.keys, undo_ctx.num_keys, sizeof(struct undo_key_info),
+	      key_compare);
+
+	/* replay */
+	io_channel_set_blksize(channel, undo_ctx.fs_blocksize);
+	for (i = 0, ikey = undo_ctx.keys; i < undo_ctx.num_keys; i++, ikey++) {
+		retval = io_channel_read_blk64(undo_ctx.undo_file,
+					       ikey->fileblk,
+					       -(int)ikey->size,
+					       buf);
+		if (retval) {
+			com_err(prg_name, retval,
+				_("while fetching block %llu."),
+				ikey->fileblk);
+			io_error = 1;
+			continue;
+		}
+
+		if (verbose)
+			printf("Replayed block of size %u from %llu to %llu\n",
+				ikey->size, ikey->fileblk, ikey->fsblk);
+		if (dry_run)
+			continue;
+		retval = io_channel_write_blk64(channel, ikey->fsblk,
+						-(int)ikey->size, buf);
+		if (retval) {
+			com_err(prg_name, retval,
+				_("while writing block %llu."), ikey->fsblk);
+			io_error = 1;
+		}
+	}
+
+	if (csum_error)
+		fprintf(stderr, _("Undo file corruption; run e2fsck NOW!\n"));
+	if (io_error)
+		fprintf(stderr, _("IO error during replay; run e2fsck NOW!\n"));
+	if (!(ext2fs_le32_to_cpu(undo_ctx.hdr.state) & E2UNDO_STATE_FINISHED)) {
+		force = 1;
+		fprintf(stderr, _("Incomplete undo record; run e2fsck.\n"));
+	}
+	ext2fs_free_mem(&buf);
+	ext2fs_free_mem(&undo_ctx.keys);
 	io_channel_close(channel);
-	tdb_close(tdb);
 
-	return 0;
+	/* If there were problems, try to force a fsck */
+	if (!dry_run && (force || csum_error || io_error)) {
+		retval = ext2fs_open2(device_name, NULL,
+				   EXT2_FLAG_RW | EXT2_FLAG_64BITS, 0, 0,
+				   manager, &fs);
+		if (retval)
+			goto out;
+		fs->super->s_state &= ~EXT2_VALID_FS;
+		if (csum_error || io_error)
+			fs->super->s_state |= EXT2_ERROR_FS;
+		ext2fs_mark_super_dirty(fs);
+		ext2fs_close_free(&fs);
+	}
+
+out:
+	io_channel_close(undo_ctx.undo_file);
+
+	return csum_error;
 }

