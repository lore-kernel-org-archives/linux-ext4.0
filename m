From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext3: Avoid creating new file in append-only dir when open(2) return error
Date: Sat, 29 Oct 2011 02:03:07 +0800
Message-ID: <1319824987-5621-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52742 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1J1SD1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 14:03:27 -0400
Received: by gyb13 with SMTP id 13so3880274gyb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 11:03:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Newly created file on ext3 inherits inode flags from parent directory,
so new inode created in append-only directory has S_APPEND flag set,
may_open() called by do_last() checks that flag then returns -EPERM,
but at that time the new inode is already created.

This can be reproduced by:
	# mkdir -p /mnt/ext3/append-only
	# chattr +a /mnt/ext3/append-only
	# ./opentest /mnt/ext3/append-only/newtestfile
	# ls -l /mnt/ext3/append-only/newtestfile

opentest will return 'Operation not permitted', but the ls shows that
newtestfile is already created.

	# cat opentest.c
	#include <stdio.h>
	#include <sys/types.h>
	#include <fcntl.h>
	#include <sys/stat.h>

	int main(int argc, char *argv[])
	{
		int fd;
		fd = open(argv[1], O_RDWR|O_CREAT, 0666);
		if (fd == -1)
			perror("open failed");
		return 0;
	}

To avoid this, check EXT3_APPEND_FL flag first in ext3_create before
really allocating new inode.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext3/namei.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 0629e09..323cf2f 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -36,6 +36,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
+#include <linux/namei.h>
 #include <trace/events/ext3.h>
 
 #include "namei.h"
@@ -1704,6 +1705,15 @@ static int ext3_create (struct inode * dir, struct dentry * dentry, int mode,
 	handle_t *handle;
 	struct inode * inode;
 	int err, retries = 0;
+	int open_flag = nd->intent.open.file->f_flags;
+
+	if ((EXT3_I(dir)->i_flags & EXT3_FL_INHERITED) & EXT3_APPEND_FL) {
+		if ((open_flag & O_ACCMODE) != O_RDONLY &&
+		    !(open_flag & O_APPEND))
+			return -EPERM;
+		if (open_flag & O_TRUNC)
+			return -EPERM;
+	}
 
 	dquot_initialize(dir);
 
-- 
1.7.7.1

