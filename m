From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO
	whentry_to_release_page fails
Date: Tue, 05 Aug 2008 14:17:07 -0700
Message-ID: <1217971027.7516.20.camel@mingming-laptop>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
	 <1217953055.7899.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:33625 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYHEVRM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 17:17:12 -0400
In-Reply-To: <1217953055.7899.11.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-05=E4=BA=8C=E7=9A=84 12:17 -0400=EF=BC=8CChris Mason=E5=
=86=99=E9=81=93=EF=BC=9A
> On Tue, 2008-08-05 at 13:51 +0900, Hisashi Hifumi wrote:
> > >> >=20
> > >> > diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c=20
> > >linux-2.6.27-rc1/fs/jbd/transaction.c
> > >> > --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29=20
> > >19:28:47.000000000 +0900
> > >> > +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.=
000000000 +0900
> > >> > @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal=
_
> > >> >  	*/
> > >> >  	if (ret =3D=3D 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & _=
_GFP_FS)) {
> > >> >  		journal_wait_for_transaction_sync_data(journal);
> > >> > +
> > >> > +		bh =3D head;
> > >> > +		do {
> > >> > +			while (atomic_read(&bh->b_count))
> > >> > +				schedule();
> > >> > +		} while ((bh =3D bh->b_this_page) !=3D head);
> > >> >  		ret =3D try_to_free_buffers(page);
> > >> >  	}
> > >>=20
> > >> The loop is problematic.  If the scheduler decides to keep runni=
ng this
> > >> task then we have a busy loop.  If this task has realtime policy=
 then
> > >> it might even lock up the kernel.
> > >>=20
> > >
> > >ocfs2 calls journal_try_to_free_buffers too, looping on b_count mi=
ght
> > >not be the best idea there either.
> > >
> > >This code gets called from releasepage, which is used other places=
 than
> > >the O_DIRECT invalidation paths, I'd be worried about performance
> > >problems here.
> > >
> >=20
> > try_to_release_page has gfp_mask parameter. So when try_to_releasep=
age
> > is called from performance sensitive part, gfp_mask should not be s=
et.
> > b_count check loop is inside of (gfp_mask & __GFP_WAIT) && (gfp_mas=
k & __GFP_FS) check.
>=20
> Looks like try_to_free_pages will go into releasepage with wait & fs
> both set.  This kind of change would make me very nervous.
>=20

Hi Chris,

The gfp_mask try_to_free_pages() takes from it's caller will past it
down to try_to_release_page().  Based on the meaning of __GFP_WAIT and
GFP_FS, if the upper level caller set these two flags,  I assume the
upper level caller expect delay and wait for fs to finish?


But I agree that using a loop in journal_try_to_free_buffers() to wait
for the busy bh release the counter is expensive...
Mingming
> -chris
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
