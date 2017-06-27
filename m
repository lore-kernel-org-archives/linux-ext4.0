From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Tue, 27 Jun 2017 23:58:04 +0200
Message-ID: <20170627215804.GD5250@amd>
References: <20170622232307.48392-1-khazhy@google.com>
 <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
 <20170623122603.jmvyw4oqkojcapv3@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RhUH2Ysw6aD5utA4"
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        Khazhismel Kumykov <khazhy@google.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57950 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbdF0V6H (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 17:58:07 -0400
Content-Disposition: inline
In-Reply-To: <20170623122603.jmvyw4oqkojcapv3@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--RhUH2Ysw6aD5utA4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > >> Previously, a read error would be ignored and we would eventually re=
turn
> > >> NULL from ext4_find_entry, which signals "no such file or directory"=
=2E We
> > >> should be returning EIO.
> > >>=20
> > >> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> > >=20
> > > Thanks, applied.
> >=20
> > I don't necessarily agree that this is an improvement.=20
> >=20
> > If the requested entry is not in the bad block, this will return an
> > error even if the file name could be found in another block. It
> > would be better to save the error until the end and only return -EIO
> > if the entry cannot be found.
>=20
> The problem is that if we continue, successive reads may all take
> seconds or minutes to fail, thus tieing up the process for a long
> time.  If this process happens to be, say, the node's Kubernetes
> management server it can take down the entire node (since if there
=2E..
> By returning EIO right away, we can "fast fail".

Well, OTOH if I have a bad flash, and get EIO trying to read
~/my-disertation-thesis.tex because ~/.emacs could not be read... I'll be
quite unhappy.

Yes, fast fail is nice when you have redundant machines, but can be a
problem otherwise.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--RhUH2Ysw6aD5utA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllS1OwACgkQMOfwapXb+vKXjQCfT4PW8G6eSy6aiXCikrvayMvq
f20AnjPlBfTOcmJBvwNbvhgjrWl2QTW1
=jujb
-----END PGP SIGNATURE-----

--RhUH2Ysw6aD5utA4--
