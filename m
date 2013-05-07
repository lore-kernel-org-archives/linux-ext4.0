From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 12/29] jbd2: Transaction reservation support
Date: Tue, 7 May 2013 13:22:00 +0800
Message-ID: <20130507052200.GA17170@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-13-git-send-email-jack@suse.cz>
 <20130505093939.GA27346@gmail.com>
 <20130506124939.GA9147@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52998 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab3EGFET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 May 2013 01:04:19 -0400
Received: by mail-pb0-f54.google.com with SMTP id rr4so126093pbb.41
        for <linux-ext4@vger.kernel.org>; Mon, 06 May 2013 22:04:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130506124939.GA9147@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 06, 2013 at 02:49:39PM +0200, Jan Kara wrote:
...
> > > +/*
> > >   * start_this_handle: Given a handle, deal with any locking or stalling
> > >   * needed to make sure that there is enough journal space for the handle
> > >   * to begin.  Attach the handle to a transaction and set up the
> > > @@ -151,12 +237,14 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
> > >  			     gfp_t gfp_mask)
> > >  {
> > >  	transaction_t	*transaction, *new_transaction = NULL;
> > > -	tid_t		tid;
> > > -	int		needed, need_to_start;
> > >  	int		nblocks = handle->h_buffer_credits;
> > >  	unsigned long ts = jiffies;
> > >  
> > > -	if (nblocks > journal->j_max_transaction_buffers) {
> > > +	/*
> > > +	 * 1/2 of transaction can be reserved so we can practically handle
> > > +	 * only 1/2 of maximum transaction size per operation
> > > +	 */
> > 
> > Sorry, but I don't understand here why we only reserve 1/2 of maximum
> > transaction size.
>   Well, we allow 1/2 of maximum transaction size to be allocated in already
> reserved handles. So if someone submitted a request for a handle with
> more than 1/2 of maximum transaction size, then we might have to wait for
> reserved handles to be freed. That would be a slight complication in the
> code and it would also possibly introduce livelocking issues - after a
> reserved transaction is freed, someone can reserve a new one before the
> large handle creation request is satisfied. Again this can be solved but
> the complications simply doesn't seem to be worth it.

Fair enough.  Thanks for your explanation.

Regards,
                                                - Zheng
