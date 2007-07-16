From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Date: Mon, 16 Jul 2007 01:26:31 -0700
Message-ID: <1184574391.4005.32.camel@localhost.localdomain>
References: <1183275490.4010.134.camel@localhost.localdomain>
	 <20070710193117.a4ef6298.akpm@linux-foundation.org>
	 <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
	 <20070710214221.26539eb6.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?=22C=E9dric?= "Augonnet\""
	<cedric.augonnet@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070710214221.26539eb6.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 21:42 -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 23:21:49 -0400 "C=C3=A9dric Augonnet" <cedric.aug=
onnet@gmail.com> wrote:
>=20
> > 2007/7/10, Andrew Morton <akpm@linux-foundation.org>:
> >=20
> > Hi all,
> >=20
> > > > +     size =3D sizeof(struct transaction_stats_s);
> > > > +     s->stats =3D kmalloc(size, GFP_KERNEL);
> > > > +     if (s =3D=3D NULL) {
> > > > +             kfree(s);
> > > > +             return -EIO;
> > >
> > > ENOMEM
> >=20
> > I'm sorry if i missed some point, but i just don't see the use of s=
uch
> > a kfree here, not sure Andrew meant you should only return ENOMEM
> > instead, but why issuing those kfree(NULL), instead of just a if (!=
s)
> > return ENOMEM ?
> >=20
>=20
> You found a bug.  It was meant to be
>=20
> 	if (s->stats =3D=3D NULL)
>=20
>=20
The incremental fix patch is attached just FYI. It will be folded to th=
e
parent patch once the parent patch is being updated.


---
 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/fs/jbd2/journal.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/fs/jbd2/journal.c	2007-07-16 00:05:03.000000000 -=
0700
+++ linux-2.6.22/fs/jbd2/journal.c	2007-07-16 00:05:59.000000000 -0700
@@ -751,7 +751,7 @@ static int jbd2_seq_history_open(struct=20
 		return -EIO;
 	size =3D sizeof(struct transaction_stats_s) * journal->j_history_max;
 	s->stats =3D kmalloc(size, GFP_KERNEL);
-	if (s =3D=3D NULL) {
+	if (s->stats =3D=3D NULL) {
 		kfree(s);
 		return -EIO;
 	}


-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
