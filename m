From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] JBD: Export jbd-debug via debugfs
Date: Tue, 25 Sep 2007 11:33:10 -0500
Message-ID: <20070925163310.10823.88275.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jack@suse.cz
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50415 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbXIYQgj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 12:36:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

JBD: Export jbd-debug via debugfs

The jbd-debug file used to be located in /proc/sys/fs/jbd-debug, but
create_proc_entry() does not do lookups on file names that are more that one
directory deep.  This causes the entry creation to fail and hence, no proc
file is created.

Instead of fixing this on procfs might as well move the jbd2-debug file to
debugfs which would be the preferred location for this kind of tunable.  The
new location is now /sys/kernel/debug/jbd/jbd-debug.


Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
--

 fs/Kconfig          |   10 ++++----
 fs/jbd/journal.c    |   65 ++++++++++++++++++++-------------------------------
 include/linux/jbd.h |    2 +-
 3 files changed, 31 insertions(+), 46 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 58a0650..a8937a6 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
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
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 06ab3c1..1fb59fa 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -35,6 +35,7 @@
 #include <linux/kthread.h>
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
+#include <linux/debugfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -1939,64 +1940,48 @@ void journal_put_journal_head(struct journal_head *jh)
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
+	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
+	if (jbd_debugfs_dir)
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+					       jbd_debugfs_dir,
+					       &journal_enable_debug);
 }
 
-static int write_jbd_debug(struct file *file, const char __user *buffer,
-			   unsigned long count, void *data)
+static void __exit remove_jbd_debugfs_entry(void)
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
+	if (jbd_debug)
+		debugfs_remove(jbd_debug);
+	if (jbd_debugfs_dir)
+		debugfs_remove(jbd_debugfs_dir);
 }
 
-#define JBD_PROC_NAME "sys/fs/jbd-debug"
+#else
 
-static void __init create_jbd_proc_entry(void)
+static void __init create_jbd_debugfs_entry(void)
 {
-	proc_jbd_debug = create_proc_entry(JBD_PROC_NAME, 0644, NULL);
-	if (proc_jbd_debug) {
-		/* Why is this so hard? */
-		proc_jbd_debug->read_proc = read_jbd_debug;
-		proc_jbd_debug->write_proc = write_jbd_debug;
-	}
+	do {
+	} while (0);
 }
 
-static void __exit remove_jbd_proc_entry(void)
+static void __exit remove_jbd_debugfs_entry(void)
 {
-	if (proc_jbd_debug)
-		remove_proc_entry(JBD_PROC_NAME, NULL);
+	do {
+	} while (0);
 }
 
-#else
-
-#define create_jbd_proc_entry() do {} while (0)
-#define remove_jbd_proc_entry() do {} while (0)
-
 #endif
 
 struct kmem_cache *jbd_handle_cache;
@@ -2054,7 +2039,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		journal_destroy_caches();
-	create_jbd_proc_entry();
+	create_jbd_debugfs_entry();
 	return ret;
 }
 
@@ -2065,7 +2050,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
-	remove_jbd_proc_entry();
+	remove_jbd_debugfs_entry();
 	journal_destroy_caches();
 }
 
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 4527375..526548d 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -57,7 +57,7 @@
  * CONFIG_JBD_DEBUG is on.
  */
 #define JBD_EXPENSIVE_CHECKING
-extern int journal_enable_debug;
+extern u8 journal_enable_debug;
 
 #define jbd_debug(n, f, a...)						\
 	do {								\
