From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 20 May 2014 11:18:25 +0200
Message-ID: <20140520091825.GI3427@quack.suse.cz>
References: <1400185026-3972-1-git-send-email-jack@suse.cz>
 <1400185026-3972-3-git-send-email-jack@suse.cz>
 <537B1353.8060704@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaETJS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 05:18:28 -0400
Content-Disposition: inline
In-Reply-To: <537B1353.8060704@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-05-14 02:33:23, Thavatchai Makphaibulchoke wrote:
> Please see my one comment below.
> 
> BTW, I've run aim7 on your before I notice what I commented below.  There
> are workloads that my patch outperform yours and vice versa.  I will have
> to redo it over again.
> 
> On 05/15/2014 02:17 PM, Jan Kara wrote:
> > @@ -2631,13 +2644,18 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
> >  	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
> >  		return 0;
> >  
> > -	mutex_lock(&sbi->s_orphan_lock);
> > +	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
> > +		     !mutex_is_locked(&inode->i_mutex));
> > +	/* Do this quick check before taking global s_orphan_lock. */
> >  	if (list_empty(&ei->i_orphan))
> > -		goto out;
> > +		return 0;
> >  
> > -	ino_next = NEXT_ORPHAN(inode);
> > -	prev = ei->i_orphan.prev;
> > +	if (handle) {
> > +		/* Grab inode buffer early before taking global s_orphan_lock */
> > +		err = ext4_reserve_inode_write(handle, inode, &iloc);
> > +	}
> >  
> > +	mutex_lock(&sbi->s_orphan_lock);
> >  	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
> > 
> 
> Should set prev = ei->i_orphan.prev; here, instead of down below where it
> has already been removed from the list.
  Bah, I'm sorry for causing extra work to you. That's a really stupid
mistake. Thanks for finding that! Also I've realized we cannot really
reliably do
  ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
outside of s_orphan_lock because that inode may be reclaimed the moment
after we drop s_orphan_lock. So I had to remove that optimization as well
and move the call back under s_orphan_lock. I'm running xfstests now
(updated so they include also the test Ted found failing) to verify
correctness again and then I'll get my performance numbers with fixed
patches.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
