From: Taesoo Kim <taesoo@gatech.edu>
Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
Date: Thu, 19 Mar 2015 08:02:43 -0400
Message-ID: <20150319120243.GG31460@taesoo.org>
References: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com>
 <alpine.LFD.2.00.1503181142160.23465@localhost.localdomain>
 <20150318173931.GJ29195@taesoo.org>
 <alpine.LFD.2.00.1503191046280.29774@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Taesoo Kim <tsgatesv@gmail.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
	csong84@gatech.edu
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35592 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbCSMCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2015 08:02:47 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503191046280.29774@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/19/15 at 10:48am, Luk=C3=A1=C5=A1 Czerner wrote:
> On Wed, 18 Mar 2015, Taesoo Kim wrote:
>=20
> > Date: Wed, 18 Mar 2015 13:39:31 -0400
> > From: Taesoo Kim <taesoo@gatech.edu>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: Taesoo Kim <tsgatesv@gmail.com>, tytso@mit.edu,
> >     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
> >     csong84@gatech.edu
> > Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
> >=20
> > > The patch looks good, thanks.
> >=20
> > Thank you.
> > =20
> > > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> > >=20
> > > Btw, were you able to reproduce the problem, or have you seen the
> > > problem in the wild ? Or did you just spot it in the code ?
> >=20
> > We are developing a static checker to spot inconsistent programming
> > patterns; our first goal is to scan over existing filesystems and
> > figure out how they are implemented differently (or similarly). We
> > will report bugs in sequence as soon as our team confirm (just star=
t
> > sending patches to other fs).
>=20
> And this was found but it ?

Our current prototype.
=20
> But anyway it sounds really interesting, do you have any more
> information you can share about the project ? Project website,
> description, or source code would be great :)

We need 1-2 months to wrap up. I would say, right after the deadline,
we plan to make the code/result publicly available :)

Taesoo
=20
> Thanks!
> -Lukas
>=20
> >=20
> > Thanks,
> > Taesoo
> >=20
> > > Thanks!
> > > -Lukas
> > >=20
> > > >=20
> > > > Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
> > > > ---
> > > >  fs/jbd2/transaction.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > > > index 5f09370..edb7f59 100644
> > > > --- a/fs/jbd2/transaction.c
> > > > +++ b/fs/jbd2/transaction.c
> > > > @@ -1091,6 +1091,7 @@ int jbd2_journal_get_create_access(handle=
_t *handle, struct buffer_head *bh)
> > > >  		JBUFFER_TRACE(jh, "file as BJ_Reserved");
> > > >  		spin_lock(&journal->j_list_lock);
> > > >  		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
> > > > +		spin_unlock(&journal->j_list_lock);
> > > >  	} else if (jh->b_transaction =3D=3D journal->j_committing_tra=
nsaction) {
> > > >  		/* first access by this transaction */
> > > >  		jh->b_modified =3D 0;
> > > > @@ -1098,8 +1099,8 @@ int jbd2_journal_get_create_access(handle=
_t *handle, struct buffer_head *bh)
> > > >  		JBUFFER_TRACE(jh, "set next transaction");
> > > >  		spin_lock(&journal->j_list_lock);
> > > >  		jh->b_next_transaction =3D transaction;
> > > > +		spin_unlock(&journal->j_list_lock);
> > > >  	}
> > > > -	spin_unlock(&journal->j_list_lock);
> > > >  	jbd_unlock_bh_state(bh);
> > > >=20
> > > >  	/*
> > > > --
> > > > 2.3.3
> > > >=20
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux=
-ext4" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
> > > >=20
> >=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
