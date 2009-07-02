From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 21:15:54 -0400
Message-ID: <200907012115.57826.vapier@gentoo.org>
References: <200905311113.23004.arvidjaar@mail.ru> <200907011835.08501.vapier@gentoo.org> <20090702005858.GH17054@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1818538.SYJ1OpMOhC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48930 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZGBBRV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jul 2009 21:17:21 -0400
In-Reply-To: <20090702005858.GH17054@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1818538.SYJ1OpMOhC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 July 2009 20:58:58 Theodore Tso wrote:
> On Wed, Jul 01, 2009 at 06:35:06PM -0400, Mike Frysinger wrote:
> > > In older udev releases, before we switched to automake, I had
> > > something like this, which behaves a bit like the Linux kernel build,
> > > and V=3D1 switches off the silent mode:
> >
> > why not just use automake-1.11's silent-rules option.  then you dont ha=
ve
> > to waste time reinventing the wheel.
>
> Because I consider automake the spawn of Satan?  :-)

i'll have you know Satan's wheel is awfully shiny ...

Kay's rules look like they should be fairly straightforward to drop into=20
e2fsprogs.  personally i'd use:
E =3D @:
when V=3D1, but this is probably just splitting hairs
=2Dmike

--nextPart1818538.SYJ1OpMOhC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKTApNAAoJEEFjO5/oN/WBaEYP/R1srz7rHDSwyzSnV1hcz7jY
J3zDdeAbWFxqWXk1+PUU6G2H9eB9gt2qfkjHFPeo2Ho5yz+bIEUNmsLwfQBqg6/q
jbcyoZ5OIjBbUNXlyWgC10BiaoIwXt+VKkrLH4cDpEt8MZ//Bb4LjXFw6ME3jWen
7go+1z492amkDfqoTXUuIjJykNqv87HxVIMcyYdNQp59gck971Q/QKuc4Whfm07C
AoRWPWMGMNaLHq/R99M2pu2hVFS2NqmvYLmJF9/BSATfQiDxoZiGNIxOruPwiLDi
8bCF2IQYW8zFOL3O/r/jnmSH512X8l5o+9gwBv4JaYBhb2kTfar1k8Rsi+Hjo+sv
qjTCNekI2nfEKb2bVNpiVQ/Pcw2a36+CMalTVabpAC9CEW1sRAow3oZqUQikcHa2
gfUyyqKi1ZZbiSmoMh9+dOZFhD8vq+nEoP2+wctRkQB3gTo+E5KWBjKHnbkQFYVy
J8eV1KzteEUAPiYT2GfkT9fT54KpoBMShcDPMHXFQ3gvxmhk9o2p4z4n6bk/cp19
wryPpSElfbSZos2wimFCGy9zNFnK1MC2h+QAnAK5KpPJTjc2MYHERJNewJOIZp4p
k0fc/V5zHE9uhSbOMZoj9tMQXGGYAUUgc7welY3D/TmdJAWYqRW0/B8vLyHgvo9R
FJfW4FLIIoqYA0K5ys0h
=BIn/
-----END PGP SIGNATURE-----

--nextPart1818538.SYJ1OpMOhC--
