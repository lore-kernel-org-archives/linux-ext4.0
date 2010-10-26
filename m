From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 6/7] mke2fs: Use unix_discard() for discards
Date: Tue, 26 Oct 2010 19:54:17 +0200
Message-ID: <1288115658-7004-7-git-send-email-lczerner@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0JZRyk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 13:54:40 -0400
In-Reply-To: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is generic discard function in struct_io_manager, or in
unix_io_manager to be specific. So use this instead of
mke2fs_discard_blocks().

Since mke2fs_discard_blocks() is not used anymore (and should not be)
remove it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c |   50 +++++++++++---------------------------------------
 1 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 32e3a2b..09ce711 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1902,48 +1902,10 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 
 #ifdef __linux__
 
-#ifndef BLKDISCARD
-#define BLKDISCARD	_IO(0x12,119)
-#endif
-
 #ifndef BLKDISCARDZEROES
 #define BLKDISCARDZEROES _IO(0x12,124)
 #endif
 
-/*
- * Return zero if the discard succeeds, and -1 if the discard fails.
- */
-static int mke2fs_discard_blocks(ext2_filsys fs)
-{
-	int fd;
-	int ret;
-	int blocksize;
-	__u64 blocks;
-	__uint64_t range[2];
-
-	blocks = ext2fs_blocks_count(fs->super);
-	blocksize = EXT2_BLOCK_SIZE(fs->super);
-	range[0] = 0;
-	range[1] = blocks * blocksize;
-
-	fd = open64(fs->device_name, O_RDWR);
-
-	if (fd > 0) {
-		ret = ioctl(fd, BLKDISCARD, &range);
-		if (verbose) {
-			printf(_("Calling BLKDISCARD from %llu to %llu "),
-			       (unsigned long long) range[0],
-			       (unsigned long long) range[1]);
-			if (ret)
-				printf(_("failed.\n"));
-			else
-				printf(_("succeeded.\n"));
-		}
-		close(fd);
-	}
-	return ret;
-}
-
 static int mke2fs_discard_zeroes_data(ext2_filsys fs)
 {
 	int fd;
@@ -2023,7 +1985,17 @@ int main (int argc, char *argv[])
 
 	/* Can't undo discard ... */
 	if (discard && (io_ptr != undo_io_manager)) {
-		retval = mke2fs_discard_blocks(fs);
+		blk64_t blocks = ext2fs_blocks_count(fs->super);
+		retval = io_ptr->discard(fs->io, 0, blocks, fs);
+
+		if (verbose) {
+			printf(_("Calling BLKDISCARD from 0 to %llu "),
+			       (unsigned long long) blocks);
+			if (retval)
+				printf(_("failed.\n"));
+			else
+				printf(_("succeeded.\n"));
+		}
 
 		if (!retval && mke2fs_discard_zeroes_data(fs)) {
 			if (verbose)
-- 
1.7.2.3

