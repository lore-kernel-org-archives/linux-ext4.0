From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference when journal
 restart fails
Date: Thu, 14 May 2015 13:33:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1505141327501.26657@localhost.localdomain>
References: <1431594186-29043-1-git-send-email-lczerner@redhat.com> <20150514092457.GB13656@quack.suse.cz> <alpine.LFD.2.00.1505141133500.26657@localhost.localdomain> <20150514103500.GA30083@quack.suse.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1967376782-1431603213=:26657"
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150514103500.GA30083@quack.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1967376782-1431603213=:26657
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 May 2015, Jan Kara wrote:

> Date: Thu, 14 May 2015 12:35:00 +0200
> From: Jan Kara <jack@suse.cz>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
>     Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
> Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference when journal
>     restart fails
> 
> On Thu 14-05-15 11:37:46, Lukáš Czerner wrote:
> > On Thu, 14 May 2015, Jan Kara wrote:
> > 
> > > Date: Thu, 14 May 2015 11:24:57 +0200
> > > From: Jan Kara <jack@suse.cz>
> > > To: Lukas Czerner <lczerner@redhat.com>
> > > Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
> > >     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
> > > Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference when journal
> > >     restart fails
> > > 
> > > On Thu 14-05-15 11:03:06, Lukas Czerner wrote:
> > > > Currently when journal restart fails, we'll have the h_transaction of
> > > > the handle set to NULL to indicate that the handle has been effectively
> > > > aborted. We handle this situation quietly in the jbd2_journal_stop() and just
> > > > free the handle and exit because everything else has been done before we
> > > > attempted (and failed) to restart the journal.
> > > > 
> > > > Unfortunately there are a number of problems with that approach
> > > > introduced with commit
> > > > 
> > > > 41a5b913197c "jbd2: invalidate handle if jbd2_journal_restart()
> > > > fails"
> > > > 
> > > > First of all in ext4 jbd2_journal_stop() will be called through
> > > > __ext4_journal_stop() where we would try to get a hold of the superblock
> > > > by dereferencing h_transaction which in this case would lead to NULL
> > > > pointer dereference and crash.
> > > > 
> > > > In addition we're going to free the handle regardless of the refcount
> > > > which is bad as well, because others up the call chain will still
> > > > reference the handle so we might potentially reference already freed
> > > > memory.
> > > > 
> > > > Moreover it's expected that we'll get aborted handle as well as detached
> > > > handle in some of the journalling function as the error propagates up
> > > > the stack, so it's unnecessary to call WARN_ON every time we get
> > > > detached handle.
> > > > 
> > > > And finally we might leak some memory by forgetting to free reserved
> > > > handle in jbd2_journal_stop() in the case where handle was detached from
> > > > the transaction (h_transaction is NULL).
> > > > 
> > > > Fix the NULL pointer dereference in __ext4_journal_stop() by just
> > > > calling jbd2_journal_stop() quietly as suggested by Jan Kara. Also fix
> > > > the potential memory leak in jbd2_journal_stop() and use proper
> > > > handle refcounting before we attempt to free it to avoid use-after-free
> > > > issues.
> > > > 
> > > > And finally remove all WARN_ON(!transaction) from the code so that we do
> > > > not get random traces when something goes wrong because when journal
> > > > restart fails we will get to some of those functions.
> > > > 
> > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > > v2: As Jan Kara pointed out setting h_transaction to NULL is actually
> > > > desirable because the handle was detached from that transaction.
> > > 
> > > The patch looks good, you can add:
> > > 
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > 
> > >   Just one small nit below:
> > > 
> > > ...
> > > > @@ -1530,8 +1524,22 @@ int jbd2_journal_stop(handle_t *handle)
> > > >  	tid_t tid;
> > > >  	pid_t pid;
> > > >  
> > > > -	if (!transaction)
> > > > -		goto free_and_exit;
> > > > +	if (!transaction) {
> > > > +		/*
> > > > +		 * Handle is already detached from the transaction so
> > > > +		 * there is nothing to do other than decrease a refcount,
> > > > +		 * or free the handle if refcount drops to zero
> > > > +		 */
> > > > +		if (--handle->h_ref > 0) {
> > > > +			jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
> > > > +							 handle->h_ref);
> > > > +			return err;
> > > > +		} else {
> > > > +			if (handle->h_rsv_handle)
> > > > +				jbd2_free_handle(handle->h_rsv_handle);
> > > > +			goto free_and_exit;
> > > 
> > > It would we nicer if you just moved free_and_exit label before freeing of
> > > the reserved handle instead of duplicating the code here. Also it is more
> > > future proof if we add more places jumping to the label...
> > 
> > The problem is that this a special case when we have detached handle
> > so we only need to free the structure. In normal case we're calling
> > jbd2_journal_free_reserved() instead and I did not wanted to add
> > (!transaction) condition to multiple places.
> > 
> > jbd2_journal_free_reserved() is different in that it does
> > sub_reserved_credits() for the journal, but in this case it has
> > already been done in jbd2__journal_restart().
>   Hum, actually you must call jbd2_journal_free_reserved() so that you
> don't leak credits assigned for the reserved handle, I missed that you call
> only jbd2_free_handle(). And note that although the current handle is
> detached, its reserved handle is still properly attached to the journal
> (not any particular transaction) so it is safe to call
> jbd2_journal_free_reserved().

Sure, but this is already done in jbd2__journal_restart()

if (handle->h_rsv_handle) {
	sub_reserved_credits(journal, handle->h_rsv_handle->h_buffer_credits);
}

and AFAICT if start_this_handle() fails then we would not have
increased the reserved credits, or am I missing something ?

-Lukas

> 
> 								Honza
> 
--8323328-1967376782-1431603213=:26657--
