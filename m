From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] jbd2: Limit number of reserved credits
Date: Fri, 31 Jul 2015 12:22:43 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1507311207500.25183@localhost.localdomain>
References: <1438329863-26422-1-git-send-email-lczerner@redhat.com> <20150731094639.GB16125@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbbGaKWs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Jul 2015 06:22:48 -0400
In-Reply-To: <20150731094639.GB16125@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 31 Jul 2015, Jan Kara wrote:

> Date: Fri, 31 Jul 2015 11:46:39 +0200
> From: Jan Kara <jack@suse.cz>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, jack@suse.cz
> Subject: Re: [PATCH] jbd2: Limit number of reserved credits
> 
>   Hello,
> 
> On Fri 31-07-15 10:04:23, Lukas Czerner wrote:
> > Currently there is no limitation on number of reserved credits we can
> > ask for. If we ask for more reserved credits than 1/2 of maximum
> > transaction size, or if total number of credits exceeds the maximum
> > transaction size per operation (which is currently only possible with
> > the former) we will spin forever in start_this_handle().
> > 
> > Fix this by adding this limitation at the start of start_this_handle().
> > 
> > This patch also removes the credit limitation 1/2 of maximum transaction
> > size, since we really only want to limit the number of reserved credits.
> > There is not much point to limit the credits if there is still space in
> > the journal.
> > 
> > This accidentally also fixes the online resize, where due to the
> > limitation of the journal credits we're unable to grow file systems with
> > 1k block size and size between 16M and 32M. It has been partially fixed
> > by 2c869b262a10ca99cb866d04087d75311587a30c, but not entirely.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > 
> > Honzo I think that this should be enough to remove the limitation of 1/2 of
> > maximum transaction size for regular credits, but I might be missing
> > something, please let me know. Also do you have any specific test case to
> > exercise transaction reservation support - I've only ran xfstests.
> > 
> >  fs/jbd2/transaction.c | 22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index f3d0617..491a328 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -262,20 +262,24 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
> >  	int		rsv_blocks = 0;
> >  	unsigned long ts = jiffies;
> >  
> > +	if (handle->h_rsv_handle)
> > +		rsv_blocks = handle->h_rsv_handle->h_buffer_credits;
> > +
> >  	/*
> > -	 * 1/2 of transaction can be reserved so we can practically handle
> > -	 * only 1/2 of maximum transaction size per operation
> > +	 * Limit the number of reserved credits to 1/2 of maximum transaction
> > +	 * size and limit the number of total credits to not exceed maximum
> > +	 * transaction size per operation.
> >  	 */
> > -	if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
> > -		printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
> > -		       current->comm, blocks,
> > -		       journal->j_max_transaction_buffers / 2);
> > +	if ((rsv_blocks > journal->j_max_transaction_buffers / 2) ||
> > +	    (rsv_blocks + blocks > journal->j_max_transaction_buffers)) {
> > +		printk(KERN_ERR "JBD2: %s wants too many credits "
> > +		       "credits:%d rsv_credits:%d max:%d\n",
> > +		       current->comm, blocks, rsv_blocks,
> > +		       journal->j_max_transaction_buffers);
> > +		WARN_ON(1);
> >  		return -ENOSPC;
> >  	}
> 
> Well, the trouble with this is the following: The currently running
> transaction has X reserved credits and Y normal credits. We know X+Y <=
> journal->j_max_transaction_buffers. Now you request additional A reserved
> and B normal credits. Suppose we cannot fit in the current transaction -
> i.e., X+Y+A+B > journal->j_max_transaction_buffers. The only thing we can do
> is to push running transaction to commit and start a new one. However, the
> new transaction will also have X reserved credits - you inherit reserved
> credits from the previous transaction until they are converted to normal
> credits. So if X+A+B is still > journal->j_max_transaction_buffers, you
> still cannot start current handle and you'd have to wait until someone
> converts his reserved credits.

Ok I understand, but isn't this true either way ? If anything the
limit might make it worse in that case because if

X+A+B is still > journal->j_max_transaction_buffers

in the new case without the limit then it's definitely true for the
case with the limit as well. The number of reserved credits is
limited in both cases so it's not really a factor, is it ?

Yes in the limitless case it might happen that we have so much
normal credits that we can't fit in the reserved credits so we have
to commit and start a new one, but that's true in both cases only
with the limit it will happen sooner and possible more often because
we just have less space to work with.

Sorry if I am asking dumb questions, but I am trying to understand
how is this supposed to work.

And above all that limitation we're talking about is a hard limit
which you're not supposed to hit ever. Only if something is really
wrong and is asking for a handle with way too much credits...that's
not what can normally happen. So what's the problem again ?

Thanks!
-Lukas


> 
> However these waits will create journal stalls causing possible performance
> issues and also introduce a lock dependency - suddently you are not allowed
> to acquire locks ranking above transaction start before starting a reserved
> handle (as these locks can be held by processes being stuck waiting for
> reserved credits to convert).
> 
> So overall halving the maximum allowed credits seemed like the least
> painful solution to the problem.
> 
> 								Honza
> >  
> > -	if (handle->h_rsv_handle)
> > -		rsv_blocks = handle->h_rsv_handle->h_buffer_credits;
> > -
> >  alloc_transaction:
> >  	if (!journal->j_running_transaction) {
> >  		/*
> > -- 
> > 1.8.3.1
> > 
> 
