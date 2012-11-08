From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Prevent race while waling extent tree
Date: Thu, 8 Nov 2012 17:07:25 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211081705460.19842@dhcp-1-104.brq.redhat.com>
References: <1352372929-18513-1-git-send-email-lczerner@redhat.com> <87liecs3qq.fsf@openvz.org> <alpine.LFD.2.00.1211081424000.19842@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-1756226799-1352390848=:19842"
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab2KHQHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 11:07:31 -0500
In-Reply-To: <alpine.LFD.2.00.1211081424000.19842@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1756226799-1352390848=:19842
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 8 Nov 2012, Luká¨ Czerner wrote:

> Date: Thu, 8 Nov 2012 14:43:19 +0100 (CET)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
>     tytso@mit.edu
> Subject: Re: [PATCH] ext4: Prevent race while waling extent tree
> 
> On Thu, 8 Nov 2012, Dmitry Monakhov wrote:
> 
> > Date: Thu, 08 Nov 2012 16:01:17 +0400
> > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> > Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
> > Subject: Re: [PATCH] ext4: Prevent race while waling extent tree
> > 
> > On Thu,  8 Nov 2012 12:08:49 +0100, Lukas Czerner <lczerner@redhat.com> wrote:
> > > Currently ext4_ext_walk_space() only takes i_data_sem for read when
> > > searching for the extent at given block with ext4_ext_find_extent().
> > > Then it drops the lock and the extent tree can be changed at will.
> > > However later on we're searching for the 'next' extent, but the extent
> > > tree might already have changed, so the information might not be
> > > accurate.
> > > 
> > > In fact we can hit BUG_ON(end <= start) if the extent got inserted into
> > > the tree after the one we found and before the block we were searching
> > > for. This has been reproduced by running xfstests 225 in loop on s390x
> > > architecture, but theoretically we could hit this on any other
> > > architecture as well, but probably not as often.
> > > 
> > > ext4_ext_walk_space() is currently only used from ext4_fiemap() and even
> > > if we do not hit the BUG_ON() fiemap might return scrambled information
> > > to the user.
> > > 
> > > Fix this by requiring ext4_ext_walk_space() to be called with i_data_sem
> > > held. By calling it from ext4_fiemap() we can only take the i_data_sem
> > > for read, but possibly other users might want to modify the extents so
> > > they will be able to take write lock.
> > Agree as a short term fix for BUGON case, but Theodore suggested to use
> > seqlock approach http://lists.openwall.net/linux-ext4/2011/10/26/25
> 
> Yeah, it make sense to protect us from fiemap abuse, however using
> seqlock for walking the extent tree seems like an overkill
> especially considering how much work will that require. We would
> have to make sure that everything we do in the ext4_ext_walk_space()
> and other function we're calling there is safe even if the extent
> tree change under our hands. I do not think this is the right way.
> 
> I was thinking about checking for contentions on the semaphore from
> within the ext4_ext_walk_space() - possibly enabling/disabling it
> with a function parameter ?
> 
> Sadly kernel does not provide a helper to check for that so what
> about something like this in the beginning of the while loop in
> ext4_ext_walk_space ?
> 
> if (check_contention) {
> 	int contends = 0;
> 	unsigned int flags;
> 
> 	raw_spin_lock_irqsave(&EXT4_I(inode)->i_data_sem->wait_lock, flags);
> 	if (!list_empty(&EXT4_I(inode)->i_data_sem->wait_list)
> 		contends = 1
> 	raw_spin_unlock_irqrestore(&EXT4_I(inode)->i_data_sem->wait_lock, flags);
> 
> 	if (contends)
> 		break
> }
> 
> or we can add the helper to the rwsem code and use that.
> 
> 
> What do you think ?

Nevermind, trhere is no generic way to tell how many waiters for the
semaphore there is...

-Lukas

> 
> Thanks!
> -Lukas
> 
> > 
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > ---
> > >  fs/ext4/extents.c |    9 +++++++--
> > >  1 files changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index 7011ac9..f1aca06 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -1959,6 +1959,11 @@ cleanup:
> > >  	return err;
> > >  }
> > >  
> > > +/*
> > > + * ext4_ext_walk_space() should be called with i_data_sem locked. If we're
> > > + * not modifying found extents, or extent tree in callback function, then
> > > + * read lock is ok.
> > > + */
> > >  static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> > >  			       ext4_lblk_t num, ext_prepare_callback func,
> > >  			       void *cbdata)
> > > @@ -1976,9 +1981,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> > >  	while (block < last && block != EXT_MAX_BLOCKS) {
> > >  		num = last - block;
> > >  		/* find extent for this block */
> > > -		down_read(&EXT4_I(inode)->i_data_sem);
> > >  		path = ext4_ext_find_extent(inode, block, path);
> > > -		up_read(&EXT4_I(inode)->i_data_sem);
> > >  		if (IS_ERR(path)) {
> > >  			err = PTR_ERR(path);
> > >  			path = NULL;
> > > @@ -5021,8 +5024,10 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > >  		 * Walk the extent tree gathering extent information.
> > >  		 * ext4_ext_fiemap_cb will push extents back to user.
> > >  		 */
> > > +		down_read(&EXT4_I(inode)->i_data_sem);
> > >  		error = ext4_ext_walk_space(inode, start_blk, len_blks,
> > >  					  ext4_ext_fiemap_cb, fieinfo);
> > > +		up_read(&EXT4_I(inode)->i_data_sem);
> > >  	}
> > >  
> > >  	return error;
> > > -- 
> > > 1.7.7.6
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
--571107329-1756226799-1352390848=:19842--
