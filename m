From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 02 Jan 2008 13:51:32 -0800
Message-ID: <1199310692.5786.53.camel@dione>
References: <20080102013218.GO27566@does.not.exist>
	 <20080102174157.GD3351@webber.adilger.int>
	 <20080102195146.GB15898@does.not.exist>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XMu64o54CM2SRP122olD"
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757784AbYABVvz@vger.kernel.org>
In-Reply-To: <20080102195146.GB15898@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-XMu64o54CM2SRP122olD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > Isn't CONFIG_EXPERIMENTAL enough?
>=20
> Most people and all distributions use CONFIG_EXPERIMENTAL=3Dy simply=20
> because too many options (including options required for hardware=20
> support) depend on it.

Maybe I'm wrong, but I think most people use the distro-provided
precompiled kernels. This is only a danger to people who insist on
compiling their own kernels but who don't know enough to investigate
things labeled "EXPERIMENTAL" before typing Y.

IMHO, these people are a dying breed since modern distros seem to do a
good job at preventing problems that drive ordinary users to compile
their own kernels in the first place. IMHO, it's reasonable to expect
the small minority of Linux users who want to compile their own kernels
to learn that "EXPERIMENTAL" means something.

Cheers,
Eric


--=-XMu64o54CM2SRP122olD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHfAdke2L37HVup3ARArSqAKDg09++/R8jwUIWZlL7fxBKUnWspwCeLiUY
ht/3UcAfTENpr7My3h+Mmk0=
=Z7oK
-----END PGP SIGNATURE-----

--=-XMu64o54CM2SRP122olD--

