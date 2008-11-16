From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: Re: ext4 unlink performance
Date: Sat, 15 Nov 2008 21:38:16 -0600
Message-ID: <20081116033816.GA11135@untroubled.org>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu> <20081115204423.GA4671@untroubled.org> <20081116005610.GI22948@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:35917 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751635AbYKPDiT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Nov 2008 22:38:19 -0500
Content-Disposition: inline
In-Reply-To: <20081116005610.GI22948@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 15, 2008 at 07:56:10PM -0500, Theodore Tso wrote:
>   Bruce, how much memory did you have in your
> system?  Do you have a large amount of memory, say 6-8 gigs, by any
> chance?

The test system has 1.5GB RAM.

> One thing is clear --- we need to rethink our block and inode
> allocation algorithms in light of delayed allocation.  Maybe XFS has
> some tricks up its sleeve that we can learn from?

Just so I am clear as well, I fully realize this is quite an artifical
benchmark.  I asked about it because of how large the regression is.  I
deal with many systems that typically have to handle creating and
unlinking large numbers of small files (mail servers).  They all are
running ext3 now, but I am considering switching them to ext4 once
2.6.28 is out.  As such my big concern is that this regression will
cause performance problems for them.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJH5Wo6W+y3GmZgOgRApo2AKChQhfQNzHKhNjN4An12CdgwQTvgQCfak61
0VgUrWY9kpG3FPOAZ4xzBmI=
=02IK
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
