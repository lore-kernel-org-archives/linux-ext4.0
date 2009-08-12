From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] Compile warning fix when enable EXT_DEBUG
Date: Wed, 12 Aug 2009 09:02:02 -0700
Message-ID: <1250092922.18329.32.camel@mingming-laptop>
References: <1250091147.18329.10.camel@mingming-laptop>
	 <4A82E41F.2050702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50561 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZHLQCP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2009 12:02:15 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7CG0YkY029858
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 10:00:34 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7CG24qX146130
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 10:02:05 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7CG23ms016201
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 10:02:04 -0600
In-Reply-To: <4A82E41F.2050702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-08-12 at 10:47 -0500, Eric Sandeen wrote:
> Mingming wrote:
> > When enable EXT_DEBUG I got the following compile warning on PPC64
> >=20
> >   CC [M]  fs/ext4/inode.o
> >   CC [M]  fs/ext4/extents.o
> > fs/ext4/extents.c: In function =E2=80=98ext4_ext_rm_leaf=E2=80=99:
> > fs/ext4/extents.c:2097: warning: format =E2=80=98%lu=E2=80=99 expec=
ts type =E2=80=98long unsigned int=E2=80=99, but argument 2 has type =E2=
=80=98ext4_lblk_t=E2=80=99
> > fs/ext4/extents.c: In function =E2=80=98ext4_ext_get_blocks=E2=80=99=
:
> > fs/ext4/extents.c:2789: warning: format =E2=80=98%u=E2=80=99 expect=
s type =E2=80=98unsigned int=E2=80=99, but argument 4 has type =E2=80=98=
long unsigned int=E2=80=99
> > fs/ext4/extents.c:2852: warning: format =E2=80=98%lu=E2=80=99 expec=
ts type =E2=80=98long unsigned int=E2=80=99, but argument 3 has type =E2=
=80=98ext4_lblk_t=E2=80=99
> > fs/ext4/extents.c:2953: warning: format =E2=80=98%lu=E2=80=99 expec=
ts type =E2=80=98long unsigned int=E2=80=99, but argument 4 has type =E2=
=80=98unsigned int=E2=80=99
> >   CC [M]  fs/ext4/migrate.o
> >=20
> > The patch fixed compile warning.
>=20
> and a little bit more ... :)
>=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> >=20
> > Index: linux-2.6.31-rc4/fs/ext4/extents.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.31-rc4.orig/fs/ext4/extents.c
> > +++ linux-2.6.31-rc4/fs/ext4/extents.c
> > @@ -2105,7 +2105,8 @@ ext4_ext_rm_leaf(handle_t *handle, struc
> >  		else
> >  			uninitialized =3D 0;
> > =20
> > -		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
> > +		ext_debug("remove ext %u:[%d]%d\n", ex_ee_block,
> > +			 ext4_ext_is_uninitialized(ex), ex_ee_len);
> >  		path[depth].p_ext =3D ex;
>=20
> Shouldn't part of this be in your next patch, [PATCH]Show unwritten
> extent flag in ext4_ext_show_leaf() ?
>=20

ah, that's right, I will resend the two patches :)

Mingming
> Thanks,
> -Eric


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
