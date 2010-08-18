From: Andre Noll <maan@systemlinux.org>
Subject: Memory allocation failed, e2fsck: aborted
Date: Wed, 18 Aug 2010 16:04:22 +0200
Message-ID: <20100818140422.GL27457@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TdMwOTenGjBWB1uY"
Cc: Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:46682 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab0HROEa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Aug 2010 10:04:30 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--TdMwOTenGjBWB1uY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I'm having trouble with checking a corrupt ext3 file system resulting
=66rom a 3-disk failure on a 12 disk software raid6 array. The disk
failure was due to an issue with the (3ware) controller and 11 disks
appear to be fine. However, I had to --assemble --force the array
because two of the 11 disks were not up to date after the crash.

e2fsck from today's git master branch aborts after a while with

	./e2fsck -f -y -C 0 /dev/euclidean/snap_abt1_kristall_RockMakerStorage
	e2fsck 1.41.12 (17-May-2010)
	Backing up journal inode block information.

	Pass 1: Checking inodes, blocks, and sizes
	Error storing inode count information (inode=3D245859898, count=3D2): Memo=
ry allocation failed
	e2fsck: aborted

This is an old 32 bit system with only 1G of ram and a 2.6.24 distro
kernel. I added _lots_ of swap but this did not help.

Any hints on how to proceed?

Since the file system is corrupt anyway, it is maybe easiest
to delete inode 245859898 with debugfs, but maybe there is
a better option. Moreover, since this might be some kind of
e2fsck-trusts-corrupt-data issue, you might be interested in looking
at this.

Further info: The ext3 file system lives on a lv within a vg whose
single pv is the 12 disk raid6 array. The file system stores hard
link based backups, so it contains _lots_ of hard links.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--TdMwOTenGjBWB1uY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMa+hmWto1QDEAkw8RApbXAJ4nQ1ng1BhU+Rbr0TnSWy14DXvGtACeNE3/
+NYmnDzAW3rLtCEF8uKAwP8=
=RGkn
-----END PGP SIGNATURE-----

--TdMwOTenGjBWB1uY--
