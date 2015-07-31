From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Limit number of reserved credits
Date: Fri, 31 Jul 2015 12:46:04 +0200
Message-ID: <20150731104604.GB22869@quack.suse.cz>
References: <1438329863-26422-1-git-send-email-lczerner@redhat.com>
 <20150731094639.GB16125@quack.suse.cz>
 <alpine.LFD.2.00.1507311207500.25183@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbbGaKqH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Jul 2015 06:46:07 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1507311207500.25183@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 31-07-15 12:22:43, Luk=C3=A1=C5=A1 Czerner wrote:
> On Fri, 31 Jul 2015, Jan Kara wrote:
>=20
> > Date: Fri, 31 Jul 2015 11:46:39 +0200
> > From: Jan Kara <jack@suse.cz>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, jack@suse.cz
> > Subject: Re: [PATCH] jbd2: Limit number of reserved credits
> >=20
> >   Hello,
> >=20
> > On Fri 31-07-15 10:04:23, Lukas Czerner wrote:
> > > Currently there is no limitation on number of reserved credits we=
 can
> > > ask for. If we ask for more reserved credits than 1/2 of maximum
> > > transaction size, or if total number of credits exceeds the maxim=
um
> > > transaction size per operation (which is currently only possible =
with
> > > the former) we will spin forever in start_this_handle().
> > >=20
> > > Fix this by adding this limitation at the start of start_this_han=
dle().
> > >=20
> > > This patch also removes the credit limitation 1/2 of maximum tran=
saction
> > > size, since we really only want to limit the number of reserved c=
redits.
> > > There is not much point to limit the credits if there is still sp=
ace in
> > > the journal.
> > >=20
> > > This accidentally also fixes the online resize, where due to the
> > > limitation of the journal credits we're unable to grow file syste=
ms with
> > > 1k block size and size between 16M and 32M. It has been partially=
 fixed
> > > by 2c869b262a10ca99cb866d04087d75311587a30c, but not entirely.
> > >=20
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > ---
> > >=20
> > > Honzo I think that this should be enough to remove the limitation=
 of 1/2 of
> > > maximum transaction size for regular credits, but I might be miss=
ing
> > > something, please let me know. Also do you have any specific test=
 case to
> > > exercise transaction reservation support - I've only ran xfstests=
=2E
> > >=20
> > >  fs/jbd2/transaction.c | 22 +++++++++++++---------
> > >  1 file changed, 13 insertions(+), 9 deletions(-)
> > >=20
> > > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > > index f3d0617..491a328 100644
> > > --- a/fs/jbd2/transaction.c
> > > +++ b/fs/jbd2/transaction.c
> > > @@ -262,20 +262,24 @@ static int start_this_handle(journal_t *jou=
rnal, handle_t *handle,
> > >  	int		rsv_blocks =3D 0;
> > >  	unsigned long ts =3D jiffies;
> > > =20
> > > +	if (handle->h_rsv_handle)
> > > +		rsv_blocks =3D handle->h_rsv_handle->h_buffer_credits;
> > > +
> > >  	/*
> > > -	 * 1/2 of transaction can be reserved so we can practically han=
dle
> > > -	 * only 1/2 of maximum transaction size per operation
> > > +	 * Limit the number of reserved credits to 1/2 of maximum trans=
action
> > > +	 * size and limit the number of total credits to not exceed max=
imum
> > > +	 * transaction size per operation.
> > >  	 */
> > > -	if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
> > > -		printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
> > > -		       current->comm, blocks,
> > > -		       journal->j_max_transaction_buffers / 2);
> > > +	if ((rsv_blocks > journal->j_max_transaction_buffers / 2) ||
> > > +	    (rsv_blocks + blocks > journal->j_max_transaction_buffers))=
 {
> > > +		printk(KERN_ERR "JBD2: %s wants too many credits "
> > > +		       "credits:%d rsv_credits:%d max:%d\n",
> > > +		       current->comm, blocks, rsv_blocks,
> > > +		       journal->j_max_transaction_buffers);
> > > +		WARN_ON(1);
> > >  		return -ENOSPC;
> > >  	}
> >=20
> > Well, the trouble with this is the following: The currently running
> > transaction has X reserved credits and Y normal credits. We know X+=
Y <=3D
> > journal->j_max_transaction_buffers. Now you request additional A re=
served
> > and B normal credits. Suppose we cannot fit in the current transact=
ion -
> > i.e., X+Y+A+B > journal->j_max_transaction_buffers. The only thing =
we can do
> > is to push running transaction to commit and start a new one. Howev=
er, the
> > new transaction will also have X reserved credits - you inherit res=
erved
> > credits from the previous transaction until they are converted to n=
ormal
> > credits. So if X+A+B is still > journal->j_max_transaction_buffers,=
 you
> > still cannot start current handle and you'd have to wait until some=
one
> > converts his reserved credits.
>=20
> Ok I understand, but isn't this true either way ? If anything the
> limit might make it worse in that case because if
>=20
> X+A+B is still > journal->j_max_transaction_buffers
>=20
> in the new case without the limit then it's definitely true for the
> case with the limit as well. The number of reserved credits is
> limited in both cases so it's not really a factor, is it ?
>=20
> Yes in the limitless case it might happen that we have so much
> normal credits that we can't fit in the reserved credits so we have
> to commit and start a new one, but that's true in both cases only
> with the limit it will happen sooner and possible more often because
> we just have less space to work with.
>=20
> Sorry if I am asking dumb questions, but I am trying to understand
> how is this supposed to work.
>=20
> And above all that limitation we're talking about is a hard limit
> which you're not supposed to hit ever. Only if something is really
> wrong and is asking for a handle with way too much credits...that's
> not what can normally happen. So what's the problem again ?

Thanks for correcting me! I was conflating two different conditions in =
the
transaction handling code. So with the change you propose, it would be =
only
possible that starting of large handles would keep pushing transactions=
 to
commit because it couldn't fit the handle into the running transaction
because of reserved credits. So if we wanted to relieve the condition a=
s
you suggest, we'd also need to modify the logic in
add_transaction_credits() to wait on j_wait_reserved in case number of
reserved credits of current trans + number of credits requested for the=
 handle
is too big. But that looks doable...

								Honza

>=20
> Thanks!
> -Lukas
>=20
>=20
> >=20
> > However these waits will create journal stalls causing possible per=
formance
> > issues and also introduce a lock dependency - suddently you are not=
 allowed
> > to acquire locks ranking above transaction start before starting a =
reserved
> > handle (as these locks can be held by processes being stuck waiting=
 for
> > reserved credits to convert).
> >=20
> > So overall halving the maximum allowed credits seemed like the leas=
t
> > painful solution to the problem.
> >=20
> > 								Honza
> > > =20
> > > -	if (handle->h_rsv_handle)
> > > -		rsv_blocks =3D handle->h_rsv_handle->h_buffer_credits;
> > > -
> > >  alloc_transaction:
> > >  	if (!journal->j_running_transaction) {
> > >  		/*
> > > --=20
> > > 1.8.3.1
> > >=20
> >=20
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
