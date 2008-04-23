From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Thu, 24 Apr 2008 00:28:01 +0530
Message-ID: <20080423185801.GC21899@skywalker>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu> <20080421164144.GG9700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57851 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYDWS6U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 14:58:20 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m3NIvVVg013246
	for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 04:57:31 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3NJ2DE7285886
	for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 05:02:13 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3NIwQ9f003247
	for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 04:58:26 +1000
Content-Disposition: inline
In-Reply-To: <20080421164144.GG9700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 12:41:44PM -0400, Theodore Tso wrote:
> 
> * ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
>  - Add test cases for undoe2fs: u_undoe2fs_mke2fs and
>    u_undoe2fs_tune2fs
>  - Fix the resize inode test case
>  - tune2fs: Support for large inode migration.
>  - mke2fs: Add support for the undo I/O manager.
>  - Add undoe2fs command
>  - libext2fs: Add undo I/O manager
> 
> 	These patches have been *significantly* rototilled.
> 
> 	* The test cases weren't correctly setting and deleting the
> 	  test_name.ok and test_name.failed files
> 
> 	* mke2fs would bomb out with an incomprehensible error message
> 	  if run twice in a row, or if the user didn't have write access
> 	  to /var/lib/e2fsprogs (some users run mke2fs as a non-root
> 	  user!)
> 
> 	* the undoe2fs program was calling com_err and passing
> 	  in uninitialized retval values, and was otherwise confused
> 	  about how to do proper error handling, resulting in garbage
> 	  getting printed if the file passed in didn't exist
> 
> 	* there was a terrible performance problem because in the
> 	  mke2fs case, the undo manager was using a tdb_data_size of
> 	  512.
> 
> 	* I added the ability to configure the location of the scratch
>           dirctory via mke2fs.conf for mk2efs.  What we should do for
>           tune2fs is less clear, and still needs to be addressed.  It
>           is also possible to force an undo file to be always created,
>           and not just when doing a lazy inode table initialization.
>           By using a 4k instead of 512 tdb_data_size, the time to
>           speed up an mke2fs was cut in half, while still using an
>           undo file.  I suspect if we force the tdb_data_size to be
>           even larger, say 32k or 64k the overhead would shrink even
>           more.
> 
> 	Unfortunately, there appears to be some kind of data
> 	corruption bug if I force a tdb_data_size of 32768, so I'm not
> 	entirely sure I trust the undo manager to be working
> 	correctly.  The undo_manager code itself needs a pretty
> 	serious auditing and checking to make sure it's doing the
> 	right thing with large tdb_data_sizes.
> 

The bug was in the changes added to support block size via set_options
We had two records in the data for blocksize. one 1024. configured via
set_blk_size and other 32K configured via set_options. So the undoe2fs
was replaying with 1K as the block size.

The below changes get everything working for me. The patch is not clean.
so they are not to apply. I still need to think a little bit more about
what to do when we attempt to read tdb_data_size from the end of file
system. Will send the cleanup patch later.

Let me know whether you want to keep the debug printf

diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 9bee1b6..4ad0fd6 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -169,6 +169,9 @@ static errcode_t write_block_size(TDB_CONTEXT *tdb, int block_size)
 	tdb_key.dsize = sizeof("filesystem BLKSIZE");
 	tdb_data.dptr = (unsigned char *)&(block_size);
 	tdb_data.dsize = sizeof(block_size);
+#ifdef DEBUG
+	printf("Setting blocksize %d\n", block_size);
+#endif
 
 	retval = tdb_store(tdb, tdb_key, tdb_data, TDB_INSERT);
 	if (retval == -1) {
@@ -182,13 +185,14 @@ static errcode_t undo_write_tdb(io_channel channel,
 				unsigned long block, int count)
 
 {
-	int size, loop_count = 0, i;
+	int size, i;
 	unsigned long block_num, backing_blk_num;
 	errcode_t retval = 0;
 	ext2_loff_t offset;
 	struct undo_private_data *data;
 	TDB_DATA tdb_key, tdb_data;
 	char *read_ptr;
+	unsigned long end_block;
 
 	data = (struct undo_private_data *) channel->private_data;
 
@@ -208,21 +212,26 @@ static errcode_t undo_write_tdb(io_channel channel,
 			size = count * channel->block_size;
 	}
 
+#ifdef DEBUG
+	printf("Writing at %ld of size %ld\n", block, size);
+#endif
 	/*
 	 * Data is stored in tdb database as blocks of tdb_data_size size
 	 * This helps in efficient lookup further.
 	 *
 	 * We divide the disk to blocks of tdb_data_size.
 	 */
+	/*FIXME  need to check end of file system. */
 
-	block_num = ((block*channel->block_size)+data->offset) /
-		data->tdb_data_size;
-
-	loop_count = (size + data->tdb_data_size -1) /
-		data->tdb_data_size;
+	offset = (block * channel->block_size) + data->offset ;
+	block_num = offset / data->tdb_data_size;
+	end_block = (offset + size) / data->tdb_data_size;
 
+#ifdef DEBUG
+	printf("Writing from %ld to %ld\n", block_num, end_block);
+#endif
 	tdb_transaction_start(data->tdb);
-	for (i = 0; i < loop_count; i++) {
+	while (block_num <= end_block ) {
 
 		tdb_key.dptr = (unsigned char *)&block_num;
 		tdb_key.dsize = sizeof(block_num);
@@ -231,8 +240,11 @@ static errcode_t undo_write_tdb(io_channel channel,
 		 * Check if we have the record already
 		 */
 		if (tdb_exists(data->tdb, tdb_key)) {
-
 			/* Try the next block */
+#ifdef DEBUG
+			printf("The block %d already exist in database\n",
+					block_num);
+#endif
 			block_num++;
 			continue;
 		}
@@ -258,6 +270,9 @@ static errcode_t undo_write_tdb(io_channel channel,
 		}
 
 		memset(read_ptr, 0, count);
+#ifdef DEBUG
+		printf("Reading from %ld to %ld\n", backing_blk_num, count);
+#endif
 
 		retval = io_channel_read_blk(data->real, backing_blk_num,
 					     -count, read_ptr);
@@ -276,10 +291,22 @@ static errcode_t undo_write_tdb(io_channel channel,
 		printf("Printing with key %ld data %x and size %d\n",
 		       block_num,
 		       tdb_data.dptr,
-		       channel->tdb_data_size);
+		       data->tdb_data_size);
 #endif
 
-		data->tdb_written = 1;
+		if (!data->tdb_written) {
+			data->tdb_written = 1;
+
+			/* Write the blocksize to tdb file */
+			retval = write_block_size(data->tdb,
+						  data->tdb_data_size);
+			if (retval) {
+				tdb_transaction_cancel(data->tdb);
+				retval = EXT2_ET_TDB_ERR_IO;
+				free(read_ptr);
+				return retval;
+			}
+		}
 		retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_INSERT);
 		if (retval == -1) {
 			/*
@@ -417,11 +444,6 @@ static errcode_t undo_set_blksize(io_channel channel, int blksize)
 	 */
 	if (!data->tdb_data_size) {
 		data->tdb_data_size = blksize;
-
-		/* Write it to tdb file */
-		retval = write_block_size(data->tdb, data->tdb_data_size);
-		if (retval)
-			return retval;
 	}
 
 	channel->block_size = blksize;
@@ -540,12 +562,6 @@ static errcode_t undo_set_option(io_channel channel, const char *option,
 			return EXT2_ET_INVALID_ARGUMENT;
 		if (!data->tdb_data_size || !data->tdb_written) {
 			data->tdb_data_size = tmp;
-
-			/* Write it to tdb file */
-			retval = write_block_size(data->tdb,
-						  data->tdb_data_size);
-			if (retval)
-				return retval;
 		}
 		return 0;
 	}
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 593b743..be772ee 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1745,6 +1745,7 @@ static int should_do_undo(const char *name)
 	io_manager manager = unix_io_manager;
 	int csum_flag, force_undo;
 
+
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	force_undo = get_int_from_profile(fs_types, "force_undo", 0);
@@ -1873,7 +1874,7 @@ int main (int argc, char *argv[])
 		com_err(device_name, retval, _("while setting up superblock"));
 		exit(1);
 	}
-#if 0			/* XXX bug in undo_io.c if we set this? */
+#if 1			/* XXX bug in undo_io.c if we set this? */
 	io_channel_set_options(fs->io, "tdb_data_size=32768");
 #endif
 
