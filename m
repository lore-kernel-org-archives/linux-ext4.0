From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Mon, 24 Jul 2017 21:15:48 +0200
Message-ID: <20170724191548.GA32425@amd>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Cc: linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>, tytso@mit.edu,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-07-24 21:08:16, Reindl Harald wrote:
>=20
>=20
> Am 24.07.2017 um 20:57 schrieb Pavel Machek:
> >Would it be feasible to run bcache (write-through) with existing ext4
> >filesystem?
> >
> >I have 400GB of data I'd rather not move, and SSD I could use for
> >caching. Ok, SSD is connecte over USB2, but I guess it is still way
> >faster then seeking harddrive on random access
>=20
> i doubt that seriously - USB2 has a terrible latency

Well.. if that's too slow, I can get SSD M.2; plus bcache docs says
that combination works.

And... if you ever tried to do git diff while git checkout is running
on spinning rust... spinning rust has awful parameters when idle, and
it only gets worse when loaded :-(.
								=09
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll2R2QACgkQMOfwapXb+vL9PwCfRMP3k/4KHRZEMQVHNHM0BIjB
DFIAmwdUjEpgcSn1tAPb61HHBM9IBAuJ
=7786
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
