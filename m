From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] libext2fs: move the alignment field from unix_io to the io_manager
Date: Mon,  7 May 2012 14:56:21 -0400
Message-ID: <1336416985-24605-2-git-send-email-tytso@mit.edu>
References: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Cc: ksumrall@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38765 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab2EGS42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2012 14:56:28 -0400
In-Reply-To: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The align field which indicated the required data alignment of data
buffers was stored in a field specific to the unix_io manager.  Move
it to the top-level io_channel structure so it can be better
generalized.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2_io.h |    1 +
 lib/ext2fs/test_io.c |    7 ++++++-
 lib/ext2fs/unix_io.c |   25 ++++++++++++++-----------
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index bcc2f87..95b8de3 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -58,6 +58,7 @@ struct struct_io_channel {
 	long		reserved[14];
 	void		*private_data;
 	void		*app_data;
+	int		align;
 };
 
 struct struct_io_stats {
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index f67f6ae..7d3cdfe 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -247,6 +247,9 @@ static errcode_t test_open(const char *name, int flags, io_channel *channel)
 	if ((value = safe_getenv("TEST_IO_WRITE_ABORT")) != NULL)
 		data->write_abort_count = strtoul(value, NULL, 0);
 
+	if (data->real)
+		io->align = data->real->align;
+
 	*channel = io;
 	return 0;
 
@@ -292,8 +295,10 @@ static errcode_t test_set_blksize(io_channel channel, int blksize)
 	data = (struct test_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_TEST_IO_CHANNEL);
 
-	if (data->real)
+	if (data->real) {
 		retval = io_channel_set_blksize(data->real, blksize);
+		channel->align = data->real->align;
+	}
 	if (data->set_blksize)
 		data->set_blksize(blksize, retval);
 	if (data->flags & TEST_FLAG_SET_BLKSIZE)
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index da3f8fd..3269392 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -180,8 +180,9 @@ static errcode_t raw_read_blk(io_channel channel,
 		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
 		goto error_out;
 	}
-	if ((data->align == 0) ||
-	    ((IS_ALIGNED(buf, data->align)) && IS_ALIGNED(size, data->align))) {
+	if ((channel->align == 0) ||
+	    (IS_ALIGNED(buf, channel->align) &&
+	     IS_ALIGNED(size, channel->align))) {
 		actual = read(data->dev, buf, size);
 		if (actual != size) {
 		short_read:
@@ -250,8 +251,9 @@ static errcode_t raw_write_blk(io_channel channel,
 		goto error_out;
 	}
 
-	if ((data->align == 0) ||
-	    ((IS_ALIGNED(buf, data->align)) && IS_ALIGNED(size, data->align))) {
+	if ((channel->align == 0) ||
+	    (IS_ALIGNED(buf, channel->align) &&
+	     IS_ALIGNED(size, channel->align))) {
 		actual = write(data->dev, buf, size);
 		if (actual != size) {
 		short_write:
@@ -319,14 +321,15 @@ static errcode_t alloc_cache(io_channel channel,
 		if (cache->buf)
 			ext2fs_free_mem(&cache->buf);
 		retval = ext2fs_get_memalign(channel->block_size,
-					     data->align, &cache->buf);
+					     channel->align, &cache->buf);
 		if (retval)
 			return retval;
 	}
-	if (data->align) {
+	if (channel->align) {
 		if (data->bounce)
 			ext2fs_free_mem(&data->bounce);
-		retval = ext2fs_get_memalign(channel->block_size, data->align,
+		retval = ext2fs_get_memalign(channel->block_size,
+					     channel->align,
 					     &data->bounce);
 	}
 	return retval;
@@ -518,8 +521,8 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 
 #ifdef BLKSSZGET
 	if (flags & IO_FLAG_DIRECT_IO) {
-		if (ioctl(data->dev, BLKSSZGET, &data->align) != 0)
-			data->align = io->block_size;
+		if (ioctl(data->dev, BLKSSZGET, &io->align) != 0)
+			io->align = io->block_size;
 	}
 #endif
 
@@ -534,7 +537,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	 * Some operating systems require that the buffers be aligned,
 	 * regardless of O_DIRECT
 	 */
-	data->align = 512;
+	io->align = 512;
 #endif
 
 
@@ -810,7 +813,7 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 	data = (struct unix_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
-	if (data->align != 0) {
+	if (channel->align != 0) {
 #ifdef ALIGN_DEBUG
 		printf("unix_write_byte: O_DIRECT fallback\n");
 #endif
-- 
1.7.10.rc3

