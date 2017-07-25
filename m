From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 22:55:27 +0200
Message-ID: <20170725205526.GA31280@amd>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
 <20170725134604.GA26445@amd>
 <20170725180225.2k3o6xtdnhygrhia@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
To: Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170725180225.2k3o6xtdnhygrhia@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-07-25 14:02:25, Theodore Ts'o wrote:
> On Tue, Jul 25, 2017 at 03:46:04PM +0200, Pavel Machek wrote:
> >=20
> > Is there some field in ext2 superblock that changes every time
> > filesystem is changed? Is mtime changed by fsck/badblocks/...?
>=20
> No, there isn't.  If we were writing the superblock every time the
> file system is changed it would be ***extremely*** flash unfriendly.
> It would also be a scalability bottleneck, it would cause us to pay an
> extra HDD seek, etc.  So it's a really bad Bad BAD idea, and so we
> don't do it.

Ok, I did not mean "every time" when I said "every time". That would
be too heavy.

I mean... is there something changed by the regular mount (like mtime)
plus by operations like fsck and badblocks?

In particular, does fsck change mtime when it writes to the
filesystem?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll3sD4ACgkQMOfwapXb+vKXDgCfQFpuErVEMAjgavomMw/yJjIc
bNAAnRsdkB1MyQq7JpggFTauTT9DqBi6
=m8za
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
