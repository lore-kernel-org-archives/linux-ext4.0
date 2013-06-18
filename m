From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/2] ext2: Reduce object size when !CONFIG_PRINTK
Date: Tue, 18 Jun 2013 10:14:39 -0700
Message-ID: <2e70d518b9f6b8eea33c01a36983a1ccb1839282.1371575536.git.joe@perches.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Reducing the object size ~5kb/15% could be useful for embedded
systems.

Add #ifdef CONFIG_PRINTK #else #endif blocks
to hold formats and arguments, passing " " to
functions when !CONFIG_PRINTK and still verifying
format and arguments with no_printk.

 $ size fs/ext2/built-in.o*
    text   data	    bss	    dec	    hex	filename
   31297     44	      4	  31345	   7a71	fs/ext2/built-in.o.ext2.new
   36288     44	      4	  36336	   8df0	fs/ext2/built-in.o.ext2.old

 $ grep -E "CONFIG_EXT2|CONFIG_PRINTK" .config
 # CONFIG_PRINTK is not set
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
 # CONFIG_EXT2_FS_XIP is not set

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext2/ext2.h  | 22 ++++++++++++++++++++--
 fs/ext2/super.c |  6 +++---
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index d9a17d0..888ae31 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -767,12 +767,30 @@ struct dentry *ext2_get_parent(struct dentry *child);
 
 /* super.c */
 extern __printf(3, 4)
-void ext2_error(struct super_block *, const char *, const char *, ...);
+void __ext2_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
-void ext2_msg(struct super_block *, const char *, const char *, ...);
+void __ext2_msg(struct super_block *, const char *, const char *, ...);
 extern void ext2_update_dynamic_rev (struct super_block *sb);
 extern void ext2_write_super (struct super_block *);
 
+#ifdef CONFIG_PRINTK
+#define ext2_error(sb, func, fmt, ...)					\
+	__ext2_error(sb, func, fmt, ##__VA_ARGS__)
+#define ext2_msg(sb, prefix, fmt, ...)					\
+	__ext2_msg(sb, prefix, fmt, ##__VA_ARGS__)
+#else
+#define ext2_error(sb, func, fmt, ...)					\
+do {									\
+	no_printk(fmt, ##__VA_ARGS__);					\
+	__ext2_error(sb, func, " ");					\
+} while (0)
+#define ext2_msg(sb, prefix, fmt, ...)					\
+do {									\
+	no_printk(fmt, ##__VA_ARGS__);					\
+	__ext2_msg(sb, prefix, " ");					\
+} while (0)
+#endif
+
 /*
  * Inodes and files operations
  */
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 2885349..61ffb3f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -45,8 +45,8 @@ static int ext2_sync_fs(struct super_block *sb, int wait);
 static int ext2_freeze(struct super_block *sb);
 static int ext2_unfreeze(struct super_block *sb);
 
-void ext2_error(struct super_block *sb, const char *function,
-		const char *fmt, ...)
+void __ext2_error(struct super_block *sb, const char *function,
+		  const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -80,7 +80,7 @@ void ext2_error(struct super_block *sb, const char *function,
 	}
 }
 
-void ext2_msg(struct super_block *sb, const char *prefix,
+void __ext2_msg(struct super_block *sb, const char *prefix,
 		const char *fmt, ...)
 {
 	struct va_format vaf;
-- 
1.8.1.2.459.gbcd45b4.dirty
