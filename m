From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Filesystem writes on RAID5 too slow
Date: Tue, 19 Nov 2013 00:41:40 +0600
Message-ID: <20131119004140.3fea96df@natsu>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x4nyDRcD=BOV5KkYrQUcxCe"; protocol="application/pgp-signature"
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
	"Kernel.org-Linux-XFS" <linux-xfs@vger.kernel.org>,
	"Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>
To: Martin Boutin <martboutin@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Sig_/x4nyDRcD=BOV5KkYrQUcxCe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Nov 2013 11:02:15 -0500
Martin Boutin <martboutin@gmail.com> wrote:

> I have the md0 raid device formatted as ext3 with a 4k block size, and
> stride and stripes correctly chosen to match the raid chunk size, that
> is, stride=3D128,stripe-width=3D256.

What is your stripe cache size?
http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-tr=
ansfer/

> The command line for measuring filesystem read and write speeds was:
>=20
> $ dd if=3D/tmp/diskmnt/filerd.zero of=3D/dev/null bs=3D1M count=3D1000 if=
lag=3Ddirect
> $ dd if=3D/dev/zero of=3D/tmp/diskmnt/filewr.zero bs=3D1M count=3D1000 of=
lag=3Ddirect

Try testing with "fdatasync" instead of "direct" here.

--=20
With respect,
Roman

--Sig_/x4nyDRcD=BOV5KkYrQUcxCe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKKX2QACgkQTLKSvz+PZwh1mwCgjuGOIMIxOqMQRP79r1fKVx+f
1f0AnR9v0sYECiXgCFZoXoUzhVdBmPwO
=kJZ2
-----END PGP SIGNATURE-----

--Sig_/x4nyDRcD=BOV5KkYrQUcxCe--
