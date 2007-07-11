From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [EXT4 set 2][PATCH 5/5] cleanups: Export jbd2-debug via debugfs
Date: Wed, 11 Jul 2007 13:22:40 -0500
Message-ID: <20070711132240.2073da56@rx8>
References: <1183275408.4010.124.camel@localhost.localdomain>
	<20070710163025.9db582f8.akpm@linux-foundation.org>
	<20070711003809.3ced667b@naruto>
	<20070710232509.4838644e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52314 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXGKShd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 14:37:33 -0400
In-Reply-To: <20070710232509.4838644e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The jbd2-debug file used to be located in /proc/sys/fs/jbd2-debug, but
create_proc_entry() does not do lookups on file names that are more that one
directory deep.  This causes the entry creation to fail and hence, no proc
file is created.

Instead of fixing this on procfs might as well move the jbd2-debug file to
debugfs which would be the preferred location for this kind of tunable.  The
new location is now /sys/kernel/debug/jbd2/jbd2-debug.


Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---
 fs/Kconfig           |   10 	5 +	5 -	0 !
 fs/jbd2/journal.c    |   67 	27 +	40 -	0 !
 include/linux/jbd2.h |    2 	1 +	1 -	0 !
 3 files changed, 33 insertions(+), 46 deletions(-)

Index: linux-2.6/fs/jbd2/journal.c
===================================================================
--- linux-2.6.orig/fs/jbd2/journal.c	2007-07-11 09:46:25.000000000 -0500
+++ linux-2.6/fs/jbd2/journal.c	2007-07-11 11:31:30.000000000 -0500
@@ -35,6 +35,7 @@
 #include <linux/kthread.h>
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
+#include <linux/debugfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -1951,64 +1952,50 @@ void jbd2_journal_put_journal_head(struc
 }
 
 /*
- * /proc tunables
+ * debugfs tunables
  */
 #if defined(CONFIG_JBD2_DEBUG)
-int jbd2_journal_enable_debug;
+u8 jbd2_journal_enable_debug;
 EXPORT_SYMBOL(jbd2_journal_enable_debug);
 #endif
 
-#if defined(CONFIG_JBD2_DEBUG) && defined(CONFIG_PROC_FS)
+#if defined(CONFIG_JBD2_DEBUG) && defined(CONFIG_DEBUG_FS)
 
-static struct proc_dir_entry *proc_jbd_debug;
+#define JBD2_DEBUG_NAME "jbd2-debug"
 
-static int read_jbd_debug(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
-{
-	int ret;
+struct dentry *jbd2_debugfs_dir, *jbd2_debug;
 
-	ret = sprintf(page + off, "%d\n", jbd2_journal_enable_debug);
-	*eof = 1;
-	return ret;
+static void __init jbd2_create_debugfs_entry(void)
+{
+	jbd2_debugfs_dir = debugfs_create_dir("jbd2", NULL);
+	if (jbd2_debugfs_dir)
+		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME, S_IRUGO,
+					       jbd2_debugfs_dir,
+					       &jbd2_journal_enable_debug);
 }
 
-static int write_jbd_debug(struct file *file, const char __user *buffer,
-			   unsigned long count, void *data)
+static void __exit jbd2_remove_debugfs_entry(void)
 {
-	char buf[32];
-
-	if (count > ARRAY_SIZE(buf) - 1)
-		count = ARRAY_SIZE(buf) - 1;
-	if (copy_from_user(buf, buffer, count))
-		return -EFAULT;
-	buf[ARRAY_SIZE(buf) - 1] = '\0';
-	jbd2_journal_enable_debug = simple_strtoul(buf, NULL, 10);
-	return count;
+	if (jbd2_debug)
+		debugfs_remove(jbd2_debug);
+	if (jbd2_debugfs_dir)
+		debugfs_remove(jbd2_debugfs_dir);
 }
 
-#define JBD_PROC_NAME "sys/fs/jbd2-debug"
+#else
 
-static void __init create_jbd_proc_entry(void)
+static void __init jbd2_create_debugfs_entry(void)
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
 
-static void __exit jbd2_remove_jbd_proc_entry(void)
+static void __exit jbd2_remove_debugfs_entry(void)
 {
-	if (proc_jbd_debug)
-		remove_proc_entry(JBD_PROC_NAME, NULL);
+	do {
+	} while (0);
 }
 
-#else
-
-#define create_jbd_proc_entry() do {} while (0)
-#define jbd2_remove_jbd_proc_entry() do {} while (0)
-
 #endif
 
 struct kmem_cache *jbd2_handle_cache;
@@ -2067,7 +2054,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		jbd2_journal_destroy_caches();
-	create_jbd_proc_entry();
+	jbd2_create_debugfs_entry();
 	return ret;
 }
 
@@ -2078,7 +2065,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
-	jbd2_remove_jbd_proc_entry();
+	jbd2_remove_debugfs_entry();
 	jbd2_journal_destroy_caches();
 }
 
Index: linux-2.6/include/linux/jbd2.h
===================================================================
--- linux-2.6.orig/include/linux/jbd2.h	2007-07-11 09:46:25.000000000 -0500
+++ linux-2.6/include/linux/jbd2.h	2007-07-11 10:37:06.000000000 -0500
@@ -57,7 +57,7 @@
  * CONFIG_JBD2_DEBUG is on.
  */
 #define JBD_EXPENSIVE_CHECKING
-extern int jbd2_journal_enable_debug;
+extern u8 jbd2_journal_enable_debug;
 
 #define jbd_debug(n, f, a...)						\
 	do {								\
Index: linux-2.6/fs/Kconfig
===================================================================
--- linux-2.6.orig/fs/Kconfig	2007-06-22 09:45:51.000000000 -0500
+++ linux-2.6/fs/Kconfig	2007-07-11 12:23:04.000000000 -0500
@@ -251,7 +251,7 @@ config JBD2
 
 config JBD2_DEBUG
 	bool "JBD2 (ext4dev/ext4) debugging support"
-	depends on JBD2
+	depends on JBD2 && DEBUG_FS
 	help
 	  If you are using the ext4dev/ext4 journaled file system (or
 	  potentially any other filesystem/device using JBD2), this option
@@ -260,10 +260,10 @@ config JBD2_DEBUG
 	  By default, the debugging output will be turned off.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with "echo N > /proc/sys/fs/jbd2-debug", where N is a number between
-	  1 and 5. The higher the number, the more debugging output is
-	  generated.  To turn debugging off again, do
-	  "echo 0 > /proc/sys/fs/jbd2-debug".
+	  with "echo N > /sys/kernel/debug/jbd2/jbd2-debug", where N is a
+	  number between 1 and 5. The higher the number, the more debugging
+	  output is generated.  To turn debugging off again, do
+	  "echo 0 > /sys/kernel/debug/jbd2/jbd2-debug".
 
 config FS_MBCACHE
 # Meta block cache for Extended Attributes (ext2/ext3/ext4)
