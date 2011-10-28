From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext2: Avoid creating new file in append-only dir when open(2) return error
Date: Sat, 29 Oct 2011 02:03:34 +0800
Message-ID: <1319825014-5668-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39080 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1J1SDs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 14:03:48 -0400
Received: by ggnb1 with SMTP id b1so3899061ggn.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 11:03:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Newly created file on ext2 inherits inode flags from parent directory,
so new inode created in append-only directory has S_APPEND flag set,
may_open() called by do_last() checks that flag then returns -EPERM,
but at that time the new inode is already created.

This can be reproduced by:
	# mkdir -p /mnt/ext2/append-only
	# chattr +a /mnt/ext2/append-only
	# ./opentest /mnt/ext2/append-only/newtestfile
	# ls -l /mnt/ext2/append-only/newtestfile

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

To avoid this, check EXT2_APPEND_FL flag first in ext2_create before
really allocating new inode.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext2/namei.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 761fde8..b9f8998 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -32,6 +32,7 @@
 
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
+#include <linux/namei.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -97,6 +98,16 @@ struct dentry *ext2_get_parent(struct dentry *child)
 static int ext2_create (struct inode * dir, struct dentry * dentry, int mode, struct nameidata *nd)
 {
 	struct inode *inode;
+	int open_flag = nd->intent.open.file->f_flags;
+
+	if ((EXT2_I(dir)->i_flags & EXT2_FL_INHERITED) & EXT2_APPEND_FL) {
+		if ((open_flag & O_ACCMODE) != O_RDONLY &&
+		    !(open_flag & O_APPEND))
+			return -EPERM;
+		if (open_flag & O_TRUNC)
+			return -EPERM;
+	}
+
 
 	dquot_initialize(dir);
 
-- 
1.7.7.1

