From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 08/15] libext2fs: fix memory leak on error path
Date: Mon, 29 Nov 2010 17:55:10 +0900
Message-ID: <1291020917-8671-9-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51817 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0K2Izl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:41 -0500
Received: by mail-gw0-f46.google.com with SMTP id 20so1866691gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:41 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

io->name should be freed if ext2fs_file_open2() fails.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/inode_io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/inode_io.c b/lib/ext2fs/inode_io.c
index 4faaa48..bc934d3 100644
--- a/lib/ext2fs/inode_io.c
+++ b/lib/ext2fs/inode_io.c
@@ -157,11 +157,13 @@ static errcode_t inode_open(const char *name, int flags, io_channel *channel)
 				   &data->inode : 0, open_flags,
 				   &data->file);
 	if (retval)
-		goto cleanup;
+		goto cleanup_name;
 
 	*channel = io;
 	return 0;
 
+cleanup_name:
+	ext2fs_free_mem(&io->name);
 cleanup:
 	if (data) {
 		ext2fs_free_mem(&data);
-- 
1.7.0.4

