From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V4 01/11] mke2fs: add the ability to copy files from a given directory
Date: Sat, 1 Mar 2014 03:06:05 -0500
Message-ID: <1393661175-459-2-git-send-email-liezhi.yang@windriver.com>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:61640 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaCAIGX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Mar 2014 03:06:23 -0500
In-Reply-To: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We will add a -d option which will be used for adding the files from a
given directory to the filesystem, it is similiar to genext2fs, but
genext2fs doesn't fully support ext4.

* We already have the basic operations in debugfs:
  - Copy regular file
  - Create directory
  - Create symlink
  - Create special file

  We will move these operations into create_inode.h and create_inode.c,
  then let both mke2fs and debugfs use them.

* What we need to do are:
  - Copy the given directory recursively, this will be done by the
    populate_fs()
  - Set the owner, mode and other informations
  - Handle the hard links

TODO:
  - The libext2fs can't create the socket file (S_IFSOCK), do we have a
    plan to support it ?

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
---
 misc/create_inode.c |   26 ++++++++++++++++++++++++++
 misc/create_inode.h |   17 +++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 misc/create_inode.c
 create mode 100644 misc/create_inode.h

diff --git a/misc/create_inode.c b/misc/create_inode.c
new file mode 100644
index 0000000..46aaa60
--- /dev/null
+++ b/misc/create_inode.c
@@ -0,0 +1,26 @@
+#include "create_inode.h"
+
+/* Make a special file which is block, character and fifo */
+errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
+{
+}
+
+/* Make a symlink name -> target */
+errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
+{
+}
+
+/* Make a directory in the fs */
+errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
+{
+}
+
+/* Copy the native file to the fs */
+errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
+{
+}
+
+/* Copy files from source_dir to fs */
+errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
+{
+}
diff --git a/misc/create_inode.h b/misc/create_inode.h
new file mode 100644
index 0000000..9fc97fa
--- /dev/null
+++ b/misc/create_inode.h
@@ -0,0 +1,17 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include "et/com_err.h"
+#include "e2p/e2p.h"
+#include "ext2fs/ext2fs.h"
+#include "nls-enable.h"
+
+ext2_filsys    current_fs;
+ext2_ino_t     root;
+
+/* For populating the filesystem */
+extern errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir);
+extern errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st);
+extern errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target);
+extern errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st);
+extern errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest);
-- 
1.7.10.4

