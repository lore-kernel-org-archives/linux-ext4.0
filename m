From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: some large dir testing results
Date: Thu, 20 Apr 2017 15:10:20 -0600
Message-ID: <F883702D-CECE-4FE8-ACA7-706EAB3D69FB@dilger.ca>
References: <52B4B404-9FE0-4586-A02A-3451AA5BE089@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AD5836AC-28CB-4E58-983C-D933D79D1534";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35124 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947478AbdDTVK3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Apr 2017 17:10:29 -0400
Received: by mail-io0-f172.google.com with SMTP id r16so83501533ioi.2
        for <linux-ext4@vger.kernel.org>; Thu, 20 Apr 2017 14:10:28 -0700 (PDT)
In-Reply-To: <52B4B404-9FE0-4586-A02A-3451AA5BE089@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_AD5836AC-28CB-4E58-983C-D933D79D1534
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Apr 20, 2017, at 1:00 PM, Alexey Lyashkov <alexey.lyashkov@gmail.com> =
wrote:
> I run some testing on my environment with large dir patches provided =
by Artem.

Alexey, thanks for running these tests.

> Each test run a 11 loops with creating 20680000 mknod objects for =
normal dir, and 20680000 for large dir.

Just to clarify, here you write that both 2-level and 3-level =
directories
are creating about 20.7M entries, but in the tests shown below it looks
like the 3-level htree is creating ~207M entries (i.e. 10x as many)?

> FS was reformatted before each test, files was created in root dir to =
have an allocate inodes and blocks from GD#0 and up.
> Journal have a size - 4G and it was internal journal.
> Kernel was RHEL 7.2 based with lustre patches.

For non-Lustre readers, "createmany" is a single-threaded test that
creates a lot of files with the specified name in the given directory.
It has different options for using mknod(), open(), link(), mkdir(),
and unlink() or rmdir() to create and remove different types of entries,
and prints running stats on the current and overall rate of creation.

> Test script code
> #!/bin/bash
>=20
> LOOPS=3D11
>=20
> for i in `seq ${LOOPS}`; do
> 	mkfs -t ext4 -F -I 256 -J size=3D4096 ${DEV}
> 	mount -t ldiskfs ${DEV} ${MNT}
> 	pushd ${MNT}
> 	/usr/lib/lustre/tests/createmany -m test 20680000 >& =
/tmp/small-mknod${i}
> 	popd
> 	umount ${DEV}
> done
>=20
>=20
> for i in `seq ${LOOPS}`; do
> 	mkfs -t ext4 -F -I 256 -J size=3D4096 -O large_dir ${DEV}
> 	mount -t ldiskfs ${DEV} ${MNT}
> 	pushd ${MNT}
> 	/usr/lib/lustre/tests/createmany -m test 206800000 >& =
/tmp/large-mknod${i}
> 	popd
> 	umount ${DEV}
> done
>=20
> Tests was run on two nodes - first node have a storage with raid10 of =
fast HDD=E2=80=99s, second node have a NMVE as block device.
> Current directory code have a near of similar results for both nodes =
for first test:
> - HDD node 56k-65k creates/s
> - SSD node ~80k creates/s
> But large_dir testing have a large differences for nodes.
> - HDD node have a drop a creation rate to 11k create/s
> - SSD node have drop to 46k create/s

Sure, it isn't totally surprising that a larger directory becomes =
slower,
because the htree hashing is essentially inserting into random blocks.
For 207M entries of ~9 char names this would be about:

    entries * (sizeof(ext4_dir_entry) + round_up(name_len, 4)) * =
use_ratio

    =3D 206800000 * (8 + (4 + 9 + 3)) * 4 / 3 ~=3D 6.6GB of leaf blocks

Unfortunately, all of the leaf blocks need to be kept in RAM in order to
get any good performance, since each entry is inserted into a random =
leaf.
There also needs to be more RAM for 4GB journal, dcache, inodes, etc.

I guess the good news is that htree performance is also not going to =
degrade
significantly over time due to further fragmentation since it is already
doing random insert/delete when the directory is very large.

> Initial analyze say about several problems
> 0) CPU load isn=E2=80=99t high, and perf top say ldiskfs functions =
isn=E2=80=99t hot (2%-3% cpu), most spent for dir entry checking =
function.
>=20
> 1) lookup have a large time to read a directory block to verify file =
not exist. I think it because a block fragmentation.
> [root@pink03 ~]# cat /proc/100993/stack
> [<ffffffff81211b1e>] sleep_on_buffer+0xe/0x20
> [<ffffffff812130da>] __wait_on_buffer+0x2a/0x30
> [<ffffffffa0899e6c>] ldiskfs_bread+0x7c/0xc0 [ldiskfs]
> [<ffffffffa088ee4a>] __ldiskfs_read_dirblock+0x4a/0x400 [ldiskfs]
> [<ffffffffa08915af>] ldiskfs_dx_find_entry+0xef/0x200 [ldiskfs]
> [<ffffffffa0891b8b>] ldiskfs_find_entry+0x4cb/0x570 [ldiskfs]
> [<ffffffffa08921d5>] ldiskfs_lookup+0x75/0x230 [ldiskfs]
> [<ffffffff811e8e7d>] lookup_real+0x1d/0x50
> [<ffffffff811e97f2>] __lookup_hash+0x42/0x60
> [<ffffffff811ee848>] filename_create+0x98/0x180
> [<ffffffff811ef6e1>] user_path_create+0x41/0x60
> [<ffffffff811f084a>] SyS_mknodat+0xda/0x220
> [<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
> [<ffffffff81645549>] system_call_fastpath+0x16/0x1b

I don't think anything can be done here if the RAM size isn't large
enough to hold all of the directory leaf blocks in memory.

Would you be able to re-run this benchmark using the TEA hash?  For
workloads like this where filenames are created in a sequential order
(createmany, Lustre object directories, others) the TEA hash can be
an improvement.

In theory, TEA hash entry insertion into the leaf blocks would be mostly
sequential for these workloads. The would localize the insertions into
the directory, which could reduce the number of leaf blocks that are
active at one time and could improve the performance noticeably. This
is only an improvement if the workload is known, but for Lustre OST
object directories that is the case, and is mostly under our control.

> 2) Some JBD problems when create thread have a wait a shadow BH from a =
committed transaction.
> [root@pink03 ~]# cat /proc/100993/stack
> [<ffffffffa06a072e>] sleep_on_shadow_bh+0xe/0x20 [jbd2]
> [<ffffffffa06a1bad>] do_get_write_access+0x2dd/0x4e0 [jbd2]
> [<ffffffffa06a1dd7>] jbd2_journal_get_write_access+0x27/0x40 [jbd2]
> [<ffffffffa08c7cab>] __ldiskfs_journal_get_write_access+0x3b/0x80 =
[ldiskfs]
> [<ffffffffa08ce817>] __ldiskfs_new_inode+0x447/0x1300 [ldiskfs]
> [<ffffffffa08948c8>] ldiskfs_create+0xd8/0x190 [ldiskfs]
> [<ffffffff811eb42d>] vfs_create+0xcd/0x130
> [<ffffffff811f0960>] SyS_mknodat+0x1f0/0x220
> [<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
> [<ffffffff81645549>] system_call_fastpath+0x16/0x1b

You might consider to use "createmany -l" to link entries (at least 65k
at a time) to the same inode (this would need changes to createmany to
create more than 65k files), so that you are exercising the directory
code and not loading so many inodes into memory?

> [root@pink03 ~]# cat /proc/100993/stack
> [<ffffffffa06a072e>] sleep_on_shadow_bh+0xe/0x20 [jbd2]
> [<ffffffffa06a1bad>] do_get_write_access+0x2dd/0x4e0 [jbd2]
> [<ffffffffa06a1dd7>] jbd2_journal_get_write_access+0x27/0x40 [jbd2]
> [<ffffffffa08c7cab>] __ldiskfs_journal_get_write_access+0x3b/0x80 =
[ldiskfs]
> [<ffffffffa08a75bd>] ldiskfs_mb_mark_diskspace_used+0x7d/0x4f0 =
[ldiskfs]
> [<ffffffffa08abacc>] ldiskfs_mb_new_blocks+0x2ac/0x5d0 [ldiskfs]
> [<ffffffffa08db63d>] ldiskfs_ext_map_blocks+0x49d/0xed0 [ldiskfs]
> [<ffffffffa08997d9>] ldiskfs_map_blocks+0x179/0x590 [ldiskfs]
> [<ffffffffa0899c55>] ldiskfs_getblk+0x65/0x200 [ldiskfs]
> [<ffffffffa0899e17>] ldiskfs_bread+0x27/0xc0 [ldiskfs]
> [<ffffffffa088e3be>] ldiskfs_append+0x7e/0x150 [ldiskfs]
> [<ffffffffa088fb09>] do_split+0xa9/0x900 [ldiskfs]
> [<ffffffffa0892bb2>] ldiskfs_dx_add_entry+0xc2/0xbc0 [ldiskfs]
> [<ffffffffa0894154>] ldiskfs_add_entry+0x254/0x6e0 [ldiskfs]
> [<ffffffffa0894600>] ldiskfs_add_nondir+0x20/0x80 [ldiskfs]
> [<ffffffffa0894904>] ldiskfs_create+0x114/0x190 [ldiskfs]
> [<ffffffff811eb42d>] vfs_create+0xcd/0x130
> [<ffffffff811f0960>] SyS_mknodat+0x1f0/0x220
> [<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
> [<ffffffff81645549>] system_call_fastpath+0x16/0x1b

The other issue here may be that ext4 extent-mapped directories are
not very efficient.  Each block takes 12 bytes in the extent tree vs.
only 4 bytes for block-mapped directories.  Unfortunately, it isn't
possible to use block-mapped directories for filesystems over 2^32 =
blocks.

Another option might be to use bigalloc with, say, 16KB or 64KB chunks
so that the directory leaf blocks are not so fragmented and the extent
map can be kept more compact.

> I know several jbd2 improvements by Kara isn=E2=80=99t landed into =
RHEL7, but i don=E2=80=99t think it will big improvement, as SSD have =
less perf drop.
> I think perf dropped due additional seeks requested to have access to =
the dir data or inode allocation.

Cheers, Andreas






--Apple-Mail=_AD5836AC-28CB-4E58-983C-D933D79D1534
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD4DBQFY+SO+pIg59Q01vtYRAgc9AJYjrOaQMlTyH9/utUN1SO6rvCn0AKCw1JZj
skKV3gWhralTkRrO3yTomQ==
=psK0
-----END PGP SIGNATURE-----

--Apple-Mail=_AD5836AC-28CB-4E58-983C-D933D79D1534--
