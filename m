From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Tue, 05 May 2009 12:30:40 +0100
Message-ID: <1241523040.5593.23.camel@quest>
References: <20090224084434.GF6020@nb.net.home>
	 <20090324121147.GA22386@zelda.netsplit.com>
	 <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest>
	 <20090422133304.GP15541@mit.edu> <1240407745.2902.3.camel@wing-commander>
	 <20090422134945.GQ15541@mit.edu> <1241025728.16780.21.camel@quest>
	 <20090429205458.GA24749@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sscmmyCaXufmK7UT3B3X"
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:60836 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZEELaD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2009 07:30:03 -0400
In-Reply-To: <20090429205458.GA24749@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-sscmmyCaXufmK7UT3B3X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-29 at 16:54 -0400, Theodore Tso wrote:

> Scott, thanks for submitting these patches.   Two quick comments:
>=20
> 1) It's greatly preferred if you submit each patch as separate e-mail
> messages, with the one-line summary as the subject (as you might find
> in a git submission or as described in sections 5.4 and 5.5 in the file
> Documentation/development-process/5.Posting in the Linux kernel sources).
> The reason for this is that the patchs will then be tracked in patchwork:
>=20
>     http://patchwork.ozlabs.org/project/linux-ext4/list/
>=20
> and if it's accurately reflected there, it's much less likely that I
> won't accidentally forget to act on your patches, especially when I
> get busy/overloaded.  The best thing to do is to use "git
> format-patch" (which you apparenlty did to generate the patch), and
> then use "git send-email" to send out the patches.
>=20
At this point, consider these patches "for your review" ;)  If you're
happy with them, I'll submit them to the mailing list properly.

> 2) While lsb_release is mandatory on Ubuntu systems (there is a
> dependency from ubuntu-minimal), it is not guaranteed to exist on
> Debian systems.
>=20
That's why I have "|| Debian" in there.

This is the same rule we use in util-linux on Debian/Ubuntu.

> So how I already test for Ubuntu in the rules file is
> via this construct:
>=20
> 	if test -f /etc/lsb-release && \
> 		grep -q DISTRIB_ID=3DUbuntu /etc/lsb-release; then \
> 	$(INSTALL) -p -m 0644 e2fsck/e2fsck.conf.ubuntu \
>        		${debdir}/e2fsprogs/etc/e2fsck.conf; \
> 	fi
>=20
It's not guaranteed that /etc/lsb-release says DISTRIB_ID=3DUbuntu - if we
ever simply changed the defaults in lsb_release, then this would fail -
no?

> Hmm, one of these days I should probably check and see if Ubuntu
> finally fixed the installer and init scripts breakage which forced me
> to set a special e2fsck.conf file just for Ubuntu.  (See git commit
> 60702c26 in the e2fsprogs repository for more details.)
>=20
We spent a very long time on this - in Jaunty this should be
rock-solidly correct <g>

> 3) In the "nice to have" category, it would be nice if whether or not
> blkid is built is controled via DEB_BUILD_OPTIONS flag instead of a
> free-standard environment variable, but I won't insist on that.
>=20
Good idea.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-sscmmyCaXufmK7UT3B3X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoAI2AACgkQSnQiFMl4yK56+ACfT32r2RpDrSFwhyY/+2Pj4dRR
EvkAoKyKSE1/UlZ9OlIhWSgK5pcYwNz8
=ZVHm
-----END PGP SIGNATURE-----

--=-sscmmyCaXufmK7UT3B3X--

