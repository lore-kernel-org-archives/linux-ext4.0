From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 2/8] exofs: remove lock/unlock super
Date: Thu, 16 Aug 2012 16:10:11 +0300
Message-ID: <1345122611.3393.225.camel@sauron.fi.intel.com>
References: <502CC4AA.6040702@gmail.com>
	 <1345119652.3393.220.camel@sauron.fi.intel.com>
	 <502CE840.4060802@panasas.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7pqpxobN4N0X1bCzyMF0"
Cc: Marco Stornelli <marco.stornelli@gmail.com>, bhalevy@tonian.com,
	jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <502CE840.4060802@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-7pqpxobN4N0X1bCzyMF0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 15:32 +0300, Boaz Harrosh wrote:
> On 08/16/2012 03:20 PM, Artem Bityutskiy wrote:
>=20
> > On Thu, 2012-08-16 at 12:00 +0200, Marco Stornelli wrote:
> >> From: Marco Stornelli <marco.stornelli@gmail.com>
> >>
> >> Remove lock and unlock super operation.
> >>
> >> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> >=20
> > Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >=20
>=20
>=20
> Are you sure? It used to be that exofs_sync_fs() could be called
> concurrently.
>=20
> What about two "bash -c sync" calls or a sync and an unmount
> in parallel. anything protecting that?
>=20
> If so then sure, but please let me test first.

Umm, actually we will probably end up writing the same twice without the
lock.=20

--=20
Best Regards,
Artem Bityutskiy

--=-7pqpxobN4N0X1bCzyMF0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLPEzAAoJECmIfjd9wqK0RbAP/RTo+4b5WdFNp7LlbXbhC1iE
fpKaqras3r8JudcpePQ/9nKdWqOx85nu1ZaXjov9uL//hRnJVxJ2h7ghTlaQ9/jc
gaTm+cHqh5HsS6CxfGnnz/LwUN/Kounb/YekxSNogsry1+8GXxYr5wTLPR/7LlVi
8BA9NyWOIzxOqX8S0KeZtZs5ww31bRl8hPTLqiUazGOtDcwMixSm8R7bgHov8guw
enJBxK3ONv+b6BC9id0AA82sxOQNXZuzd/SabiplWsGCVjLtbpeI/V0QbIQMqznU
HfTLP5cXCCD/5nEUYXQ8IbN0niUoOcCA7Gwv2bcbuVlQKjx5JduXM6mSnfkx5xKM
0YiiifU5WweWGtWk7tZUr7qNj8Uo8FqgVndDeZgD5LWZHuRImSi7cFWof4dwv4t1
2WB3fjc2wUOd3ZTbJFeRJGn0zJtkFOW4QeceFCC7wk/QIEFfn9zQs/qD79zdQ1BU
Yxj5KZ2qXNEY5IKO2OLzSQbgssc5zBwTQY/6rT03YGL3AJxEcPrCX3Qezs1twWtd
/L++4WirDw2L8bIkr4FGd7A1kaMWRQGWfvDZWp9UakSy3PDuifSc9XcpjxXlgjCV
xLRrb4UIZYDAhSeq6Qr8chLEIwRBSKiTU8R5UZmIuky8CfsLXtOzap6awwVJ5Ruz
sv8Ls9QhmMVVr7S/GLC9
=xgEu
-----END PGP SIGNATURE-----

--=-7pqpxobN4N0X1bCzyMF0--
