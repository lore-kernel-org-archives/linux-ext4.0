From: Jan Kara <jack@suse.cz>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Mon, 7 Apr 2008 13:47:58 +0200
Message-ID: <20080407114758.GE19286@duck.suse.cz>
References: <20080325182909.GD21732@atrey.karlin.mff.cuni.cz> <200804041537.m34FbwBG009160@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Erez Zadok <ezk@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36707 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754131AbYDGLsB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2008 07:48:01 -0400
Content-Disposition: inline
In-Reply-To: <200804041537.m34FbwBG009160@agora.fsl.cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 04-04-08 11:37:58, Erez Zadok wrote:
> In message <20080325182909.GD21732@atrey.karlin.mff.cuni.cz>, Jan Kara writes:
> 
> > > I was building a kernel using "make -j 4" inside a unionfs, mounted on top
> > > of ext3.  The kernel is vanilla 2.6.25-rc6 plus unionfs patches.  At some
> > > point I forced a cache flush using "echo 3 > /proc/sys/vm/drop_caches" and I
> > > got the lockdep warning below.  Note that unionfs doesn't appear to be
> > > involved in this lockdep warning at all, so I suspect this is probably an
> > > issue between jbd and ext3 directly.
> > > 
> > > Let me know if I can be of more help.
> >   Actually, I have a fix for that - attached. Can you try it? Thanks.
> > 									Honza
> [...]
> 
> > From f5e41087e345fa5c3b46ac36e6e4a654d2f7f624 Mon Sep 17 00:00:00 2001
> > From: Jan Kara <jack@suse.cz>
> > Date: Tue, 18 Mar 2008 14:38:06 +0100
> > Subject: [PATCH] Fix drop_pagecache_sb() to not call __invalidate_mapping_pages() under
> > inode_lock.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/drop_caches.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> > index 59375ef..f5aae26 100644
> > --- a/fs/drop_caches.c
> > +++ b/fs/drop_caches.c
> > @@ -14,15 +14,21 @@ int sysctl_drop_caches;
> >  
> >  static void drop_pagecache_sb(struct super_block *sb)
> >  {
> > -	struct inode *inode;
> > +	struct inode *inode, *toput_inode = NULL;
> >  
> >  	spin_lock(&inode_lock);
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> >  		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> >  			continue;
> > +		__iget(inode);
> > +		spin_unlock(&inode_lock);
> >  		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
> > +		iput(toput_inode);
> > +		toput_inode = inode;
> > +		spin_lock(&inode_lock);
> >  	}
> >  	spin_unlock(&inode_lock);
> > +	iput(toput_inode);
> >  }
> >  
> >  void drop_pagecache(void)
> 
> Jan, I tried the above patch on top of v2.6.25-rc8-82-g49115b7, and using
> the same setup and workloads that produced the warning before: running "make
> -j 20" of the linux kernel 100 times, dual-CPU, SMP, PREEMPT, while running
> flush_cache every few seconds.  The entire run took over 12 hours.  I'm
> happy to report that so far I've not gotten the same lockdep warning as
> before.
  Great news, thanks.

> Maybe this can now go to -mm for more testing?
  Andrew has already merged it :).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
