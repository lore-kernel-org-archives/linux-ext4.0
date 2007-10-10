From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 1/2] add init_ext4_proc() stub for when CONFIG_PROC_FS is not set
Date: Tue, 9 Oct 2007 20:22:05 -0400
Message-ID: <20071010002203.GL31713@thunk.org>
References: <20071009055033.145153755@au1.ibm.com> <20071009061101.666614585@au1.ibm.com> <1191947487.12131.33.camel@dyn9047017100.beaverton.ibm.com> <1191949386.3793.16.camel@localhost.localdomain> <20071009174012.GJ31713@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@gmail.com>, markn@au1.ibm.com,
	ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45809 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJJAWP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2007 20:22:15 -0400
Content-Disposition: inline
In-Reply-To: <20071009174012.GJ31713@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 09, 2007 at 01:40:12PM -0400, Theodore Tso wrote:
> On Tue, Oct 09, 2007 at 10:03:06AM -0700, Mingming Cao wrote:
> > I guess our testing did not catch this up because we have CONFIG_PROC_FS
> > enabled all the time. mballoc needs procfs for exporting some stats info
> > and tunable paramenters to optimize/customize multiple allocation.
> > 
> > We could select CONFIG_PROC_FS at kconfig when ext4dev is enabled.
> 
> We definitely should be able to compile without CONFIG_PROC_FS; it's a
> major flaw in the mballoc-core.patch that it doesn't work without it.  

I will fold the following into mballoc-core.patch.  It's sufficient to
allow us to compile w/o CONFIG_PROC_FS defined.

							- Ted

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4409c0c..2305af4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2854,9 +2854,11 @@ int __init init_ext4_proc(void)
 	if (ext4_pspace_cachep == NULL)
 		return -ENOMEM;
 
+#ifdef CONFIG_PROC_FS
 	proc_root_ext4 = proc_mkdir(EXT4_ROOT, proc_root_fs);
 	if (proc_root_ext4 == NULL)
 		printk(KERN_ERR "EXT4-fs: Unable to create %s\n", EXT4_ROOT);
+#endif
 
 	return 0;
 }
@@ -2865,7 +2867,9 @@ void exit_ext4_proc(void)
 {
 	/* XXX: synchronize_rcu(); */
 	kmem_cache_destroy(ext4_pspace_cachep);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry(EXT4_ROOT, proc_root_fs);
+#endif
 }
 
 
