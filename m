From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: Bug#389772: e2fsprogs: e2fsck produces broken htree on ppc
Date: Sun, 1 Oct 2006 01:57:17 +0200
Message-ID: <20060930235717.GA3403@alea.gnuu.de>
References: <20060927122251.GA732@alea.gnuu.de> <20060929010857.GC11055@thunk.org> <20060929171547.GO22010@schatzie.adilger.int> <20060929211556.GA11017@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Cc: Andreas Dilger <adilger@clusterfs.com>, 389772@bugs.debian.org,
	paulus@au.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([84.16.234.68]:14049 "EHLO uucp.gnuu.de")
	by vger.kernel.org with ESMTP id S1751260AbWJAJML (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Oct 2006 05:12:11 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20060929211556.GA11017@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Theodore,

Theodore Tso schrieb am Fri 29. Sep, 17:15 (-0400):
> If the filesystem is empty (or at least no no hashtree directories),
> then when the kernel creates new directories and expands to the point
> where they become indexed, they will be indexed with the PPC variant
> of the hash algorithm.  This will be self consistent, and everything
> will work fine --- until the filesystem gets corrupted to the point
> where e2fsprogs needs to rebuild one or more hashed directories.  At
> that point the directories will be rebuilt using the same conventions
> used by all other conventions, but the directories will no longer be
> useful on the PPC kernel.
>=20
> Joerg, can you confirm this?

Yes.

> On a PPC machine, can you create a smallish ext3 filesystem (say, 4-8
> megabytes), create a directory with enough files in it that it becomes
> indexed (verify using lsattr), and show that it works just fine on a
> PPC.  Now take that image, and transfer it to an x86 machine;

I don't have a x86 machine.

> you should find that the kernel can't look up any of the directories on
> the x86 machine.  If you then run e2fsck -fD on that filesystem
> (running the e2fsck on either x86 or PPC; it shouldn't make a
> difference), then the resulting filesystem should work just fine on the
> x86, and fail on the PPC.

I put two files at http://www.minet.uni-jena.de/~joergs/ img-broken and
img-working. In the last image, img-working, I can access all files,
especially "test/broken f=FCr=DF". The first image, img-broken, is the
image after running e2fsck -Df on img-working. So you can test if one
of these images work on x86, especially if the file "test/broken f=FCr=DF"
is accessable.

Bye, J=F6rg.
--=20
Wer A sagt, mu=DF nicht B sagen. Er kann auch erkennen, da=DF A falsch war.
      	    	      	       	       	    	(Erich K=E4stner)

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQEVAwUBRR8EXYZ13Cz2nwVYAQJlLggAtGZOiXZDYJirgI579vZFdfA2Wl/7mxXn
HfWCrrDcYco5ZtlTJIgZ/MbZfWtb3FaUlB4H0AVEK83xX5cr0tDLLQ3sY3I0jSAK
VJQWxJafhvFij2nqgtmr3ZhWv/tP6Ye4Fb1UGg/6apNd0RY9IAAoVdqYEkDSavO1
YI5MNdNOav2XyboAcGCfqL6bMF4yY3A4VvxevbbUdv00yOtGrm8a4hYyZdckn1lN
S9+j0sejYFnSQkuGd7Veb5vN0vVJy988wIuHvUUE4V3E/jCUPJS9njJH5lGq1ePF
4qPTmHUtthZL8dTBw1H29edNjj+bHQy4xCH+5FeTBZWhxo3/DaW9JQ==
=auh3
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
