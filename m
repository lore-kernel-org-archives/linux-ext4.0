From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/6] e2fsprogs: Add CHANNEL_FLAGS_DISCARD_ZEROES flag for io_manager
Date: Thu, 18 Nov 2010 14:38:37 +0100
Message-ID: <1290087521-9123-3-git-send-email-lczerner@redhat.com>
References: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622Ab0KRNiw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 08:38:52 -0500
In-Reply-To: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the device have discard support and simultaneously discard zeroes
data (and it is properly advertised), then we can take advantage of such
behavior in several e2fsprogs tools.

Add new flag CHANNEL_FLAGS_DISCARD_ZEROES for struct_io_channel so
each io_manager can take advantage of this. The flag is properly set
according to BLKDISCARDZEROES ioctl in unix_open.

Also remove old mke2fs_discard_zeroes_data() function and substitute it
with helper which test this flag.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/ext2_io.h |    3 +++
 lib/ext2fs/unix_io.c |   14 +++++++++++++-
 misc/mke2fs.c        |   23 +----------------------
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index c8ec8e5..ec5d2d1 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -29,6 +29,9 @@ typedef struct struct_io_channel *io_channel;
 typedef struct struct_io_stats *io_stats;
 
 #define CHANNEL_FLAGS_WRITETHROUGH	0x01
+#define CHANNEL_FLAGS_DISCARD_ZEROES	0x02
+
+#define ext2fs_discard_zeroes_data(i) (i->flags & CHANNEL_FLAGS_DISCARD_ZEROES)
 
 struct struct_io_channel {
 	errcode_t	magic;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 991de50..703df86 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -425,12 +425,18 @@ static errcode_t flush_cached_blocks(io_channel channel,
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
 	struct unix_private_data *data = NULL;
 	errcode_t	retval;
-	int		open_flags;
+	int		open_flags, zeroes = 0;
 	struct stat	st;
 #ifdef __linux__
 	struct 		utsname ut;
@@ -487,6 +493,12 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	}
 #endif
 
+#ifdef BLKDISCARDZEROES
+	ioctl(data->dev, BLKDISCARDZEROES, &zeroes);
+	if (zeroes)
+		io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
+#endif
+
 #if defined(__CYGWIN__) || defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
 	/*
 	 * Some operating systems require that the buffers be aligned,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0980045..3c5d8b7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1903,10 +1903,6 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
-#ifndef BLKDISCARDZEROES
-#define BLKDISCARDZEROES _IO(0x12,124)
-#endif
-
 /*
  * Return zero if the discard succeeds, and -1 if the discard fails.
  */
@@ -1941,23 +1937,6 @@ static int mke2fs_discard_blocks(ext2_filsys fs)
 	return ret;
 }
 
-static int mke2fs_discard_zeroes_data(ext2_filsys fs)
-{
-	int fd;
-	int ret;
-	int discard_zeroes_data = 0;
-
-	fd = open64(fs->device_name, O_RDWR);
