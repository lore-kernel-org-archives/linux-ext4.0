From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
Date: Wed, 26 Sep 2007 14:35:39 -0700
Message-ID: <20070926143539.b01bc0bc.akpm@linux-foundation.org>
References: <1190713240.3154.20.camel@castor.rsk.org>
	<20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
	<46F8EB26.2090104@linux.vnet.ibm.com>
	<20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
	<20070925074938.2321bc15@gara>
	<20070925084153.36ab65a5@gara>
	<20070925143608.GB18758@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jrs@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	richard@rsk.demon.co.uk, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106AbXIZVhE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2007 17:37:04 -0400
In-Reply-To: <20070925143608.GB18758@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Sep 2007 16:36:08 +0200
Jan Kara <jack@suse.cz> wrote:

> > On Tue, 25 Sep 2007 07:49:38 -0500
> > "Jose R. Santos" <jrs@us.ibm.com> wrote:
> > 
> > > On Tue, 25 Sep 2007 13:50:46 +0200
> > > Jan Kara <jack@ucw.cz> wrote:
> > > > > Jan Kara wrote:
> > > > > >>
> > > > > >-#define create_jbd_proc_entry() do {} while (0)
> > > > > >-#define remove_jbd_proc_entry() do {} while (0)
> > > > > >+static ctl_table fs_table[] = {
> > > > > >+	{
> > > > > >+                .ctl_name       = -1,	/* Don't want it */
> > > > > 
> > > > > 
> > > > > 
> > > > > shouldn't this be CTL_UNNUMBERED ?
> > > >   Oh, it should be. I didn't notice we have this :) Thanks for notifying
> > > > me. Attached is a fixed version.
> > > 
> > > This was fixed in JBD2 by moving the jbd-debug file to debugfs:
> > > http://lkml.org/lkml/2007/7/11/334
> > > 
> > > Since this code is already in the kernel, we should keep it consistent. 
> > > 
> > 
> > OK.  Here's a quick patch to fix this.  Adapted from the JBD2 patch.
> > Let me know what you think.
>   Looks fine - exactly what I've just done here :).

hm.  I found rather a lot of issues.  If this patch is derived from the
JBD2 patch then perhaps the JBD2 patch needs some looking at.

> >     Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
>   You can add Signed-off-by: Jan Kara <jack@suse.cz>

I suspect you might be getting your signed-off-bys and acked-bys mixed up. 
(If not this patch, then the previous one).  Please see
Documentation/SubmittingPatches section 13 for the difference.

Jose, please review and if possible runtime test these proposed changes?



From: Andrew Morton <akpm@linux-foundation.org>

- use `#ifdef foo' instead of `#if defined(foo)'

- CONFIG_JBD_DEBUG depends on CONFIG_DEBUG_FS so we don't need to duplicate
  that logic in the .c file ifdefs

- Make journal_enable_debug __read_mostly just for the heck of it

- Make jbd_debugfs_dir and jbd_debug static

- debugfs_remove(NULL) is legal: remove unneeded tests

- jbd_create_debugfs_entry is a better name than create_jbd_debugfs_entry

- ditto remove_jbd_debugfs_entry

- C functions are preferred over macros

Cc: "Jose R. Santos" <jrs@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/jbd/journal.c~jbd-config_jbd_debug-cannot-create-proc-entry-fix fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-config_jbd_debug-cannot-create-proc-entry-fix
+++ a/fs/jbd/journal.c
@@ -1853,16 +1853,15 @@ void journal_put_journal_head(struct jou
 /*
  * debugfs tunables
  */
-#if defined(CONFIG_JBD_DEBUG)
-u8 journal_enable_debug;
-EXPORT_SYMBOL(journal_enable_debug);
-#endif
+#ifdef CONFIG_JBD_DEBUG
 
-#if defined(CONFIG_JBD_DEBUG) && defined(CONFIG_DEBUG_FS)
+u8 journal_enable_debug __read_mostly;
+EXPORT_SYMBOL(journal_enable_debug);
 
-struct dentry  *jbd_debugfs_dir, *jbd_debug;
+static struct dentry *jbd_debugfs_dir;
+static struct dentry *jbd_debug;
 
-static void __init create_jbd_debugfs_entry(void)
+static void __init jbd_create_debugfs_entry(void)
 {
 	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
 	if (jbd_debugfs_dir)
@@ -1871,18 +1870,21 @@ static void __init create_jbd_debugfs_en
 					       &journal_enable_debug);
 }
 
-static void __exit remove_jbd_debugfs_entry(void)
+static void __exit jbd_remove_debugfs_entry(void)
 {
-	if (jbd_debug)
-		debugfs_remove(jbd_debug);
-	if (jbd_debugfs_dir)
-		debugfs_remove(jbd_debugfs_dir);
+	debugfs_remove(jbd_debug);
+	debugfs_remove(jbd_debugfs_dir);
 }
 
 #else
 
-#define create_jbd_debugfs_entry() do {} while (0)
-#define remove_jbd_debugfs_entry() do {} while (0)
+static inline void jbd_create_debugfs_entry(void)
+{
+}
+
+static inline void jbd_remove_debugfs_entry(void)
+{
+}
 
 #endif
 
@@ -1940,7 +1942,7 @@ static int __init journal_init(void)
 	ret = journal_init_caches();
 	if (ret != 0)
 		journal_destroy_caches();
-	create_jbd_debugfs_entry();
+	jbd_create_debugfs_entry();
 	return ret;
 }
 
@@ -1951,7 +1953,7 @@ static void __exit journal_exit(void)
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
-	remove_jbd_debugfs_entry();
+	jbd_remove_debugfs_entry();
 	journal_destroy_caches();
 }
 
_
