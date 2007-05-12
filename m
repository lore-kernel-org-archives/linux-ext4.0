From: Eric <erpo41@gmail.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Sat, 12 May 2007 02:32:44 -0700
Message-ID: <1178962364.20145.99.camel@eric-laptop>
References: <20070512020248.GQ6375@schatzie.adilger.int>
	 <1178957506.20145.41.camel@eric-laptop>  <46457BD5.8040301@clusterfs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WyhFmmwKYfVv9hGLlexV"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:2339 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbXELJcw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 May 2007 05:32:52 -0400
Received: by py-out-1112.google.com with SMTP id a29so1036637pyi
        for <linux-ext4@vger.kernel.org>; Sat, 12 May 2007 02:32:52 -0700 (PDT)
In-Reply-To: <46457BD5.8040301@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-WyhFmmwKYfVv9hGLlexV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-05-12 at 12:33 +0400, Alex Tomas wrote:
> > In the unlikely event that the RAID stride were to change, I think the
> > autodetect-each-time method would be superior to the store-in-superbloc=
k
> > method.
>=20
> true, but in some cases (hardware raid, SAN, etc) there is no easy way
> to learn that other than asking user.

That hadn't occurred to me. Perhaps the filesystem driver or mkfs could
probe for the stride in those cases? If the code asks for, say, 10MiB of
data from the block device and it gets back sectors that are spaced
128KiB apart before it gets the rest of the data, it can make an
intelligent guess about the stride.

I wonder what penalties would come from a bad guess due to a cache in
between the block device driver and the disk platters, or other load on
a SAN...


Eric


--=-WyhFmmwKYfVv9hGLlexV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGRYm8e2L37HVup3ARAhOHAJ93RaaDeeQaJJO7znS7rxfu2+3EGgCffG1t
HdMsRwg96vmciBRDabDPeYI=
=OLnc
-----END PGP SIGNATURE-----

--=-WyhFmmwKYfVv9hGLlexV--
