From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: support O_DIRECT functionality for Mac OS X
Date: Mon, 20 Feb 2012 20:48:10 -0500
Message-ID: <1329788890-26351-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57286 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab2BUBsM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 20:48:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Darwin uses fcntl(fd, F_NOCACHE, 1) instead of the O_DIRECT flag.

Addresses-SourceForge-Bug: #3140289

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/unix_io.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 5337022..9f0613a 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -445,6 +445,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	struct unix_private_data *data = NULL;
 	errcode_t	retval;
 	int		open_flags, zeroes = 0;
+	int		f_nocache = 0;
 	ext2fs_struct_stat st;
 #ifdef __linux__
 	struct 		utsname ut;
@@ -480,9 +481,12 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 	open_flags = (flags & IO_FLAG_RW) ? O_RDWR : O_RDONLY;
 	if (flags & IO_FLAG_EXCLUSIVE)
 		open_flags |= O_EXCL;
-#ifdef O_DIRECT
+#if defined(O_DIRECT)
 	if (flags & IO_FLAG_DIRECT_IO)
 		open_flags |= O_DIRECT;
+#elif defined(F_NOCACHE)
+	if (flags & IO_FLAG_DIRECT_IO)
+		f_nocache = F_NOCACHE;
 #endif
 	data->flags = flags;
 
@@ -491,6 +495,12 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 		retval = errno;
 		goto cleanup;
 	}
+	if (f_nocache) {
+		if (fcntl(data->dev, f_nocache, 1) < 0) {
+			retval = errno;
+			goto cleanup;
+		}
+	}
 
 	/*
 	 * If the device is really a block device, then set the
-- 
1.7.9.107.g97f9a

