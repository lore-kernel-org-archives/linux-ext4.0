From: Jan Kara <jack@ucw.cz>
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
Date: Tue, 25 Sep 2007 13:50:46 +0200
Message-ID: <20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
References: <1190713240.3154.20.camel@castor.rsk.org> <20070925105112.GB8126@atrey.karlin.mff.cuni.cz> <46F8EB26.2090104@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: richard kennedy <richard@rsk.demon.co.uk>, sct@redhat.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57343 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXIYLur (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 07:50:47 -0400
Content-Disposition: inline
In-Reply-To: <46F8EB26.2090104@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> 
> 
> Jan Kara wrote:
> >>
> >-#define create_jbd_proc_entry() do {} while (0)
> >-#define remove_jbd_proc_entry() do {} while (0)
> >+static ctl_table fs_table[] = {
> >+	{
> >+                .ctl_name       = -1,	/* Don't want it */
> 
> 
> 
> shouldn't this be CTL_UNNUMBERED ?
  Oh, it should be. I didn't notice we have this :) Thanks for notifying
me. Attached is a fixed version.

> 
> >+                .procname       = "jbd-debug",
> >+                .data           = &journal_enable_debug,
> >+                .maxlen         = sizeof(int),
> >+                .mode           = 0644,
> >+                .proc_handler   = &proc_dointvec,
> >+        },
> >+        { .ctl_name = 0 },
> >+};
> >

--------

JBD debug code used old way of creating proc entries for jbd-debug file.
Change it to use sysctl instead.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc6/fs/jbd/journal.c linux-2.6.23-rc6-1-jbddebug_fix/fs/jbd/journal.c
--- linux-2.6.23-rc6/fs/jbd/journal.c	2007-09-25 12:39:53.000000000 +0200
+++ linux-2.6.23-rc6-1-jbddebug_fix/fs/jbd/journal.c	2007-09-25 14:09:11.000000000 +0200
@@ -1944,58 +1944,29 @@ void journal_put_journal_head(struct jou
 #if defined(CONFIG_JBD_DEBUG)
 int journal_enable_debug;
 EXPORT_SYMBOL(journal_enable_debug);
-#endif
-
-#if defined(CONFIG_JBD_DEBUG) && defined(CONFIG_PROC_FS)
-
-static struct proc_dir_entry *proc_jbd_debug;
-
-static int read_jbd_debug(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
-{
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
+static struct ctl_table_header *jbd_debug_table;
 
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
-}
-
-static void __exit remove_jbd_proc_entry(void)
-{
-	if (proc_jbd_debug)
-		remove_proc_entry(JBD_PROC_NAME, NULL);
-}
-
-#else
-
-#define create_jbd_proc_entry() do {} while (0)
-#define remove_jbd_proc_entry() do {} while (0)
+static ctl_table fs_table[] = {
+	{
+                .ctl_name       = CTL_UNNUMBERED,
+                .procname       = "jbd-debug",
+                .data           = &journal_enable_debug,
+                .maxlen         = sizeof(int),
+                .mode           = 0644,
+                .proc_handler   = &proc_dointvec,
+        },
+        { .ctl_name = 0 },
+};
+
+static ctl_table sys_table[] = {
+        {
+                .ctl_name       = CTL_FS,
+                .procname       = "fs",
+                .mode           = 0555,
+                .child          = fs_table,
+        },
+        { .ctl_name = 0 },
+};
 
 #endif
 
@@ -2054,7 +2025,10 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		journal_destroy_caches();
-	create_jbd_proc_entry();
+
+#ifdef CONFIG_JBD_DEBUG
+	jbd_debug_table = register_sysctl_table(sys_table);
+#endif
 	return ret;
 }
 
@@ -2064,8 +2038,8 @@ static void __exit journal_exit(void)
 	int n = atomic_read(&nr_journal_heads);
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
+	unregister_sysctl_table(jbd_debug_table);
 #endif
-	remove_jbd_proc_entry();
 	journal_destroy_caches();
 }
 
