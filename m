From: Bruce Guenter <bruce@untroubled.org>
Subject: ext4 df regression introduced by commit 9d0be50
Date: Mon, 10 May 2010 12:05:31 -0600
Message-ID: <20100510180531.GA13538@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:41283 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756158Ab0EJSMO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 May 2010 14:12:14 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

I think I have found a regression introduced by commit 9d0be50 "ext4:
Calculate metadata requirements more accurately".

I am using ext4 on a NFSv4 server running unpatched kernel 2.6.33.3.
The client is currently running unpatch 2.6.33.3, although I also saw
the problem with the client running 2.6.32.10.

The output from 'df' on the client varies wildly in the presence of
certain writes.  I have not pinned down an exact write pattern that
causes it, but I do have an application that causes it fairly reliably.
When the bug happens, I see swings like this:

Sun May  9 23:04:58 2010 blocks=3D961173888 available=3D28183168
Sun May  9 23:04:59 2010 blocks=3D961173888 available=3D12823424
Sun May  9 23:05:00 2010 blocks=3D961173888 available=3D28183040

(produced by a script that checks statvfs output every second; units are
kB, df output is effectively identical)

There is no possible way this system could write and then erase 15GB of
disk space in a second, as the drive can sustain only about 40MB/sec.
This problem is not present in any of the 2.6.32.* kernels.  I used git
bisect to narrow down the range to between 3e8d95d (good) and 741f21e8
(bad) before I gave up because the kernels would oops before I could
test.  There are 2 ext4 patches in that range, 9d0be50 and ee5f4d9.  The
other patches are S390 and SH arch fixes.

I checked out a copy of 2.6.33.3 and reverted commit 9d0be50.  There was
a small conflict in fs/ext4/inode.c which I hand merged.  The resulting
kernel has not exhibited the problem in an hour of testing, where
previously I could trigger it in a minute or two.

If you need more information, I can gladly provide it.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkvoSusACgkQ6W+y3GmZgOgYFwCfa07RdSKnDXJ4YsjPItZvHTwH
JW4AniyuhKk7IOggRyV2EY4AB7VBf7FE
=bx5K
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
