From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Subject: ext4 volume > 16TB possible?
Date: Mon, 7 Apr 2008 11:02:37 -1000
Message-ID: <20080407210237.GO23213@ifa.hawaii.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MSd2ShuMixI0uVaZ"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:33137 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYDGVlG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 17:41:06 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--MSd2ShuMixI0uVaZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

Is there as of yet a means of creating a large ext4 filesystem?  mke2fs
as of 1.40.8 is still limited to creating ext3 filesystems at 16TB.

--
ipp022 misc # parted /dev/sda print
Model: Areca ARC-1280-VOL#00 (scsi)
Disk /dev/sda: 22.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      17.4kB  100MB   100MB   ext3                   =20
 2      100MB   32.9GB  32.8GB  linux-swap             =20
 3      32.9GB  65.6GB  32.8GB  ext3                   =20
 4      65.6GB  22.0TB  21.9TB                         =20

ipp022 misc # ./mke2fs -F -j -J size=3D400 -O
dir_index,filetype,resize_inode,sparse_super -i32768 -m1 -L ipp022.0 /dev/s=
da4
mke2fs 1.40.8 (13-Mar-2008)
mke2fs: File too large while trying to determine filesystem size
--

Cheers,

-J

--

--MSd2ShuMixI0uVaZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH+ovtWa2BU+b7tU0RAlU1AJ4pG9+qom43Xz3WliGI5Q92RmBRHACfayrr
pD+eccTBIxtRrvtCe2nVSuo=
=2Rkb
-----END PGP SIGNATURE-----

--MSd2ShuMixI0uVaZ--
