From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 13:12:10 +0200
Message-ID: <20170725111210.GA5667@amd>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
 <20170725064304.GA11723@amd>
 <20170725103248.GA12869@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Cc: Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@ucw.cz>
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170725103248.GA12869@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-07-25 12:32:48, Vojtech Pavlik wrote:
> On Tue, Jul 25, 2017 at 08:43:04AM +0200, Pavel Machek wrote:
> > On Tue 2017-07-25 00:51:56, Theodore Ts'o wrote:
> > > On Mon, Jul 24, 2017 at 10:04:51PM +0200, Pavel Machek wrote:
> > > > Question for you was... Is the first 1KiB of each ext4 filesystem s=
till
> > > > free and "reserved for a bootloader"?
> > >=20
> > > Yes.
> >=20
> > Thanks.
> >=20
> > > > If I needed more for bcache superblock (8KiB, IIRC), would that be
> > > > easy to accomplish on existing filesystem?
> > >=20
> > > Huh?  Why would the bcache superblock matter when you're talking about
> > > the ext4 layout?  The bcache superblock will be on the bcache
> > > device/partition, and the ext4 superblock will be on the ext4
> > > device/partition.
> >=20
> > I'd like to enable bcache on already existing ext4 partition. AFAICT
> > normal situation, even on the backing device, is:
> >=20
> > | 8KiB bcache superblock | 1KiB reserved | ext4 superblock | 400GB data=
 |
> >=20
> > Unfortunately, that would mean shifting 400GB data 8KB forward, and
> > compatibility problems. So I'd prefer adding bcache superblock into
> > the reserved space, so I can have caching _and_ compatibility with
> > grub2 etc (and avoid 400GB move):
>=20
> The common way to do that is to move the beginning of the partition,
> assuming your ext4 lives in a partition.

Well... if I move the partition, grub2 (etc) will be unable to access
data on it. (Plus I do not have free space before some of the
partitions I'd like to be cached).

> I don't see how overlapping the ext4 and the bcache backing device
> starts would give you what you want, because bcache assumes the
> backing device data starts with an offset.

My plan is to make offset 0. AFAICT bcache superblock can be shrunk.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll3J4oACgkQMOfwapXb+vLgZgCgk7aFOyDRJA08ytdAUnaWyAzw
tTYAn3i+H9peK6L+VVHoO7JoI0ygLbX8
=pKso
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
