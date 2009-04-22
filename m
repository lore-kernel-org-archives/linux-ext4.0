From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Wed, 22 Apr 2009 14:42:25 +0100
Message-ID: <1240407745.2902.3.camel@wing-commander>
References: <20090224084434.GF6020@nb.net.home>
	 <20090324121147.GA22386@zelda.netsplit.com>
	 <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest>
	 <20090422133304.GP15541@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/aS0AXmbb+K/NUHNkOKi"
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:41909 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZDVNmf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Apr 2009 09:42:35 -0400
In-Reply-To: <20090422133304.GP15541@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-/aS0AXmbb+K/NUHNkOKi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Great to hear from you, Ted!

On Wed, 2009-04-22 at 09:33 -0400, Theodore Tso wrote:

> Also, I have not dropped in the debian packaging changes which you
> made Scott, since you just conditionally made changes to the
> debian/rules and debian/config file, which means e2fsprogs would break
> on Debian (which hasn't even packaged util-linux-ng yet) and on
> versions of Ubuntu that haven't made the switch yet.
>=20
Yeah, that seems fair.  I actually left both versions of the code in the
rules with the in-tree blkid stuff commented out assuming we'd ifeq
around them as we do with util-linux-ng.

The package went into a PPA not the archive, so it was in a "just get it
done and worry about making it look good later" state.

Obviously this doesn't solve the debian/control problem - that would
require generating it with/without the libblkid parts depending on
target distro.

> P.S.  Scott, if you haven't been tracking linux-ext4, there are some
> rather critical resize2fs bugfixes that recently came into the tree,
> which fix bugs that cause filesystem corruption when growing or
> shrinking ext4 filesystems off-line.
>=20
Grabbed that, thanks!

We're absolutely final frozen for Jaunty now; the CDs were spun on
Monday, but the problem has been noted in our Release Notes.

Since the patches are reasonably small and uninvasive, we'll look into
them for a jaunty-updates upload.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-/aS0AXmbb+K/NUHNkOKi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknvHsEACgkQSnQiFMl4yK5KhACfRdSkzFqVBN9lPyWW6niJ/a1n
oZUAoI6akrEBekyy9cY1gStAq0G1TMoy
=3tIJ
-----END PGP SIGNATURE-----

--=-/aS0AXmbb+K/NUHNkOKi--

