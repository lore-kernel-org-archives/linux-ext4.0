From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: preserve original nofs flag during journal restart
Date: Wed, 17 May 2017 16:56:27 +0200
Message-ID: <20170517145627.GB5632@quack2.suse.cz>
References: <20170517123301.24211-1-tahsin@google.com>
 <20170517141357.GN18247@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48805 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751607AbdEQO4a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 May 2017 10:56:30 -0400
Content-Disposition: inline
In-Reply-To: <20170517141357.GN18247@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 17-05-17 16:13:57, Michal Hocko wrote:
> On Wed 17-05-17 05:33:01, Tahsin Erdogan wrote:
> > When a transaction starts, start_this_handle() saves current
> > PF_MEMALLOC_NOFS value so that it can be restored at journal stop time.
> > Journal restart is a special case that calls start_this_handle() without
> > stopping the transaction. start_this_handle() isn't aware that the
> > original value is already stored so it overwrites it with current value.
> > 
> > For instance, a call sequence like below leaves PF_MEMALLOC_NOFS flag set
> > at the end:
> > 
> >   jbd2_journal_start()
> >   jbd2__journal_restart()
> >   jbd2_journal_stop()
> > 
> > Make jbd2__journal_restart() restore the original value before calling
> > start_this_handle().
> > 
> > Fixes: 81378da64de6 ("jbd2: mark the transaction context with the scope GFP_NOFS context")
> > Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> > ---
> >  fs/jbd2/transaction.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 9ee4832b6f8b..dfd6afebdfeb 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -680,6 +680,7 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
> >  
> >  	rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
> >  	handle->h_buffer_credits = nblocks;
> > +	memalloc_nofs_restore(handle->saved_alloc_context);
> >  	ret = start_this_handle(journal, handle, gfp_mask);
> >  	return ret;
> >  }
> 
> I remember Jack has mentioned something about nested transaction back
> then when reviewing the patch. But I cannot remember or find a pointer
> to that email. I have a vague recollection that there is a reference
> counting for those transactions.
> 
> Anyway, Is this patch really correct? So let's say we are in
> the transaction context already and then you disable the scope
> NOFS protection, start_this_handle will allocate before it calls
> memalloc_nofs_save and that would recurse to the filesystem.  If
> anything wouldn't it be better to simply call memalloc_nofs_save only if
> we start a new transaction? I thought we were doing that already but the
> code is so convoluted I have hard time to wrap my head around it.

I was thinking about his as well but the fact is jbd2__journal_restart()
actually does equivalent of jbd2_journal_stop() for the handle above the
place where memalloc_nofs_restore() was added so in this sense we really
miss memalloc_nofs_restore() there... So what Tahsin did makes sense.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
