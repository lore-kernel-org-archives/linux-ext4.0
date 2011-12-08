From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Fix error handling on inode bitmap corruption
Date: Thu, 8 Dec 2011 23:28:16 +0100
Message-ID: <20111208222816.GB24269@quack.suse.cz>
References: <1323376115-23881-1-git-send-email-jack@suse.cz>
 <1323376115-23881-2-git-send-email-jack@suse.cz>
 <4EE12211.3000604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab1LHW2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 17:28:17 -0500
Content-Disposition: inline
In-Reply-To: <4EE12211.3000604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 08-12-11 14:46:09, Eric Sandeen wrote:
> On 12/8/11 2:28 PM, Jan Kara wrote:
> > When insert_inode_locked() fails in ext3_new_inode() it most likely
> > means inode bitmap got corrupted and we allocated again inode which
> > is already in use. Also doing unlock_new_inode() during error recovery
> > is wrong since inode does not have I_NEW set. Fix the problem by jumping
> > to fail: (instead of fail_drop:) which declares filesystem error and
> > does not call unlock_new_inode().
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> I think ext2 could use the same treatment.
> 
> BTW, though, have you recently started seeing the issue?  We have
> people hitting this when resuming after suspend; it seems likely
> that the bitmap did get corrupted though, based on some other
> things seen in similar bugs.
  Interesting. I've got a report from IBM testing ext3 on SLE11 SP2 kernel
(3.0 based). Their filesystem got damaged (might be HW issue, not sure yet)
and they also observed warnings from unlock_new_inode().

								Honza
> > ---
> >  fs/ext3/ialloc.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> > index 5c866e0..adae962 100644
> > --- a/fs/ext3/ialloc.c
> > +++ b/fs/ext3/ialloc.c
> > @@ -525,8 +525,12 @@ got:
> >  	if (IS_DIRSYNC(inode))
> >  		handle->h_sync = 1;
> >  	if (insert_inode_locked(inode) < 0) {
> > -		err = -EINVAL;
> > -		goto fail_drop;
> > +		/*
> > +		 * Likely a bitmap corruption causing inode to be allocated
> > +		 * twice.
> > +		 */
> > +		err = -EIO;
> > +		goto fail;
> >  	}
> >  	spin_lock(&sbi->s_next_gen_lock);
> >  	inode->i_generation = sbi->s_next_generation++;
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
