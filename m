From: Jan Kara <jack@suse.cz>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Wed, 2 Apr 2008 10:12:15 +0200
Message-ID: <20080402081215.GA2716@duck.suse.cz>
References: <20080325182909.GD21732@atrey.karlin.mff.cuni.cz> <200804012123.m31LNY3T012962@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Erez Zadok <ezk@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54877 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752155AbYDBIMT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2008 04:12:19 -0400
Content-Disposition: inline
In-Reply-To: <200804012123.m31LNY3T012962@agora.fsl.cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-04-08 17:23:34, Erez Zadok wrote:
 <snip>
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
> 
> Jan, I'll be happy to test this, but I don't understand two things about
> this patch:
> 
> 1. Is it safe to unlock and re-lock inode_lock temporarily within the loop?
> 
> 2. What's the motivation behind having the second toput_inode pointer?  It
>    appears that the first iteration through the loop, toput_inode will be
>    NULL, so we'll be iput'ing a NULL pointer (which is ok).  So you're
>    trying to iput the previous inode pointer that the list iterated over,
>    right?  Is that intended?
  I'll try to explain the locking here:
1) We are not allowed to call into __invalidate_mapping_pages() with
inode_lock held - that it the bug lockdep is complaining about. Moreover it
leads to rather long waiting times for inode_lock (quite possibly several
seconds).
2) When we release inode_lock, we need to protect from inode going away,
thus we hold reference to it - that guarantees us inode stays in the list.
3) When we continue scanning of the list we must get inode_lock before we
put the inode reference to avoid races. But we cannot do iput() when we
hold inode_lock. Thus we save pointer to inode and do iput() next time we
have released the inode_lock...

> Peter's post:
> 
> 	http://lkml.org/lkml/2008/3/23/202
> 
> includes a reference to a mail by Andrew which implies that the fix may be
> much more involved than what you outlined above, no?
  Definitely we can do a more involved fix ;) What Andrew proposes would have
some other benefits as well. But until somebody gets to that, this slight
hack should work fine (Andrew has already merged my patch in -mm so I
guess he agrees ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
