From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [EXT4 set 2][PATCH 5/5] cleanups: Export jbd2-debug via debugfs
Date: Wed, 11 Jul 2007 00:38:09 -0500
Message-ID: <20070711003809.3ced667b@naruto>
References: <1183275408.4010.124.camel@localhost.localdomain>
 <20070710163025.9db582f8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37815 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXGKFiO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 01:38:14 -0400
In-Reply-To: <20070710163025.9db582f8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 10 Jul 2007 16:30:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 01 Jul 2007 03:36:48 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > > On Jun 07, 2007  23:45 -0500, Jose R. Santos wrote:
> > > > The jbd2-debug file used to be located in /proc/sys/fs/jbd2-debug, but
> > > > create_proc_entry() does not do lookups on file names with more that one
> > > > directory deep.  This causes the entry creation to fail and hence, no proc
> > > > file is created.  This patch moves the file to /proc/jbd2-degug.
> > > > 
> > > > The file could be move to /proc/fs/jbd2/jbd2-debug, but it would require
> > > > some minor alterations to the jbd-stats patch.
> > > 
> > > I don't think we really want to be adding top-level files in /proc.
> > > What about using the "debugfs" filesystem (not to be confused with
> > > the e2fsprogs 'debugfs' command)?
> > 
> > How about this then?  Moved the file to use debugfs as well as having
> > the nice effect of removing more lines than what it adds.
> > 
> > Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> 
> Please clean up the changelog.
> 
> The changelog should include information about the location and the content
> of these debugfs files.  it should provide any instructions which users
> will need to be able to create and use those files.

Will fix.

> Alternatively (and preferably) do this via an update to
> Documentation/filesystems/ext4.txt.

Seems like I also need to update the doc on Kconfig as well.  Do you
prefer this in separate patches? (current patch, kconfig patch, ext4
doc update patch?
 
> >  fs/jbd2/journal.c    |   62    20 +    42 -    0 !
> >  include/linux/jbd2.h |    2    1 +     1 -     0 !
> >  2 files changed, 21 insertions(+), 43 deletions(-)
> 
> Again, this patch isn't in Ted's kernel.org directory and hasn't been in -mm.
> 
> Apart from the lack of testing and review which this causes, it means I
> can't just do `pushpatch name-of-this-patch' and look at it in tkdiff.  So
> I squint at the diff, but that's harder when the diff wasn't prepared with
> `diff -p'.  Oh well.

Will fix.

> 
> > Index: linux-2.6.22-rc4/fs/jbd2/journal.c
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/fs/jbd2/journal.c	2007-06-11 16:16:18.000000000 -0700
> > +++ linux-2.6.22-rc4/fs/jbd2/journal.c	2007-06-11 16:36:10.000000000 -0700
> > @@ -35,6 +35,7 @@
> >  #include <linux/kthread.h>
> >  #include <linux/poison.h>
> >  #include <linux/proc_fs.h>
> > +#include <linux/debugfs.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/page.h>
> > @@ -1954,60 +1955,37 @@
> >   * /proc tunables
> >   */
> >  #if defined(CONFIG_JBD2_DEBUG)
> > -int jbd2_journal_enable_debug;
> > +u16 jbd2_journal_enable_debug;
> >  EXPORT_SYMBOL(jbd2_journal_enable_debug);
> >  #endif
> >  
> > -#if defined(CONFIG_JBD2_DEBUG) && defined(CONFIG_PROC_FS)
> > +#if defined(CONFIG_JBD2_DEBUG) && defined(CONFIG_DEBUG_FS)
> 
> Has this been compile-tested with CONFIG_DEBUGFS=n?

I think I did, but honestly don't remember.  Will check with the new
patch. :) 

> >  
> > -#define create_jbd_proc_entry() do {} while (0)
> > -#define jbd2_remove_jbd_proc_entry() do {} while (0)
> > +#define jbd2_create_debugfs_entry() do {} while (0)
> > +#define jbd2_remove_debugfs_entry() do {} while (0)
> 
> I suggest that these be converted to (preferable) inline functions while
> you're there.

OK.

> >  #endif
> >  
> > @@ -2067,7 +2045,7 @@
> >  	ret = journal_init_caches();
> >  	if (ret != 0)
> >  		jbd2_journal_destroy_caches();
> > -	create_jbd_proc_entry();
> > +	jbd2_create_debugfs_entry();
> >  	return ret;
> >  }
> >  
> > @@ -2078,7 +2056,7 @@
> >  	if (n)
> >  		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
> >  #endif
> > -	jbd2_remove_jbd_proc_entry();
> > +	jbd2_remove_debugfs_entry();
> >  	jbd2_journal_destroy_caches();
> >  }
> >  
> > Index: linux-2.6.22-rc4/include/linux/jbd2.h
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/include/linux/jbd2.h	2007-06-11 16:16:18.000000000 -0700
> > +++ linux-2.6.22-rc4/include/linux/jbd2.h	2007-06-11 16:35:25.000000000 -0700
> > @@ -57,7 +57,7 @@
> >   * CONFIG_JBD2_DEBUG is on.
> >   */
> >  #define JBD_EXPENSIVE_CHECKING
> 
> JBD2?
>
> > -extern int jbd2_journal_enable_debug;
> > +extern u16 jbd2_journal_enable_debug;
> 
> Why was this made 16-bit?  To save 2 bytes?  Could have saved 3 if we're
> going to do that.

OK.
 
> Shoudln't all this debug info be a per-superblock thing rather than
> kernel-wide?

I don't think it is worth pursuing this feature since this seems to
have been broken for a while now (its been there since the first git
revission in ext3) and nobody has noticed it until now.  It could be
address on a later patch though, since the initial purpose of the patch
was to fix the broken JBD2_DEBUG option. Of course, this may not be
clearly express in the changelog. :)

-JRS
