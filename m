From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/25] libext2:  move buf variable completely under ifdef
Date: Fri, 16 Sep 2011 15:49:20 -0500
Message-ID: <1316206180-6375-6-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46732 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If !WORDS_BIGENDIAN, it is pointless to test whether buf
is NULL, because it is initialized to NULL and never changed.
This makes Coverity complain, so we can just move all handling
of "buf" under the #ifdef.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/ext_attr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 52664eb..ddcc89f 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -82,9 +82,9 @@ errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block, void *inbuf)
 {
 	errcode_t	retval;
 	char		*write_buf;
+#ifdef WORDS_BIGENDIAN
 	char		*buf = NULL;
 
-#ifdef WORDS_BIGENDIAN
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
 		return retval;
@@ -94,8 +94,9 @@ errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block, void *inbuf)
 	write_buf = (char *) inbuf;
 #endif
 	retval = io_channel_write_blk64(fs->io, block, 1, write_buf);
-	if (buf)
-		ext2fs_free_mem(&buf);
+#ifdef WORDS_BIGENDIAN
+	ext2fs_free_mem(&buf);
+#endif
 	if (!retval)
 		ext2fs_mark_changed(fs);
 	return retval;
-- 
1.7.4.1

