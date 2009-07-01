From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 18:35:06 -0400
Message-ID: <200907011835.08501.vapier@gentoo.org>
References: <200905311113.23004.arvidjaar@mail.ru> <20090701214345.GG17054@mit.edu> <ac3eb2510907011452g3c2c2b3cs8d0ed398117879be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4856915.3oMVuJeUV0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:59045 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZGAWgh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jul 2009 18:36:37 -0400
In-Reply-To: <ac3eb2510907011452g3c2c2b3cs8d0ed398117879be@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart4856915.3oMVuJeUV0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 July 2009 17:52:11 Kay Sievers wrote:
> On Wed, Jul 1, 2009 at 23:43, Theodore Tso<tytso@mit.edu> wrote:
> > On Tue, Jun 30, 2009 at 12:17:02PM +0200, Kay Sievers wrote:
> >> And another thing is your custom "silent build" which can not be
> >> disabled. Our build system requires the command output for fancy
> >> analysis, so it would be good if it could be disabled, like it can for
> >> the kernel (V=3D1). Any ideas, or do I miss some switch?
> >
> > Is a configure-level switch all that you need?  I hadn't done a
> > make-level switch because I was trying to avoid adding a requirement
> > of using GNU make in building e2fsprogs, since it gets used by *BSD
> > and Solaris systems as well.  (And in fact some of the recent UUID bug
> > fixes come from FreeBSD bug reports, and I suspect FreeBSD will
> > continue to use UUID library from e2fsprogs rather than pulling in
> > util-linux-ng....)
>
> Anything would work, that resolves the '@' to nothing and puts out the
> command, an environment var or a switch.
>
> In older udev releases, before we switched to automake, I had
> something like this, which behaves a bit like the Linux kernel build,
> and V=3D1 switches off the silent mode:

why not just use automake-1.11's silent-rules option.  then you dont have t=
o=20
waste time reinventing the wheel.
=2Dmike

--nextPart4856915.3oMVuJeUV0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKS+ScAAoJEEFjO5/oN/WBWC0P/iaCFhaJO+O9IB/t3Tdxfi6p
uepzO4tkFf6nTKNktqZ5gctE22Tb3E2bQUk+UUVPGil5Ta3cAxZi0p4RcoyKjnXH
dm1BkHQSPX5mclktC9LnLqqZ/hMHsNrJZr1azHr+M2qZ6Bd3ZIY0rWPB0YyDm6ej
KpG/ucymVW337zH+uy2LqMnM0ywPkYSeMOWYJUnscEYzUoGlgrn2ztk05UiMLsrA
6VvBvBx5/BGPvAwG3iVBxhzKpH7sgkPvrQpynpyLIbu9Xbw4R73dziemZ1ojXejt
mVyvAJsK58ichMFIpgxnHSxOO/kUY2giDV0UBoYMWAReiim1zY9iyvi/N+3OhFQp
gYQ2C7MJLcSxeDdF8aVZgwUFxCT4JCaLMr0SPR5VfZFnIqcrJ7rU+uMRFePxPizZ
oMKwOc8d+OVDy/2lEq5NV7IUcRM8mENaSettQ6hig5wwOL8Y/kAXn/FcgLyfOZ+a
Gqz7tgrMieM1GFgFNMT3DN/mwVPhSRqeYknFJYCjpL/y6ZqAInApB6jqhVZ8n5kI
HTf6X1bdOsWr3YXQcHzXFP0TDxFbcKbT7XN8XRe8DYPsO/qzfmQYxWqrzCmxrl+z
RN7UM3Y3/SSgXNc/8tMBNbphodN0NiBhbh9l3Cl4RD7KGXAR27DS2o8RBCeAPQMY
N8cQKpxIikv/zJbst+4E
=45Kc
-----END PGP SIGNATURE-----

--nextPart4856915.3oMVuJeUV0--
