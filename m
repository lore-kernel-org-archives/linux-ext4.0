From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
Date: Tue, 25 Sep 2007 08:41:53 -0500
Message-ID: <20070925084153.36ab65a5@gara>
References: <1190713240.3154.20.camel@castor.rsk.org>
	<20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
	<46F8EB26.2090104@linux.vnet.ibm.com>
	<20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
	<20070925074938.2321bc15@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	richard kennedy <richard@rsk.demon.co.uk>, sct@redhat.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:36406 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXIYNl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 09:41:56 -0400
In-Reply-To: <20070925074938.2321bc15@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Sep 2007 07:49:38 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:

> On Tue, 25 Sep 2007 13:50:46 +0200
> Jan Kara <jack@ucw.cz> wrote:
> > > Jan Kara wrote:
> > > >>
> > > >-#define create_jbd_proc_entry() do {} while (0)
> > > >-#define remove_jbd_proc_entry() do {} while (0)
> > > >+static ctl_table fs_table[] = {
> > > >+	{
> > > >+                .ctl_name       = -1,	/* Don't want it */
> > > 
> > > 
> > > 
> > > shouldn't this be CTL_UNNUMBERED ?
> >   Oh, it should be. I didn't notice we have this :) Thanks for notifying
> > me. Attached is a fixed version.
> 
> This was fixed in JBD2 by moving the jbd-debug file to debugfs:
> http://lkml.org/lkml/2007/7/11/334
> 
> Since this code is already in the kernel, we should keep it consistent. 
> 

OK.  Here's a quick patch to fix this.  Adapted from the JBD2 patch.
Let me know what you think.

-JRS

commit 6cbd2ce05b7504514707ce825170a5d77abf6a6e
Author: root <root@toolssf2.ltc.austin.ibm.com>
Date:   Thu Jun 14 09:40:09 2007 -0500

    The jbd-debug file used to be located in /proc/sys/fs/jbd-debug, but
    create_proc_entry() does not do lookups on file names that are more that one
    directory deep.  This causes the entry creation to fail and hence, no proc
    file is created.
    
    Instead of fixing this on procfs might as well move the jbd2-debug file to
    debugfs which would be the preferred location for this kind of tunable.  The
    new location is now /sys/kernel/debug/jbd/jbd-debug.
    
    
    Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

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
index 06ab3c1..3cad624 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -35,6 +35,7 @@
 #include <linux/kthread.h>
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
+#include <linux/debugfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -1939,63 +1940,38 @@ void journal_put_journal_head(struct journal_head *jh)
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
 
@@ -2054,7 +2030,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		journal_destroy_caches();
-	create_jbd_proc_entry();
+	create_jbd_debugfs_entry();
 	return ret;
 }
 
@@ -2065,7 +2041,7 @@ static void __exit journal_exit(void)
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
