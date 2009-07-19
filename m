From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Sun, 19 Jul 2009 15:59:21 +0100
Message-ID: <1248015561.4524.26.camel@quest>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com>
	 <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest>
	 <20090717150207.GA29705@mit.edu> <1247843694.4524.13.camel@quest>
	 <20090719115617.GF2416@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PX2tB/wPC+Uo9Y+CZyov"
Cc: linux-ext4@vger.kernel.org, util-linux-ng@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:60387 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZGSO7K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jul 2009 10:59:10 -0400
In-Reply-To: <20090719115617.GF2416@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-PX2tB/wPC+Uo9Y+CZyov
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-07-19 at 07:56 -0400, Theodore Tso wrote:

> > > > I've done the packaging for him, it's just waiting on him to get ba=
ck
> > > > home to sponsor the uploads.
> > >=20
> > > Are the .deb packages somewhere where I can examine them?
> > >=20
> > Yes, they're in Ubuntu.
>=20
> I just took a quick look at them, and it appears that they are missing
> the libblkid1-dbg, libuuid1-dbg, and uuid-runtime-dbg packages.
>=20
We auto-generate debug packages for all binaries in Ubuntu, extracted
from the compiler, e.g.:

http://ddebs.ubuntu.com/pool/main/u/util-linux/libblkid1-dbgsym_2.16-1ubunt=
u1_i386.ddeb

Since I'm not a Debian maintainer, I don't know how such things are done
in Debian so left this for you and/or Lamont to fill in.

> Also, apparently no once noticed until now, but there's a bug in the
> util-linux-ng's uuid.sym file.  The uuid_pack and uuid_unpack symbols
> are missing, because someone forgot to include them in the uuid.sym
> file.  The debian symbol generation system which I see you carefully
> moved over detected the problem, but you apparently didn't take a
> close enough look at its output to detect the warning messages.
>=20
I just copied the symbols file over and applied the update your output
said.

> BTW, **why** is util-linux-ng gratuitously introducing backwards
> incompatibility such that packages built with util-linux-ng won't work
> with the older shared libraries?   There's no reason to do this.
>=20
> There is a hint in the (obsolete) comments in uuid.sym that suggests a
> reason why, but it's not justified for libuuid:
>=20
You'd have to ask Karel about that one.

However I think now it's happened, we shouldn't back it out again.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-PX2tB/wPC+Uo9Y+CZyov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpjNMkACgkQSnQiFMl4yK7s8ACdFF52n1ywP+phDbjKzLxO3cZa
qS0AnAzJj88S2RCcgrUDUtaCHTh46HlE
=Przv
-----END PGP SIGNATURE-----

--=-PX2tB/wPC+Uo9Y+CZyov--

