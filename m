From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Wed, 26 Jul 2017 22:01:28 +0200
Message-ID: <20170726200128.GB26445@amd>
References: <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
 <20170725064304.GA11723@amd>
 <20170725103248.GA12869@suse.com>
 <20170725111210.GA5667@amd>
 <alpine.LRH.2.11.1707251810091.9683@mail.ewheeler.net>
 <20170725220221.GA32240@amd>
 <alpine.LRH.2.11.1707261728460.9683@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Cc: Vojtech Pavlik <vojtech@ucw.cz>, Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1707261728460.9683@mail.ewheeler.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > > Unfortunately, that would mean shifting 400GB data 8KB forward,=
 and
> > > > > > compatibility problems. So I'd prefer adding bcache superblock =
into
> > > > > > the reserved space, so I can have caching _and_ compatibility w=
ith
> > > > > > grub2 etc (and avoid 400GB move):
> > > > >=20
> > > > > The common way to do that is to move the beginning of the partiti=
on,
> > > > > assuming your ext4 lives in a partition.
> > > >=20
> > > > Well... if I move the partition, grub2 (etc) will be unable to acce=
ss
> > > > data on it. (Plus I do not have free space before some of the
> > > > partitions I'd like to be cached).
> > >=20
> > > Why not use dm-linear and prepend space for the bcache superblock?  I=
f=20
> > > this is your boot device, then you would need to write a custom=20
> > > initrd hook too.
> >=20
> > Thanks for a pointer. That would actually work, but I'd have to be
> > very, very careful using it...
> >=20
> > ...because if I, or systemd or some kind of automounter sees the
> > underlying device (sda4) and writes to it (it is valid ext4 after
> > all), I'll have inconsistent base device and cache ... and that will
> > be asking for major problems (even in writethrough mode).
>=20
> Sigh.  Gone are the days when distributions would only mount filesystems=
=20
> if you ask them to. =20
>=20
> If this is a desktop, then I'm not sure what to suggest.  But for

This is a desktop.

> with no GUI, turn off the grub2 osprober (GRUB_DISABLE_OS_PROBER=3D"true"=
 in=20
> /etc/sysconfig/grub).  If this was LVM, then I would suggest also setting=
=20
> global_filter in lvm.conf.  If you find other places that need poked to=
=20
> prevent automounting then please let me know!
>=20
> As for ext4 feature bits, can they be arbitrarily named? (I think they ar=
e=20
> bits, so maybe not).  Maybe propose a patch to ext4 to provide a

Hmm. I guess I could just set "read-only compatible" bit "this device
has a cache"... but last time I checked, ext3 still replayed log
during read-only mount...
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll49RgACgkQMOfwapXb+vLQhACgjaZfHPlSYwonv0xAmxC4sz9c
1lMAnRfZvA13ZUBLCD5HB8lJhFgMe+oH
=2ipz
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
