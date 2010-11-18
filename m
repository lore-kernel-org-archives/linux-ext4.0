From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/6] mke2fs: Use unix_discard() for discards
Date: Thu, 18 Nov 2010 14:38:40 +0100
Message-ID: <1290087521-9123-6-git-send-email-lczerner@redhat.com>
References: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab0KRNi6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 08:38:58 -0500
In-Reply-To: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is generic discard function in struct_io_manager, or in
unix_io_manager to be specific. So use this instead of
mke2fs_discard_blocks().

Since mke2fs_discard_blocks() is not used anymore (and should not be)
remove it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c |   54 +++++++++++-------------------------------------------
 1 files changed, 11 insertions(+), 43 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d63c27f..e000058 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1907,48 +1907,6 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	return retval;
 }
 
-#ifdef __linux__
-
-#ifndef BLKDISCARD
-#define BLKDISCARD	_IO(0x12,119)
-#endif
-
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
-#endif
-
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -2009,7 +1967,17 @@ int main (int argc, char *argv[])
 
 	/* Can't undo discard ... */
 	if (discard && (io_ptr != undo_io_manager)) {
-		retval = mke2fs_discard_blocks(fs);
+		blk64_t blocks = ext2fs_blocks_count(fs->super);
+		retval = io_ptr->discard(fs->io, 0, blocks, fs->blocksize);
+
+		if (verbose) {
+			printf(_("Calling BLKDISCARD from 0 to %llu "),
+			       (unsigned long long) blocks);
+			if (retval)
+				printf(_("failed.\n"));
+			else
+				printf(_("succeeded.\n"));
+		}
 
 		if (!retval && ext2fs_discard_zeroes_data(fs->io)) {
 			if (verbose)
-- 
1.7.2.3

