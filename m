From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: ext4 fails on ext2 filesystems
Date: Sun, 18 Jan 2009 11:04:59 +0100
Message-ID: <20090118100458.GA22064@alea.gnuu.de>
References: <20090118013516.GA4876@alea.gnuu.de> <20090118023841.GD25943@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:1553 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759410AbZARKKh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 05:10:37 -0500
Content-Disposition: inline
In-Reply-To: <20090118023841.GD25943@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

Theodore Tso schrieb am Sat 17. Jan, 21:38 (-0500):
> On Sun, Jan 18, 2009 at 02:35:16AM +0100, J=C3=B6rg Sommer wrote:
> >=20
> > But when remounting the filesystem read/write and changing a file, the
> > changes are written to the filesystem, but it's remounted readonly
> > immediatly. I've set the mount option remount-ro.
> >=20
> > [  203.082300] EXT4 FS on hda3, no journal
> > [  205.746713] EXT4-fs error (device hda3): ext4_free_data: circular in=
direct block detected, inode=3D165056, block=3D184476
> >=20
>=20
> Can you do me a favor?  Can you run debugfs /dev/hda3, and then run
> the debugfs command: "stat <165056>"? =20

I've reproduced the error, because I've ran a fsck in the meantime:

% dmesg |tail G -F EXT
[24648.457402] EXT4 FS on hda3, no journal
[25253.227881] EXT4-fs error (device hda3): ext4_free_data: circular indire=
ct block detected, inode=3D165056, block=3D184476

# debugfs /dev/hda3 <<<$'stat <165056>\ntestb 184476\nquit'
debugfs 1.41.3 (12-Oct-2008)
debugfs:  stat <165056>
Inode: 165056   Type: regular    Mode:  0644   Flags: 0x0
Generation: 2419652156    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4972fd07:7463285e -- Sun Jan 18 10:57:27 2009
 atime: 0x4972fd06:acc79ebb -- Sun Jan 18 10:57:26 2009
 mtime: 0x4972fd07:7463285e -- Sun Jan 18 10:57:27 2009
crtime: 0x06fd7249:acc79ebb -- Wed Sep 19 08:52:41 1973
dtime: 0x4972fd07 -- Sun Jan 18 10:57:27 2009
Size of extra inode fields: 28
BLOCKS:

debugfs:  testb 184476
Block 184476 not in use
debugfs:  quit

Bye, J=C3=B6rg.
--=20
Treffen sich zwei Funktionen.
Sagt die eine: =E2=80=9EVerschwinde oder ich differenzier' dich!=E2=80=9C
Erwidert die andere: =E2=80=9E=C3=84tsch, ich bin exponentiell!=E2=80=9C

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkly/soACgkQwe0mZwH1VIBGdACgxLFjqUQfkhXwF8saGRgokzoY
EhUAn22l8iVT01zMkjuBuSoro3y2b1b4
=UdGo
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
