From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Corrupt ext4 fs after creation
Date: Tue, 14 Mar 2017 14:05:57 -0600
Message-ID: <C9FDA9DA-D1C7-4D3A-9498-EE3B45F39746@dilger.ca>
References: <153de314-38ff-ad68-65d9-a292213b47f6@phytec.de>
 <532e8151-ecc8-6411-9471-b7a74b4e0ab9@phytec.de>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_745C855C-0C27-4247-B05A-3E1A465F4BA3";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Teresa Remmet <t.remmet@phytec.de>
To: Daniel Schultz <d.schultz@phytec.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34960 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdCNUGH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2017 16:06:07 -0400
Received: by mail-io0-f196.google.com with SMTP id f103so1046305ioi.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2017 13:06:06 -0700 (PDT)
In-Reply-To: <532e8151-ecc8-6411-9471-b7a74b4e0ab9@phytec.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_745C855C-0C27-4247-B05A-3E1A465F4BA3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Mar 14, 2017, at 4:34 AM, Daniel Schultz <d.schultz@phytec.de> wrote:
>=20
> Hi,
>=20
> we use the Yocto Project to create custom BSPs for a AM335x SoC. After =
they upgraded the e2fsprogs from 1.42.9 to 1.43 we run into problems =
with our ext4 root file system. During the first boot systemd checks the =
rootfs with fsck.ext4 and needs a restart beacause of an error.

This isn't really an "error"...

> The fs is created with mkfs.ext4 and direct I/O and is available on =
ftp://ftp.phytec.de/pub/Test/phytec-headless-image-phyboard-wega-am335x-2.=
ext4
>=20
> $ du -ks =
/home/schultz/yocto/PD17.1.0/build/tmp/work/phyboard_wega_am335x_2-phytec-=
linux-gnueabi/phytec-headless-image/1.0-r0/rootfs
> 109708
> $ truncate /var/tmp/wic/build/rootfs_root.2.ext4 -s 159674777
> $ mkfs.ext4 -F -i 8192 /var/tmp/wic/build/rootfs_root.2.ext4 -L root =
-d =
/home/schultz/yocto/PD17.1.0/build/tmp/work/phyboard_wega_am335x_2-phytec-=
linux-gnueabi/phytec-headless-image/1.0-r0/rootfs
> mke2fs 1.43 (17-May-2016)
> Discarding device blocks: done
> Creating filesystem with 155932 1k blocks and 19520 inodes
> Filesystem UUID: 6728344f-aa6d-4bbb-a06d-e649e36024d3
> Superblock backups stored on blocks:
> 	8193, 24577, 40961, 57345, 73729
>=20
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (4096 blocks): done
> Copying files into the device: done
> Writing superblocks and filesystem accounting information: done
> $ du -Lbks /var/tmp/wic/build/rootfs_root.2.ext4
> 155933
>=20
>=20
> I figured out that when I run fsck.ext4 it will perform a directory =
optimizing which leads to a non-zero error code of 1 (File system errors =
corrected).

> Also, I figured out that this optimizing only occurres on the first =
boot and not after creating a lot of new files and dirs. After checking =
the fs it contains more blocks than before.
>=20
> root@phyboard-wega-am335x-2:~# fsck.ext4 -V
> e2fsck 1.43 (17-May-2016)
>        Using EXT2FS Library version 1.43, 17-May-2016
> root@phyboard-wega-am335x-2:~# fsck.ext4 =
/dev/disk/by-id/mmc-NCard_0x2519026e-part2
> e2fsck 1.43 (17-May-2016)
> Superblock last write time (Mon Mar 13 10:53:39 2017,
>        now =3D Wed Jan 25 11:07:23 2017) is in the future.

This is the real error - your system clock is at Jan 25, but the =
superblock
was modified yesterday (which is likely correct), so e2fsck thinks the
superblock is wrong.

Fix your clock before running e2fsck, or use the magic setting for =
embedded
systems so that this check is skipped.  I believe something like the =
following
in /etc/e2fsck.conf would fix this (see e2fsck.conf(5) man page):

[options]
     broken_system_clock=3Dtrue

I suspect once this is fixed, e2fsck will not complain about the =
directory
optimization step anymore.

Cheers, Andreas

> Fix<y>? yes
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 3A: Optimizing directories
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
>=20
> root: ***** FILE SYSTEM WAS MODIFIED *****
> root: 5221/19520 files (0.9% non-contiguous), 105503/155932 blocks
> root@phyboard-wega-am335x-2:~# fsck.ext4 =
/dev/disk/by-id/mmc-NCard_0x2519026e-part2
> e2fsck 1.43 (17-May-2016)
> root: clean, 5221/19520 files, 105503/155932 blocks
>=20
>=20
> Can anyone give me more informations about what's wrong with our fs =
and if I can forbid (without problems) the directory optimization?
>=20
> Thanks
>=20
> --
> Mit freundlichen Gr=C3=BC=C3=9Fen,
> With best regards,
>  Daniel Schultz


Cheers, Andreas






--Apple-Mail=_745C855C-0C27-4247-B05A-3E1A465F4BA3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYyE0npIg59Q01vtYRAkq0AKDZhdsaExlbfFZhyQfKGzN9/1x8VgCffb24
b6oQnCY8tHK5hkwvVyYvuQo=
=yfZ0
-----END PGP SIGNATURE-----

--Apple-Mail=_745C855C-0C27-4247-B05A-3E1A465F4BA3--
