From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/7] e2fsprogs: Add discard_zeroes_data into struct_io_manager
Date: Tue, 26 Oct 2010 19:54:13 +0200
Message-ID: <1288115658-7004-3-git-send-email-lczerner@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0JZRyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 13:54:33 -0400
In-Reply-To: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the device have discard support and simultaneously discard zeroes
data (and it is properly advertised), then we can take advantage of such
behavior in several e2fsprogs tools.

Add new variable discard_zeroes_data into struct_io_manager structure so
each io_manager can take advantage of this. Set it to 0 by default in
unix_io_manager and test_io_manager and fill it with BLKDISCARDZEROES
ioctl in unix_open.

Every other io_manager which would like to take advantage of this should
set the default to 0 in its io_manager definition and then check and set
the value preferably in *_open() function.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/ext2_io.h |    1 +
 lib/ext2fs/test_io.c |    1 +
 lib/ext2fs/unix_io.c |   12 ++++++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index d202007..cc79fda 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -85,6 +85,7 @@ struct struct_io_manager {
 					int count, const void *data);
 	errcode_t (*discard)(io_channel channel, unsigned long long block,
 			     unsigned long long count, const void *data);
+	int	discard_zeroes_data;
 	long	reserved[16];
 };
 
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index 8d887a8..2fac849 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -89,6 +89,7 @@ static struct struct_io_manager struct_test_manager = {
 	test_get_stats,
 	test_read_blk64,
 	test_write_blk64,
+	0,				/* discard zeroes data */
 };
 
 io_manager test_io_manager = &struct_test_manager;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 5b6cdec..b3908dc 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -133,6 +133,7 @@ static struct struct_io_manager struct_unix_manager = {
 	unix_read_blk64,
 	unix_write_blk64,
 	unix_discard,
+	0,				/* discard zeroes data */
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
@@ -425,6 +426,12 @@ static errcode_t flush_cached_blocks(io_channel channel,
 }
 #endif /* NO_IO_CACHE */
 
+#ifdef __linux__
+#ifndef BLKDISCARDZEROES
+#define BLKDISCARDZEROES _IO(0x12,124)
+#endif
+#endif
+
 static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 {
 	io_channel	io = NULL;
@@ -487,6 +494,11 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	}
 #endif
 
+#ifdef BLKDISCARDZEROES
+	ioctl(data->dev, BLKDISCARDZEROES,
+		&unix_io_manager->discard_zeroes_data);
+#endif
+
 #if defined(__CYGWIN__) || defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
 	/*
 	 * Some operating systems require that the buffers be aligned,
-- 
1.7.2.3

