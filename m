From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: ext4 unlink performance
Date: Thu, 13 Nov 2008 12:57:12 -0600
Message-ID: <20081113185712.GB11204@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:60835 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752625AbYKMTD6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 14:03:58 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

I started running some comparison benchmarks between ext3 and ext4 this
week.  During one torture test, I observed that ext4 unlink speed is
much slower than ext3, and using 256-byte inodes makes it worse.

The torture test consists of unpacking a large tarball consisting of a
about 725,000 small files in random order and then recursively unlinking
the extracted directory.  The majority of the files in the archive are a
single block, about 15% are span multiple blocks.

The results:

ext4 128 extract: 618.991 elapsed 54.903 user 81.789 sys 22.08%
ext4 256 extract: 671.655 elapsed 55.099 user 74.593 sys 19.30%
ext3 128 extract: 950.965 elapsed 55.155 user 77.473 sys 13.94%
ext3 256 extract: 985.687 elapsed 55.591 user 94.698 sys 15.24%

ext4 beats ext3 hands down, with either inode size.  I would think that
the 128 byte inode runs are faster than the 256 byte inode runs simply
because of the number of small files involved.

ext4 128 unlink: 913.934 elapsed 0.296 user 33.550 sys 3.70%
ext4 256 unlink: 1507.696 elapsed 0.324 user 37.602 sys 2.51%
ext3 128 unlink: 171.150 elapsed 0.244 user 23.825 sys 14.06%
ext3 256 unlink: 360.073 elapsed 0.328 user 27.954 sys 7.85%

Ouch.  Why is ext4 so much slower than ext3 here, and why is there such
a huge discrepancy between the different inode sizes?  The filesystems
were created with the stock options except for inode size and ^huge_file
(for historical reasons when I was testing with older kernels).

I tested this with Linus's git sources on x86_64 on IDE.  2.6.28-rc4 and
2.6.27 had similar performance.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJHHiI6W+y3GmZgOgRAr75AJ0dfIplh2ohpk0H3bc32tRnbEeaQACfY3tM
xgxYf5e/NebdjMNFwn+1pyc=
=3CRl
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
