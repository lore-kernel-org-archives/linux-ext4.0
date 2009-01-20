From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: ext4 fails on ext2 filesystems
Date: Tue, 20 Jan 2009 14:56:12 +0100
Message-ID: <20090120135612.GB2287@alea.gnuu.de>
References: <20090118013516.GA4876@alea.gnuu.de> <20090119233059.GH3286@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:2084 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304AbZATOTK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jan 2009 09:19:10 -0500
Content-Disposition: inline
In-Reply-To: <20090119233059.GH3286@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Andreas,

Andreas Dilger schrieb am Tue 20. Jan, 07:30 (+0800):
> On Jan 18, 2009  02:35 +0100, J=EF=BF=BDrg Sommer wrote:
> > I've an ext2 filesystem as root filesystem, because it's mounted readon=
ly
> > for the most part. I've built in the support for ext[234] in the kernel.
> > Ext4 takes precedence over ext2 and it mounts the root filesystem:
>=20
> Hmm, probably an unintended consequence of the newly-added patch to
> allow ext4 to mount ext2 filesystems.
>=20
> > But when remounting the filesystem read/write and changing a file, the
> > changes are written to the filesystem, but it's remounted readonly
> > immediatly. I've set the mount option remount-ro.
> >=20
> > [  203.082300] EXT4 FS on hda3, no journal
> > [  205.746713] EXT4-fs error (device hda3): ext4_free_data: circular in=
direct block detected, inode=3D165056, block=3D184476
>=20
> > motherboard	: PowerBook6,3 MacRISC3 Power Macintosh
>=20
> Hmm, looks like it might be a bug in the endian conversion?

Or an unsigned vs. signed char bug? Can I somehow help you hunting the
bug? How can I mount my rootfs with ext4 on 2.6.28. Maybe this bug isn't
in this version.

Bye, J=C3=B6rg.
--=20
$ cat /dev/random
#!/usr/bin/perl -WT
print "hello world\n";

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl11/wACgkQwe0mZwH1VIC7AQCfRRnTRg+QE8DF06vQDq8sE/E7
XdgAn0KUe/4lro0affzI5PtyJDx0/eHw
=GLyQ
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
