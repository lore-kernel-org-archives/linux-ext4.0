From: Andre Noll <maan@systemlinux.org>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Fri, 20 Aug 2010 16:36:47 +0200
Message-ID: <20100820143647.GY16603@skl-net.de>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819005404.GO21182@thunk.org> <20100819131017.GV16603@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="35rzUHtxHARXKmYf"
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:59809 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0HTOg7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 10:36:59 -0400
Content-Disposition: inline
In-Reply-To: <20100819131017.GV16603@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--35rzUHtxHARXKmYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 15:10, Andre Noll wrote:
> > Something which *might* help (but will take a long time) is to add to
> > your /etc/e2fsck.conf (if you have one; if not create one wiht these
> > contents):
> >=20
> > [scratch_files]
> >     directory =3D /var/cache/fsck
> >=20
> > (And then make sure /var/cache/fsck exists.)
>=20
> Thanks for the hint. It is running for an hour now and I will report
> back tomorrow. ATM, it's at 1% and the two files in /var/cache/fsck
> are ~50M large.

It got much slower: 4.8% after one day. So I cancelled the fsck and
am copying the raw device to a 64bit machine and run fsck there,
as Andreas suggested.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--35rzUHtxHARXKmYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD4DBQFMbpL/Wto1QDEAkw8RAmsUAJwL3l+wlBNcldanMRgtUb/ddTA53gCYkbR+
Jp9RT4x87Qj1XAOEtRIpXw==
=wxtH
-----END PGP SIGNATURE-----

--35rzUHtxHARXKmYf--
