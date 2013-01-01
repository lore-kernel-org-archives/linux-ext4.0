From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/2 v2] debugfs: fixup the hard-coded buffer length in dump_file
Date: Tue,  1 Jan 2013 20:30:14 +0800
Message-ID: <1357043415-24668-2-git-send-email-wenqing.lz@taobao.com>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
Cc: George Spelvin <linux@horizon.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57770 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3AAMQ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2013 07:16:58 -0500
Received: by mail-pb0-f53.google.com with SMTP id jt11so7388317pbb.12
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jan 2013 04:16:57 -0800 (PST)
In-Reply-To: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

For dumping a sparse file, a buffer needs to be allocated, and length is equal
to block size.  So we can't define a hard-coded length due to the block size
might be 1k, 2k, or 4k.  Now we malloc this buffer to fix the hard-coded length.

CC: George Spelvin <linux@horizon.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/dump.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index a15a0b7..5b2289c 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -105,10 +105,10 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 {
 	errcode_t retval;
 	struct ext2_inode	inode;
-	char 		buf[8192];
+	char		*buf = 0;
 	ext2_file_t	e2_file;
 	int		nbytes;
-	unsigned int	got;
+	unsigned int	got, blocksize = current_fs->blocksize;
 
 	if (debugfs_read_inode(ino, &inode, cmdname))
 		return;
@@ -118,8 +118,13 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 		com_err(cmdname, retval, "while opening ext2 file");
 		return;
 	}
+	retval = ext2fs_get_array(1, blocksize, &buf);
+	if (retval) {
+		com_err(cmdname, retval, "while allocating memory");
+		return;
+	}
 	while (1) {
-		retval = ext2fs_file_read(e2_file, buf, sizeof(buf), &got);
+		retval = ext2fs_file_read(e2_file, buf, blocksize, &got);
 		if (retval)
 			com_err(cmdname, retval, "while reading ext2 file");
 		if (got == 0)
@@ -128,6 +133,8 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 		if ((unsigned) nbytes != got)
 			com_err(cmdname, errno, "while writing file");
 	}
+	if (buf)
+		ext2fs_free_mem(&buf);
 	retval = ext2fs_file_close(e2_file);
 	if (retval) {
 		com_err(cmdname, retval, "while closing ext2 file");
-- 
1.7.12.rc2.18.g61b472e

