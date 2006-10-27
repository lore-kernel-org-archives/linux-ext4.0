From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext3: bogus i_mode errors with 2.6.18.1
Date: Fri, 27 Oct 2006 17:34:14 +0200
Message-ID: <20061027153414.GA6446@skl-net.de>
References: <20061023144556.GY22487@skl-net.de> <20061023164416.GM3509@schatzie.adilger.int> <20061023200242.GA5015@schatzie.adilger.int> <20061024091449.GZ22487@skl-net.de> <20061024202716.GX3509@schatzie.adilger.int> <20061025094418.GA22487@skl-net.de> <20061026093613.GM3509@schatzie.adilger.int> <20061026160241.GB12843@skl-net.de> <20061026180133.GN3509@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:35252 "EHLO m18s25.vlinux.de")
	by vger.kernel.org with ESMTP id S1752318AbWJ0Pew (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Oct 2006 11:34:52 -0400
To: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061026180133.GN3509@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:01, Andreas Dilger wrote:
> On Oct 26, 2006  18:02 +0200, Andre Noll wrote:
> > On 03:36, Andreas Dilger wrote:
> > > The other issue is that you need to potentially set "num" bits in the
> > > bitmap here, if those all overlap metadata.  In fact, it might just
> > > make more sense at this stage to walk all of the bits in the bitmaps,
> > > the inode table and the backup superblock and group descriptor to see
> > > if they need fixing also.
> >=20
> > I tried to implement this, but I could not find out how to check at this
> > point whether a given bit (in the block bitmap, say) needs fixing.
>=20
> Well, since we know at least one bit needs fixing and results in the block
> being written to disk then setting the bits for all of the other metadata
> blocks in this group has no extra IO cost (only a tiny amount of CPU).
> Re-setting the bits if they are already set is not harmful.

I.e, something like

        int i;
        ext3_fsblk_t bit;
        unsigned long gdblocks =3D EXT3_SB(sb)->s_gdb_count;

        for (i =3D 0, bit =3D 1; i < gdblocks; i++, bit++)
                ext3_set_bit(bit, gdp_bh->b_data);

Is that correct?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFFQib2Wto1QDEAkw8RAlR2AJ49PO4A8H+Lusutr5yTsZfzwMhPwACgmrR6
CpmzqKaIWVk7G2KnDMAO5kA=
=Hya/
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
