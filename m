From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix error handling on inode bitmap corruption
Date: Thu, 8 Dec 2011 23:21:29 +0100
Message-ID: <20111208222129.GA24269@quack.suse.cz>
References: <1323376115-23881-1-git-send-email-jack@suse.cz>
 <4EE121C0.5070908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1LHWVb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 17:21:31 -0500
Content-Disposition: inline
In-Reply-To: <4EE121C0.5070908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 08-12-11 14:44:48, Eric Sandeen wrote:
> On 12/8/11 2:28 PM, Jan Kara wrote:
> > When insert_inode_locked() fails in ext4_new_inode() it most likely means inode
> > bitmap got corrupted and we allocated again inode which is already in use. Also
> > doing unlock_new_inode() during error recovery is wrong since the inode does
> > not have I_NEW set. Fix the problem by jumping to fail: (instead of fail_drop:)
> > which declares filesystem error and does not call unlock_new_inode().
> 
> This looks an awful lot like the:
> 
> [PATCH 3/6 V2] ext4: fix up error handling for insert_inode_locked
> 
> I sent a couple days ago.
> 
> Except yours is better ;)  I had overlooked the existing fail: target.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
  Ah, I haven't catch up with mailing lists after a few days of vacation
yet... Thanks for review.

								Honza

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/ialloc.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 00beb4f..8fb6844 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -885,8 +885,12 @@ got:
> >  	if (IS_DIRSYNC(inode))
> >  		ext4_handle_sync(handle);
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
