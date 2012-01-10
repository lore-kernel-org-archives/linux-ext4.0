From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: clear b_modified before moving the jh to a
 different transaction
Date: Tue, 10 Jan 2012 22:10:09 +0100
Message-ID: <20120110211009.GF4516@quack.suse.cz>
References: <1326219175-4529-1-git-send-email-josef@redhat.com>
 <20120110201706.GD4516@quack.suse.cz>
 <20120110202119.GA3523@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2AJVKL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 16:10:11 -0500
Content-Disposition: inline
In-Reply-To: <20120110202119.GA3523@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-01-12 15:21:20, Josef Bacik wrote:
> On Tue, Jan 10, 2012 at 09:17:06PM +0100, Jan Kara wrote:
> > On Tue 10-01-12 13:12:55, Josef Bacik wrote:
> > > If we are journalling data (ie journal=data or big symlinks) we can discard
> > > buffers and move them to different transactions to make sure they get cleaned up
> > > properly.  The problem is b_modified could still be set from the last
> > > transaction that touched it, so putting it on the currently running transaction
> > > or setting it up to be put on the next transaction will run into problems if the
> > > buffer gets reused in that transaction as the space accounting logic won't be
> > > done, which will result in panics at commit time because t_nr_buffers will end
> > > up being more than t_outstanding_credits.  Thanks to Jan Kara for pointing out
> > > the other part of this problem a few months ago.  Thanks,
> >   Ho hum, I'm inclined to apply this just because it makes sense. But I
> > still don't see how a transaction can reuse a buffer from BJ_Forget list.
> > We attach there only truncated buffers and their underlying block can be
> > reallocated only after the transaction freeing them is committed. So have
> > you some incentive that this patch indeed fixes the t_outstanding_credits
> > assertion you were hunting?
> 
> So more the problem is where we set b_next_transaction, since it could be
> reallocated in the next transaction after the current transaction commits and
> then we're really screwed.  I have no real evidence to prove that this is
> causing my problem yet, but it's definitely wrong and I want to get it fixed
> before I forget it :).
  I see. But journal_invalidatepage() is called before blocks are freed
which means that the freeing of the block happens either in the running
transaction (to which we set b_next_transaction) or even in the following
one. And we also set buffer_freed() so the buffer should be filed to
BJ_Forget list when it is refiled. I agree the logic is kind of fragile so
there can be bug somewhere. Just I don't see it (yet).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
