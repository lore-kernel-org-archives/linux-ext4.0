From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Wed, 1 Aug 2012 15:42:32 +1000
Message-ID: <20120801054231.GD6467@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120627112117.GA15231@thor.bakeyournoodle.com>
 <20120627125443.GA32356@thunk.org>
 <20120628024356.GB17989@thor.bakeyournoodle.com>
 <20120730214531.GE10343@thunk.org>
 <20120731052150.GB14970@thor.bakeyournoodle.com>
 <20120731195726.GD32228@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:37542 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab2HAFmi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2012 01:42:38 -0400
Content-Disposition: inline
In-Reply-To: <20120731195726.GD32228@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 03:57:26PM -0400, Theodore Ts'o wrote:

> Unfortunately, all of these changes put together were significant
> enough that I didn't feel comfortable putting them in the 1.42.x
> maintenance branch, especially since Debian is going through its
> freeze process and I'm trying to get 1.42.5 into the release.  So I'm
> being a lot more conservative about what sort of changes I'm allowing
> into the maintenance branch at this point.

Okay.
=20
> The 'master' and 'next' branches in git are targetting the 1.43
> release of e2fsprogs.  If you need a tarball, and not just git tree
> reference, I could cut a pre-release snapshot for testing purposes.  I
> was planning on doing that soon for the metadata checksum and/or
> inline data features in any case.

I don't think I specifically need it, but if I see an RC or testing
snapshot I'll certainly use it :)

Again thanks for your help on this.

Yours Tony

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQGMHHAAoJEEsCiJRY75GKG/IP+QFwu4whR5ra/vyO/eLet7vO
5QU9Q3T2vBLBU9qYgRSRC2In/FdoIsqnK6xryAFx6uUEKN1mzSNeEl++hLNdc+Y0
Dgap3wibdaYpw66kBacMaHJiq63T4e0DhELAQyrolhybOoJRf52a2SurLokiyPzJ
5D2zuVuYZPxY+Ckjv4DHrfGvNOR6bliby/6pIgFF8DhSi+7uLJTyg83DdXlBjTrH
9aL1CxD2I6CGU8jGMRiH+ZWRe5MkCspv3CBQLpIOOX0ssi8GH0tRGwYChx2BT6Mj
SJADgxhDHArHkNLK2xCzc71edA/lNZRCGiToOaPLtzrUcIGi0zTjAliJc3UcjOqM
DRhzQCF8puKArkVBpp/vK/Zt6ujfH+vkGjuseuUWD1rU/TeBYBzpPkI4kd6KoHLp
1LAoVkvuvn/147bRlMIRY/UN9CgxXAeFR9PkCWndPX6CJaLSFXhbtbmomWgyO0rK
G2n59DW7QLHmovcmpQl0qqgofa3MTvb0feuXmDW3X0Hxve9H/ETE/+BYJokq8GSb
FYs9xCrdepDKWe012EjYvg2GfqzRd8dVvRXwkr3RgoUkg7ZOIrNB+8ZNMPkgZfAC
bBDnFYS8sJF2qWj23i96CzvTP5BSWHQa1FVsKroc/UJXhcFWzfVvuVwlhUEdfq3h
Ies+WHghJX8n29a/BKSB
=ZcKq
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
