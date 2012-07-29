From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: resize2fs > 16TB questions
Date: Sun, 29 Jul 2012 09:11:03 -0700
Message-ID: <2AD4EE0D-16C3-4D01-9A34-544E5D5FE8ED@whamcloud.com>
References: <2019C80F-7D05-44FD-89AE-829E3A97053A@sportsandbytes.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?utf-8?Q?Arne_H=C3=BCggenberg?= <hueggenberg@sportsandbytes.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39967 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2G2QLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2012 12:11:25 -0400
Received: by obbuo13 with SMTP id uo13so7575823obb.19
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jul 2012 09:11:24 -0700 (PDT)
In-Reply-To: <2019C80F-7D05-44FD-89AE-829E3A97053A@sportsandbytes.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-29, at 8:24, Arne H=C3=BCggenberg <hueggenberg@sportsandbyte=
s.de> wrote:
>=20
> im trying to resize a ext4 fs to > 16TB.

Unfortunately, this is not possible today without advance planning.  Th=
ere are some structures on disk (group descriptors) that need to be lar=
ger for 64-bit filesystems. It is possible to format a 32-bit filesyste=
m with larger group descriptors using the "-O 64bit" option, but this d=
oesn't happen by default today.=20

Possibly we should start using the 64-byte group descriptors by default=
 for filesystems over, say, 4 TB, so they can be resized beyond 16 TB.

It might also be possible to modify resize2fs to change the group descr=
iptor size, but that isn't possible today.=20

> Having had a look at the e2fsprogs 1.42.x release notes i thought tha=
t, with the online resize ioctl having been merged in Kernel 3.3, this =
should be possible.
>=20
> But so far i have had no success achieving this:
>=20
> ~ # uname -a
> Linux 3.3.8-gentoo #1 SMP Fri Jul 27 16:13:25 CEST 2012 x86_64 Intel(=
R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Linux
>=20
> ~ # tune2fs -l /dev/vg0/lvol1
> tune2fs 1.42.4 (12-June-2012)
> Filesystem volume name:   <none>
> Last mounted on:          /home/filestore_extern_1
> Filesystem UUID:          8fba4f1b-5311-4c9b-b8bf-def4957dc1bd
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index=
 filetype needs_recovery extent 64bit flex_bg sparse_super large_file h=
uge_file uninit_bg dir_nlink extra_isize

Was the filesystem formatted with the 64bit option, or was this enabled=
 after formatting time?  This puts my earlier comment in doubt.=20

> Filesystem flags:         signed_directory_hash=20
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              521011200
> Block count:              4168089600
> Reserved block count:     191127425
> Free blocks:              2195165566
> Free inodes:              520937830
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      60
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         4096
> Inode blocks per group:   256
> RAID stride:              16
> RAID stripe width:        160
> Flex block group size:    16
> Filesystem created:       Fri Jul 27 17:16:24 2012
> Last mount time:          Sun Jul 29 15:22:23 2012
> Last write time:          Sun Jul 29 15:22:23 2012
> Mount count:              6
> Maximum mount count:      -1
> Last checked:             Fri Jul 27 17:16:24 2012
> Check interval:           0 (<none>)
> Lifetime writes:          7485 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:              256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      ef2ec72a-750b-4822-bd8d-9117faadeaee
> Journal backup:           inode blocks

Unfortunately, the group descriptor size is not printed. =20

> ~ # vgdisplay
>  --- Volume group ---
>  VG Name               vg0
>  System ID            =20
>  Format                lvm2
>  Metadata Areas        2
>  Metadata Sequence No  4
>  VG Access             read/write
>  VG Status             resizable
>  MAX LV                0
>  Cur LV                1
>  Open LV               1
>  Max PV                0
>  Cur PV                2
>  Act PV                2
>  VG Size               18.18 TiB
>  PE Size               4.00 MiB
>  Total PE              4766718
>  Alloc PE / Size       4766718 / 18.18 TiB
>  Free  PE / Size       0 / 0  =20
>  VG UUID               q6p5LG-pi1P-pAcI-fSsv-vFI7-6sAA-eabaBH
>=20
> ~ # lvdisplay
>  --- Logical volume ---
>  LV Name                /dev/vg0/lvol1
>  VG Name                vg0
>  LV UUID                7OF1do-HqZD-FGSN-chJF-rPYC-x1Ty-vGCZlc
>  LV Write Access        read/write
>  LV Status              available
>  # open                 1
>  LV Size                18.18 TiB
>  Current LE             4766718
>  Segments               2
>  Allocation             inherit
>  Read ahead sectors     auto
>  - currently set to     256
>  Block device           254:1
>=20
> ~ # resize2fs /dev/vg0/lvol1
> resize2fs 1.42.4 (12-June-2012)
> resize2fs: New size too large to be expressed in 32 bits

This may just be a hard-coded check built into resize2fs, but may be ov=
er-zealous of the filesystem was formatted with -O 64bit.=20

> Any advice on how to proceed would be welcome.
>=20
> Regards,
> Arne
>=20
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
