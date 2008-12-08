From: Andre Noll <maan@systemlinux.org>
Subject: Re: Problems with checking corrupted large ext3 file system
Date: Mon, 8 Dec 2008 14:09:42 +0100
Message-ID: <20081208130942.GX17966@skl-net.de>
References: <20081203101100.GO17966@skl-net.de> <20081204000936.GE3186@webber.adilger.int> <20081204163759.GR17966@skl-net.de> <20081204195138.GA1323@mit.edu> <20081205192359.GV17966@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="McQJJYUzjTUqtsGv"
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:37131 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYLHNZb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Dec 2008 08:25:31 -0500
Content-Disposition: inline
In-Reply-To: <20081205192359.GV17966@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--McQJJYUzjTUqtsGv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:23, Andre Noll wrote:

> After 5 hours, it printed the "Restarting e2fsck from the
> beginning..." message just like the unpatched version. It's now at 45%
> in the second run with no further messages so far. In particular, there
> are no more "clone multiply-claimed blocks" messages.  I'm leaving
> for the weekend now, but I'll send another mail on Monday.

The fsck completed successfully and I've mounted the file system
again. The users are currently investigating the situation, which will
take a while. Until now one user reported that approximately half of
his files are corrupted. Guess I will have to restore from tapes :-(.

Anyway, many thanks to Andreas and Ted.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--McQJJYUzjTUqtsGv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJPRyWWto1QDEAkw8RAmdbAKCjc3sll8Xi/zI2TvLGlGfOszm2TQCfUwOu
5oRoipGRJN2LQmcgy/pq65M=
=neRq
-----END PGP SIGNATURE-----

--McQJJYUzjTUqtsGv--
