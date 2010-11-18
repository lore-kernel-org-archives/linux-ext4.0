From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/6] e2fsprogs: Add discard function into struct_io_manager
Date: Thu, 18 Nov 2010 14:38:36 +0100
Message-ID: <1290087521-9123-2-git-send-email-lczerner@redhat.com>
References: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622Ab0KRNiv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 08:38:51 -0500
In-Reply-To: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---
 lib/ext2fs/ext2_io.h |    2 ++
 lib/ext2fs/unix_io.c |   31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index ccc9c8b..c8ec8e5 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -83,6 +83,8 @@ struct struct_io_manager {
 					int count, void *data);
 	errcode_t (*write_blk64)(io_channel channel, unsigned long long block,
 					int count, const void *data);
+	errcode_t (*discard)(io_channel channel, unsigned long long block,
+			     unsigned long long count, unsigned int blocksize);
 	long	reserved[16];
 };
 
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 1df1fdd..991de50 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -115,6 +115,8 @@ static errcode_t unix_read_blk64(io_channel channel, unsigned long long block,
 			       int count, void *data);
 static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
 				int count, const void *data);
+static errcode_t unix_discard(io_channel channel, unsigned long long block,
+			      unsigned long long count, unsigned int blocksize);
 
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
+#ifdef __linux__
+
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static errcode_t unix_discard(io_channel channel, unsigned long long block,
+			     unsigned long long count, unsigned int blocksize)
+{
+	struct unix_private_data *data;
+	__uint64_t	range[2];
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	range[0] = (__uint64_t)(block);
+	range[1] = (__uint64_t)(count);
+	range[0] *= (__uint64_t)(blocksize);
+	range[1] *= (__uint64_t)(blocksize);
+
+	return ioctl(data->dev, BLKDISCARD, &range);
+}
+
+#else
+#define unix_discard(channel, block, count, blocksize)	EXT2_ET_UNIMPLEMENTED
+#endif
-- 
1.7.2.3

