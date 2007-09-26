From: akpm@linux-foundation.org
Subject: + jbd-config_jbd_debug-cannot-create-proc-entry.patch added to -mm tree
Date: Wed, 26 Sep 2007 14:35:46 -0700
Message-ID: <200709262135.l8QLZkhg005069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jrs@us.ibm.com, jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: config_jbd_debug cannot create /proc entry
has been added to the -mm tree.  Its filename is
     jbd-config_jbd_debug-cannot-create-proc-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jbd: config_jbd_debug cannot create /proc entry
From: "Jose R. Santos" <jrs@us.ibm.com>

The jbd-debug file used to be located in /proc/sys/fs/jbd-debug, but
create_proc_entry() does not do lookups on file names that are more that
one directory deep.  This causes the entry creation to fail and hence, no
proc file is created.

Instead of fixing this on procfs might as well move the jbd2-debug file to
debugfs which would be the preferred location for this kind of tunable. 
The new location is now /sys/kernel/debug/jbd/jbd-debug.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/Kconfig~jbd-config_jbd_debug-cannot-create-proc-entry fs/Kconfig
--- a/fs/Kconfig~jbd-config_jbd_debug-cannot-create-proc-entry
+++ a/fs/Kconfig
@@ -219,7 +219,7 @@ config JBD
 
 config JBD_DEBUG
 	bool "JBD (ext3) debugging support"
-	depends on JBD
+	depends on JBD && DEBUG_FS
 	help
 	  If you are using the ext3 journaled file system (or potentially any
 	  other file system/device using JBD), this option allows you to
@@ -228,10 +228,10 @@ config JBD_DEBUG
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
@@ -1850,63 +1851,38 @@ void journal_put_journal_head(struct jou
 }
 
 /*
- * /proc tunables
+ * debugfs tunables
  */
 #if defined(CONFIG_JBD_DEBUG)
-int journal_enable_debug;
+u8 journal_enable_debug;
 EXPORT_SYMBOL(journal_enable_debug);
 #endif
 
-#if defined(CONFIG_JBD_DEBUG) && defined(CONFIG_PROC_FS)
+#if defined(CONFIG_JBD_DEBUG) && defined(CONFIG_DEBUG_FS)
 
-static struct proc_dir_entry *proc_jbd_debug;
+struct dentry  *jbd_debugfs_dir, *jbd_debug;
 
-static int read_jbd_debug(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static void __init create_jbd_debugfs_entry(void)
 {
-	int ret;
-
-	ret = sprintf(page + off, "%d\n", journal_enable_debug);
-	*eof = 1;
-	return ret;
-}
-
-static int write_jbd_debug(struct file *file, const char __user *buffer,
-			   unsigned long count, void *data)
-{
-	char buf[32];
-
-	if (count > ARRAY_SIZE(buf) - 1)
-		count = ARRAY_SIZE(buf) - 1;
-	if (copy_from_user(buf, buffer, count))
-		return -EFAULT;
-	buf[ARRAY_SIZE(buf) - 1] = '\0';
-	journal_enable_debug = simple_strtoul(buf, NULL, 10);
-	return count;
-}
-
-#define JBD_PROC_NAME "sys/fs/jbd-debug"
-
-static void __init create_jbd_proc_entry(void)
-{
-	proc_jbd_debug = create_proc_entry(JBD_PROC_NAME, 0644, NULL);
-	if (proc_jbd_debug) {
-		/* Why is this so hard? */
-		proc_jbd_debug->read_proc = read_jbd_debug;
-		proc_jbd_debug->write_proc = write_jbd_debug;
-	}
+	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
+	if (jbd_debugfs_dir)
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+					       jbd_debugfs_dir,
+					       &journal_enable_debug);
 }
 
-static void __exit remove_jbd_proc_entry(void)
+static void __exit remove_jbd_debugfs_entry(void)
 {
-	if (proc_jbd_debug)
-		remove_proc_entry(JBD_PROC_NAME, NULL);
+	if (jbd_debug)
+		debugfs_remove(jbd_debug);
+	if (jbd_debugfs_dir)
+		debugfs_remove(jbd_debugfs_dir);
 }
 
 #else
 
-#define create_jbd_proc_entry() do {} while (0)
-#define remove_jbd_proc_entry() do {} while (0)
+#define create_jbd_debugfs_entry() do {} while (0)
+#define remove_jbd_debugfs_entry() do {} while (0)
 
 #endif
 
@@ -1964,7 +1940,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		journal_destroy_caches();
-	create_jbd_proc_entry();
+	create_jbd_debugfs_entry();
 	return ret;
 }
 
@@ -1975,7 +1951,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
-	remove_jbd_proc_entry();
+	remove_jbd_debugfs_entry();
 	journal_destroy_caches();
 }
 
diff -puN include/linux/jbd.h~jbd-config_jbd_debug-cannot-create-proc-entry include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-config_jbd_debug-cannot-create-proc-entry
+++ a/include/linux/jbd.h
@@ -57,7 +57,7 @@
  * CONFIG_JBD_DEBUG is on.
  */
 #define JBD_EXPENSIVE_CHECKING
-extern int journal_enable_debug;
+extern u8 journal_enable_debug;
 
 #define jbd_debug(n, f, a...)						\
 	do {								\
_

Patches currently in -mm which might be from jrs@us.ibm.com are

jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
ext4-flex_bg-kernel-support-v2.patch
