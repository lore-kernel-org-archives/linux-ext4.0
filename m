From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC][PATCH 0/8] 64bit inode e2fsprogs support
Date: Fri, 27 Oct 2017 16:04:56 -0600
Message-ID: <FFFDF5AA-E79F-46F0-99B6-0E38DB1943BA@dilger.ca>
References: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F1F0C91C-2AF8-4449-AC3B-22176900968B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:53670 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbdJ0WFC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 18:05:02 -0400
Received: by mail-io0-f194.google.com with SMTP id 189so15660296iow.10
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 15:05:01 -0700 (PDT)
In-Reply-To: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F1F0C91C-2AF8-4449-AC3B-22176900968B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Andreas Dilger (2):
>  e2fsck: add support for dirdata feature
>  tests: add basic tests for dirdata feature
>=20
> Artem Blagodarenko (5):
>  e2fsck Fix access after free for dx_db structure
>  LU-9309 debugfs: 64bit inode support
>  LU-9309 ext2fs: add EXT4_FEATURE_INCOMPAT_64INODE suport
>  LU-9309 quota: swaping s_prj_quota_inum superblock field
>  LU-9309 quota: quota 64bit inode number cleanup
>=20
> Bobi Jam (1):
>  LU-1774 tests: e2fsck -D does not change dirdata

We probably don't want to keep the LU ticket number in the patch
description.  What we've been doing for Lustre patches going into
the upstream kernel is to add a tag:

Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309

so that this information is maintained in a more useful way.

Cheers, Andreas

>=20
> debugfs/debugfs.c                 |   2 +-
> debugfs/htree.c                   |   2 +-
> debugfs/ls.c                      |  47 +++-
> debugfs/set_fields.c              |   4 +
> debugfs/util.c                    |   4 +-
> e2fsck/e2fsck.c                   |   4 +-
> e2fsck/e2fsck.h                   |   4 +-
> e2fsck/extents.c                  |   8 +-
> e2fsck/journal.c                  |   2 +-
> e2fsck/pass1.c                    |  29 +--
> e2fsck/pass1b.c                   |   2 +-
> e2fsck/pass2.c                    | 144 ++++++++---
> e2fsck/pass3.c                    |   8 +
> e2fsck/pass4.c                    |   2 +-
> e2fsck/pass5.c                    |  20 +-
> e2fsck/problem.c                  |   5 +
> e2fsck/problem.h                  |   3 +
> e2fsck/quota.c                    |  10 +-
> e2fsck/rehash.c                   |  96 ++++---
> e2fsck/super.c                    |  17 +-
> e2fsck/unix.c                     |  17 +-
> ext2ed/inode_com.c                |   2 +-
> ext2ed/super_com.c                |   6 +-
> lib/e2p/feature.c                 |   2 +
> lib/e2p/ls.c                      |   8 +-
> lib/ext2fs/alloc.c                |   8 +-
> lib/ext2fs/alloc_stats.c          |   5 +-
> lib/ext2fs/badblocks.c            |  92 +++----
> lib/ext2fs/bb_compat.c            |   6 +-
> lib/ext2fs/bb_inode.c             |  14 +-
> lib/ext2fs/bitmaps.c              |   2 +-
> lib/ext2fs/dirblock.c             |  34 +++
> lib/ext2fs/ext2_fs.h              |  27 +-
> lib/ext2fs/ext2fs.h               | 116 +++++++--
> lib/ext2fs/ext2fsP.h              |   8 +-
> lib/ext2fs/extent.c               |   2 +-
> lib/ext2fs/freefs.c               |   4 +-
> lib/ext2fs/gen_bitmap64.c         |   2 +-
> lib/ext2fs/get_num_dirs.c         |   4 +-
> lib/ext2fs/icount.c               |   7 +-
> lib/ext2fs/initialize.c           |  17 +-
> lib/ext2fs/inline_data.c          |  16 +-
> lib/ext2fs/inode.c                |   8 +-
> lib/ext2fs/lfsck.h                |  40 +++
> lib/ext2fs/link.c                 |  10 +-
> lib/ext2fs/newdir.c               |   4 +-
> lib/ext2fs/openfs.c               |   4 +-
> lib/ext2fs/rw_bitmaps.c           |   2 +-
> lib/ext2fs/swapfs.c               |   6 +
> lib/ext2fs/tst_bitmaps.c          |   7 +-
> lib/ext2fs/tst_iscan.c            |   2 +-
> lib/ext2fs/tst_super_size.c       |   5 +
> lib/ext2fs/write_bb_file.c        |   2 +-
> lib/support/mkquota.c             |  10 +-
> lib/support/quotaio.c             |   2 +-
> lib/support/quotaio.h             |  47 +++-
> misc/badblocks.c                  |  34 +--
> misc/dumpe2fs.c                   |   2 +-
> misc/findsuper.c                  |   6 +-
> misc/fuse2fs.c                    |   6 +-
> misc/mke2fs.c                     |  28 ++-
> misc/tune2fs.c                    |  15 +-
> resize/main.c                     |   3 +-
> resize/resize2fs.c                |  27 +-
> tests/f_dir_optimize/expect.1     | 511 =
++++++++++++++++++++++++++++++++++++++
> tests/f_dir_optimize/expect.2     | 511 =
++++++++++++++++++++++++++++++++++++++
> tests/f_dir_optimize/image.gz     | Bin 0 -> 102520 bytes
> tests/f_dir_optimize/name         |   1 +
> tests/f_dir_optimize/script       |  36 +++
> tests/f_dirdata/expect.1          |  15 ++
> tests/f_dirdata/expect.2          |   7 +
> tests/f_dirdata/image.gz          | Bin 0 -> 72169 bytes
> tests/f_dirdata/name              |   1 +
> tests/f_dirdata_optimize/expect.1 |  10 +
> tests/f_dirdata_optimize/expect.2 |   7 +
> tests/f_dirdata_optimize/image.gz | Bin 0 -> 32121 bytes
> tests/f_dirdata_optimize/name     |   1 +
> tests/f_dirdata_optimize/script   |   3 +
> tests/progs/test_icount.c         |   4 +-
> 79 files changed, 1837 insertions(+), 352 deletions(-)
> create mode 100644 lib/ext2fs/lfsck.h
> create mode 100644 tests/f_dir_optimize/expect.1
> create mode 100644 tests/f_dir_optimize/expect.2
> create mode 100644 tests/f_dir_optimize/image.gz
> create mode 100644 tests/f_dir_optimize/name
> create mode 100644 tests/f_dir_optimize/script
> create mode 100644 tests/f_dirdata/expect.1
> create mode 100644 tests/f_dirdata/expect.2
> create mode 100644 tests/f_dirdata/image.gz
> create mode 100644 tests/f_dirdata/name
> create mode 100644 tests/f_dirdata_optimize/expect.1
> create mode 100644 tests/f_dirdata_optimize/expect.2
> create mode 100644 tests/f_dirdata_optimize/image.gz
> create mode 100644 tests/f_dirdata_optimize/name
> create mode 100644 tests/f_dirdata_optimize/script
>=20
> --
> 2.13.5 (Apple Git-94)
>=20


Cheers, Andreas






--Apple-Mail=_F1F0C91C-2AF8-4449-AC3B-22176900968B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ862IpIg59Q01vtYRAt8kAJ476CqtcamcC/r9oBYypl4kyFzwJgCgpWjq
oYovJV4YhsC8iy4JyPbQ5N4=
=t25v
-----END PGP SIGNATURE-----

--Apple-Mail=_F1F0C91C-2AF8-4449-AC3B-22176900968B--
