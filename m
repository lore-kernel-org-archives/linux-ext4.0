From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: Avoid creating new file in append-only dir when open(2) return error
Date: Sat, 29 Oct 2011 02:02:41 +0800
Message-ID: <1319824961-5587-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64795 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1J1SC7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 14:02:59 -0400
Received: by ywm3 with SMTP id 3so3889361ywm.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 11:02:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Newly created file on ext4 inherits inode flags from parent directory,
so new inode created in append-only directory has S_APPEND flag set,
may_open() called by do_last() checks that flag then returns -EPERM,
but at that time the new inode is already created.

This can be reproduced by:
	# mkdir -p /mnt/ext4/append-only
	# chattr +a /mnt/ext4/append-only
	# ./opentest /mnt/ext4/append-only/newtestfile
	# ls -l /mnt/ext4/append-only/newtestfile

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

To avoid this, check EXT4_APPEND_FL flag first in ext4_create before
really allocating new inode.

Besides this fix, remove comments about 'extent' mount option in
ext4_new_inode(), it's no longer existed.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext4/ialloc.c |    6 +-----
 fs/ext4/namei.c  |   10 ++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..c25b9e5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1005,11 +1005,7 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
-	/*
-	 * Don't inherit extent flag from directory, amongst others. We set
-	 * extent flag on newly created directory and file only if -o extent
-	 * mount option is specified
-	 */
+	/* Don't inherit extent flag from directory, amongst others. */
 	ei->i_flags =
 		ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
 	ei->i_file_acl = 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c924fa..b58be5d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -34,6 +34,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
+#include <linux/namei.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -1743,6 +1744,15 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, int mode,
 	handle_t *handle;
 	struct inode *inode;
 	int err, retries = 0;
+	int open_flag = nd->intent.open.file->f_flags;
+
+	if ((EXT4_I(dir)->i_flags & EXT4_FL_INHERITED) & EXT4_APPEND_FL) {
+		if ((open_flag & O_ACCMODE) != O_RDONLY &&
+		    !(open_flag & O_APPEND))
+			return -EPERM;
+		if (open_flag & O_TRUNC)
+			return -EPERM;
+	}
 
 	dquot_initialize(dir);
 
-- 
1.7.7.1

