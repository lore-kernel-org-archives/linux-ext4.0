From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] libext2fs: factor out I/O buffer allocation
Date: Mon,  7 May 2012 14:56:24 -0400
Message-ID: <1336416985-24605-5-git-send-email-tytso@mit.edu>
References: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Cc: ksumrall@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38764 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab2EGS42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2012 14:56:28 -0400
In-Reply-To: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a new function, io_channel_alloc_buf() which allocates I/O
buffers with appropriate alignment if we are using direct I/O.  The
original code was sometimes using a larger alignment factor than
necessary, and would always request an aligned memory buffer even when
it was not necessary since the block device was not opened with
O_DIRECT.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2_io.h    |    2 ++
 lib/ext2fs/inode.c      |    4 ++--
 lib/ext2fs/io_manager.c |   17 +++++++++++++++++
 lib/ext2fs/openfs.c     |    2 +-
 lib/ext2fs/rw_bitmaps.c |   16 ++++------------
 lib/ext2fs/unix_io.c    |    7 ++-----
 6 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 95b8de3..1894fb8 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -122,6 +122,8 @@ extern errcode_t io_channel_write_blk64(io_channel channel,
 extern errcode_t io_channel_discard(io_channel channel,
 				    unsigned long long block,
 				    unsigned long long count);
+extern errcode_t io_channel_alloc_buf(io_channel channel,
+				      int count, void *ptr);
 
 /* unix_io.c */
 extern io_manager unix_io_manager;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 6c524ff..77fc447 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -157,8 +157,8 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 			 (fs->blocksize / scan->inode_size - 1)) *
 			scan->inode_size / fs->blocksize;
 	}
-	retval = ext2fs_get_memalign(scan->inode_buffer_blocks * fs->blocksize,
-				     fs->blocksize, &scan->inode_buffer);
+	retval = io_channel_alloc_buf(fs->io, scan->inode_buffer_blocks,
+				      &scan->inode_buffer);
 	scan->done_group = 0;
 	scan->done_group_data = 0;
 	scan->bad_block_ptr = 0;
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index 25df59e..34e4859 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -111,3 +111,20 @@ errcode_t io_channel_discard(io_channel channel, unsigned long long block,
 
 	return EXT2_ET_UNIMPLEMENTED;
 }
+
+errcode_t io_channel_alloc_buf(io_channel io, int count, void *ptr)
+{
+	size_t	size;
+
+	if (count == 0)
+		size = io->block_size;
+	else if (count > 0)
+		size = io->block_size * count;
+	else
+		size = -count;
+
+	if (io->align)
+		return ext2fs_get_memalign(size, io->align, ptr);
+	else
+		return ext2fs_get_mem(size, ptr);
+}
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 220d954..482e4ab 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -144,7 +144,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		goto cleanup;
 	fs->image_io = fs->io;
 	fs->io->app_data = fs;
-	retval = ext2fs_get_memalign(SUPERBLOCK_SIZE, 512, &fs->super);
+	retval = io_channel_alloc_buf(fs->io, -SUPERBLOCK_SIZE, &fs->super);
 	if (retval)
 		goto cleanup;
 	if (flags & EXT2_FLAG_IMAGE_FILE) {
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 81e09c0..53f6ec4 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -53,8 +53,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	inode_nbytes = block_nbytes = 0;
 	if (do_block) {
 		block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
-		retval = ext2fs_get_memalign(fs->blocksize, fs->blocksize,
-					     &block_buf);
+		retval = io_channel_alloc_buf(fs->io, 0, &block_buf);
 		if (retval)
 			goto errout;
 		memset(block_buf, 0xff, fs->blocksize);
@@ -62,8 +61,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	if (do_inode) {
 		inode_nbytes = (size_t)
 			((EXT2_INODES_PER_GROUP(fs->super)+7) / 8);
-		retval = ext2fs_get_memalign(fs->blocksize, fs->blocksize,
-					     &inode_buf);
+		retval = io_channel_alloc_buf(fs->io, 0, &inode_buf);
 		if (retval)
 			goto errout;
 		memset(inode_buf, 0xff, fs->blocksize);
@@ -186,13 +184,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		retval = ext2fs_allocate_block_bitmap(fs, buf, &fs->block_map);
 		if (retval)
 			goto cleanup;
-		if (do_image)
-			retval = ext2fs_get_mem(fs->blocksize, &block_bitmap);
-		else
-			retval = ext2fs_get_memalign(fs->blocksize,
-						     fs->blocksize,
-						     &block_bitmap);
-			
+		retval = io_channel_alloc_buf(fs->io, 0, &block_bitmap);
 		if (retval)
 			goto cleanup;
 	} else
@@ -205,7 +197,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		retval = ext2fs_allocate_inode_bitmap(fs, buf, &fs->inode_map);
 		if (retval)
 			goto cleanup;
-		retval = ext2fs_get_mem(fs->blocksize, &inode_bitmap);
+		retval = io_channel_alloc_buf(fs->io, 0, &inode_bitmap);
 		if (retval)
 			goto cleanup;
 	} else
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 8319eba..2ce0563 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -316,17 +316,14 @@ static errcode_t alloc_cache(io_channel channel,
 		cache->in_use = 0;
 		if (cache->buf)
 			ext2fs_free_mem(&cache->buf);
-		retval = ext2fs_get_memalign(channel->block_size,
-					     channel->align, &cache->buf);
+		retval = io_channel_alloc_buf(channel, 0, &cache->buf);
 		if (retval)
 			return retval;
 	}
 	if (channel->align) {
 		if (data->bounce)
 			ext2fs_free_mem(&data->bounce);
-		retval = ext2fs_get_memalign(channel->block_size,
-					     channel->align,
-					     &data->bounce);
+		retval = io_channel_alloc_buf(channel, 0, &data->bounce);
 	}
 	return retval;
 }
-- 
1.7.10.rc3

