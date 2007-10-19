From: akpm@linux-foundation.org
Subject: [patch 017/144] jbd: config_jbd_debug cannot create /proc entry
Date: Thu, 18 Oct 2007 23:24:03 -0700
Message-ID: <200710190624.l9J6O3Ta019257@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jrs@us.ibm.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757216AbXJSGYd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Oct 2007 02:24:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: "Jose R. Santos" <jrs@us.ibm.com>

The jbd-debug file used to be located in /proc/sys/fs/jbd-debug, but
create_proc_entry() does not do lookups on file names that are more that
one directory deep.  This causes the entry creation to fail and hence, no
proc file is created.

Instead of fixing this on procfs might as well move the jbd2-debug file to
debugfs which would be the preferred location for this kind of tunable. 
The new location is now /sys/kernel/debug/jbd/jbd-debug.

[akpm@linux-foundation.org: zillions of cleanups]
Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig          |   10 +++---
 fs/jbd/journal.c    |   64 +++++++++++++-----------------------------
 include/linux/jbd.h |    2 -
 3 files changed, 27 insertions(+), 49 deletions(-)

diff -puN fs/Kconfig~jbd-config_jbd_debug-cannot-create-proc-entry fs/Kconfig
--- a/fs/Kconfig~jbd-config_jbd_debug-cannot-create-proc-entry
+++ a/fs/Kconfig
@@ -220,7 +220,7 @@ config JBD
 
 config JBD_DEBUG
 	bool "JBD (ext3) debugging support"
-	depends on JBD
+	depends on JBD && DEBUG_FS
 	help
 	  If you are using the ext3 journaled file system (or potentially any
 	  other file system/device using JBD), this option allows you to
@@ -229,10 +229,10 @@ config JBD_DEBUG
 	  debugging output will be turned off.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with "echo N > /proc/sys/fs/jbd-debug", where N is a number between
-	  1 and 5, the higher the number, the more debugging output is
-	  generated.  To turn debugging off again, do
-	  "echo 0 > /proc/sys/fs/jbd-debug".
+	  with "echo N > /sys/kernel/debug/jbd/jbd-debug", where N is a
+	  number between 1 and 5, the higher the number, the more debugging
+	  output is generated.  To turn debugging off again, do
+	  "echo 0 > /sys/kernel/debug/jbd/jbd-debug".
 
 config JBD2
 	tristate
diff -puN fs/jbd/journal.c~jbd-config_jbd_debug-cannot-create-proc-entry fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-config_jbd_debug-cannot-create-proc-entry
+++ a/fs/jbd/journal.c
@@ -35,6 +35,7 @@
 #include <linux/kthread.h>
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
+#include <linux/debugfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -1851,64 +1852,41 @@ void journal_put_journal_head(struct jou
 }
 
 /*
- * /proc tunables
+ * debugfs tunables
  */
-#if defined(CONFIG_JBD_DEBUG)
-int journal_enable_debug;
-EXPORT_SYMBOL(journal_enable_debug);
-#endif
+#ifdef CONFIG_JBD_DEBUG
 
-#if defined(CONFIG_JBD_DEBUG) && defined(CONFIG_PROC_FS)
+u8 journal_enable_debug __read_mostly;
+EXPORT_SYMBOL(journal_enable_debug);
 
-static struct proc_dir_entry *proc_jbd_debug;
+static struct dentry *jbd_debugfs_dir;
+static struct dentry *jbd_debug;
 
-static int read_jbd_debug(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static void __init jbd_create_debugfs_entry(void)
 {
-	int ret;
-
-	ret = sprintf(page + off, "%d\n", journal_enable_debug);
-	*eof = 1;
-	return ret;
+	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
+	if (jbd_debugfs_dir)
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+					       jbd_debugfs_dir,
+					       &journal_enable_debug);
 }
 
-static int write_jbd_debug(struct file *file, const char __user *buffer,
-			   unsigned long count, void *data)
+static void __exit jbd_remove_debugfs_entry(void)
 {
-	char buf[32];
-
-	if (count > ARRAY_SIZE(buf) - 1)
-		count = ARRAY_SIZE(buf) - 1;
-	if (copy_from_user(buf, buffer, count))
-		return -EFAULT;
-	buf[ARRAY_SIZE(buf) - 1] = '\0';
-	journal_enable_debug = simple_strtoul(buf, NULL, 10);
-	return count;
+	debugfs_remove(jbd_debug);
+	debugfs_remove(jbd_debugfs_dir);
 }
 
-#define JBD_PROC_NAME "sys/fs/jbd-debug"
+#else
 
-static void __init create_jbd_proc_entry(void)
+static inline void jbd_create_debugfs_entry(void)
 {
-	proc_jbd_debug = create_proc_entry(JBD_PROC_NAME, 0644, NULL);
-	if (proc_jbd_debug) {
-		/* Why is this so hard? */
-		proc_jbd_debug->read_proc = read_jbd_debug;
-		proc_jbd_debug->write_proc = write_jbd_debug;
-	}
 }
 
-static void __exit remove_jbd_proc_entry(void)
+static inline void jbd_remove_debugfs_entry(void)
 {
-	if (proc_jbd_debug)
-		remove_proc_entry(JBD_PROC_NAME, NULL);
 }
 
-#else
-
-#define create_jbd_proc_entry() do {} while (0)
-#define remove_jbd_proc_entry() do {} while (0)
-
 #endif
 
 struct kmem_cache *jbd_handle_cache;
@@ -1965,7 +1943,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		journal_destroy_caches();
-	create_jbd_proc_entry();
+	jbd_create_debugfs_entry();
 	return ret;
 }
 
@@ -1976,7 +1954,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
-	remove_jbd_proc_entry();
+	jbd_remove_debugfs_entry();
 	journal_destroy_caches();
 }
 
diff -puN include/linux/jbd.h~jbd-config_jbd_debug-cannot-create-proc-entry include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-config_jbd_debug-cannot-create-proc-entry
+++ a/include/linux/jbd.h
@@ -58,7 +58,7 @@
  * CONFIG_JBD_DEBUG is on.
  */
 #define JBD_EXPENSIVE_CHECKING
-extern int journal_enable_debug;
+extern u8 journal_enable_debug;
 
 #define jbd_debug(n, f, a...)						\
 	do {								\
_
