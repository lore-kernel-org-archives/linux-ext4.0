From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [1/6] e2fsprogs: Add discard function into struct_io_manager
Date: Tue, 23 Nov 2010 09:54:30 -0500
Message-ID: <20101123145430.GA32759@thunk.org>
References: <1290087521-9123-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, adilger@dilger.ca, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52359 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab0KWPS5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 10:18:57 -0500
Content-Disposition: inline
In-Reply-To: <1290087521-9123-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 03:38:36AM -0000, Lukas Czerner wrote:
> In order to provide generic "discard" function for all e2fsprogs tools
> add a discard function prototype into struct_io_manager. Specific
> function for specific io managers can be crated that way.
> 
> This commit also creates unix_discard function which uses BLKDISCARD
> ioctl to discard data blocks on the block device and bind it into
> unit_io_manager structure to be available for all e2fsprogs tools.
> Note that BLKDISCARD is still Linux specific ioctl, however other
> unix systems may provide similar functionality. So far the
> unix_discard() remains linux specific hence is embedded in #ifdef
> __linux__ macro.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I had to make a few cleanup changes before I could merge this into the
master branch.

1) unix_discard() was defined as a macro in the !__linux__ case.
Since unix_discard() gets used to fill in a function pointer in the
io_channel_ops structure, this would have caused non-linux compiles to
break.

2) I added a io_channel_discard() function which checks to see if
io_channel->discard is non-NULL before dereferencing the function
pointer (you had mke2fs and e2fsck blindly dereferencing the function
pointer before checking to see if it was non-NULL; this is bad,
because not all io_managers, in particular, not the test_io manager in
your patches, support discard).

3) I added support for discard to the test_io manager, which makes
debugging much easier (just compile with --enable-testio-debug, and
then set the TEST_IO_FLAGS environment variable).

4) There was no need to pass the block size to the discard function.
The blocksize is part of the io_channel abstraction, and is stored in
the channel structure.

					- Ted

The resulting patch looked like this.

commit e90a59ed434d6c5e38dd148aa4ba5b22b8f7eb24
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Nov 18 03:38:36 2010 +0000

    e2fsprogs: Add discard function into struct_io_manager
    
    In order to provide generic "discard" function for all e2fsprogs tools
    add a discard function prototype into struct_io_manager. Specific
    function for specific io managers can be crated that way.
    
    This commit also creates unix_discard function which uses BLKDISCARD
    ioctl to discard data blocks on the block device and bind it into
    unit_io_manager structure to be available for all e2fsprogs tools.
    Note that BLKDISCARD is still Linux specific ioctl, however other
    unix systems may provide similar functionality. So far the
    unix_discard() remains linux specific hence is embedded in #ifdef
    __linux__ macro.
    
    Signed-off-by: Lukas Czerner <lczerner@redhat.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index ccc9c8b..f26b569 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -83,6 +83,8 @@ struct struct_io_manager {
 					int count, void *data);
 	errcode_t (*write_blk64)(io_channel channel, unsigned long long block,
 					int count, const void *data);
+	errcode_t (*discard)(io_channel channel, unsigned long long block,
+			     unsigned long long count);
 	long	reserved[16];
 };
 
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index 6d0e234..80f9dfc 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -99,3 +99,14 @@ errcode_t io_channel_write_blk64(io_channel channel, unsigned long long block,
 	return (channel->manager->write_blk)(channel, (unsigned long) block,
 					     count, data);
 }
+
+errcode_t io_channel_discard(io_channel channel, unsigned long long block,
+			     unsigned long long count)
+{
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+
+	if (channel->manager->discard)
+		return (channel->manager->discard)(channel, block, count);
+
+	return EXT2_ET_UNIMPLEMENTED;
+}
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index 8d887a8..242d442 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -73,7 +73,8 @@ static errcode_t test_write_byte(io_channel channel, unsigned long offset,
 static errcode_t test_set_option(io_channel channel, const char *option,
 				 const char *arg);
 static errcode_t test_get_stats(io_channel channel, io_stats *stats);
-
+static errcode_t test_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count);
 
 static struct struct_io_manager struct_test_manager = {
 	EXT2_ET_MAGIC_IO_MANAGER,
@@ -89,6 +90,7 @@ static struct struct_io_manager struct_test_manager = {
 	test_get_stats,
 	test_read_blk64,
 	test_write_blk64,
+	test_discard,
 };
 
 io_manager test_io_manager = &struct_test_manager;
@@ -120,6 +122,7 @@ void (*test_io_cb_write_byte)
 #define TEST_FLAG_FLUSH			0x08
 #define TEST_FLAG_DUMP			0x10
 #define TEST_FLAG_SET_OPTION		0x20
+#define TEST_FLAG_DISCARD		0x40
 
 static void test_dump_block(io_channel channel,
 			    struct test_private_data *data,
@@ -495,3 +498,21 @@ static errcode_t test_get_stats(io_channel channel, io_stats *stats)
 	}
 	return retval;
 }
+
+static errcode_t test_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count)
+{
+	struct test_private_data *data;
+	errcode_t	retval = 0;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct test_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_TEST_IO_CHANNEL);
+
+	retval = io_channel_discard(channel, block, count);
+	if (data->flags & TEST_FLAG_DISCARD)
+		fprintf(data->outfile,
+			"Test_io: discard(%llu, %llu) returned %s\n",
+			block, count, retval ? error_message(retval) : "OK");
+	return retval;
+}
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 1df1fdd..2302374 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -115,6 +115,8 @@ static errcode_t unix_read_blk64(io_channel channel, unsigned long long block,
 			       int count, void *data);
 static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
 				int count, const void *data);
+static errcode_t unix_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count);
 
 static struct struct_io_manager struct_unix_manager = {
 	EXT2_ET_MAGIC_IO_MANAGER,
@@ -130,6 +132,7 @@ static struct struct_io_manager struct_unix_manager = {
 	unix_get_stats,
 	unix_read_blk64,
 	unix_write_blk64,
+	unix_discard,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
@@ -834,3 +837,31 @@ static errcode_t unix_set_option(io_channel channel, const char *option,
 	}
 	return EXT2_ET_INVALID_ARGUMENT;
 }
+
+#if defined(__linux__) && !defined(BLKDISCARD)
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static errcode_t unix_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count)
+{
+#ifdef BLKDISCARD
+	struct unix_private_data *data;
+	__uint64_t	range[2];
+	int		ret;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	range[0] = (__uint64_t)(block) * channel->block_size;
+	range[1] = (__uint64_t)(count) * channel->block_size;
+
+	ret = ioctl(data->dev, BLKDISCARD, &range);
+	if (ret < 0)
+		return errno;
+	return 0;
+#else
+	return EXT2_ET_UNIMPLEMENTED;
+#endif
+}
