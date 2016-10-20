From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext4: make online resizing conditional
Date: Thu, 20 Oct 2016 20:37:34 +0200
Message-ID: <20161020183734.18024-1-fabf@skynet.be>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch tries to address the following comment in ext4/resize.c
"This could probably be made into a module, because it is not often in use."

Having ext4 resizing in a module would give a lot of depmod dependency cycles
but we can make it an option.

resize.h has been added for more readability.

Tried the following resizing:
dd if=/dev/zero of=ddext4 bs=1M count=100
losetup -f ddext4
mkfs -t ext4 /dev/loop0
losetup -D
dd if=/dev/zero of=ddappend bs=1M count=50
cat ddappend >> ddext4
losetup -f ddext4
mount /dev/loop0 /mnt
resize2fs /dev/loop0

With option disabled:
"Operation not supported While checking for on-line resizing support"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/Kconfig  |  7 +++++++
 fs/ext4/Makefile |  3 ++-
 fs/ext4/ext4.h   | 12 ------------
 fs/ext4/ioctl.c  |  1 +
 fs/ext4/resize.c |  2 +-
 fs/ext4/resize.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 53 insertions(+), 14 deletions(-)
 create mode 100644 fs/ext4/resize.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index e38039f..2ec35c3 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -122,3 +122,10 @@ config EXT4_DEBUG
 	  If you select Y here, then you will be able to turn on debugging
 	  with a command such as:
 		echo 1 > /sys/module/ext4/parameters/mballoc_debug
+
+config EXT4_RESIZE
+	bool "EXT4 resize"
+	depends on EXT4_FS
+	default y
+	help
+	  Support online ext4 partition resizing.
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 354103f..efe6579 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -5,10 +5,11 @@
 obj-$(CONFIG_EXT4_FS) += ext4.o
 
 ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
-		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
+		ioctl.o namei.o super.o symlink.o hash.o extents.o \
 		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
 		mmp.o indirect.o extents_status.o xattr.o xattr_user.o \
 		xattr_trusted.o inline.o readpage.o sysfs.o
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_RESIZE)		+= resize.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 282a51b..819a07b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2555,14 +2555,6 @@ extern int ext4_generic_delete_entry(handle_t *handle,
 				     int csum_size);
 extern bool ext4_empty_dir(struct inode *inode);
 
-/* resize.c */
-extern int ext4_group_add(struct super_block *sb,
-				struct ext4_new_group_data *input);
-extern int ext4_group_extend(struct super_block *sb,
-				struct ext4_super_block *es,
-				ext4_fsblk_t n_blocks_count);
-extern int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count);
-
 /* super.c */
 extern int ext4_seq_options_show(struct seq_file *seq, void *offset);
 extern int ext4_calculate_overhead(struct super_block *sb);
@@ -3239,10 +3231,6 @@ static inline void ext4_inode_resume_unlocked_dio(struct inode *inode)
 					    EXT4_WQ_HASH_SZ])
 extern wait_queue_head_t ext4__ioend_wq[EXT4_WQ_HASH_SZ];
 
-#define EXT4_RESIZING	0
-extern int ext4_resize_begin(struct super_block *sb);
-extern void ext4_resize_end(struct super_block *sb);
-
 static inline void ext4_set_io_unwritten_flag(struct inode *inode,
 					      struct ext4_io_end *io_end)
 {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bf5ae8e..81d28d2 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -18,6 +18,7 @@
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
+#include "resize.h"
 
 /**
  * Swap memory between @a and @b for @len bytes.
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index cf68100..8192194 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -5,7 +5,6 @@
  *
  * Copyright (C) 2001, 2002 Andreas Dilger <adilger@clusterfs.com>
  *
- * This could probably be made into a module, because it is not often in use.
  */
 
 
@@ -15,6 +14,7 @@
 #include <linux/slab.h>
 
 #include "ext4_jbd2.h"
+#include "resize.h"
 
 int ext4_resize_begin(struct super_block *sb)
 {
diff --git a/fs/ext4/resize.h b/fs/ext4/resize.h
new file mode 100644
index 0000000..1375434
--- /dev/null
+++ b/fs/ext4/resize.h
@@ -0,0 +1,42 @@
+/*
+ * linux/fs/ext4/resize.h
+ *
+ */
+
+#define EXT4_RESIZING	0
+
+#if IS_ENABLED(CONFIG_EXT4_RESIZE)
+extern int ext4_resize_fs(struct super_block *, ext4_fsblk_t);
+extern int ext4_resize_begin(struct super_block *);
+extern void ext4_resize_end(struct super_block *);
+extern int ext4_group_add(struct super_block *, struct ext4_new_group_data *);
+extern int ext4_group_extend(struct super_block *, struct ext4_super_block *,
+			     ext4_fsblk_t);
+#else
+static int ext4_resize_begin(struct super_block *sb)
+{
+	return -EOPNOTSUPP;
+}
+
+static void ext4_resize_end(struct super_block *sb)
+{
+}
+
+static inline int ext4_group_add(struct super_block *sb,
+				 struct ext4_new_group_data *input)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ext4_group_extend(struct super_block *sb,
+		struct ext4_super_block *es, ext4_fsblk_t n_blocks_count)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ext4_resize_fs(struct super_block *sb,
+				 ext4_fsblk_t n_blocks_count)
+{
+	return -EOPNOTSUPP;
+}
+#endif
-- 
2.9.3
