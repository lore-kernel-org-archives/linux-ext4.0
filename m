From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/31] e2undo: ditch tdb file, write everything to a flat
 file
Date: Wed, 7 Jan 2015 17:36:05 -0800
Message-ID: <20150108013605.GA9976@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
 <20141220211837.25563.96678.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46361 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAHBgM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2015 20:36:12 -0500
Content-Disposition: inline
In-Reply-To: <20141220211837.25563.96678.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All of the comments below will be fixed in the v2 patch.

On Sat, Dec 20, 2014 at 01:18:37PM -0800, Darrick J. Wong wrote:
> The existing undo file format (which is based on tdb) has many
> problems.  First, its comparison of superblock fields is ineffective,
> since the last mount time is only written by the kernel, not the tools
> (which means that undo files can be applied out of order, thus
> corrupting the filesystem); block numbers are written in CPU byte
> order, which will cause silent failures if an undo file is moved from
> one type of system to another; using the tdb database costs us an
> enormous amount of CPU overhead to maintain the key data structure,
> and finally, the tdb database is unable to deal with databases larger
> than 2GB.  (Upstream tdb 1.2.12 can handle 4GB, but upgrading a 2TB FS
> to 64bit,metadata_csum easily produces 4.5GB of undo files, so we
> might as well move off of tdb now.)
> 
> The last problem is fatal if you want to use tune2fs to turn on
> metadata checksumming, since that rewrites every block on the
> filesystem, which can easily produce a many-gigabyte undo file, which
> of course is unreadable and therefore the operation cannot be undone.
> 
> Therefore, rip all of that out in favor of writing to a flat file.
> Old blocks are appended to a file and the index is written to the end
> when we're done.  This implementation is much faster than wasting a
> considerable amount of time trying to maintain a hash index, which
> drops the runtime overhead of tune2fs -O metadata_csum from ~45min
> to ~20 seconds on a 2TB filesystem.
> 
> I have a few reasons that factored in my decision not to repurpose the
> jbd2 file format for undo files.  First, undo files are limited to
> 2^32 blocks (16TB) which some day might not serve us well.  Second,
> the journal block size is tied to the file system block size, but
> mke2fs wants to be able to back up big chunks of old device contents.
> This would require large changes to the e2fsck journal replay code,
> which itself is derived from the kernel jbd2 driver, which I'd rather
> not destabilize.  Third, I want to require undo files to store the FS
> superblock at the end of undo file creation so that e2undo can be
> reasonably sure that an undo file is supposed to apply against the
> given block device, and doing so would require changes to the jbd2
> format.  Fourth, it didn't seem like a good idea that external
> journals should resemble undo files so closely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/undo_io.c |  283 ++++++++++++++++++++++++--------------
>  misc/e2undo.8.in     |   11 +
>  misc/e2undo.c        |  371 +++++++++++++++++++++++++++++++++++++-------------
>  3 files changed, 461 insertions(+), 204 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
> index 9a01e30..a480246 100644
> --- a/lib/ext2fs/undo_io.c
> +++ b/lib/ext2fs/undo_io.c
> @@ -39,8 +39,6 @@
>  #endif
>  #include <limits.h>
>  
> -#include "tdb.h"
> -
>  #include "ext2_fs.h"
>  #include "ext2fs.h"
>  
> @@ -50,17 +48,67 @@
>  #define ATTR(x)
>  #endif
>  
> +#undef DEBUG
> +
> +#ifdef DEBUG
> +# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
> +#else
> +# define dbg_printf(f, a...)
> +#endif
> +
>  /*
>   * For checking structure magic numbers...
>   */
>  
>  #define EXT2_CHECK_MAGIC(struct, code) \
>  	  if ((struct)->magic != (code)) return (code)
> +/*
> + * Undo file format: The file is cut up into undo_header.block_size blocks.
> + * The first block contains the header.
> + * There is then a repeating series of blocks as follows:
> + *   A key block, which contains undo_keys to map the following data blocks.
> + *   Data blocks
> + * The last block contains the superblock.
> + * (Note that there are pointers to the first key block and the sb, so this
> + * order isn't strictly necessary.)
> + */
> +#define E2UNDO_MAGIC "E2UNDO02"
> +#define KEYBLOCK_MAGIC 0xCADECADE
> +
> +struct undo_header {
> +	char magic[8];		/* "E2UNDO02" */
> +	__le64 num_keys;	/* how many keys? */
> +	__le64 super_offset;	/* where in the file is the superblock copy? */
> +	__le64 key_offset;	/* where do the key/data block chunks start? */
> +	__le32 block_size;	/* block size of the undo file */
> +	__le32 fs_block_size;	/* block size of the target device */
> +	__le32 sb_crc;		/* crc32c of the superblock */
> +	__u8 padding[464];	/* padding */
> +	__le32 header_crc;	/* crc32c of this header (but not this field) */
> +};
> +
> +struct undo_key {
> +	__le64 fsblk;		/* where in the fs does the block go */
> +	__le32 blk_crc;		/* crc32c of the block */
> +	__le32 size;		/* how many bytes in this block? */
> +};
> +
> +struct undo_key_block {
> +	__le32 magic;		/* KEYBLOCK_MAGIC number */
> +	__le32 crc;		/* block checksum */
> +	__le64 reserved;	/* zero */
> +
> +	struct undo_key keys[0];	/* keys, which come immediately after */
> +};
>  
>  struct undo_private_data {
>  	int	magic;
> -	TDB_CONTEXT *tdb;
> -	char *tdb_file;
> +
> +	/* the undo file io channel */
> +	io_channel undo_file;
> +	blk64_t undo_blk_num, key_blk_num;
> +	struct undo_key_block *keyb;
> +	size_t num_keys, keys_in_block;
>  
>  	/* The backing io channel */
>  	io_channel real;
> @@ -73,16 +121,15 @@ struct undo_private_data {
>  
>  	ext2fs_block_bitmap written_block_map;
>  	struct struct_ext2_filsys fake_fs;
> +
> +	struct undo_header hdr;
>  };
> +#define KEYS_PER_BLOCK(d) (((d)->tdb_data_size / sizeof(struct undo_key)) - 1)
>  
>  static io_manager undo_io_backing_manager;
>  static char *tdb_file;
>  static int actual_size;
>  
> -static unsigned char mtime_key[] = "filesystem MTIME";
> -static unsigned char blksize_key[] = "filesystem BLKSIZE";
> -static unsigned char uuid_key[] = "filesystem UUID";
> -
>  errcode_t set_undo_io_backing_manager(io_manager manager)
>  {
>  	/*
> @@ -103,17 +150,34 @@ errcode_t set_undo_io_backup_file(char *file_name)
>  	return 0;
>  }
>  
> -static errcode_t write_file_system_identity(io_channel undo_channel,
> -							TDB_CONTEXT *tdb)
> +static errcode_t write_undo_indexes(struct undo_private_data *data)
>  {
>  	errcode_t retval;
>  	struct ext2_super_block super;
> -	TDB_DATA tdb_key, tdb_data;
> -	struct undo_private_data *data;
>  	io_channel channel;
> -	int block_size ;
> +	int block_size;
> +	__u32 sb_crc, hdr_crc;
> +
> +	/* Spit out a key block, if there's any data */
> +	if (data->keys_in_block) {
> +		data->keyb->magic = ext2fs_cpu_to_le32(KEYBLOCK_MAGIC);
> +		data->keyb->crc = 0;
> +		data->keyb->crc = ext2fs_cpu_to_le32(
> +					 ext2fs_crc32c_le(~0,
> +					 (unsigned char *)data->keyb,
> +					 data->tdb_data_size));
> +		dbg_printf("Writing keyblock to blk %llu\n", data->key_blk_num);
> +		retval = io_channel_write_blk64(data->undo_file,
> +						data->key_blk_num,
> +						1, data->keyb);
> +		if (retval)
> +			return retval;
> +		memset(data->keyb, 0, data->tdb_data_size);
> +		data->keys_in_block = 0;
> +		data->key_blk_num = data->undo_blk_num;
> +	}
>  
> -	data = (struct undo_private_data *) undo_channel->private_data;
> +	/* Prepare superblock for write */
>  	channel = data->real;
>  	block_size = channel->block_size;
>  
> @@ -121,52 +185,42 @@ static errcode_t write_file_system_identity(io_channel undo_channel,
>  	retval = io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, &super);
>  	if (retval)
>  		goto err_out;
> -
> -	/* Write to tdb file in the file system byte order */
> -	tdb_key.dptr = mtime_key;
> -	tdb_key.dsize = sizeof(mtime_key);
> -	tdb_data.dptr = (unsigned char *) &(super.s_mtime);
> -	tdb_data.dsize = sizeof(super.s_mtime);
> -
> -	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
> -	if (retval == -1) {
> -		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
> +	sb_crc = ext2fs_crc32c_le(~0, (unsigned char *)&super, SUPERBLOCK_SIZE);
> +
> +	/* Write the undo header to disk. */
> +	memcpy(data->hdr.magic, E2UNDO_MAGIC, sizeof(data->hdr.magic));
> +	data->hdr.num_keys = ext2fs_cpu_to_le64(data->num_keys);
> +	data->hdr.super_offset = ext2fs_cpu_to_le64(data->undo_blk_num);
> +	data->hdr.key_offset = ext2fs_cpu_to_le64(1);
> +	data->hdr.fs_block_size = ext2fs_cpu_to_le32(block_size);
> +	data->hdr.sb_crc = ext2fs_cpu_to_le32(sb_crc);

It would be useful to have a state bit here that could tell us if we made it
all the way to undo_close(), which implies that the operation completed
successfully.  When the bit isn't set, that means that the program writing the
undo file likely errored out halfway through, and the user should be warned at
e2undo time to run fsck.

> +	hdr_crc = ext2fs_crc32c_le(~0, (unsigned char *)&data->hdr,
> +				   sizeof(data->hdr) -
> +				   sizeof(data->hdr.header_crc));
> +	data->hdr.header_crc = ext2fs_cpu_to_le32(hdr_crc);
> +	retval = io_channel_write_blk64(data->undo_file, 0,
> +					-(int)sizeof(data->hdr),
> +					&data->hdr);
> +	if (retval)
>  		goto err_out;
> -	}
> -
> -	tdb_key.dptr = uuid_key;
> -	tdb_key.dsize = sizeof(uuid_key);
> -	tdb_data.dptr = (unsigned char *)&(super.s_uuid);
> -	tdb_data.dsize = sizeof(super.s_uuid);
>  
> -	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
> -	if (retval == -1) {
> -		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
> -	}
> +	/*
> +	 * Record the entire superblock (in FS byte order) so that we can't
> +	 * apply e2undo files to the wrong FS or out of order.
> +	 */
> +	dbg_printf("Writing superblock to block %llu\n", data->undo_blk_num);
> +	retval = io_channel_write_blk64(data->undo_file, data->undo_blk_num,
> +					-SUPERBLOCK_SIZE, &super);

It's confusing how this keeps writing the superblock wherever the last block
is, and letting the next block write overwrite it.  Seeing as the header tells
us where the superblock is located, just put it somewhere at the beginning, and
perhaps twiddle s_magic so that blkid and libmagic won't get confused if the
superblock ends up at offset 1024.

> +	if (retval)
> +		goto err_out;
> +	data->undo_blk_num++;
>  
> +	retval = io_channel_flush(data->undo_file);
>  err_out:
>  	io_channel_set_blksize(channel, block_size);
>  	return retval;
>  }
>  
> -static errcode_t write_block_size(TDB_CONTEXT *tdb, int block_size)
> -{
> -	errcode_t retval;
> -	TDB_DATA tdb_key, tdb_data;
> -
> -	tdb_key.dptr = blksize_key;
> -	tdb_key.dsize = sizeof(blksize_key);
> -	tdb_data.dptr = (unsigned char *)&(block_size);
> -	tdb_data.dsize = sizeof(block_size);
> -
> -	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
> -	if (retval == -1) {
> -		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
> -	}
> -
> -	return retval;
> -}
> -
>  static errcode_t undo_setup_tdb(struct undo_private_data *data)
>  {
>  	errcode_t retval;
> @@ -187,15 +241,17 @@ static errcode_t undo_setup_tdb(struct undo_private_data *data)
>  	if (retval)
>  		return retval;
>  
> -	/* Write the blocksize to tdb file */
> -	tdb_transaction_start(data->tdb);
> -	retval = write_block_size(data->tdb,
> -				  data->tdb_data_size);
> -	if (retval) {
> -		tdb_transaction_cancel(data->tdb);
> -		return EXT2_ET_TDB_ERR_IO;
> -	}
> -	tdb_transaction_commit(data->tdb);
> +	/* Allocate key block */
> +	retval = ext2fs_get_memzero(data->tdb_data_size, &data->keyb);
> +	if (retval)
> +		return retval;
> +	data->key_blk_num = data->undo_blk_num++;
> +
> +	/* Record block size */
> +	dbg_printf("Undo block size %d\n", data->tdb_data_size);
> +	dbg_printf("Keys per block %zu\n", KEYS_PER_BLOCK(data));
> +	data->hdr.block_size = ext2fs_cpu_to_le32(data->tdb_data_size);
> +	io_channel_set_blksize(data->undo_file, data->tdb_data_size);
>  	return 0;
>  }
>  
> @@ -208,13 +264,16 @@ static errcode_t undo_write_tdb(io_channel channel,
>  	errcode_t retval = 0;
>  	ext2_loff_t offset;
>  	struct undo_private_data *data;
> -	TDB_DATA tdb_key, tdb_data;
>  	unsigned char *read_ptr;
>  	unsigned long long end_block;
> +	unsigned long long data_size;
> +	void *data_ptr;
> +	struct undo_key *key;
> +	__u32 blk_crc;
>  
>  	data = (struct undo_private_data *) channel->private_data;
>  
> -	if (data->tdb == NULL) {
> +	if (data->undo_file == NULL) {
>  		/*
>  		 * Transaction database not initialized
>  		 */
> @@ -243,11 +302,7 @@ static errcode_t undo_write_tdb(io_channel channel,
>  	block_num = offset / data->tdb_data_size;
>  	end_block = (offset + size) / data->tdb_data_size;
>  
> -	tdb_transaction_start(data->tdb);
> -	while (block_num <= end_block ) {
> -
> -		tdb_key.dptr = (unsigned char *)&block_num;
> -		tdb_key.dsize = sizeof(block_num);
> +	while (block_num <= end_block) {
>  		/*
>  		 * Check if we have the record already
>  		 */
> @@ -259,6 +314,13 @@ static errcode_t undo_write_tdb(io_channel channel,
>  		}
>  		ext2fs_mark_block_bitmap2(data->written_block_map, block_num);
>  
> +		/* Spit out a key block */
> +		if (data->keys_in_block == KEYS_PER_BLOCK(data)) {
> +			retval = write_undo_indexes(data);
> +			if (retval)
> +				return retval;
> +		}
> +
>  		/*
>  		 * Read one block using the backing I/O manager
>  		 * The backing I/O manager block size may be
> @@ -273,7 +335,6 @@ static errcode_t undo_write_tdb(io_channel channel,
>  				((offset - data->offset) % channel->block_size);
>  		retval = ext2fs_get_mem(count, &read_ptr);
>  		if (retval) {
> -			tdb_transaction_cancel(data->tdb);
>  			return retval;
>  		}
>  
> @@ -288,33 +349,43 @@ static errcode_t undo_write_tdb(io_channel channel,
>  		if (retval) {
>  			if (retval != EXT2_ET_SHORT_READ) {
>  				free(read_ptr);
> -				tdb_transaction_cancel(data->tdb);
>  				return retval;
>  			}
>  			/*
>  			 * short read so update the record size
>  			 * accordingly
>  			 */
> -			tdb_data.dsize = actual_size;
> +			data_size = actual_size;
>  		} else {
> -			tdb_data.dsize = data->tdb_data_size;
> +			data_size = data->tdb_data_size;
>  		}
> -		tdb_data.dptr = read_ptr +
> -				((offset - data->offset) % channel->block_size);
> -#ifdef DEBUG
> -		printf("Printing with key %lld data %x and size %d\n",
> +		if (data_size == 0) {
> +			free(read_ptr);
> +			block_num++;
> +			continue;
> +		}
> +		dbg_printf("Read %llu bytes from FS block %llu (blk=%llu cnt=%u)\n",
> +		       data_size, backing_blk_num, block, count);
> +		if ((data_size % data->undo_file->block_size) == 0)
> +			sz = data_size / data->undo_file->block_size;
> +		else
> +			sz = -actual_size;
> +		data_ptr = read_ptr + ((offset - data->offset) %
> +				       data->undo_file->block_size);
> +		dbg_printf("Writing block %llu to offset %llu size %d\n",
>  		       block_num,
> -		       tdb_data.dptr,
> -		       tdb_data.dsize);
> -#endif
> -		retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_REPLACE);
> -		if (retval == -1) {
> -			/*
> -			 * TDB_ERR_EXISTS cannot happen because we
> -			 * have already verified it doesn't exist
> -			 */
> -			tdb_transaction_cancel(data->tdb);
> -			retval = EXT2_ET_TDB_ERR_IO;
> +		       data->undo_blk_num,
> +		       sz);
> +		data->num_keys++;
> +		key = &data->keyb->keys[data->keys_in_block++];
> +		key->fsblk = ext2fs_cpu_to_le64(backing_blk_num);
> +		blk_crc = ext2fs_crc32c_le(~0, (unsigned char *)data_ptr,
> +					   data_size);
> +		key->blk_crc = ext2fs_cpu_to_le32(blk_crc);
> +		key->size = ext2fs_cpu_to_le32(data_size);

Since the key size is a u32 byte count, you might as well collect a run of
contiguous blocks and save them all with one key.  There's a slight risk that a
minor bitflip somewhere could cause the whole block to be marked bad, but
seeing as our current strategy for handling that is to re-run with -f to ignore
csum errors and force a fsck, I guess that's not /so/ bad.

> +		retval = io_channel_write_blk64(data->undo_file,
> +					data->undo_blk_num++, sz, data_ptr);
> +		if (retval) {
>  			free(read_ptr);
>  			return retval;
>  		}
> @@ -322,7 +393,6 @@ static errcode_t undo_write_tdb(io_channel channel,
>  		/* Next block */
>  		block_num++;
>  	}
> -	tdb_transaction_commit(data->tdb);
>  
>  	return retval;
>  }
> @@ -375,29 +445,33 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
>  
>  	memset(data, 0, sizeof(struct undo_private_data));
>  	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
> -	data->written_block_map = NULL;
> +	data->undo_blk_num = 1;
>  
>  	if (undo_io_backing_manager) {
>  		retval = undo_io_backing_manager->open(name, flags,
>  						       &data->real);
>  		if (retval)
>  			goto cleanup;
> +
> +		retval = ext2fs_open_file(tdb_file,
> +					  O_RDWR | O_CREAT | O_TRUNC | O_EXCL,
> +					  0600);

O_CREAT | O_TRUNC?  Why not allow programs to reopen an undo file, particularly
if the user passes in a specific undo file via -z.  You'd want to perform some
checking to ensure that the state of the FS when we finished writing the undo
file matches the current state of the FS (comparing superblocks would suffice
to capture UUID, mount time, write time, and lifetime write counters).

For big multi-program transitions (think resize2fs -b to enable 64bit, then
tune2fs -O to enable metadata_csum, then a full fsck -fyD to rebuild the
indexes) reusing the same undo file saves us the trouble of storing (and then
restoring) a lot of in-between-program-invocation state.

(In particular, doing exactly that on my 2TB test FS reduces the undo space
requirement from 4430MB to 2930MB.)

> +		if (retval < 0)
> +			goto cleanup;
> +		close(retval);
> +		retval = undo_io_backing_manager->open(tdb_file, IO_FLAG_RW,
> +						       &data->undo_file);
> +		if (retval)
> +			goto cleanup;
>  	} else {
> -		data->real = 0;
> +		data->real = NULL;
> +		data->undo_file = NULL;
>  	}
>  
>  	if (data->real)
>  		io->flags = (io->flags & ~CHANNEL_FLAGS_DISCARD_ZEROES) |
>  			    (data->real->flags & CHANNEL_FLAGS_DISCARD_ZEROES);
>  
> -	/* setup the tdb file */
> -	data->tdb = tdb_open(tdb_file, 0, TDB_CLEAR_IF_FIRST | TDB_NOLOCK | TDB_NOSYNC,
> -			     O_RDWR | O_CREAT | O_TRUNC | O_EXCL, 0600);
> -	if (!data->tdb) {
> -		retval = errno;
> -		goto cleanup;
> -	}
> -
>  	/*
>  	 * setup err handler for read so that we know
>  	 * when the backing manager fails do short read
> @@ -409,6 +483,8 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
>  	return 0;
>  
>  cleanup:
> +	if (data && data->undo_file)
> +		io_channel_close(data->undo_file);
>  	if (data && data->real)
>  		io_channel_close(data->real);
>  	if (data)
> @@ -430,13 +506,12 @@ static errcode_t undo_close(io_channel channel)
>  	if (--channel->refcount > 0)
>  		return 0;
>  	/* Before closing write the file system identity */
> -	err = write_file_system_identity(channel, data->tdb);
> +	err = write_undo_indexes(data);

Most of the e2fsprogs client programs will exit() when they encounter errors.
Since we're no longer writing out the entire undo file index with every block
write and the client programs can't be relied upon to shut down the IO channel,
I suppose we ought to find a way to make sure that write_undo_indexes() gets
called at exit if undo_close() hasn't already been called.

>  	if (data->real)
>  		retval = io_channel_close(data->real);
> -	if (data->tdb) {
> -		tdb_flush(data->tdb);
> -		tdb_close(data->tdb);
> -	}
> +	if (data->undo_file)
> +		io_channel_close(data->undo_file);
> +	ext2fs_free_mem(&data->keyb);
>  	if (data->written_block_map)
>  		ext2fs_free_generic_bitmap(data->written_block_map);
>  	ext2fs_free_mem(&channel->private_data);
> @@ -632,8 +707,6 @@ static errcode_t undo_flush(io_channel channel)
>  	data = (struct undo_private_data *) channel->private_data;
>  	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
>  
> -	if (data->tdb)
> -		tdb_flush(data->tdb);
>  	if (data->real)
>  		retval = io_channel_flush(data->real);
>  
> diff --git a/misc/e2undo.8.in b/misc/e2undo.8.in
> index 4bf0798..3677b83 100644
> --- a/misc/e2undo.8.in
> +++ b/misc/e2undo.8.in
> @@ -10,6 +10,9 @@ e2undo \- Replay an undo log for an ext2/ext3/ext4 filesystem
>  [
>  .B \-f
>  ]
> +[
> +.B \-n
> +]
>  .I undo_log device
>  .SH DESCRIPTION
>  .B e2undo
> @@ -24,13 +27,15 @@ used to undo a failed operation by an e2fsprogs program.
>  .B \-f
>  Normally,
>  .B e2undo
> -will check the filesystem UUID and last modified time to make sure the
> -undo log matches with the filesystem on the device.  If they do not
> -match,
> +will check the filesystem superblock to make sure the undo log matches
> +with the filesystem on the device.  If they do not match,
>  .B e2undo
>  will refuse to apply the undo log as a safety mechanism.  The
>  .B \-f
>  option disables this safety mechanism.
> +.TP
> +.B \-n
> +Dry-run; do not actually write blocks back to the filesystem.
>  .SH AUTHOR
>  .B e2undo
>  was written by Aneesh Kumar K.V. (aneesh.kumar@linux.vnet.ibm.com)
> diff --git a/misc/e2undo.c b/misc/e2undo.c
> index d828d3b..00e8e27 100644
> --- a/misc/e2undo.c
> +++ b/misc/e2undo.c
> @@ -20,13 +20,72 @@
>  #if HAVE_ERRNO_H
>  #include <errno.h>
>  #endif
> -#include "ext2fs/tdb.h"
>  #include "ext2fs/ext2fs.h"
>  #include "nls-enable.h"
>  
> -static unsigned char mtime_key[] = "filesystem MTIME";
> -static unsigned char uuid_key[] = "filesystem UUID";
> -static unsigned char blksize_key[] = "filesystem BLKSIZE";
> +#undef DEBUG
> +
> +#ifdef DEBUG
> +# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
> +#else
> +# define dbg_printf(f, a...)
> +#endif
> +
> +/*
> + * Undo file format: The file is cut up into undo_header.block_size blocks.
> + * The first block contains the header.
> + * There is then a repeating series of blocks as follows:
> + *   A key block, which contains undo_keys to map the following data blocks.
> + *   Data blocks
> + * The last block contains the superblock.
> + * (Note that there are pointers to the first key block and the sb, so this
> + * order isn't strictly necessary.)
> + */
> +#define E2UNDO_MAGIC "E2UNDO02"
> +#define KEYBLOCK_MAGIC 0xCADECADE
> +
> +struct undo_header {
> +	char magic[8];		/* "E2UNDO02" */
> +	__le64 num_keys;	/* how many keys? */
> +	__le64 super_offset;	/* where in the file is the superblock copy? */
> +	__le64 key_offset;	/* where do the key/data block chunks start? */
> +	__le32 block_size;	/* block size of the undo file */
> +	__le32 fs_block_size;	/* block size of the target device */
> +	__le32 sb_crc;		/* crc32c of the superblock */
> +	__u8 padding[464];	/* padding */
> +	__le32 header_crc;	/* crc32c of the header (but not this field) */
> +};
> +
> +struct undo_key {
> +	__le64 fsblk;		/* where in the fs does the block go */
> +	__le32 blk_crc;		/* crc32c of the block */
> +	__le32 size;		/* how many bytes in this block? */
> +};
> +
> +struct undo_key_block {
> +	__le32 magic;		/* KEYBLOCK_MAGIC number */
> +	__le32 crc;		/* block checksum */
> +	__le64 reserved;	/* zero */
> +
> +	struct undo_key keys[0];	/* keys, which come immediately after */
> +};
> +
> +struct undo_key_info {
> +	blk64_t fsblk;
> +	blk64_t fileblk;
> +	__u32 blk_crc;
> +	unsigned int size;
> +};
> +
> +struct undo_context {
> +	struct undo_header hdr;
> +	io_channel undo_file;
> +	unsigned int blocksize, fs_blocksize;
> +	blk64_t super_block;
> +	size_t num_keys;
> +	struct undo_key_info *keys;
> +};
> +#define KEYS_PER_BLOCK(d) (((d)->blocksize / sizeof(struct undo_key)) - 1)
>  
>  static char *prg_name;
>  
> @@ -37,13 +96,28 @@ static void usage(void)
>  	exit(1);
>  }
>  
> -static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
> +static void print_undo_mismatch(struct ext2_super_block *fs_super,
> +				struct ext2_super_block *undo_super)
> +{
> +	printf("%s",
> +	       _("The file system superblock doesn't match the undo file.\n"));
> +	if (memcmp(fs_super->s_uuid, undo_super->s_uuid,
> +		   sizeof(fs_super->s_uuid)))
> +		printf("%s", _("UUID does not match.\n"));
> +	if (fs_super->s_mtime != undo_super->s_mtime)
> +		printf("%s", _("Last mount time does not match.\n"));
> +	if (fs_super->s_wtime != undo_super->s_wtime)
> +		printf("%s", _("Last write time does not match.\n"));
> +	if (fs_super->s_kbytes_written != undo_super->s_kbytes_written)
> +		printf("%s", _("Lifetime write counter does not match.\n"));
> +}
> +
> +static int check_filesystem(struct undo_context *ctx, io_channel channel)
>  {
> -	__u32   s_mtime;
> -	__u8    s_uuid[16];
> -	errcode_t retval;
> -	TDB_DATA tdb_key, tdb_data;
>  	struct ext2_super_block super;
> +	char *buf;
> +	__u32 sb_crc;
> +	errcode_t retval;
>  
>  	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
>  	retval = io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, &super);
> @@ -53,83 +127,64 @@ static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
>  		return retval;
>  	}
>  
> -	tdb_key.dptr = mtime_key;
> -	tdb_key.dsize = sizeof(mtime_key);
> -	tdb_data = tdb_fetch(tdb, tdb_key);
> -	if (!tdb_data.dptr) {
> -		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
> -		com_err(prg_name, retval, "%s",
> -			_("while fetching last mount time."));
> +	/*
> +	 * Compare the FS and the undo file superblock so that we can't apply
> +	 * e2undo "patches" out of order.
> +	 */
> +	retval = ext2fs_get_mem(ctx->blocksize, &buf);
> +	if (retval) {
> +		com_err(prg_name, retval, "%s", _("while allocating memory"));
>  		return retval;
>  	}
> -
> -	s_mtime = *(__u32 *)tdb_data.dptr;
> -	free(tdb_data.dptr);
> -	if (super.s_mtime != s_mtime) {
> -		com_err(prg_name, 0,
> -			_("The filesystem last mount time didn't match %u."),
> -			s_mtime);
> -
> -		return  -1;
> -	}
> -
> -
> -	tdb_key.dptr = uuid_key;
> -	tdb_key.dsize = sizeof(uuid_key);
> -	tdb_data = tdb_fetch(tdb, tdb_key);
> -	if (!tdb_data.dptr) {
> -		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
> -		com_err(prg_name, retval, "%s", _("while fetching UUID"));
> +	retval = io_channel_read_blk64(ctx->undo_file, ctx->super_block,
> +				       -SUPERBLOCK_SIZE, buf);
> +	if (retval) {
> +		ext2fs_free_mem(&buf);
> +		com_err(prg_name, retval, "%s", _("while fetching superblock"));
>  		return retval;
>  	}
> -	memcpy(s_uuid, tdb_data.dptr, sizeof(s_uuid));
> -	free(tdb_data.dptr);
> -	if (memcmp(s_uuid, super.s_uuid, sizeof(s_uuid))) {
> -		com_err(prg_name, 0, "%s",
> -			_("The filesystem UUID didn't match."));
> +	if (memcmp(&super, buf, sizeof(super))) {
> +		print_undo_mismatch(&super, (struct ext2_super_block *)buf);
> +		ext2fs_free_mem(&buf);
> +		return -1;
> +	}
> +	sb_crc = ext2fs_crc32c_le(~0, (unsigned char *)buf, SUPERBLOCK_SIZE);
> +	if (ext2fs_le32_to_cpu(ctx->hdr.sb_crc) != sb_crc) {
> +		fprintf(stderr,
> +			_("Undo file superblock checksum doesn't match.\n"));
>  		return -1;
>  	}
> +	ext2fs_free_mem(&buf);
>  
>  	return 0;
>  }
>  
> -static int set_blk_size(TDB_CONTEXT *tdb, io_channel channel)
> +static int key_compare(const void *a, const void *b)
>  {
> -	int block_size;
> -	errcode_t retval;
> -	TDB_DATA tdb_key, tdb_data;
> -
> -	tdb_key.dptr = blksize_key;
> -	tdb_key.dsize = sizeof(blksize_key);
> -	tdb_data = tdb_fetch(tdb, tdb_key);
> -	if (!tdb_data.dptr) {
> -		retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
> -		com_err(prg_name, retval, "%s", _("while fetching block size"));
> -		return retval;
> -	}
> -
> -	block_size = *(int *)tdb_data.dptr;
> -	free(tdb_data.dptr);
> -#ifdef DEBUG
> -	printf("Block size %d\n", block_size);
> -#endif
> -	io_channel_set_blksize(channel, block_size);
> +	const struct undo_key_info *ka, *kb;
>  
> -	return 0;
> +	ka = a;
> +	kb = b;
> +	return ext2fs_le64_to_cpu(ka->fsblk) -
> +	       ext2fs_le64_to_cpu(kb->fsblk);
>  }
>  
>  int main(int argc, char *argv[])
>  {
> -	int c,force = 0;
> -	TDB_CONTEXT *tdb;
> -	TDB_DATA key, data;
> +	int c, force = 0, dry_run = 0;
>  	io_channel channel;
>  	errcode_t retval;
> -	int  mount_flags;
> -	blk64_t  blk_num;
> +	int mount_flags, csum_error = 0;
> +	size_t i, keys_per_block;
>  	char *device_name, *tdb_file;
>  	io_manager manager = unix_io_manager;
> -	void *old_dptr = NULL;
> +	struct undo_context undo_ctx;
> +	char *buf;
> +	struct undo_key_block *keyb;
> +	struct undo_key *dkey;
> +	struct undo_key_info *ikey;
> +	__u32 key_crc, blk_crc, hdr_crc;
> +	blk64_t lblk;
>  
>  #ifdef ENABLE_NLS
>  	setlocale(LC_MESSAGES, "");
> @@ -141,11 +196,14 @@ int main(int argc, char *argv[])
>  	add_error_table(&et_ext2_error_table);
>  
>  	prg_name = argv[0];
> -	while((c = getopt(argc, argv, "f")) != EOF) {
> +	while((c = getopt(argc, argv, "fn")) != EOF) {
>  		switch (c) {
>  			case 'f':
>  				force = 1;
>  				break;
> +			case 'n':
> +				dry_run = 1;
> +				break;

Could be useful to have a -v for verbose status messages and a -h to dump the
e2undo file header.

>  			default:
>  				usage();
>  		}
> @@ -157,14 +215,41 @@ int main(int argc, char *argv[])
>  	tdb_file = argv[optind];
>  	device_name = argv[optind+1];
>  
> -	tdb = tdb_open(tdb_file, 0, 0, O_RDONLY, 0600);
> -
> -	if (!tdb) {
> +	/* Interpret the undo file */
> +	retval = manager->open(tdb_file, IO_FLAG_EXCLUSIVE,
> +			       &undo_ctx.undo_file);
> +	if (retval) {
>  		com_err(prg_name, errno,
>  				_("while opening undo file `%s'\n"), tdb_file);
>  		exit(1);
>  	}
> +	retval = io_channel_read_blk64(undo_ctx.undo_file, 0,
> +				       -(int)sizeof(undo_ctx.hdr),
> +				       &undo_ctx.hdr);
> +	if (retval) {
> +		com_err(prg_name, retval, _("while reading undo file"));
> +		exit(1);
> +	}
> +	if (memcmp(undo_ctx.hdr.magic, E2UNDO_MAGIC,
> +		    sizeof(undo_ctx.hdr.magic))) {
> +		fprintf(stderr, _("%s: Not an undo file.\n"), tdb_file);
> +		exit(1);
> +	}
> +	hdr_crc = ext2fs_crc32c_le(~0, (unsigned char *)&undo_ctx.hdr,
> +				   sizeof(struct undo_header) -
> +				   sizeof(__u32));
> +	if (!force && ext2fs_le32_to_cpu(undo_ctx.hdr.header_crc) != hdr_crc) {
> +		fprintf(stderr, _("%s: Header checksum doesn't match.\n"),
> +			tdb_file);
> +		exit(1);
> +	}
> +	undo_ctx.blocksize = ext2fs_le32_to_cpu(undo_ctx.hdr.block_size);
> +	undo_ctx.fs_blocksize = ext2fs_le32_to_cpu(undo_ctx.hdr.fs_block_size);
> +	undo_ctx.super_block = ext2fs_le64_to_cpu(undo_ctx.hdr.super_offset);
> +	undo_ctx.num_keys = ext2fs_le64_to_cpu(undo_ctx.hdr.num_keys);
> +	io_channel_set_blksize(undo_ctx.undo_file, undo_ctx.blocksize);
>  
> +	/* open the fs */
>  	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
>  	if (retval) {
>  		com_err(prg_name, retval, _("Error while determining whether "
> @@ -179,52 +264,146 @@ int main(int argc, char *argv[])
>  	}
>  
>  	retval = manager->open(device_name,
> -				IO_FLAG_EXCLUSIVE | IO_FLAG_RW,  &channel);
> +			       IO_FLAG_EXCLUSIVE | (dry_run ? 0 : IO_FLAG_RW),
> +			       &channel);
>  	if (retval) {
>  		com_err(prg_name, retval,
>  				_("while opening `%s'"), device_name);
>  		exit(1);
>  	}
>  
> -	if (!force && check_filesystem(tdb, channel)) {
> +	if (!force && check_filesystem(&undo_ctx, channel))
>  		exit(1);
> -	}
>  
> -	if (set_blk_size(tdb, channel)) {
> +	/* prepare to read keys */
> +	retval = ext2fs_get_mem(sizeof(struct undo_key_info) * undo_ctx.num_keys,
> +				&undo_ctx.keys);
> +	if (retval) {
> +		com_err(prg_name, retval, "%s", _("while allocating memory"));
> +		exit(1);
> +	}
> +	ikey = undo_ctx.keys;
> +	retval = ext2fs_get_mem(undo_ctx.blocksize, &keyb);
> +	if (retval) {
> +		com_err(prg_name, retval, "%s", _("while allocating memory"));
> +		exit(1);
> +	}
> +	retval = ext2fs_get_mem(undo_ctx.blocksize, &buf);
> +	if (retval) {
> +		com_err(prg_name, retval, "%s", _("while allocating memory"));
>  		exit(1);
>  	}
>  
> -	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
> -		free(old_dptr);
> -		old_dptr = key.dptr;
> -		if (!strcmp((char *) key.dptr, (char *) mtime_key) ||
> -		    !strcmp((char *) key.dptr, (char *) uuid_key) ||
> -		    !strcmp((char *) key.dptr, (char *) blksize_key)) {
> -			continue;
> +	/* load keys */
> +	keys_per_block = KEYS_PER_BLOCK(&undo_ctx);
> +	lblk = ext2fs_le64_to_cpu(undo_ctx.hdr.key_offset);
> +	dbg_printf("nr_keys=%lu, kpb=%zu, blksz=%u\n",
> +		   undo_ctx.num_keys, keys_per_block, undo_ctx.blocksize);
> +	for (i = 0; i < undo_ctx.num_keys; i += keys_per_block) {
> +		size_t j, max_j;
> +		__le32 crc;
> +
> +		retval = io_channel_read_blk64(undo_ctx.undo_file,
> +					       lblk, 1, keyb);
> +		if (retval) {
> +			com_err(prg_name, retval, "%s", _("while reading keys"));
> +			exit(1);
> +		}
> +
> +		/* check keys */
> +		if (!force &&
> +		    ext2fs_le32_to_cpu(keyb->magic) != KEYBLOCK_MAGIC) {
> +			fprintf(stderr, _("%s: wrong key magic at %llu\n"),
> +				tdb_file, lblk);
> +			exit(1);
>  		}
> +		crc = keyb->crc;
> +		keyb->crc = 0;
> +		key_crc = ext2fs_crc32c_le(~0, (unsigned char *)keyb,
> +					   undo_ctx.blocksize);
> +		if (!force && ext2fs_le32_to_cpu(crc) != key_crc) {
> +			fprintf(stderr,
> +				_("%s: key block checksum error at %llu.\n"),
> +				tdb_file, lblk);
> +			exit(1);
> +		}
> +
> +		/* load keys from key block */
> +		lblk++;
> +		max_j = undo_ctx.num_keys - i;
> +		if (max_j > keys_per_block)
> +			max_j = keys_per_block;
> +		for (j = 0, dkey = keyb->keys;
> +		     j < max_j;
> +		     j++, ikey++, dkey++) {
> +			ikey->fsblk = ext2fs_le64_to_cpu(dkey->fsblk);
> +			ikey->fileblk = lblk++;
> +			ikey->blk_crc = ext2fs_le32_to_cpu(dkey->blk_crc);
> +			ikey->size = ext2fs_le32_to_cpu(dkey->size);

Icky.  Please check ikey->size; later down you assume that ikey->size <
blocksize.  For that matter, it's quite possible to specify multiblock extents
with this key format, but this code would explode if it ever found such a
thing.

> +
> +			/* check each block's crc */
> +			retval = io_channel_read_blk64(undo_ctx.undo_file,
> +						       ikey->fileblk,
> +						       -(int)undo_ctx.blocksize,
> +						       buf);
> +			if (retval) {
> +				com_err(prg_name, retval,
> +					_("while fetching block %llu."),
> +					ikey->fileblk);
> +				exit(1);
> +			}
>  
> -		blk_num = *(blk64_t *)key.dptr;
> -		data = tdb_fetch(tdb, key);
> -		if (!data.dptr) {
> -			retval = EXT2_ET_TDB_SUCCESS + tdb_error(tdb);
> +			blk_crc = ext2fs_crc32c_le(~0, (unsigned char *)buf,
> +						   ikey->size);
> +			if (blk_crc != ikey->blk_crc) {
> +				fprintf(stderr,
> +					_("checksum error in filesystem block %llu\n"),
> +					ikey->fsblk);
> +				if (!force)
> +					exit(1);
> +				csum_error = 1;
> +			}
> +		}
> +	}
> +	ext2fs_free_mem(&keyb);
> +
> +	/* sort keys in fs block order */
> +	qsort(undo_ctx.keys, undo_ctx.num_keys, sizeof(struct undo_key_info),
> +	      key_compare);
> +
> +	/* replay */
> +	io_channel_set_blksize(channel, undo_ctx.fs_blocksize);
> +	for (i = 0, ikey = undo_ctx.keys; i < undo_ctx.num_keys; i++, ikey++) {
> +		retval = io_channel_read_blk64(undo_ctx.undo_file,
> +					       ikey->fileblk,
> +					       -(int)undo_ctx.blocksize,
> +					       buf);
> +		if (retval) {
>  			com_err(prg_name, retval,
> -				_("while fetching block %llu."), blk_num);
> +				_("while fetching block %llu."),
> +				ikey->fileblk);
>  			exit(1);
>  		}
> -		printf(_("Replayed transaction of size %zd at location %llu\n"),
> -							data.dsize, blk_num);
> -		retval = io_channel_write_blk64(channel, blk_num,
> -						-data.dsize, data.dptr);
> -		free(data.dptr);
> -		if (retval == -1) {
> +
> +		dbg_printf("Replayed transaction of size %u from %llu to %llu\n",
> +				ikey->size, ikey->fileblk, ikey->fsblk);
> +		if (dry_run)
> +			continue;
> +		retval = io_channel_write_blk64(channel, ikey->fsblk,
> +						-(int)ikey->size, buf);
> +		if (retval) {
>  			com_err(prg_name, retval,
> -				_("while writing block %llu."), blk_num);
> +				_("while writing block %llu."), ikey->fsblk);
>  			exit(1);
>  		}
>  	}
> -	free(old_dptr);
> +
> +	if (csum_error)
> +		fprintf(stderr, _("Undo file corruption; run e2fsck NOW!\n"));

In addition to whining about checksum errors, I think we should complain IO
errors, without aborting playback.  In case of either error, we can keep
going in the hope of restoring as much of the FS as possible.

Then we could try to open the filesystem (unless we're undoing mkfs) to clear
the VALID_FS bit and set the ERROR_FS bit, which will force a full fsck.

--D

> +	ext2fs_free_mem(&buf);
> +	ext2fs_free_mem(&undo_ctx.keys);
>  	io_channel_close(channel);
> -	tdb_close(tdb);
> +	io_channel_close(undo_ctx.undo_file);
>  
> -	return 0;
> +	return csum_error;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
