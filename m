From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference when journal
 restart fails
Date: Thu, 14 May 2015 13:43:04 +0200
Message-ID: <20150514114304.GB10093@quack.suse.cz>
References: <1431594186-29043-1-git-send-email-lczerner@redhat.com>
 <20150514092457.GB13656@quack.suse.cz>
 <alpine.LFD.2.00.1505141133500.26657@localhost.localdomain>
 <20150514103500.GA30083@quack.suse.cz>
 <alpine.LFD.2.00.1505141327501.26657@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1505141327501.26657@localhost.localdomain>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 14-05-15 13:33:28, Luk=C3=A1=C5=A1 Czerner wrote:
> On Thu, 14 May 2015, Jan Kara wrote:
>=20
> > Date: Thu, 14 May 2015 12:35:00 +0200
> > From: Jan Kara <jack@suse.cz>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
> >     Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
> > Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference when jou=
rnal
> >     restart fails
> >=20
> > On Thu 14-05-15 11:37:46, Luk=C3=A1=C5=A1 Czerner wrote:
> > > On Thu, 14 May 2015, Jan Kara wrote:
> > >=20
> > > > Date: Thu, 14 May 2015 11:24:57 +0200
> > > > From: Jan Kara <jack@suse.cz>
> > > > To: Lukas Czerner <lczerner@redhat.com>
> > > > Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
> > > >     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
> > > > Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference when=
 journal
> > > >     restart fails
> > > >=20
> > > > On Thu 14-05-15 11:03:06, Lukas Czerner wrote:
> > > > > Currently when journal restart fails, we'll have the h_transa=
ction of
> > > > > the handle set to NULL to indicate that the handle has been e=
ffectively
> > > > > aborted. We handle this situation quietly in the jbd2_journal=
_stop() and just
> > > > > free the handle and exit because everything else has been don=
e before we
> > > > > attempted (and failed) to restart the journal.
> > > > >=20
> > > > > Unfortunately there are a number of problems with that approa=
ch
> > > > > introduced with commit
> > > > >=20
> > > > > 41a5b913197c "jbd2: invalidate handle if jbd2_journal_restart=
()
> > > > > fails"
> > > > >=20
> > > > > First of all in ext4 jbd2_journal_stop() will be called throu=
gh
> > > > > __ext4_journal_stop() where we would try to get a hold of the=
 superblock
> > > > > by dereferencing h_transaction which in this case would lead =
to NULL
> > > > > pointer dereference and crash.
> > > > >=20
> > > > > In addition we're going to free the handle regardless of the =
refcount
> > > > > which is bad as well, because others up the call chain will s=
till
> > > > > reference the handle so we might potentially reference alread=
y freed
> > > > > memory.
> > > > >=20
> > > > > Moreover it's expected that we'll get aborted handle as well =
as detached
> > > > > handle in some of the journalling function as the error propa=
gates up
> > > > > the stack, so it's unnecessary to call WARN_ON every time we =
get
> > > > > detached handle.
> > > > >=20
> > > > > And finally we might leak some memory by forgetting to free r=
eserved
> > > > > handle in jbd2_journal_stop() in the case where handle was de=
tached from
> > > > > the transaction (h_transaction is NULL).
> > > > >=20
> > > > > Fix the NULL pointer dereference in __ext4_journal_stop() by =
just
> > > > > calling jbd2_journal_stop() quietly as suggested by Jan Kara.=
 Also fix
> > > > > the potential memory leak in jbd2_journal_stop() and use prop=
er
> > > > > handle refcounting before we attempt to free it to avoid use-=
after-free
> > > > > issues.
> > > > >=20
> > > > > And finally remove all WARN_ON(!transaction) from the code so=
 that we do
> > > > > not get random traces when something goes wrong because when =
journal
> > > > > restart fails we will get to some of those functions.
> > > > >=20
> > > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > > v2: As Jan Kara pointed out setting h_transaction to NULL is =
actually
> > > > > desirable because the handle was detached from that transacti=
on.
> > > >=20
> > > > The patch looks good, you can add:
> > > >=20
> > > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > >=20
> > > >   Just one small nit below:
> > > >=20
> > > > ...
> > > > > @@ -1530,8 +1524,22 @@ int jbd2_journal_stop(handle_t *handle=
)
> > > > >  	tid_t tid;
> > > > >  	pid_t pid;
> > > > > =20
> > > > > -	if (!transaction)
> > > > > -		goto free_and_exit;
> > > > > +	if (!transaction) {
> > > > > +		/*
> > > > > +		 * Handle is already detached from the transaction so
> > > > > +		 * there is nothing to do other than decrease a refcount,
> > > > > +		 * or free the handle if refcount drops to zero
> > > > > +		 */
> > > > > +		if (--handle->h_ref > 0) {
> > > > > +			jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
> > > > > +							 handle->h_ref);
> > > > > +			return err;
> > > > > +		} else {
> > > > > +			if (handle->h_rsv_handle)
> > > > > +				jbd2_free_handle(handle->h_rsv_handle);
> > > > > +			goto free_and_exit;
> > > >=20
> > > > It would we nicer if you just moved free_and_exit label before =
freeing of
> > > > the reserved handle instead of duplicating the code here. Also =
it is more
> > > > future proof if we add more places jumping to the label...
> > >=20
> > > The problem is that this a special case when we have detached han=
dle
> > > so we only need to free the structure. In normal case we're calli=
ng
> > > jbd2_journal_free_reserved() instead and I did not wanted to add
> > > (!transaction) condition to multiple places.
> > >=20
> > > jbd2_journal_free_reserved() is different in that it does
> > > sub_reserved_credits() for the journal, but in this case it has
> > > already been done in jbd2__journal_restart().
> >   Hum, actually you must call jbd2_journal_free_reserved() so that =
you
> > don't leak credits assigned for the reserved handle, I missed that =
you call
> > only jbd2_free_handle(). And note that although the current handle =
is
> > detached, its reserved handle is still properly attached to the jou=
rnal
> > (not any particular transaction) so it is safe to call
> > jbd2_journal_free_reserved().
>=20
> Sure, but this is already done in jbd2__journal_restart()
>=20
> if (handle->h_rsv_handle) {
> 	sub_reserved_credits(journal, handle->h_rsv_handle->h_buffer_credits=
);
> }
>=20
> and AFAICT if start_this_handle() fails then we would not have
> increased the reserved credits, or am I missing something ?
  Argh, the code is more subtle than I thought ;-). You are absolutely
right and what you do is correct.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
