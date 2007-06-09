From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH][RFC] JBD2: Use DebugFS for jbd2 debug config option.
Date: Fri, 8 Jun 2007 22:57:41 -0500
Message-ID: <20070608225741.58dc7459@gara>
References: <20070607234537.56537f85@gara>
	<20070608070812.GE5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49203 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbXFID6S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2007 23:58:18 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l593riW0011760
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 23:53:44 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l593w2KL210616
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 21:58:07 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l593w2A2021413
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 21:58:02 -0600
In-Reply-To: <20070608070812.GE5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 8 Jun 2007 01:08:12 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Jun 07, 2007  23:45 -0500, Jose R. Santos wrote:
> > The jbd2-debug file used to be located in /proc/sys/fs/jbd2-debug, but
> > create_proc_entry() does not do lookups on file names with more that one
> > directory deep.  This causes the entry creation to fail and hence, no proc
> > file is created.  This patch moves the file to /proc/jbd2-degug.
> > 
> > The file could be move to /proc/fs/jbd2/jbd2-debug, but it would require
> > some minor alterations to the jbd-stats patch.
> 
> I don't think we really want to be adding top-level files in /proc.
> What about using the "debugfs" filesystem (not to be confused with
> the e2fsprogs 'debugfs' command)?

How about this then?  Moved the file to use debugfs as well as having
the nice effect of removing more lines than what it adds.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---
 fs/jbd2/journal.c    |   62    20 +    42 -    0 !
 include/linux/jbd2.h |    2    1 +     1 -     0 !
 2 files changed, 21 insertions(+), 43 deletions(-)

Index: linux-2.6.22-rc4/fs/jbd2/journal.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/jbd2/journal.c	2007-06-08 15:03:14.353372404 -0500
+++ linux-2.6.22-rc4/fs/jbd2/journal.c	2007-06-08 22:44:04.476375738 -0500
@@ -36,6 +36,7 @@
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/debugfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -2256,60 +2257,37 @@ void jbd2_journal_put_journal_head(struc
  * /proc tunables
  */
 #if defined(CONFIG_JBD2_DEBUG)
-int jbd2_journal_enable_debug;
+u16 jbd2_journal_enable_debug;
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
-
-	ret = sprintf(page + off, "%d\n", jbd2_journal_enable_debug);
-	*eof = 1;
-	return ret;
-}
+struct dentry *jbd2_debugfs_dir, *jbd2_debug;
 
-static int write_jbd_debug(struct file *file, const char __user *buffer,
-			   unsigned long count, void *data)
+static void __init jbd2_create_debugfs_entry(void)
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
-}
-
-#define JBD_PROC_NAME "sys/fs/jbd2-debug"
-
-static void __init create_jbd_proc_entry(void)
-{
-	proc_jbd_debug = create_proc_entry(JBD_PROC_NAME, 0644, NULL);
-	if (proc_jbd_debug) {
-		/* Why is this so hard? */
-		proc_jbd_debug->read_proc = read_jbd_debug;
-		proc_jbd_debug->write_proc = write_jbd_debug;
-	}
+	jbd2_debugfs_dir = debugfs_create_dir("jbd2", NULL);
+	if (jbd2_debugfs_dir)
+		jbd2_debug = debugfs_create_u16(JBD2_DEBUG_NAME, S_IRUGO,
+						jbd2_debugfs_dir,
+						&jbd2_journal_enable_debug);
 }
 
-static void __exit jbd2_remove_jbd_proc_entry(void)
+static void __exit jbd2_remove_debugfs_entry(void)
 {
-	if (proc_jbd_debug)
-		remove_proc_entry(JBD_PROC_NAME, NULL);
+	if (jbd2_debug)
+		debugfs_remove(jbd2_debug);
+	if (jbd2_debugfs_dir)
+		debugfs_remove(jbd2_debugfs_dir);
 }
 
 #else
 
-#define create_jbd_proc_entry() do {} while (0)
-#define jbd2_remove_jbd_proc_entry() do {} while (0)
+#define jbd2_create_debugfs_entry() do {} while (0)
+#define jbd2_remove_debugfs_entry() do {} while (0)
 
 #endif
 
@@ -2391,7 +2369,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		jbd2_journal_destroy_caches();
-	create_jbd_proc_entry();
+	jbd2_create_debugfs_entry();
 	jbd2_create_jbd_stats_proc_entry();
 	return ret;
 }
@@ -2403,7 +2381,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
-	jbd2_remove_jbd_proc_entry();
+	jbd2_remove_debugfs_entry();
 	jbd2_remove_jbd_stats_proc_entry();
 	jbd2_journal_destroy_caches();
 }
Index: linux-2.6.22-rc4/include/linux/jbd2.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/jbd2.h	2007-06-08 18:01:41.027527067 -0500
+++ linux-2.6.22-rc4/include/linux/jbd2.h	2007-06-08 18:02:27.351010026 -0500
@@ -57,7 +57,7 @@
  * CONFIG_JBD2_DEBUG is on.
  */
 #define JBD_EXPENSIVE_CHECKING
-extern int jbd2_journal_enable_debug;
+extern u16 jbd2_journal_enable_debug;
 
 #define jbd_debug(n, f, a...)						\
 	do {								\



-JRS
