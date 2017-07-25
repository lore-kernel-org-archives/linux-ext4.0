From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Wed, 26 Jul 2017 00:02:22 +0200
Message-ID: <20170725220221.GA32240@amd>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
 <20170725064304.GA11723@amd>
 <20170725103248.GA12869@suse.com>
 <20170725111210.GA5667@amd>
 <alpine.LRH.2.11.1707251810091.9683@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Cc: Vojtech Pavlik <vojtech@ucw.cz>, Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1707251810091.9683@mail.ewheeler.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > Unfortunately, that would mean shifting 400GB data 8KB forward, and
> > > > compatibility problems. So I'd prefer adding bcache superblock into
> > > > the reserved space, so I can have caching _and_ compatibility with
> > > > grub2 etc (and avoid 400GB move):
> > >=20
> > > The common way to do that is to move the beginning of the partition,
> > > assuming your ext4 lives in a partition.
> >=20
> > Well... if I move the partition, grub2 (etc) will be unable to access
> > data on it. (Plus I do not have free space before some of the
> > partitions I'd like to be cached).
>=20
> Why not use dm-linear and prepend space for the bcache superblock?  If=20
> this is your boot device, then you would need to write a custom=20
> initrd hook too.

Thanks for a pointer. That would actually work, but I'd have to be
very, very careful using it...

=2E..because if I, or systemd or some kind of automounter sees the
underlying device (sda4) and writes to it (it is valid ext4 after
all), I'll have inconsistent base device and cache ... and that will
be asking for major problems (even in writethrough mode).

Actually, this already would be usable, if we killed content of cache
device on every mount. Hmmm. I have reasonably long uptimes these days.

If possible, I'd like something more clever: bcache saves mtime of the
ext4 filesystem on shutdown. If the mtime does not match on the next
startup, it means someone fsck-ed the filesystem or mounted it
directly or something, and cache is invalid.

Bonus would be some kind of interlock with "incompatible feature"
bits. If the bcache has dirty data in write-back cache, it would be
nice to have "incompatible feature" bit set, so that tools that don't
have access to the cache refuse to touch it.

Best regards,

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll3v+0ACgkQMOfwapXb+vJPswCgsWqJBHPvQsCQKiDI3IqMtfKk
uegAoL4n9Oc+FcQuv4TlLno7nDPRfZZ3
=XJ6/
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
