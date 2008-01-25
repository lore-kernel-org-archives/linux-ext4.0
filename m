From: Zan Lynx <zlynx@acm.org>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Thu, 24 Jan 2008 17:25:42 -0700
Message-ID: <1201220742.7557.10.camel@localhost>
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it>
	 <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it>
	 <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it>
	 <9Orda-3ub-45@gated-at.bofh.it> <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
	 <20080124230809.GA29120@does.not.exist>  <20080124234037.GJ15858@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WUdmbAZBiuRp34QY66ro"
Cc: Adrian Bunk <bunk@kernel.org>, Bodo Eggert <7eggert@gmx.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andreas Dilger <adilger@sun.com>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753338AbYAYAgT@vger.kernel.org>
In-Reply-To: <20080124234037.GJ15858@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-WUdmbAZBiuRp34QY66ro
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-24 at 18:40 -0500, Theodore Tso wrote:
> On Fri, Jan 25, 2008 at 01:08:09AM +0200, Adrian Bunk wrote:
> > In practice, there is a small number of programs that are both the
> > common memory hogs and should be able to reduce their memory consumptio=
n
> > by 10% or 20% without big problems when requested (e.g. Java VMs,
> > Firefox and databases come into my mind).
>=20
> I agree, it's only a few processes where this makes sense.  But for
> those that do, it would be useful if they could register with the
> kernel that would like to know, (just before the system starts
> ejecting cached data, just before swapping, etc.) and at what
> frequency.  And presumably, if the kernel notices that a process is
> responding to such requests with memory actually getting released back
> to the system, that process could get "rewarded" by having the OOM
> killer less likely to target that particular thread.

Have y'all been following the /dev/mem_notify patches?
http://article.gmane.org/gmane.linux.kernel/628653

--=20
Zan Lynx <zlynx@acm.org>

--=-WUdmbAZBiuRp34QY66ro
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHmSyGG8fHaOLTWwgRApaiAJ0bgnU4rjpNsYpx1JtF9NNA2cfNFQCgk9Tc
k4QqM4HKpAqCNcCXkUJi8mg=
=4s28
-----END PGP SIGNATURE-----

--=-WUdmbAZBiuRp34QY66ro--
