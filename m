From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: kernel BUG at fs/ext4/extents.c:2766!
Date: Wed, 7 Mar 2012 18:29:49 +0100
Message-ID: <20120307172949.GA5799@alea.gnuu.de>
References: <20120307011430.GA613@alea.gnuu.de>
 <CAGBYx2bc7mgYGm3gTbJt2Lhd7UbvW59fk7JPDs9dVqPJ-9OB3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:4515 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab2CGRjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 12:39:10 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2bc7mgYGm3gTbJt2Lhd7UbvW59fk7JPDs9dVqPJ-9OB3A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hallo Yank,

Yongqiang Yang hat am Wed 07. Mar, 18:59 (+0800) geschrieben:
> On Wed, Mar 7, 2012 at 9:14 AM, J=F6rg Sommer <joerg@alea.gnuu.de> wrote:
> > Hi,
> >
> > I've got this Oops after I've created a file that filled up the
> > filesystem.
> >
> > [ =A0852.407974] ------------[ cut here ]------------
> > [ =A0852.412105] kernel BUG at /build/buildd-linux-2.6_3.2.9-1-powerpc-=
xXyGnW/linux-2.6-3.2.9/debian/build/source_powerpc_none/fs/ext4/extents.c:2=
766!
> Hi,
>=20
> Could this be reproduced?

I can't belive it, yes, it's possible. I haven't expected this. I can
provide you a filesystem image that you can boot and reproduce it
yourself, if you have qemu installed. The image is 620MB. I can also
create an image with e2image from the broken filesystem.

Regards, J=F6rg.
--=20
And 1.1.81 is officially BugFree(tm), so if you receive any bug-reports
on it, you know they are just evil lies.
            (Linus Torvalds)

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9Xmw0ACgkQwe0mZwH1VICMBwCeI1fwRuhDrr2NPvfJ2lNdX0my
bgsAn2UAjcjlGzRDKBmsCAOcTHrpqxLU
=jwgE
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
