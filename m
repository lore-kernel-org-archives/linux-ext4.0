From: Joe Perches <joe@perches.com>
Subject: [PATCH 2/2] ext3: Reduce object size when !CONFIG_PRINTK
Date: Tue, 18 Jun 2013 10:14:40 -0700
Message-ID: <ef68d49cc50ebab3d84f90154488f51d929e68ce.1371575536.git.joe@perches.com>
References: <2e70d518b9f6b8eea33c01a36983a1ccb1839282.1371575536.git.joe@perches.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2e70d518b9f6b8eea33c01a36983a1ccb1839282.1371575536.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Reducing the object size ~11kb/12% could be useful for embedded
systems.

Add #ifdef CONFIG_PRINTK #else #endif blocks
to hold formats and arguments, passing " " to
functions when !CONFIG_PRINTK and still verifying
format and arguments with no_printk.

 $ size fs/ext3/built-in.o*
    text   data	    bss	    dec	    hex	filename
   79857     51	      8	  79916	  1382c	fs/ext3/built-in.o.new
   90958     51	      8	  91017	  16389	fs/ext3/built-in.o.old

 $ grep -E "CONFIG_EXT3|CONFIG_PRINTK" .config
 # CONFIG_PRINTK is not set
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext3/ext3.h  | 44 ++++++++++++++++++++++++++++++++++++++++----
 fs/ext3/super.c | 14 +++++++-------
 2 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index e85ff15..8aa33f8 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -1081,14 +1081,14 @@ extern int ext3_group_extend(struct super_block *sb,
 
 /* super.c */
 extern __printf(3, 4)
-void ext3_error(struct super_block *, const char *, const char *, ...);
+void __ext3_error(struct super_block *, const char *, const char *, ...);
 extern void __ext3_std_error (struct super_block *, const char *, int);
 extern __printf(3, 4)
-void ext3_abort(struct super_block *, const char *, const char *, ...);
+void __ext3_abort(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
-void ext3_warning(struct super_block *, const char *, const char *, ...);
+void __ext3_warning(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
-void ext3_msg(struct super_block *, const char *, const char *, ...);
+void __ext3_msg(struct super_block *, const char *, const char *, ...);
 extern void ext3_update_dynamic_rev (struct super_block *sb);
 
 #define ext3_std_error(sb, errno)				\
@@ -1097,6 +1097,42 @@ do {								\
 		__ext3_std_error((sb), __func__, (errno));	\
 } while (0)
 
+#ifdef CONFIG_PRINTK
+
+#define ext3_error(sb, func, fmt, ...)					\
+	__ext3_error(sb, func, fmt, ##__VA_ARGS__)
+#define ext3_abort(sb, func, fmt, ...)					\
+	__ext3_abort(sb, func, fmt, ##__VA_ARGS__)
+#define ext3_warning(sb, func, fmt, ...)				\
+	__ext3_warning(sb, func, fmt, ##__VA_ARGS__)
+#define ext3_msg(sb, prefix, fmt, ...)					\
+	__ext3_msg(sb, prefix, fmt, ##__VA_ARGS__)
+
+#else
+
+#define ext3_error(sb, func, fmt, ...)					\
+do {									\
+	no_printk(fmt, ##__VA_ARGS__);					\
+	__ext3_error(sb, func, " ");					\
+} while (0)
+#define ext3_abort(sb, func, fmt, ...)					\
+do {									\
+	no_printk(fmt, ##__VA_ARGS__);					\
+	__ext3_abort(sb, func, " ");					\
+} while (0)
+#define ext3_warning(sb, func, fmt, ...)				\
+do {									\
+	no_printk(fmt, ##__VA_ARGS__);					\
+	__ext3_warning(sb, func, " ");					\
+} while (0)
+#define ext3_msg(sb, prefix, fmt, ...)					\
+do {									\
+	no_printk(fmt, ##__VA_ARGS__);					\
+	__ext3_msg(sb, prefix, " ");					\
+} while (0)
+
+#endif
+
 /*
  * Inodes and files operations
  */
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6356665..b7c3afc 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -123,7 +123,7 @@ void ext3_journal_abort_handle(const char *caller, const char *err_fn,
 	journal_abort_handle(handle);
 }
 
-void ext3_msg(struct super_block *sb, const char *prefix,
+void __ext3_msg(struct super_block *sb, const char *prefix,
 		const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -182,8 +182,8 @@ static void ext3_handle_error(struct super_block *sb)
 			sb->s_id);
 }
 
-void ext3_error(struct super_block *sb, const char *function,
-		const char *fmt, ...)
+void __ext3_error(struct super_block *sb, const char *function,
+		  const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -266,8 +266,8 @@ void __ext3_std_error (struct super_block * sb, const char * function,
  * case we take the easy way out and panic immediately.
  */
 
-void ext3_abort(struct super_block *sb, const char *function,
-		 const char *fmt, ...)
+void __ext3_abort(struct super_block *sb, const char *function,
+		  const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -297,8 +297,8 @@ void ext3_abort(struct super_block *sb, const char *function,
 		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
 }
 
-void ext3_warning(struct super_block *sb, const char *function,
-		  const char *fmt, ...)
+void __ext3_warning(struct super_block *sb, const char *function,
+		    const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-- 
1.8.1.2.459.gbcd45b4.dirty
