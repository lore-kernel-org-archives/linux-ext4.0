From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Fri, 13 Oct 2017 12:40:58 -0600
Message-ID: <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca>
 <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_33804753-F5E1-4444-B802-9A13E9DCAE0D";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:52221 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752853AbdJMSlE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Oct 2017 14:41:04 -0400
Received: by mail-io0-f174.google.com with SMTP id b186so9954792iof.8
        for <linux-ext4@vger.kernel.org>; Fri, 13 Oct 2017 11:41:04 -0700 (PDT)
In-Reply-To: <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_33804753-F5E1-4444-B802-9A13E9DCAE0D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 12, 2017, at 4:02 PM, Kilian Cavalotti =
<kilian.cavalotti.work@gmail.com> wrote:
>=20
> On Wed, Oct 11, 2017 at 7:36 AM, Kilian Cavalotti
> <kilian.cavalotti.work@gmail.com> wrote:
>> On Tue, Oct 10, 2017 at 1:36 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>> If the problem is only one of the partition being misaligned =
compared
>>> to the logical volume, you can run the "findsuper" utility which is
>>> part of e2fsprogs *sources* (it isn't built and packaged by =
default).
>>> It will scan your block device and print out the ext2/3/4 =
superblocks
>>> that it finds, along with the *byte* offset of each one found.  You
>>> can use this to determine where the start of the filesystem should =
be.
>>=20
>> I will give this a try, thanks. Although I don't really had any issue
>> to mount the filesystem r/o, which seems to indicate that there is no
>> misalignment issue, right?
>=20
> So... I tried findsuper, and it started listing things (including, for
> some, non-printable characters in the "label" field, but I guess it's
> just false-positives).

The findsuper comment was potentially misleading, as I was mixing up =
your
problem with one in another thread where the partition table was =
clobbered.

> It's still running right now, but it already listed superblocks which
> are obviously not related to the actual filesystem, but to raw disk
> images (created via dd) that I had on that filesystem. For instance:
>=20
> -- 8< ---------------------------------------------------------
> # /usr/local/sbin/findsuper /dev/mapper/overlay
> starting at 0, with 512 byte increments
> byte_offset  byte_start     byte_end  fs_blocks blksz  grp
> mkfs/mount_time           sb_uuid label
>      1024           0  17983724322816   95590400  4096    0  Thu Nov
> 26 23:22:42 2015 12c2c019 1.42.6-5644

This is likely to be the proper superblock, but it has a bit of a
strange label.  Looks like a really old e2fsprogs build version?

> 2556972232704 2556972231680  2560139979776     773376  4096    0  Tue
> Jan 29 20:40:53 2013 da57c5f6 casper-rw
> 2557257444352 2557123226624  2560290974720     773376  4096    1  Tue
> Jan 29 20:40:53 2013 da57c5f6 casper-rw
> 2557962087424 2557559434240  2560727182336     773376  4096    3  Tue
> Jan 29 20:40:53 2013 da57c5f6 casper-rw
> 2558532512768 2557861424128  2561029172224     773376  4096    5  Tue
> Jan 29 20:40:53 2013 da57c5f6 casper-rw
> 2559086160896 2558146636800  2561314384896     773376  4096    7  Tue
> Jan 29 20:40:53 2013 da57c5f6 casper-rw
> 2559656586240 2558448626688  2561616374784     773376  4096    9  Tue
> Jan 29 20:40:53 2013 da57c5f6 casper-rw
> -- 8< ---------------------------------------------------------
>=20
> That makes me think I should be able to recover those dd images with
> the correct offsets, right? So for instance, looking at the
> "casper-rw" label, I tried this:
>=20
> -- 8< ---------------------------------------------------------
> # dd if=3D/dev/ro_device of=3D/tmp/test.dd bs=3D4096 =
skip=3D2556972231680
> count=3D773376 iflag=3Dskip_bytes
> -- 8< ---------------------------------------------------------
>=20
> The resulting /tmp/test.dd file looks like a correct filesystem:
> -- 8< ---------------------------------------------------------
> # file /tmp/dd_test
> /tmp/dd_test: Linux rev 1.0 ext2 filesystem data (mounted or unclean),
> UUID=3Dda57c5f6-1018-8a45-83b9-e12a39be7ce2, volume name "casper-rw"
> (large files)
> -- 8< ---------------------------------------------------------
>=20
> But I can't seem to be able to mount it:
> -- 8< ---------------------------------------------------------
> [507159.565593] EXT2-fs (loop3): warning: mounting unchecked fs,
> running e2fsck is recommended
> [507165.114603] EXT2-fs (loop3): error: ext2_check_page: bad entry in
> directory #2: : unaligned directory entry - offset=3D0,
> inode=3D2263518911, rec_len=3D23425, name_len=3D177
> [507165.129657] EXT2-fs (loop3): error: ext2_readdir: bad page in #2
> -- 8< ---------------------------------------------------------
>=20
> Did I misinterpret the output of findsuper?

No, this looks like the _start_ of a filesystem image, but there is
no real guarantee that the blocks in the file are allocated contiguously
in the actual filesystem, so your "dd" is unlikely to work properly.
The filesystem itself is 773376 * 4KB ~=3D 3GB in size, and if it was
originally created as a sparse file there is little chance those blocks
were allocated contiguously.  The findsuper utility is meant to locate
superblocks in a block device to help recover from partition table woes.


If you still have access to some of the files, you should consider to
copy them out of the filesystem.  Next, I would recommend to make an
LVM snapshot and run e2fsck on that to see what else you get out of it.
Depending on the amount and type of corruption, that may take a very
long time on a 20TB filesystem, and not be worthwhile to wait for.

Cheers, Andreas






--Apple-Mail=_33804753-F5E1-4444-B802-9A13E9DCAE0D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ4Qi7pIg59Q01vtYRAn4GAKCbuYX4XO/+oEaOYhLI8KU5+Mj86QCeOMLH
GdC3QjTtH4mVDJXlIaTQDaw=
=yt8z
-----END PGP SIGNATURE-----

--Apple-Mail=_33804753-F5E1-4444-B802-9A13E9DCAE0D--
