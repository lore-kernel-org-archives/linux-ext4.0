From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 18/25] e2initrd_helper: Fix memory leak on error
Date: Fri, 16 Sep 2011 15:49:33 -0500
Message-ID: <1316206180-6375-19-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46756 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some error paths did not properly free "buf"

And the normal exit seemed to close e2_file twice (?)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/e2initrd_helper.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/misc/e2initrd_helper.c b/misc/e2initrd_helper.c
index eaf9ce6..3d9f5ab 100644
--- a/misc/e2initrd_helper.c
+++ b/misc/e2initrd_helper.c
@@ -73,7 +73,7 @@ static errcode_t get_file(ext2_filsys fs, const char * filename,
 {
 	errcode_t	retval;
 	char 		*buf;
-	ext2_file_t	e2_file;
+	ext2_file_t	e2_file = NULL;
 	unsigned int	got;
 	struct ext2_inode inode;
 	ext2_ino_t	ino;
@@ -101,7 +101,7 @@ static errcode_t get_file(ext2_filsys fs, const char * filename,
 
 	retval = ext2fs_file_open(fs, ino, 0, &e2_file);
 	if (retval)
-		return retval;
+		goto errout;
 
 	retval = ext2fs_file_read(e2_file, buf, inode.i_size, &got);
 	if (retval)
@@ -109,13 +109,16 @@ static errcode_t get_file(ext2_filsys fs, const char * filename,
 
 	retval = ext2fs_file_close(e2_file);
 	if (retval)
-		return retval;
+		goto errout;
 
 	ret_file->buf = buf;
 	ret_file->size = (int) got;
+	return 0;
 
 errout:
-	ext2fs_file_close(e2_file);
+	free(buf);
+	if (e2_file)
+		ext2fs_file_close(e2_file);
 	return retval;
 }
 
-- 
1.7.4.1

