From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] libext2fs: fix return value
Date: Sat, 4 May 2013 20:58:54 -0400
Message-ID: <201305042058.55976.vapier@gentoo.org>
References: <1367643954-31340-1-git-send-email-vapier@gentoo.org> <20130504235503.GC5948@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1399240.qyKxY9hoxX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35401 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab3EEA6v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 20:58:51 -0400
In-Reply-To: <20130504235503.GC5948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1399240.qyKxY9hoxX
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Saturday 04 May 2013 19:55:03 Theodore Ts'o wrote:
> On Sat, May 04, 2013 at 01:05:54AM -0400, Mike Frysinger wrote:
> > The ext2fs_test_block_bitmap_range2 func is not a void, so make sure we
> > return a value.  I picked EINVAL as it looks like what other things in
> > this func use.
> >=20
> > URL: http://bugs.gentoo.org/467986
> > Reported-by: Vicente Olivert Riera <vincent@gentoo.org>
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>=20
> This is already fixed in e2fsprogs's git repository, in commit
> 0d89e5acea9.

ok, the use of "master" and "next" is weird.  i was using the normal "maste=
r"=20
branch which is apparently out of date.
=2Dmike

--nextPart1399240.qyKxY9hoxX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRha7PAAoJEEFjO5/oN/WBbcUQAJcq76/yYEfWWH4kVnLzj//i
+UZdIkOhC7wsEqNWtX166KA4LbFmteSOp04UaGUneuz0ev+it3RbXuMxb5uir5Wm
2zMuR3FjgfrnS67roCHPrsNZkmXLcUi9popOqmS0fTPDYhWuM+TQKg2WKTtOBrGq
nwDzGtSsXkqMDrwsY48xOc/xOwjRTSRtdTXEqT3mig8cZklQNXiLjB4WGfW33iaH
5bHPV6um1zoIN8kDwljGJmT98Ixa8Vi3YjaIU958nRFrY5hsWMkmF4x8uFbB7Dvk
UTTAc2FeaiJbog1DSSO+NrDyn7xusqUeuSd5LRY6upHQKnDRmBBh7fCjg98NfZOn
0SXKmff8+oEMWm/y1z0i5BeidtPNER2Vwe1MEnQnwKPXEjuoVNzxfhWWez9h4QcD
NSffKkl49dCww6Gbml5vTFU1jGbgihOESSNRLrEBLYcbneDJcwAux1XH7u/YmaPW
TPR2mbkk2GWX2HadNSEnOZtPJG8wXtv0heJ0Z7aySKY6i/rAPrTLyi/ANfqISUjK
WcqyOPwsbGebP+0KjkPslpyyqTUKr2Ve9bTgsroXOhvavuujbwp6rAi1exWZ2tPC
//ynkIi3dcEfZYEecokhQr2jCf5kU4S29koPuJ3/KpyNRi82iKtoOoJ+fHNYqrP3
5iati0efgKlEBS4V2OcD
=znq8
-----END PGP SIGNATURE-----

--nextPart1399240.qyKxY9hoxX--
