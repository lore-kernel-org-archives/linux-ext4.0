From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 08/10] ext4: endless truncate due to nonlocked dio readers V2
Date: Thu, 27 Sep 2012 19:11:13 +0400
Message-ID: <87626z5wmm.fsf@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org> <1348487060-19598-9-git-send-email-dmonakhov@openvz.org> <20120926140538.GH10145@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34008 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2I0PLR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 11:11:17 -0400
Received: by lagh6 with SMTP id h6so460044lag.19
        for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2012 08:11:16 -0700 (PDT)
In-Reply-To: <20120926140538.GH10145@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 26 Sep 2012 16:05:38 +0200, Jan Kara <jack@suse.cz> wrote:
> On Mon 24-09-12 15:44:18, Dmitry Monakhov wrote:
> > If we have enough aggressive DIO readers, truncate and other dio
> > waiters will wait forever inside inode_dio_wait(). It is reasonable
> > to disable nonlock DIO read optimization during truncate.
>   Umm, actually this is a problem with any inode_dio_wait() call in ext4,
> isn't it? So I'd just create ext4_inode_dio_wait() doing
> 	ext4_inode_block_unlocked_dio(inode);
> 	inode_dio_wait(inode);
> 	ext4_inode_resume_unlocked_dio(inode);
> 
> and use it instead of inode_dio_wait().
Ops sorry miss that comment.
Actually all other places are very special, and guarded already: 
1) ext4_ext_punch_hole()
2) ext4_move_extents()
3) ext4_change_inode_journal_flag()
Such functions require explicit scope where nonlocked DIO read should
be disabled. So ext4_setattr() is the only place where we wait for
existing dio, but nonlocked dio reads are allowed and may result in
temporal live-lock.
> 
> 								Honza
>  
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/inode.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 32e9701..d3f86e7 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4330,9 +4330,13 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
> >  	if (attr->ia_valid & ATTR_SIZE) {
> >  		if (attr->ia_size != inode->i_size) {
> >  			truncate_setsize(inode, attr->ia_size);
> > -			/* Inode size will be reduced, wait for dio in flight */
> > -			if (orphan)
> > +			/* Inode size will be reduced, wait for dio in flight.
> > +			 * Temproraly disable unlocked DIO to prevent livelock */
>                            ^^ Temporarily
> 
> > +			if (orphan) {
> > +				ext4_inode_block_unlocked_dio(inode);
> >  				inode_dio_wait(inode);
> > +				ext4_inode_resume_unlocked_dio(inode);
> > +			}
> >  		}
> >  		ext4_truncate(inode);
> >  	}
> > -- 
> > 1.7.7.6
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
