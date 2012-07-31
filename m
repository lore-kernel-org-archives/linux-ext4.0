From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Tue, 31 Jul 2012 15:21:50 +1000
Message-ID: <20120731052150.GB14970@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120627112117.GA15231@thor.bakeyournoodle.com>
 <20120627125443.GA32356@thunk.org>
 <20120628024356.GB17989@thor.bakeyournoodle.com>
 <20120730214531.GE10343@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:33016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2GaFVz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 01:21:55 -0400
Content-Disposition: inline
In-Reply-To: <20120730214531.GE10343@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 30, 2012 at 05:45:32PM -0400, Theodore Ts'o wrote:
> On Thu, Jun 28, 2012 at 12:43:56PM +1000, Tony Breeds wrote:
> >=20
> > Okay so I think you want somethign like:
>=20
> Yep!
>=20
> > What I did was remove dblist.o from my libext2fs.a and I now get:
> > /home/tony/src/e2fsprogs/../e2fsprogs-root/lib/libext2fs.a(gen_bitmap64=
=2Eo): In function `ext2fs_alloc_generic_bmap':
> > /home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs=
/gen_bitmap64.c:112: undefined reference to `ext2fs_get_num_dirs'
> >=20
> > So it looks like dblist.o is being pulled in for ext2fs_get_num_dirs()
> > in that case a EXT2FS_BMAP64_AUTODIR bmap type has been asked for.
> >=20
> > How would you feel about moving ext2fs_get_num_dirs from dblist.c to
> > blknum.c?
>=20
> Sure, no problem.
>=20
> Take a look at this set of patches (see attached).  With this and the
> set of ext2fs functions that I understand yaboot is using, I think it
> solves the concern that you have.  This will be in the next branch of
> the e2fsprogs.

Thanks so much Ted for your help with my patches and the next set.

I tried next + your 7 patches and yaboot only fails with errors for
calloc and abort.  Both of these I'm very happy to fix in yaboot.

Looking forward to v1.42.6 :)

Yours Tony

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQF2tuAAoJEEsCiJRY75GK7sgP/Ru1q2T6uYAq6zaM4xzN5gi/
kD8ajLIvompT5DOTQ1CAALf6s+n+7ZMwC3vbi9SjfqtuXLEWHJsLhRQx/nPoUNhH
qUcERidpKTHEQnzqaqbQ27fPLSh9NRGAr4EW8qVsyLHcxt/JLHtXodEuylU9iaU/
m6/3m63jbIDMDUx0ipFeue4+yn5QX+cdjFCypZmHavQTAtpIN13KYqhoPpGkOBTq
QmQoW0jgkTU3KtIldyge7U5ZTsDN34nuSkokJVUXm7pHd7Z2SxTfQS5uekum6pwm
N9XVZeOAzclZQW9LNlwnTszJA5yhaedA2gqNQgJe98n9lHZpm1vH8x298Qt6r4tI
JdMPKlQEwk2vH4/9uVmSuol/JltPfcv8rEWoGzhBVPUcpN0YrCpesTJA/tEb03qk
ILD7o5nBdIIwj3QsYGganol294pxmnm2YvA/RAEoq9bZe06Vdba0+lWk9fwgrip0
NRioAp2KtziD9WtBtGf6UXbeC9c8i8uilxRlgdIHbYVHhL7XdPpzcpHSZR38cb4K
Ok7NiflLyjgeW7K0Z3lRUdM6T2qkXULjAY9p5EuD69N8ZiK+i4t1gq0OJe8eqUHY
fED/uKXZuXqOXvv+oduwc/TB2ZiTItF+2cJxu7AdYwx2mG97Sxx0dkoVSGakZr+u
3bf3ilLFzvpC314LuU2x
=EEUs
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
