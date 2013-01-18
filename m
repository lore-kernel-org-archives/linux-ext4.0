From: Jon Severinsson <jon@severinsson.net>
Subject: Resize2fs corrupts ext4 fs with bigalloc [Was: Re: Release candidate for e2fsprogs 1.42.7]
Date: Fri, 18 Jan 2013 20:47:16 +0100
Message-ID: <201301182047.53924.jon@severinsson.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2318791.nJZGoqHWiy";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:35069 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3ARUJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 15:09:08 -0500
Received: from ipb4.telenor.se (ipb4.telenor.se [195.54.127.167])
	by smtprelay-h31.telenor.se (Postfix) with ESMTP id 3AF4CEA1E4
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 20:47:54 +0100 (CET)
Received: from gitara.localnet (gitara.computers.severinsson.net [192.168.80.176])
	by smtp.severinsson.net (Postfix) with ESMTPSA id 5DD023538
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 20:47:54 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart2318791.nJZGoqHWiy
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Eba+QCD5F+C19jR"
Content-Transfer-Encoding: 7bit


--Boundary-01=_Eba+QCD5F+C19jR
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, Jan 16, 2013 at 02:55:24PM -0500, Theodore Ts'o wrote:
> I've just pushed an update to the e2fsprogs maint repository, and commit
> 8359f626a4e9 (the tip of the maint branch) is a release candidate for
> 1.42.7.  Please give it a test!  If I don't get any show-stopping bug
> reports, I plan to release it as 1.42.7 in the day or two.

I'm affraid I have one for you :-(

I've just tested both the debian experimental e2fsprogs package, as well as=
=20
manually built package from git 8359f626a4e9, both running on a debian test=
ing=20
system with a 3.7.3 kernel from experimental.

In both versions resize2fs corrupts a clean ext4 fs if bigalloc is enabled.

Attaching console output of example run.

Best regards
Jon Severinsson

--Boundary-01=_Eba+QCD5F+C19jR
Content-Type: text/plain;
  charset="UTF-8";
  name="resize2fs.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="resize2fs.txt"

jon@desora-core /tmp $ rm fs
jon@desora-core /tmp $ truncate -s 256G fs
jon@desora-core /tmp $ /sbin/mkfs.ext4 -T largefile4 -C 262144 -O bigalloc =
fs 128G
mke2fs 1.42.7 (15-Jan-2013)
fs is not a block special device.
Proceed anyway? (y,n) y
Discarding device blocks: done                           =20
=46ilesystem label=3D
OS type: Linux
Block size=3D4096 (log=3D2)
Cluster size=3D262144 (log=3D8)
Stride=3D0 blocks, Stripe width=3D0 blocks
32768 inodes, 33554432 blocks
1677721 blocks (5.00%) reserved for the super user
=46irst data block=3D0
Maximum filesystem blocks=3D4294967296
16 block groups
2097152 blocks per group, 32768 clusters per group
2048 inodes per group
Superblock backups stored on blocks:=20
        2097152, 6291456, 10485760, 14680064, 18874368

Allocating group tables: done                           =20
Writing inode tables: done                           =20
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done=20

jon@desora-core /tmp $ /sbin/e2fsck -f fs=20
e2fsck 1.42.7 (15-Jan-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
fs: 11/32768 files (0.0% non-contiguous), 35392/33554432 blocks
jon@desora-core /tmp $ /sbin/resize2fs -f fs=20
resize2fs 1.42.7 (15-Jan-2013)
Resizing the filesystem on fs to 67108864 (4k) blocks.
Illegal block number passed to ext2fs_unmark_block_bitmap #4194304 for bloc=
k bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #8388608 for bloc=
k bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #12582912 for blo=
ck bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #16777216 for blo=
ck bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #20971520 for blo=
ck bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #23068672 for blo=
ck bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #25165824 for blo=
ck bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #27262976 for blo=
ck bitmap for fs
Illegal block number passed to ext2fs_unmark_block_bitmap #29360128 for blo=
ck bitmap for fs
Illegal block number passed to ext2fs_mark_block_bitmap #2097153 for meta-d=
ata blocks
Illegal block number passed to ext2fs_mark_block_bitmap #6291457 for meta-d=
ata blocks
Illegal block number passed to ext2fs_mark_block_bitmap #10485761 for meta-=
data blocks
Illegal block number passed to ext2fs_mark_block_bitmap #14680065 for meta-=
data blocks
Illegal block number passed to ext2fs_mark_block_bitmap #18874369 for meta-=
data blocks
The filesystem on fs is now 67108864 blocks long.

jon@desora-core /tmp $ /sbin/e2fsck -n -f fs=20
e2fsck 1.42.7 (15-Jan-2013)
ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
/sbin/e2fsck: Group descriptors look bad... trying backup blocks...
Pass 1: Checking inodes, blocks, and sizes
Group 16's inode bitmap at 33554496 conflicts with some other fs block.
Relocate? no

Group 17's block bitmap at 33554624 conflicts with some other fs block.
Relocate? no

Group 17's inode bitmap at 33554688 conflicts with some other fs block.
Relocate? no

Group 18's block bitmap at 33554752 conflicts with some other fs block.
Relocate? no

Group 18's inode bitmap at 33554816 conflicts with some other fs block.
Relocate? no

Group 19's block bitmap at 33554880 conflicts with some other fs block.
Relocate? no

Group 19's inode bitmap at 33554944 conflicts with some other fs block.
Relocate? no

Group 20's block bitmap at 33555008 conflicts with some other fs block.
Relocate? no

Group 20's inode bitmap at 33555072 conflicts with some other fs block.
Relocate? no

Group 21's block bitmap at 33555136 conflicts with some other fs block.
Relocate? no

Group 21's inode bitmap at 33555200 conflicts with some other fs block.
Relocate? no

Group 22's block bitmap at 33555264 conflicts with some other fs block.
Relocate? no

Group 22's inode bitmap at 33555328 conflicts with some other fs block.
Relocate? no

Group 23's block bitmap at 33555392 conflicts with some other fs block.
Relocate? no

Group 23's inode bitmap at 33555456 conflicts with some other fs block.
Relocate? no

Group 24's block bitmap at 33555520 conflicts with some other fs block.
Relocate? no

Group 24's inode bitmap at 33555584 conflicts with some other fs block.
Relocate? no

Group 25's block bitmap at 33555648 conflicts with some other fs block.
Relocate? no

Group 25's inode bitmap at 33555712 conflicts with some other fs block.
Relocate? no

Group 26's block bitmap at 33555776 conflicts with some other fs block.
Relocate? no

Group 26's inode bitmap at 33555840 conflicts with some other fs block.
Relocate? no

Group 27's block bitmap at 33555904 conflicts with some other fs block.
Relocate? no

Group 27's inode bitmap at 33555968 conflicts with some other fs block.
Relocate? no

Group 28's block bitmap at 33556032 conflicts with some other fs block.
Relocate? no

Group 28's inode bitmap at 33556096 conflicts with some other fs block.
Relocate? no

Group 29's block bitmap at 33556160 conflicts with some other fs block.
Relocate? no

Group 29's inode bitmap at 33556224 conflicts with some other fs block.
Relocate? no

Group 30's block bitmap at 33556288 conflicts with some other fs block.
Relocate? no

Group 30's inode bitmap at 33556352 conflicts with some other fs block.
Relocate? no

Group 31's block bitmap at 33556416 conflicts with some other fs block.
Relocate? no

Group 31's inode bitmap at 33556480 conflicts with some other fs block.
Relocate? no

Deleted inode 51201 has zero dtime.  Fix? no

Deleted inode 55297 has zero dtime.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
=46ree blocks count wrong for group #0 (63232, counted=3D32732).
=46ix? no

=46ree blocks count wrong for group #1 (65472, counted=3D32767).
=46ix? no

=46ree blocks count wrong for group #2 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #3 (65472, counted=3D32767).
=46ix? no

=46ree blocks count wrong for group #4 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #5 (65472, counted=3D32767).
=46ix? no

=46ree blocks count wrong for group #6 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #7 (32704, counted=3D32255).
=46ix? no

=46ree blocks count wrong for group #8 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #9 (65472, counted=3D32767).
=46ix? no

=46ree blocks count wrong for group #10 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #11 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #12 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #13 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #14 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #15 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #16 (63424, counted=3D32735).
=46ix? no

=46ree blocks count wrong for group #17 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #18 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #19 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #20 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #21 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #22 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #23 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #24 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #25 (65472, counted=3D32767).
=46ix? no

=46ree blocks count wrong for group #26 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #27 (65472, counted=3D32767).
=46ix? no

=46ree blocks count wrong for group #28 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #29 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #30 (0, counted=3D32768).
=46ix? no

=46ree blocks count wrong for group #31 (0, counted=3D32768).
=46ix? no


fs: ********** WARNING: Filesystem still has errors **********

fs: 11/65536 files (0.0% non-contiguous), 37632/67108864 blocks
jon@desora-core /tmp $=20

--Boundary-01=_Eba+QCD5F+C19jR--

--nextPart2318791.nJZGoqHWiy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQ+abEAAoJEIxPDyvAFXjJTdAQAKIM4YL/YowYqqR0cm+h/EVm
8G4GAse/KerRa+WbOfcnONAS18SoAz/Od3nsBs0nHCG7smU9wByhMM2o46nMQRnw
urvt2B3lozkv4xzxvwzXESF63YxvMy20sGaWNkYkSlc3ZOS4yedgJeKgCdrdY4+D
Fu8Nzkx5br8CAjebGoJPk6M/mvXHSTUlX1nqNposqg/p28WaS/UCRtfPXSEWIwXL
i/ixujzW0b+pQLNU8VDTxGCKfL3BpsDkqmx+l/umepvaxbdF/jIjOBj2HEE4VJUc
FaOdJhM6BZZ6DTfmjXjoAz9fgmLYyBFH3Zf2AJ62UjaNugmH/Z/uo2wupJ3eTYox
Mg8U+3yZSfXmYVvJKof4Zx6LRFwvbC5XibgwEh2WP2AxetFH65r5TnGzTXbsMOLY
peQfSB9sQAt32L83jKvrF8CIdREUOfo19VDa4RY5g28pTKXWaeky18nNjnionlVy
mXgZtZmw2txkAMoWrtyUNtIYQWMaD4UHIMhcPfxQu+SEq8NC2cTb8UEHrFQgj/B4
RHZsEdRjVKTCi9EeA0WjaMsGlbpbZOuDslcGrCKu8RUzjhW1Mg75bcUsO26Gm/GO
8qh0LwZ+15DqX1lgj6VD+eAyHdqwFzGlmcqI2n+4Lioq0gITqNGLmgCH1yjYDWS6
No7yC2IH9XAiX4Dpd7e7
=QBZo
-----END PGP SIGNATURE-----

--nextPart2318791.nJZGoqHWiy--
