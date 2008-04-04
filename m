From: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Fri, 4 Apr 2008 11:37:58 -0400
Message-ID: <200804041537.m34FbwBG009160@agora.fsl.cs.sunysb.edu>
References: <20080325182909.GD21732@atrey.karlin.mff.cuni.cz>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56538 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbYDDPmO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 11:42:14 -0400
In-reply-to: Your message of "Tue, 25 Mar 2008 19:29:09 BST."
             <20080325182909.GD21732@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In message <20080325182909.GD21732@atrey.karlin.mff.cuni.cz>, Jan Kara writes:

> > I was building a kernel using "make -j 4" inside a unionfs, mounted on top
> > of ext3.  The kernel is vanilla 2.6.25-rc6 plus unionfs patches.  At some
> > point I forced a cache flush using "echo 3 > /proc/sys/vm/drop_caches" and I
> > got the lockdep warning below.  Note that unionfs doesn't appear to be
> > involved in this lockdep warning at all, so I suspect this is probably an
> > issue between jbd and ext3 directly.
> > 
> > Let me know if I can be of more help.
>   Actually, I have a fix for that - attached. Can you try it? Thanks.
> 									Honza
[...]

> From f5e41087e345fa5c3b46ac36e6e4a654d2f7f624 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 18 Mar 2008 14:38:06 +0100
> Subject: [PATCH] Fix drop_pagecache_sb() to not call __invalidate_mapping_pages() under
> inode_lock.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/drop_caches.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 59375ef..f5aae26 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -14,15 +14,21 @@ int sysctl_drop_caches;
>  
>  static void drop_pagecache_sb(struct super_block *sb)
>  {
> -	struct inode *inode;
> +	struct inode *inode, *toput_inode = NULL;
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>  		if (inode->i_state & (I_FREEING|I_WILL_FREE))
>  			continue;
> +		__iget(inode);
> +		spin_unlock(&inode_lock);
>  		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
> +		iput(toput_inode);
> +		toput_inode = inode;
> +		spin_lock(&inode_lock);
>  	}
>  	spin_unlock(&inode_lock);
> +	iput(toput_inode);
>  }
>  
>  void drop_pagecache(void)

Jan, I tried the above patch on top of v2.6.25-rc8-82-g49115b7, and using
the same setup and workloads that produced the warning before: running "make
-j 20" of the linux kernel 100 times, dual-CPU, SMP, PREEMPT, while running
flush_cache every few seconds.  The entire run took over 12 hours.  I'm
happy to report that so far I've not gotten the same lockdep warning as
before.

Maybe this can now go to -mm for more testing?

Cheers,
Erez.
