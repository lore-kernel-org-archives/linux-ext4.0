From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Limit number of reserved credits
Date: Fri, 31 Jul 2015 14:39:17 +0200
Message-ID: <20150731123917.GC22869@quack.suse.cz>
References: <1438329863-26422-1-git-send-email-lczerner@redhat.com>
 <20150731094639.GB16125@quack.suse.cz>
 <alpine.LFD.2.00.1507311207500.25183@localhost.localdomain>
 <20150731104604.GB22869@quack.suse.cz>
 <alpine.LFD.2.00.1507311256300.25183@localhost.localdomain>
 <alpine.LFD.2.00.1507311300380.25183@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbGaMjX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Jul 2015 08:39:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1507311300380.25183@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 31-07-15 13:07:59, Luk=C3=A1=C5=A1 Czerner wrote:
> On Fri, 31 Jul 2015, Luk=C3=A1=C5=A1 Czerner wrote:
>=20
> > Date: Fri, 31 Jul 2015 12:56:55 +0200 (CEST)
> > From: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > To: Jan Kara <jack@suse.cz>
> > Cc: linux-ext4@vger.kernel.org
> > Subject: Re: [PATCH] jbd2: Limit number of reserved credits
> >=20
> > On Fri, 31 Jul 2015, Jan Kara wrote:
> >=20
> > > Date: Fri, 31 Jul 2015 12:46:04 +0200
> > > From: Jan Kara <jack@suse.cz>
> > > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > > Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
> > > Subject: Re: [PATCH] jbd2: Limit number of reserved credits
> > >=20
> > > On Fri 31-07-15 12:22:43, Luk=C3=A1=C5=A1 Czerner wrote:
> > > > On Fri, 31 Jul 2015, Jan Kara wrote:
> > > >=20
> > > > > Date: Fri, 31 Jul 2015 11:46:39 +0200
> > > > > From: Jan Kara <jack@suse.cz>
> > > > > To: Lukas Czerner <lczerner@redhat.com>
> > > > > Cc: linux-ext4@vger.kernel.org, jack@suse.cz
> > > > > Subject: Re: [PATCH] jbd2: Limit number of reserved credits
> > > > >=20
> > > > >   Hello,
> > > > >=20
> > > > > On Fri 31-07-15 10:04:23, Lukas Czerner wrote:
> > > > > > Currently there is no limitation on number of reserved cred=
its we can
> > > > > > ask for. If we ask for more reserved credits than 1/2 of ma=
ximum
> > > > > > transaction size, or if total number of credits exceeds the=
 maximum
> > > > > > transaction size per operation (which is currently only pos=
sible with
> > > > > > the former) we will spin forever in start_this_handle().
> > > > > >=20
> > > > > > Fix this by adding this limitation at the start of start_th=
is_handle().
> > > > > >=20
> > > > > > This patch also removes the credit limitation 1/2 of maximu=
m transaction
> > > > > > size, since we really only want to limit the number of rese=
rved credits.
> > > > > > There is not much point to limit the credits if there is st=
ill space in
> > > > > > the journal.
> > > > > >=20
> > > > > > This accidentally also fixes the online resize, where due t=
o the
> > > > > > limitation of the journal credits we're unable to grow file=
 systems with
> > > > > > 1k block size and size between 16M and 32M. It has been par=
tially fixed
> > > > > > by 2c869b262a10ca99cb866d04087d75311587a30c, but not entire=
ly.
> > > > > >=20
> > > > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > > > ---
> > > > > >=20
> > > > > > Honzo I think that this should be enough to remove the limi=
tation of 1/2 of
> > > > > > maximum transaction size for regular credits, but I might b=
e missing
> > > > > > something, please let me know. Also do you have any specifi=
c test case to
> > > > > > exercise transaction reservation support - I've only ran xf=
stests.
> > > > > >=20
> > > > > >  fs/jbd2/transaction.c | 22 +++++++++++++---------
> > > > > >  1 file changed, 13 insertions(+), 9 deletions(-)
> > > > > >=20
> > > > > > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > > > > > index f3d0617..491a328 100644
> > > > > > --- a/fs/jbd2/transaction.c
> > > > > > +++ b/fs/jbd2/transaction.c
> > > > > > @@ -262,20 +262,24 @@ static int start_this_handle(journal_=
t *journal, handle_t *handle,
> > > > > >  	int		rsv_blocks =3D 0;
> > > > > >  	unsigned long ts =3D jiffies;
> > > > > > =20
> > > > > > +	if (handle->h_rsv_handle)
> > > > > > +		rsv_blocks =3D handle->h_rsv_handle->h_buffer_credits;
> > > > > > +
> > > > > >  	/*
> > > > > > -	 * 1/2 of transaction can be reserved so we can practical=
ly handle
> > > > > > -	 * only 1/2 of maximum transaction size per operation
> > > > > > +	 * Limit the number of reserved credits to 1/2 of maximum=
 transaction
> > > > > > +	 * size and limit the number of total credits to not exce=
ed maximum
> > > > > > +	 * transaction size per operation.
> > > > > >  	 */
> > > > > > -	if (WARN_ON(blocks > journal->j_max_transaction_buffers /=
 2)) {
> > > > > > -		printk(KERN_ERR "JBD2: %s wants too many credits (%d > %=
d)\n",
> > > > > > -		       current->comm, blocks,
> > > > > > -		       journal->j_max_transaction_buffers / 2);
> > > > > > +	if ((rsv_blocks > journal->j_max_transaction_buffers / 2)=
 ||
> > > > > > +	    (rsv_blocks + blocks > journal->j_max_transaction_buf=
fers)) {
> > > > > > +		printk(KERN_ERR "JBD2: %s wants too many credits "
> > > > > > +		       "credits:%d rsv_credits:%d max:%d\n",
> > > > > > +		       current->comm, blocks, rsv_blocks,
> > > > > > +		       journal->j_max_transaction_buffers);
> > > > > > +		WARN_ON(1);
> > > > > >  		return -ENOSPC;
> > > > > >  	}
> > > > >=20
> > > > > Well, the trouble with this is the following: The currently r=
unning
> > > > > transaction has X reserved credits and Y normal credits. We k=
now X+Y <=3D
> > > > > journal->j_max_transaction_buffers. Now you request additiona=
l A reserved
> > > > > and B normal credits. Suppose we cannot fit in the current tr=
ansaction -
> > > > > i.e., X+Y+A+B > journal->j_max_transaction_buffers. The only =
thing we can do
> > > > > is to push running transaction to commit and start a new one.=
 However, the
> > > > > new transaction will also have X reserved credits - you inher=
it reserved
> > > > > credits from the previous transaction until they are converte=
d to normal
> > > > > credits. So if X+A+B is still > journal->j_max_transaction_bu=
ffers, you
> > > > > still cannot start current handle and you'd have to wait unti=
l someone
> > > > > converts his reserved credits.
> > > >=20
> > > > Ok I understand, but isn't this true either way ? If anything t=
he
> > > > limit might make it worse in that case because if
> > > >=20
> > > > X+A+B is still > journal->j_max_transaction_buffers
> > > >=20
> > > > in the new case without the limit then it's definitely true for=
 the
> > > > case with the limit as well. The number of reserved credits is
> > > > limited in both cases so it's not really a factor, is it ?
> > > >=20
> > > > Yes in the limitless case it might happen that we have so much
> > > > normal credits that we can't fit in the reserved credits so we =
have
> > > > to commit and start a new one, but that's true in both cases on=
ly
> > > > with the limit it will happen sooner and possible more often be=
cause
> > > > we just have less space to work with.
> > > >=20
> > > > Sorry if I am asking dumb questions, but I am trying to underst=
and
> > > > how is this supposed to work.
> > > >=20
> > > > And above all that limitation we're talking about is a hard lim=
it
> > > > which you're not supposed to hit ever. Only if something is rea=
lly
> > > > wrong and is asking for a handle with way too much credits...th=
at's
> > > > not what can normally happen. So what's the problem again ?
> > >=20
> > > Thanks for correcting me! I was conflating two different conditio=
ns in the
> > > transaction handling code. So with the change you propose, it wou=
ld be only
> > > possible that starting of large handles would keep pushing transa=
ctions to
> > > commit because it couldn't fit the handle into the running transa=
ction
> > > because of reserved credits. So if we wanted to relieve the condi=
tion as
> > > you suggest, we'd also need to modify the logic in
> > > add_transaction_credits() to wait on j_wait_reserved in case numb=
er of
> > > reserved credits of current trans + number of credits requested f=
or the handle
> > > is too big. But that looks doable...
> >=20
> > Ah, right. Thanks, I'll resend the patch.
>=20
> One more question tough. Since we already check for available blocks
> in the transaction in add_transaction_credits() with:
>=20
> 	needed =3D atomic_add_return(total, &t->t_outstanding_credits);
> 		if (needed > journal->j_max_transaction_buffers) {
> 			...
>=20
> then we know that we have enough space, so we just need to make sure

The trouble happens when needed > journal->j_max_transaction_buffers. T=
hen
wait_transaction_locked(journal) doesn't necessarily guarantee forward
progress if "total > journal->j_max_transaction_buffers / 2" since we c=
an
have journal->j_max_transaction_buffers / 2 credits reserved and thus w=
e
would loop forcing transaction commits. Even now things are actually
slightly buggy because we only verify number of normal credits is <=3D
journal->j_max_transaction_buffers / 2, not 'total' so there's some
potential for busy loop even now.

Waits in that condition would need to be like:

	atomic_sub(total, &t->t_outstanding_credits);
	/*
	 * Is the number of reserved credits in the current transaction too
	 * big to fit this handle? Wait until reserved credits are freed.
	 */
	if (atomic_read(&journal->j_reserved_credits) + total >
	    journal->j_max_transaction_buffers) {
		read_unlock(&journal->j_state_lock);
		wait_event(journal->j_wait_reserved,
			   atomic_read(&journal->j_reserved_credits) + total <=3D
			   journal->j_max_transaction_buffers);
		return 1;
	}
	/*
	 * OK, if we push current transaction to commit, we should have
	 * enough space for our handle.
	 */
	wait_transaction_locked(journal);
	return 1;

								Honza

> that number of reserved credits is limited to 1/2 of
> j_max_transaction_buffers right ? So nothing more is needed except of
> maybe making sure that this is still true while we wait in case the
> reserved credits exceed 1/2 of the transaction. Something like this
> in the "if (needed > journal->j_max_transaction_buffers / 2)"
> condition should be enough ?
>=20
> 	wait_event(journal->j_wait_reserved,
> 		   atomic_read(&journal->j_reserved_credits) + total
> 		   <=3D journal->j_max_transaction_buffers);
>=20
> though I am not entirely sure this is necessary.
>=20
> Thanks!
> -Lukas
>=20
> >=20
> > -Lukas
> >=20
> > >=20
> > > 								Honza
> > >=20
> > > >=20
> > > > Thanks!
> > > > -Lukas
> > > >=20
> > > >=20
> > > > >=20
> > > > > However these waits will create journal stalls causing possib=
le performance
> > > > > issues and also introduce a lock dependency - suddently you a=
re not allowed
> > > > > to acquire locks ranking above transaction start before start=
ing a reserved
> > > > > handle (as these locks can be held by processes being stuck w=
aiting for
> > > > > reserved credits to convert).
> > > > >=20
> > > > > So overall halving the maximum allowed credits seemed like th=
e least
> > > > > painful solution to the problem.
> > > > >=20
> > > > > 								Honza
> > > > > > =20
> > > > > > -	if (handle->h_rsv_handle)
> > > > > > -		rsv_blocks =3D handle->h_rsv_handle->h_buffer_credits;
> > > > > > -
> > > > > >  alloc_transaction:
> > > > > >  	if (!journal->j_running_transaction) {
> > > > > >  		/*
> > > > > > --=20
> > > > > > 1.8.3.1
> > > > > >=20
> > > > >=20
> > >=20

--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
