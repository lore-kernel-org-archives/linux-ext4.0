From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 08/10] ext4: endless truncate due to nonlocked dio
 readers V2
Date: Thu, 27 Sep 2012 17:23:43 +0200
Message-ID: <20120927152343.GA12553@quack.suse.cz>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
 <1348487060-19598-9-git-send-email-dmonakhov@openvz.org>
 <20120926140538.GH10145@quack.suse.cz>
 <87626z5wmm.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab2I0PXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 11:23:46 -0400
Content-Disposition: inline
In-Reply-To: <87626z5wmm.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 27-09-12 19:11:13, Dmitry Monakhov wrote:
> On Wed, 26 Sep 2012 16:05:38 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Mon 24-09-12 15:44:18, Dmitry Monakhov wrote:
> > > If we have enough aggressive DIO readers, truncate and other dio
> > > waiters will wait forever inside inode_dio_wait(). It is reasonable
> > > to disable nonlock DIO read optimization during truncate.
> >   Umm, actually this is a problem with any inode_dio_wait() call in ext4,
> > isn't it? So I'd just create ext4_inode_dio_wait() doing
> > 	ext4_inode_block_unlocked_dio(inode);
> > 	inode_dio_wait(inode);
> > 	ext4_inode_resume_unlocked_dio(inode);
> > 
> > and use it instead of inode_dio_wait().
> Ops sorry miss that comment.
> Actually all other places are very special, and guarded already: 
> 1) ext4_ext_punch_hole()
> 2) ext4_move_extents()
> 3) ext4_change_inode_journal_flag()
> Such functions require explicit scope where nonlocked DIO read should
> be disabled. So ext4_setattr() is the only place where we wait for
> existing dio, but nonlocked dio reads are allowed and may result in
> temporal live-lock.
  Ah, OK. Thanks for explanation. I'm just looking for a way how we could
avoid future bugs arising from someone adding inode_dio_wait() somewhere
without realizing there's this special unlocked DIO read issue... Even I
can forget that in an year or two.

But OTOH if we are unaware of that special case, you can get the exclusion
wrong anyway because you may well need to block unlocked DIO for a longer
time. What a mess. So I guess I'm fine with how the patch is now.

								Honza

> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > > ---
> > >  fs/ext4/inode.c |    8 ++++++--
> > >  1 files changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 32e9701..d3f86e7 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -4330,9 +4330,13 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
> > >  	if (attr->ia_valid & ATTR_SIZE) {
> > >  		if (attr->ia_size != inode->i_size) {
> > >  			truncate_setsize(inode, attr->ia_size);
> > > -			/* Inode size will be reduced, wait for dio in flight */
> > > -			if (orphan)
> > > +			/* Inode size will be reduced, wait for dio in flight.
> > > +			 * Temproraly disable unlocked DIO to prevent livelock */
> >                            ^^ Temporarily
> > 
> > > +			if (orphan) {
> > > +				ext4_inode_block_unlocked_dio(inode);
> > >  				inode_dio_wait(inode);
> > > +				ext4_inode_resume_unlocked_dio(inode);
> > > +			}
> > >  		}
> > >  		ext4_truncate(inode);
> > >  	}
> > > -- 
> > > 1.7.7.6
> > > 
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
