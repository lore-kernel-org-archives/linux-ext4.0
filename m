From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] jbd: clear b_modified before moving the jh to a
 different transaction
Date: Tue, 10 Jan 2012 15:21:20 -0500
Message-ID: <20120110202119.GA3523@localhost.localdomain>
References: <1326219175-4529-1-git-send-email-josef@redhat.com>
 <20120110201706.GD4516@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab2AJUVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 15:21:45 -0500
Content-Disposition: inline
In-Reply-To: <20120110201706.GD4516@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 10, 2012 at 09:17:06PM +0100, Jan Kara wrote:
> On Tue 10-01-12 13:12:55, Josef Bacik wrote:
> > If we are journalling data (ie journal=data or big symlinks) we can discard
> > buffers and move them to different transactions to make sure they get cleaned up
> > properly.  The problem is b_modified could still be set from the last
> > transaction that touched it, so putting it on the currently running transaction
> > or setting it up to be put on the next transaction will run into problems if the
> > buffer gets reused in that transaction as the space accounting logic won't be
> > done, which will result in panics at commit time because t_nr_buffers will end
> > up being more than t_outstanding_credits.  Thanks to Jan Kara for pointing out
> > the other part of this problem a few months ago.  Thanks,
>   Ho hum, I'm inclined to apply this just because it makes sense. But I
> still don't see how a transaction can reuse a buffer from BJ_Forget list.
> We attach there only truncated buffers and their underlying block can be
> reallocated only after the transaction freeing them is committed. So have
> you some incentive that this patch indeed fixes the t_outstanding_credits
> assertion you were hunting?
> 

So more the problem is where we set b_next_transaction, since it could be
reallocated in the next transaction after the current transaction commits and
then we're really screwed.  I have no real evidence to prove that this is
causing my problem yet, but it's definitely wrong and I want to get it fixed
before I forget it :).  Thanks,

Josef
