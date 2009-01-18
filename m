From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: ext4 fails on ext2 filesystems
Date: Sun, 18 Jan 2009 02:35:16 +0100
Message-ID: <20090118013516.GA4876@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:4676 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZARCJR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 21:09:17 -0500
Received: from ibook.localnet ([192.168.0.5] helo=alea.gnuu.de)
	by alea.gnuu.de with esmtp (Exim 4.69)
	(envelope-from <joerg@alea.gnuu.de>)
	id 1LOMZJ-0001BF-22
	for linux-ext4@vger.kernel.org; Sun, 18 Jan 2009 02:35:17 +0100
Received: from joerg by alea.gnuu.de with local (Exim 4.69)
	(envelope-from <joerg@alea.gnuu.de>)
	id 1LOMZI-0001HG-GQ
	for linux-ext4@vger.kernel.org; Sun, 18 Jan 2009 02:35:16 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've an ext2 filesystem as root filesystem, because it's mounted readonly
for the most part. I've built in the support for ext[234] in the kernel.
Ext4 takes precedence over ext2 and it mounts the root filesystem:

[    6.184751] EXT4-fs: delayed allocation enabled
[    6.191487] EXT4-fs: mballoc enabled
[    6.197710] EXT4-fs: mounted filesystem hda3 without journal
[    6.203948] VFS: Mounted root (ext4 filesystem) readonly on device 3:3.

% mount | grep root
rootfs on / type rootfs (rw)
/dev/root on / type ext4 (ro,noatime,errors=3Dremount-ro,barrier=3D1,data=
=3Dwriteback)

But when remounting the filesystem read/write and changing a file, the
changes are written to the filesystem, but it's remounted readonly
immediatly. I've set the mount option remount-ro.

[  203.082300] EXT4 FS on hda3, no journal
[  205.746713] EXT4-fs error (device hda3): ext4_free_data: circular indire=
ct block detected, inode=3D165056, block=3D184476

% cat /proc/cpuinfo
processor	: 0
cpu		: 7455, altivec supported
clock		: 606.000000MHz
revision	: 3.3 (pvr 8001 0303)
bogomips	: 36.73
timebase	: 18432000
platform	: PowerMac
model		: PowerBook6,3
machine		: PowerBook6,3
motherboard	: PowerBook6,3 MacRISC3 Power Macintosh
detected as	: 287 (iBook G4)
pmac flags	: 0000001b
L2 cache	: 256K unified
pmac-generation	: NewWorld
Memory		: 640 MB

% uname -a
Linux ibook 2.6.29-rc2 #1 Sat Jan 17 18:04:20 CET 2009 ppc GNU/Linux

% tune2fs -l /dev/root
tune2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   Linux Root
Last mounted on:          <not available>
Filesystem UUID:          2a16f78b-dde3-4224-bb23-6303c0d69c92
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      ext_attr resize_inode dir_index filetype sparse_s=
uper large_file
Filesystem flags:         unsigned_directory_hash=20
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              327680
Block count:              1310520
Reserved block count:     65526
Free blocks:              294862
Free inodes:              152729
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      319
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Filesystem created:       Tue Aug 12 19:22:53 2008
Last mount time:          Sun Jan 18 01:59:11 2009
Last write time:          Sun Jan 18 01:59:27 2009
Mount count:              2
Maximum mount count:      32
Last checked:             Sat Jan 17 19:33:26 2009
Check interval:           15552000 (6 months)
Next check after:         Thu Jul 16 20:33:26 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Default directory hash:   tea
Directory Hash Seed:      ba7cdd48-9bce-4d4c-afdc-cff8b4008f11

Bye, J=C3=B6rg.
--=20
Objektivit=C3=A4t ist die Wahnvorstellung, Beobachtungen k=C3=B6nnten ohne
Beobachter gemacht werden =E2=80=93 Heinz v. Foerster

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklyh1QACgkQwe0mZwH1VID+RwCguqrkg3kFFF4ETkzdYYEUvvrL
Q6UAn1yTGaTJinRMt9hMIqVAyC6OUTP1
=ficY
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
