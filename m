Return-Path: <SRS0=NEJw=PV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37697 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbfAMAUa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2019 19:20:30 -0500
Received: by mail-pl1-f195.google.com with SMTP id b5so8462885plr.4
        for <linux-ext4@vger.kernel.org>; Sat, 12 Jan 2019 16:20:30 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <3A06C183-19FF-48B3-9C49-60353BEC9DB8@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C7598959-E1B6-46CC-9E24-291F313FB146";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Preserving a rev 0.0 ext2 filesystem
Date: Sat, 12 Jan 2019 17:20:24 -0700
In-Reply-To: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
Cc: Theodore Tso <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Jan Kara <jack@suse.com>
References: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C7598959-E1B6-46CC-9E24-291F313FB146
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 12, 2019, at 2:43 AM, Geert Uytterhoeven <geert@linux-m68k.org> =
wrote:
>=20
> Hi Ted,
>=20
> I'm still regularly using a Linux rev 0.0 ext2 filesystem as a  =
ramdisk
> on m68k, containing mid-90's binaries, from right after the =
a.out-to-ELF
> transition, so I notice if someone breaks old syscall support.
>=20
> Recently I wanted to change /dev/console on that ramdisk from a =
symlink
> to chardev 5 0.  Unfortunately I cannot mount it, without it being
> upgraded automatically to a rev 1.0 ext2 filesystem.  Apparently the
> kernel has been doing that upgrade for ages.
>=20
> Do you have a suggestion how to make that change, while preserving the
> ext2 revision?

It looks like there is a "gratuitous" call to ext4_update_dynamic_rev() =
in the
mount path that is left over from when ext3 always set the =
INCOMPAT_RECOVER and
COMPAT_HAS_JOURNAL features on every mount.  With the "nojournal" mount =
option
these are no longer needed.  You could probably just remove this call =
with no ill
effects, or better yet apply the patch that I'll push shortly to this =
effect.
It's been there since the start of git history (2.6.12-rc2) in the ext3 =
code
that was later copied to become ext4, but digging through my email =
archives it
looks like adding the call to "ext3_update_fs_rev()" was actually one of =
my first
patches against the original ext3 code "[Ext2-devel] Re: RECOVER =
INCOMPAT flag",
dated Nov 18, 2000.

The only thing ext4_update_dynamic_rev() does is update s_rev_level, and =
set
s_first_ino and s_inode_size on disk to the values that the kernel =
already
assumes to be true (newer kernels can use different values).  Those =
fields are
also set in memory later during the mount, so the rest of the code =
should work
OK (I haven't tested). This will probably only affect your filesysem =
(everything
else in the last 20 years uses EXT2_DYNAMIC_REV) so it won't be much of =
a change.

The "real" ext2 code looks like it does not call =
ext2_update_dynamic_rev() for
every filesystem during mount, only if you write a file > 2GB in size, =
so it would
also be possible to mount with the ext2.ko driver (if your kernel =
provides it).
There looks like a minor bug in ext2 that it doesn't call =
ext2_update_dynamic_rev()
if an xattr is stored on the filesystem and it sets =
EXT2_FEATURE_COMPAT_EXT_ATTR
in ext2_xattr_update_super_block().  However, nobody noticed in since =
xattrs landed.


In any case, it would be fun to give my patch a try to see if it allows =
your old
filesystem to be mounted and modified with a modern kernel and then =
mounted on
the old kernel again, as a testament to ext2/ext4 feature compatibility.

Cheers, Andreas






--Apple-Mail=_C7598959-E1B6-46CC-9E24-291F313FB146
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlw6hEgACgkQcqXauRfM
H+BuQQ/+J+9refoE5Qxjypw1Yip26O/uy9kKBuWkpl9QBs3FBn2qqxzRwT2rK2Vh
/Rg4ObEJbqv0WzBw1Zo0OLnfTDyorcuIoWj730czhQ0ClGT0ZOSkQEgd1cuTgt2A
pC32MpuXH6favWlfMU7KJRbloEElevtq2isYLOCSr61sSGY9bldY4mKMugED8m2m
OBh50BGOuDLC8XvXFlayVImEGMFobJ/sGyjPWiqxjkSPkEhPPDdhiKvpF3euzbBf
27cW7srA83+qUGOL4oheP4l4Ri65Go1RatHxRURAXOhrri/vrzIlzPFWr1+HnW5x
jAV1llwlqj3G0XaRpmUerzBivJI467SlFGT5IdPxo8LVxWCMBt3LupHrPoh4UBi4
yvMacTGAdyJjRcRyBzcRMrFxdclVbBAm/bO6sNcGT5Xmq61ZL95HFOW7V9Kd/0+i
5EbY7AT1qsn+VbojpfwmvvCdRr24nFWXt0TGYL36PYq2t6q1Ntk74XlwMXj+WYg5
Lp9NE+bm+8Jhedjexw5mb+NsQ62OvGkbZeNWV5JRjxAa33fy7upor83HrfgVOefM
ZHIAqoQ5KNPQsPD9bo4uyPucaLZInCnhvboPF6+AvbujI9F1FzpAoSs/LwgB5km3
6bm8Resy7gSYVirARdSUsHerlTdGmVHLAP0F3CHSXWj3Q2PNR2M=
=IEHr
-----END PGP SIGNATURE-----

--Apple-Mail=_C7598959-E1B6-46CC-9E24-291F313FB146--
