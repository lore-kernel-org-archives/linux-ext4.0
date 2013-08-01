From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/4] jbd: use module parameters instead of debugfs for
 jbd_debug
Date: Thu, 1 Aug 2013 19:18:26 -0400
Message-ID: <20130801231826.GA7099@windriver.com>
References: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
 <1375383668-8072-2-git-send-email-paul.gortmaker@windriver.com>
 <20130801212405.GD31857@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130801212405.GD31857@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[Re: [PATCH 1/4] jbd: use module parameters instead of debugfs for jbd_debug] On 01/08/2013 (Thu 23:24) Jan Kara wrote:

> On Thu 01-08-13 15:01:05, Paul Gortmaker wrote:
> > This is a direct backport of commit b6e96d0067d81f6a300bedee
> > ("jbd2: use module parameters instead of debugfs for jbd_debug")
> > from jbd2 into jbd.  The value is in making ext4 and ext3 user
> > experiences consistent with each other.  Quoting the original:
> > 
> >  --------------
> >  There are multiple reasons to move away from debugfs.  First of all,
> >  we are only using it for a single parameter, and it is much more
> >  complicated to set up (some 30 lines of code compared to 3), and one
> >  more thing that might fail while loading the jbd2 module.
> > 
> >  Secondly, as a module paramter it can be specified as a boot option if
> >  jbd2 is built into the kernel, or as a parameter when the module is
> >  loaded, and it can also be manipulated dynamically under
> >  /sys/module/jbd2/parameters/jbd2_debug.  So it is more flexible.
> > 
> >  Ultimately we want to move away from using jbd_debug() towards
> >  tracepoints, but for now this is still a useful simplification of the
> >  code base.
> >  --------------
> > 
> > It is worth noting that we use /sys/module/jbd/parameters/jbd1_debug
> > (i.e. the "1" might appear odd) for the module parameter in order to
> > avoid namespace collisions with the existing jbd_debug used as a
> > function call.
> > 
> > In addition, we combine the content of jbd2 commit 75497d0607b56e16e4
> > ("jbd2: remove debug dependency on debug_fs and update Kconfig help text")
> > since they were only separate commits unintentionally in jbd2.
>   Thanks for the patch but is jbd_debug really worth it - especially with
> the somewhat ugly jbd1_debug? I don't thing anybody besides kernel
> developers really uses it and those can figure how to do what they need...

It is your call; I agree that people who use jbd_debug are going to be
only people who are motivated to do so, and hence most likely kernel
developers.  So I won't be upset if you want to drop this patch.

Thanks,
Paul.
--
> 
> 								Honza
> > 
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > ---
> >  fs/jbd/Kconfig      |  6 +++---
> >  fs/jbd/journal.c    | 49 ++++++++-----------------------------------------
> >  include/linux/jbd.h |  3 +--
> >  3 files changed, 12 insertions(+), 46 deletions(-)
> > 
> > diff --git a/fs/jbd/Kconfig b/fs/jbd/Kconfig
> > index 4e28bee..54cbb55 100644
> > --- a/fs/jbd/Kconfig
> > +++ b/fs/jbd/Kconfig
> > @@ -15,7 +15,7 @@ config JBD
> >  
> >  config JBD_DEBUG
> >  	bool "JBD (ext3) debugging support"
> > -	depends on JBD && DEBUG_FS
> > +	depends on JBD
> >  	help
> >  	  If you are using the ext3 journaled file system (or potentially any
> >  	  other file system/device using JBD), this option allows you to
> > @@ -24,7 +24,7 @@ config JBD_DEBUG
> >  	  debugging output will be turned off.
> >  
> >  	  If you select Y here, then you will be able to turn on debugging
> > -	  with "echo N > /sys/kernel/debug/jbd/jbd-debug", where N is a
> > +	  with "echo N > /sys/module/jbd/parameters/jbd1_debug", where N is a
> >  	  number between 1 and 5, the higher the number, the more debugging
> >  	  output is generated.  To turn debugging off again, do
> > -	  "echo 0 > /sys/kernel/debug/jbd/jbd-debug".
> > +	  "echo 0 > /sys/module/jbd/parameters/jbd1_debug".
> > diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> > index 6510d63..166263d 100644
> > --- a/fs/jbd/journal.c
> > +++ b/fs/jbd/journal.c
> > @@ -35,7 +35,6 @@
> >  #include <linux/kthread.h>
> >  #include <linux/poison.h>
> >  #include <linux/proc_fs.h>
> > -#include <linux/debugfs.h>
> >  #include <linux/ratelimit.h>
> >  
> >  #define CREATE_TRACE_POINTS
> > @@ -44,6 +43,14 @@
> >  #include <asm/uaccess.h>
> >  #include <asm/page.h>
> >  
> > +#ifdef CONFIG_JBD_DEBUG
> > +ushort jbd_journal_enable_debug __read_mostly;
> > +EXPORT_SYMBOL(jbd_journal_enable_debug);
> > +
> > +module_param_named(jbd1_debug, jbd_journal_enable_debug, ushort, 0644);
> > +MODULE_PARM_DESC(jbd1_debug, "Debugging level for jbd");
> > +#endif
> > +
> >  EXPORT_SYMBOL(journal_start);
> >  EXPORT_SYMBOL(journal_restart);
> >  EXPORT_SYMBOL(journal_extend);
> > @@ -2017,44 +2024,6 @@ void journal_put_journal_head(struct journal_head *jh)
> >  		jbd_unlock_bh_journal_head(bh);
> >  }
> >  
> > -/*
> > - * debugfs tunables
> > - */
> > -#ifdef CONFIG_JBD_DEBUG
> > -
> > -u8 journal_enable_debug __read_mostly;
> > -EXPORT_SYMBOL(journal_enable_debug);
> > -
> > -static struct dentry *jbd_debugfs_dir;
> > -static struct dentry *jbd_debug;
> > -
> > -static void __init jbd_create_debugfs_entry(void)
> > -{
> > -	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
> > -	if (jbd_debugfs_dir)
> > -		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO | S_IWUSR,
> > -					       jbd_debugfs_dir,
> > -					       &journal_enable_debug);
> > -}
> > -
> > -static void __exit jbd_remove_debugfs_entry(void)
> > -{
> > -	debugfs_remove(jbd_debug);
> > -	debugfs_remove(jbd_debugfs_dir);
> > -}
> > -
> > -#else
> > -
> > -static inline void jbd_create_debugfs_entry(void)
> > -{
> > -}
> > -
> > -static inline void jbd_remove_debugfs_entry(void)
> > -{
> > -}
> > -
> > -#endif
> > -
> >  struct kmem_cache *jbd_handle_cache;
> >  
> >  static int __init journal_init_handle_cache(void)
> > @@ -2109,7 +2078,6 @@ static int __init journal_init(void)
> >  	ret = journal_init_caches();
> >  	if (ret != 0)
> >  		journal_destroy_caches();
> > -	jbd_create_debugfs_entry();
> >  	return ret;
> >  }
> >  
> > @@ -2120,7 +2088,6 @@ static void __exit journal_exit(void)
> >  	if (n)
> >  		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
> >  #endif
> > -	jbd_remove_debugfs_entry();
> >  	journal_destroy_caches();
> >  }
> >  
> > diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> > index 8685d1b..e45b430 100644
> > --- a/include/linux/jbd.h
> > +++ b/include/linux/jbd.h
> > @@ -20,7 +20,6 @@
> >  #ifndef __KERNEL__
> >  #include "jfs_compat.h"
> >  #define JFS_DEBUG
> > -#define jfs_debug jbd_debug
> >  #else
> >  
> >  #include <linux/types.h>
> > @@ -55,7 +54,7 @@
> >   * CONFIG_JBD_DEBUG is on.
> >   */
> >  #define JBD_EXPENSIVE_CHECKING
> > -extern u8 journal_enable_debug;
> > +extern ushort journal_enable_debug;
> >  
> >  #define jbd_debug(n, f, a...)						\
> >  	do {								\
> > -- 
> > 1.8.1.2
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
