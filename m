From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH] Fix counting routines in blknum.c to take/return __u32
 counts.
Date: Sun, 06 Sep 2009 13:41:18 -0400
Message-ID: <10552.1252258878@gamaville.dokosmarshall.org>
References: <4A9D9574.3010606@redhat.com>
 <20090902055953.GF4197@webber.adilger.int>
 <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>
 <4A9EA09E.10509@redhat.com> <13135.1251925342@alphaville.usa.hp.com>
 <20090906163704.GK3055@mit.edu>
Reply-To: nicholas.dokos@hp.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173013pub.verizon.net ([206.46.173.13]:50184 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbZIFRlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Sep 2009 13:41:40 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173013.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KPK008MZ94MGRHA@vms173013.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Sun, 06 Sep 2009 12:41:23 -0500 (CDT)
In-reply-to: Message from Theodore Tso <tytso@mit.edu> of
 "Sun\, 06 Sep 2009 12\:37\:04 EDT." <20090906163704.GK3055@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Sep 02, 2009 at 05:02:22PM -0400, Nick Dokos wrote:
> > From e8c790ab8a0f06b4c89a5b6ddba2a36f033c742c Mon Sep 17 00:00:00 2001
> > From: Nick Dokos <nicholas.dokos@hp.com>
> > Date: Wed, 2 Sep 2009 16:52:09 -0400
> > Subject: [PATCH] Fix counting routines in blknum.c to take/return __u32 counts.
> > 
> > Several routines in lib/ext2fs/blknum.c:
> > 
> >         ext2fs_bg_free_blocks_count()
> >         ext2fs_bg_free_inodes_count()
> >         ext2fs_bg_used_dirs_count()
> >         ext2fs_bg_itable_unused()
> > 
> > and their _set() counterparts, operate as if they are dealing with
> > blk64_t quantities, but they should be dealing with __u32 counts
> > instead.
> > 
> > Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> 
> Added to the e2fsprogs pu branch / 64-bit patch set.
> 
> BTW, note that this patch by itself caused the regression test suite
> to explode spectactularly, since there was a number of printf-style
> format statements that had to be changed so that dumpe2fs, debugfs
> et. al, would work correctly after changing the above-mentioned
> routines to return 32-bit values instead of 64-bit values.
> 
> I've fixed this before adding it to the e2fsprogs patch set.
> 
> Even though we do need to add more 64-bit tests, I do appreciate it if
> people could test their patches using "make check" before sending
> patches them to the ext4 list.
> 

Apologies for the breakage, but I invariably do "make check" and I got
no failures on the "make check" step (log appended). I probably should
have ported them to a 32-bit platform and tested there but I did not. Is
that where the failures arose?

Thanks,
Nick


--=-=-=
Content-Disposition: inline; filename=make.check.log
Content-Transfer-Encoding: quoted-printable
Content-Description: make check log

make[1]: Entering directory `/home/nick/src/e2fsprogs/build'
make[1]: `lib/ext2fs/ext2_types.h' is up to date.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build'
make[1]: Entering directory `/home/nick/src/e2fsprogs/build'
make[1]: `lib/blkid/blkid_types.h' is up to date.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build'
make[1]: Entering directory `/home/nick/src/e2fsprogs/build'
make[1]: `lib/uuid/uuid_types.h' is up to date.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build'
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/et'
make[1]: `compile_et' is up to date.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/et'
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/ext2fs'
make[1]: `ext2_err.h' is up to date.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/ext2fs'
making check in util
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/util'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/util'
making check in lib/et
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/et'
for i in ../../../lib/et/test_cases/*.et ; do \
		t=3D`basename $i | sed -e 's/.et//'`; \
		./compile_et --build-tree $i ; \
		diff -c ../../../lib/et/test_cases/$t.c $t.c > $t.failed; \
		if [ $? -ne 0 ]; then echo Test case $t failed; exit 1 ; fi ; \
		diff -c ../../../lib/et/test_cases/$t.h $t.h >> $t.failed; \
		if [ $? -ne 0 ]; then echo Test case $t failed; exit 1 ; fi ; \
		/bin/rm -f $t.c $t.h $t.failed; \
		echo "Test case $t succeeded" ; \
	done
Test case continuation succeeded
Test case heimdal2 succeeded
Test case heimdal3 succeeded
Test case heimdal succeeded
Test case imap_err succeeded
Test case simple succeeded
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/et'
making check in lib/ss
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/ss'
	RUN TEST test_ss
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/ss'
making check in lib/e2p
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/e2p'
./tst_ostype
0: Linux (0)
1: Hurd (1)
2: Masix (2)
3: FreeBSD (3)
4: Lites (4)
./tst_feature
Feature list:
	Compat =3D 0, Mask =3D 1, dir_prealloc
	Compat =3D 0, Mask =3D 4, has_journal
	Compat =3D 0, Mask =3D 2, imagic_inodes
	Compat =3D 0, Mask =3D 8, ext_attr
	Compat =3D 0, Mask =3D 32, dir_index
	Compat =3D 0, Mask =3D 16, resize_inode
	Compat =3D 0, Mask =3D 64, lazy_bg
	Compat =3D 2, Mask =3D 1, sparse_super
	Compat =3D 2, Mask =3D 2, large_file
	Compat =3D 2, Mask =3D 8, huge_file
	Compat =3D 2, Mask =3D 16, uninit_bg
	Compat =3D 2, Mask =3D 16, uninit_groups
	Compat =3D 2, Mask =3D 32, dir_nlink
	Compat =3D 2, Mask =3D 64, extra_isize
	Compat =3D 1, Mask =3D 1, compression
	Compat =3D 1, Mask =3D 2, filetype
	Compat =3D 1, Mask =3D 4, needs_recovery
	Compat =3D 1, Mask =3D 8, journal_dev
	Compat =3D 1, Mask =3D 64, extent
	Compat =3D 1, Mask =3D 64, extents
	Compat =3D 1, Mask =3D 16, meta_bg
	Compat =3D 1, Mask =3D 128, 64bit
	Compat =3D 1, Mask =3D 512, flex_bg

Journal feature list:
	Compat =3D 0, Mask =3D 1, journal_checksum
	Compat =3D 1, Mask =3D 1, journal_incompat_revoke
	Compat =3D 1, Mask =3D 4, journal_async_commit
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/e2p'
making check in lib/uuid
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/uuid'
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_uuid
UUID generate =3D cbbb1eb3-57be-4b3f-8ce3-694c9efa9ade
UUID: cbbb1eb357be4b3f8ce3694c9efa9ade
UUID type =3D 4, UUID variant =3D 1

UUID random string =3D f870ff83-d313-44f9-abb8-8c3027e05546
UUID: f870ff83d31344f9abb88c3027e05546
UUID type =3D 4, UUID variant =3D 1

UUID string =3D e4c3f9be-9b0a-11de-895f-001e0bbaec64
UUID time: e4c3f9be9b0a11de895f001e0bbaec64
UUID type =3D 1, UUID variant =3D 1
UUID time is: (1252258195, 772051): Sun Sep  6 13:29:55 2009

UUID parse and compare succeeded.
UUID clear and is null succeeded.
UUID copy and compare succeeded.
84949cc5-4701-4a84-895b-354c584a981b is valid, OK
84949CC5-4701-4A84-895B-354C584A981B is valid, OK
84949cc5-4701-4a84-895b-354c584a981bc is invalid, OK
84949cc5-4701-4a84-895b-354c584a981 is invalid, OK
84949cc5x4701-4a84-895b-354c584a981b is invalid, OK
84949cc504701-4a84-895b-354c584a981b is invalid, OK
84949cc5-470104a84-895b-354c584a981b is invalid, OK
84949cc5-4701-4a840895b-354c584a981b is invalid, OK
84949cc5-4701-4a84-895b0354c584a981b is invalid, OK
g4949cc5-4701-4a84-895b-354c584a981b is invalid, OK
84949cc5-4701-4a84-895b-354c584a981g is invalid, OK
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/uuid'
making check in lib/ext2fs
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/ext2fs'
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_bitops
ext2fs_test_bit appears to be correct
ext2fs_set_bit test succeeded.
ext2fs_clear_bit test succeed.
big bit number (2147483690) test: 4, expected 4
big bit number (2147483690) test: 0, expected 0
ext2fs_set_bit big_test successful
ext2fs_fast_set_bit test succeeded.
ext2fs_clear_bit test succeed.
big bit number (2147483690) test: 4, expected 4
big bit number (2147483690) test: 0, expected 0
ext2fs_fast_set_bit big_test successful
64-bit: ext2fs_test_bit appears to be correct
64-bit: ext2fs_set_bit test succeeded.
64-bit: ext2fs_clear_bit test succeed.
64-bit: big bit number (2147483690) test: 4, expected 4
64-bit: big bit number (2147483690) test: 0, expected 0
64-bit: ext2fs_set_bit big_test successful
64-bit: ext2fs_fast_set_bit test succeeded.
64-bit: ext2fs_clear_bit test succeed.
64-bit: big bit number (2147483690) test: 4, expected 4
64-bit: big bit number (2147483690) test: 0, expected 0
64-bit: ext2fs_fast_set_bit big_test successful
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_badblocks
test1: 1 2 3 4 5 6 7 8 9 10 --- OK
test2: 1 2 3 4 5 6 7 8 9 10 11 --- OK
test3: 1 2 3 4 5 6 7 8 9 10 --- OK
test4: 2 12 13 17 20 23 50 56 66=20
	block 20 is present --- OK
	block 50 is present --- OK
	block 3 is absent --- OK
	block 17 is present --- OK
	block 18 is absent --- OK
	block 16 is absent --- OK
	block 11 is absent --- OK
	block 12 is present --- OK
	block 13 is present --- OK
	block 14 is absent --- OK
	block 80 is absent --- OK
	block 45 is absent --- OK
	block 66 is present --- OK

test5: 1 17 20 23 31 51 56 57=20
Adding block 50 --- now present
Removing block 51 --- now absent
Removing block 57 --- now absent
Adding block 66 --- now present
Removing block 31 --- now absent
Adding block 12 --- now present
Adding block 2 --- now present
Adding block 13 --- now present
Removing block 1 --- now absent
After test5 sequence: 2 12 13 17 20 23 50 56 66=20

Comparison tests:
bb1 and bb2 are NOT equal.
bb1 and bb3 are equal.
bb1 and bb4 are NOT equal.
bb4 and bb5 are equal.

Block bitmap matched after reading and writing.
Expected invalid block
Block bitmap matched after reading and writing.
ext2fs library badblocks tests checks out OK!
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_iscan
Reading blocks: 5-7, 9-11, 13-20, 21-23, 25-32, 33, 35-42, 45-52, 53-60, 61=
-68, 69-76, 77-84, 85-92, 93-99, 101-108, 109-116, 117-124, 125-132, 133-14=
0, 141-148, 149-156, 157-164, 165-172, 173-180, 181-188, 189-192, 8197-8204=
, 8205-8212, 8213-8220, 8221-8228, 8229-8236, 8237-8244, 8245-8252, 8253-82=
60, 8261-8268, 8269-8276, 8277-8284, 8285-8292, 8293-8300, 8301-8308, 8309-=
8316, 8317-8324, 8325-8332, 8333-8340, 8341-8348, 8349-8356, 8357-8364, 836=
5-8372, 8373-8380, 8381-8384
Bad inodes: 25, 26, 27, 28, 29, 30, 31, 32, 57, 58, 59, 60, 61, 62, 63, 64,=
 153, 154, 155, 156, 157, 158, 159, 160, 233, 234, 235, 236, 237, 238, 239,=
 240, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318,=
 319, 320, 761, 762, 763, 764, 765, 766, 767, 768
Inode scan tested OK!
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_types
The ext2_types.h types are correct.
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_icount
Standard icount run:
icount_store(42, 42) =3D 42 (OK)
icount_store(1, 1) =3D 1 (OK)
icount_store(2, 2) =3D 2 (OK)
icount_store(3, 3) =3D 3 (OK)
icount_store(10, 1) =3D 1 (OK)
icount_store(42, 0) =3D 0 (OK)
icount_increment(5) =3D 1 (OK)
icount_increment(5) =3D 2 (OK)
icount_increment(5) =3D 3 (OK)
icount_increment(5) =3D 4 (OK)
icount_decrement(5) =3D 3 (OK)
icount_decrement(5) =3D 2 (OK)
icount_decrement(5) =3D 1 (OK)
icount_decrement(5) =3D 0 (OK)
icount_fetch(10) =3D 1 (OK)
icount_fetch(1) =3D 1 (OK)
icount_fetch(2) =3D 2 (OK)
icount_fetch(3) =3D 3 (OK)
icount_increment(1) =3D 2 (OK)
icount_decrement(2) =3D 1 (OK)
icount_decrement(2) =3D 0 (OK)
icount_fetch(12) =3D 0 (OK)
icount size is 60

Multiple bitmap test:
icount_store(42, 42) =3D 42 (OK)
icount_store(1, 1) =3D 1 (OK)
icount_store(2, 2) =3D 2 (OK)
icount_store(3, 3) =3D 3 (OK)
icount_store(10, 1) =3D 1 (OK)
icount_store(42, 0) =3D 0 (OK)
icount_increment(5) =3D 1 (OK)
icount_increment(5) =3D 2 (OK)
icount_increment(5) =3D 3 (OK)
icount_increment(5) =3D 4 (OK)
icount_decrement(5) =3D 3 (OK)
icount_decrement(5) =3D 2 (OK)
icount_decrement(5) =3D 1 (OK)
icount_decrement(5) =3D 0 (OK)
icount_fetch(10) =3D 1 (OK)
icount_fetch(1) =3D 1 (OK)
icount_fetch(2) =3D 2 (OK)
icount_fetch(3) =3D 3 (OK)
icount_increment(1) =3D 2 (OK)
icount_decrement(2) =3D 1 (OK)
icount_decrement(2) =3D 0 (OK)
icount_fetch(12) =3D 0 (OK)
icount size is 60

Resizing icount:
icount_store(1, 1) =3D 1 (OK)
icount_store(2, 2) =3D 2 (OK)
icount_store(3, 3) =3D 3 (OK)
icount_store(4, 4) =3D 4 (OK)
icount_store(5, 5) =3D 5 (OK)
icount_store(6, 1) =3D 1 (OK)
icount_store(7, 2) =3D 2 (OK)
icount_store(8, 3) =3D 3 (OK)
icount_store(9, 4) =3D 4 (OK)
icount_store(10, 5) =3D 5 (OK)
icount_store(11, 1) =3D 1 (OK)
icount_store(12, 2) =3D 2 (OK)
icount_store(13, 3) =3D 3 (OK)
icount_store(14, 4) =3D 4 (OK)
icount_store(15, 5) =3D 5 (OK)
icount_store(16, 1) =3D 1 (OK)
icount_store(17, 2) =3D 2 (OK)
icount_store(18, 3) =3D 3 (OK)
icount_store(19, 4) =3D 4 (OK)
icount_store(20, 5) =3D 5 (OK)
icount_store(21, 1) =3D 1 (OK)
icount_store(22, 2) =3D 2 (OK)
icount_store(23, 3) =3D 3 (OK)
icount_store(24, 4) =3D 4 (OK)
icount_store(25, 5) =3D 5 (OK)
icount_store(26, 1) =3D 1 (OK)
icount_store(27, 2) =3D 2 (OK)
icount_store(28, 3) =3D 3 (OK)
icount_store(29, 4) =3D 4 (OK)
icount_store(30, 5) =3D 5 (OK)
icount size is 2256

Standard icount run with tdb:
icount_store(42, 42) =3D 42 (OK)
icount_store(1, 1) =3D 1 (OK)
icount_store(2, 2) =3D 2 (OK)
icount_store(3, 3) =3D 3 (OK)
icount_store(10, 1) =3D 1 (OK)
icount_store(42, 0) =3D 0 (OK)
icount_increment(5) =3D 1 (OK)
icount_increment(5) =3D 2 (OK)
icount_increment(5) =3D 3 (OK)
icount_increment(5) =3D 4 (OK)
icount_decrement(5) =3D 3 (OK)
icount_decrement(5) =3D 2 (OK)
icount_decrement(5) =3D 1 (OK)
icount_decrement(5) =3D 0 (OK)
icount_fetch(10) =3D 1 (OK)
icount_fetch(1) =3D 1 (OK)
icount_fetch(2) =3D 2 (OK)
icount_fetch(3) =3D 3 (OK)
icount_increment(1) =3D 2 (OK)
icount_decrement(2) =3D 1 (OK)
icount_decrement(2) =3D 0 (OK)
icount_fetch(12) =3D 0 (OK)
icount size is 0

Multiple bitmap test with tdb:
icount_store(42, 42) =3D 42 (OK)
icount_store(1, 1) =3D 1 (OK)
icount_store(2, 2) =3D 2 (OK)
icount_store(3, 3) =3D 3 (OK)
icount_store(10, 1) =3D 1 (OK)
icount_store(42, 0) =3D 0 (OK)
icount_increment(5) =3D 1 (OK)
icount_increment(5) =3D 2 (OK)
icount_increment(5) =3D 3 (OK)
icount_increment(5) =3D 4 (OK)
icount_decrement(5) =3D 3 (OK)
icount_decrement(5) =3D 2 (OK)
icount_decrement(5) =3D 1 (OK)
icount_decrement(5) =3D 0 (OK)
icount_fetch(10) =3D 1 (OK)
icount_fetch(1) =3D 1 (OK)
icount_fetch(2) =3D 2 (OK)
icount_fetch(3) =3D 3 (OK)
icount_increment(1) =3D 2 (OK)
icount_decrement(2) =3D 1 (OK)
icount_decrement(2) =3D 0 (OK)
icount_fetch(12) =3D 0 (OK)
icount size is 0
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_super_size
Size of struct ext2_super_block is 1024
LD_LIBRARY_PATH=3D../../lib DYLD_LIBRARY_PATH=3D../../lib ./tst_csum
csum0000: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 0(df47): d3a4=3D=
d3a4
csum0001: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 1(2346): 3ea5=3D=
3ea5
csumffff: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 2(6746): 49a5=3D=
49a5
csum_set: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 0(df47): d3a4=3D=
d3a4
new_uuid: UUID 30303030303030303030303030303030(766d), grp 0(76fd): a4ac=3D=
a4ac
csum_new: UUID 30303030303030303030303030303030(766d), grp 0(76fd): a4ac=3D=
a4ac
csum_blk: UUID 30303030303030303030303030303030(766d), grp 0(76fd): 2e14=3D=
2e14
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/ext2fs'
making check in lib/blkid
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/lib/blkid'
./test_probe
cramfs: ok
ext2: ok
ext3: ok
fat32_label_64MB: ok
fat: ok
iso: ok
jbd: ok
jfs: ok
minix: ok
ocfs2: ok
reiser3: ok
reiser4: ok
romfs: ok
small-fat32: ok
swap0: ok
swap1: ok
udf: ok
xfs: ok
zfs: ok
19 tests succeeded	0 tests failed
./tst_types
The blkid_types.h types are correct.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/lib/blkid'
making check in intl
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/intl'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/intl'
making check in e2fsck
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/e2fsck'
LD_LIBRARY_PATH=3D../lib DYLD_LIBRARY_PATH=3D../lib ./tst_refcount
Creating refcount with size 5
Storing blk 3 with value 3
Storing blk 4 with value 4
Storing blk 1 with value 1
Storing blk 8 with value 8
Storing blk 2 with value 2
Storing blk 4 with value 0
Storing blk 2 with value 0
Refcount_collapse: size was 5, now 3
Storing blk 6 with value 6
Refcount validation OK.
Storing blk 4 with value 4
Refcount_collapse: size was 5, now 5
Storing blk 2 with value 2
bcode_fetch(1) returns 1
bcode_fetch(2) returns 2
bcode_increment(3) returns 4
bcode_increment(3) returns 5
bcode_decrement(4) returns 3
Storing blk 4 with value 4
Refcount validation OK.
Storing blk 20 with value 20
Storing blk 40 with value 40
Storing blk 30 with value 30
Storing blk 10 with value 10
bcode_decrement(30) returns 29
bcode_fetch(30) returns 29
bcode_decrement(2) returns 1
bcode_decrement(2) returns 0
Refcount_collapse: size was 10, now 9
	blk=3D1, count=3D1
	blk=3D3, count=3D5
	blk=3D4, count=3D4
	blk=3D6, count=3D6
	blk=3D8, count=3D8
	blk=3D10, count=3D10
	blk=3D20, count=3D20
	blk=3D30, count=3D29
	blk=3D40, count=3D40
Refcount validation OK.
Freeing refcount
LD_LIBRARY_PATH=3D../lib DYLD_LIBRARY_PATH=3D../lib ./tst_region
Creating region with args(1, 1001)
Printing region (min=3D1. max=3D1001)
=09
Region_allocate(10, 10) returns 0
Region_allocate(30, 10) returns 0
Printing region (min=3D1. max=3D1001)
	(10, 20)  (30, 40)=20=20
Region_allocate(1, 15) returns 1
Region_allocate(15, 8) returns 1
Region_allocate(1, 20) returns 1
Region_allocate(1, 8) returns 0
Printing region (min=3D1. max=3D1001)
	(1, 9)  (10, 20)  (30, 40)=20=20
Region_allocate(40, 10) returns 0
Printing region (min=3D1. max=3D1001)
	(1, 9)  (10, 20)  (30, 50)=20=20
Region_allocate(22, 5) returns 0
Printing region (min=3D1. max=3D1001)
	(1, 9)  (10, 20)  (22, 27)  (30, 50)=20=20
Region_allocate(27, 3) returns 0
Printing region (min=3D1. max=3D1001)
	(1, 9)  (10, 20)  (22, 50)=20=20
Region_allocate(20, 2) returns 0
Printing region (min=3D1. max=3D1001)
	(1, 9)  (10, 50)=20=20
Region_allocate(49, 1) returns 1
Region_allocate(50, 5) returns 0
Region_allocate(9, 2) returns 1
Region_allocate(9, 1) returns 0
Printing region (min=3D1. max=3D1001)
	(1, 55)=20=20
LD_LIBRARY_PATH=3D../lib DYLD_LIBRARY_PATH=3D../lib ./tst_crc32
=0DTesting length 0...=0DTesting length 1...=0DTesting length 2...=0DTestin=
g length 3...=0DTesting length 4...=0DTesting length 5...=0DTesting length =
6...=0DTesting length 7...=0DTesting length 8...=0DTesting length 9...=0DTe=
sting length 10...=0DTesting length 11...=0DTesting length 12...=0DTesting =
length 13...=0DTesting length 14...=0DTesting length 15...=0DTesting length=
 16...=0DTesting length 17...=0DTesting length 18...=0DTesting length 19...=
=0DTesting length 20...=0DTesting length 21...=0DTesting length 22...=0DTes=
ting length 23...=0DTesting length 24...=0DTesting length 25...=0DTesting l=
ength 26...=0DTesting length 27...=0DTesting length 28...=0DTesting length =
29...=0DTesting length 30...=0DTesting length 31...=0DTesting length 32...=
=0DTesting length 33...=0DTesting length 34...=0DTesting length 35...=0DTes=
ting length 36...=0DTesting length 37...=0DTesting length 38...=0DTesting l=
ength 39...=0DTesting length 40...=0DTesting length 41...=0DTesting length =
42...=0DTesting length 43...=0DTesting length 44...=0DTesting length 45...=
=0DTesting length 46...=0DTesting length 47...=0DTesting length 48...=0DTes=
ting length 49...=0DTesting length 50...=0DTesting length 51...=0DTesting l=
ength 52...=0DTesting length 53...=0DTesting length 54...=0DTesting length =
55...=0DTesting length 56...=0DTesting length 57...=0DTesting length 58...=
=0DTesting length 59...=0DTesting length 60...=0DTesting length 61...=0DTes=
ting length 62...=0DTesting length 63...=0DTesting length 64...
All test complete.  No failures expected.
LD_LIBRARY_PATH=3D../lib DYLD_LIBRARY_PATH=3D../lib ./tst_problem
e2fsck problem table verified
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/e2fsck'
making check in debugfs
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/debugfs'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/debugfs'
making check in misc
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/misc'
./base_device < ../../misc/base_device.tst > base_device.out
cmp ../../misc/base_device.tst base_device.out
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/misc'
making check in resize
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/resize'
Test succeeded.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/resize'
making check in tests/progs
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/tests/progs'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/tests/progs'
making check in po
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/po'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/po'
making check in tests
make[1]: Entering directory `/home/nick/src/e2fsprogs/build/tests'
Running e2fsprogs test suite...
=20
d_loaddump: debugfs load/dump test: ok
e_brel_bma: block relocation table using the memory array implementation: s=
kipped
e_icount_normal: inode counting abstraction optimized for storing inode cou=
nts: ok
e_icount_opt: inode counting abstraction optimized for counting: ok
e_irel_ima: inode relocation table using the memory array implementation: s=
kipped
f_16384_block: 16384 byte blocksize: ok
f_8192_block: 8192 byte blocksize: ok
f_bad_disconnected_inode: Disconnected inode with bad fields: ok
f_bad_local_jnl: test for corrupt local journal (bad V1->V2 journal upgrade=
): ok
f_badbblocks: illegal blocks in bad block inode: ok
f_baddir: corrupted directory entries: ok
f_baddir2: salvage last directory entry: ok
f_baddotdir: bad '.' and '..' entries: ok
f_badinode: corrupted inode entries: ok
f_badjour_indblks: corruption in journal inode's indirect blocks: ok
f_badjourblks: Illegal blocks in journal inode (and backup in superblock): =
ok
f_badorphan: corrupted orphan list: ok
f_badprimary: bad blocks in the primary superblock and group descriptors: ok
f_badroot: file in root directory inode: ok
f_badsymlinks: corrupted symlinks: ok
f_badtable: bad blocks in bitmaps and inode table: ok
f_bbfile: bad blocks in files: ok
f_bbinode: bad blocks in inode table: ok
f_big_sparse: big sparse file: ok
f_bitmaps: corrupted inode and block bitmaps: ok
f_clear_xattr: clearing i_file_acl when !ext_attr feature: ok
f_crashdisk: Superblock with illegal values: ok
f_dir_bad_mode: directory with corrupted i_mode: ok
f_dirlink: directory hard links: ok
f_dup: blocks claimed by two different files: ok
f_dup2: blocks claimed by three different files: ok
f_dup3: blocks claimed by one file multiple times: ok
f_dup4: find all directory pathnames: ok
f_dup_de: duplicate directory entries: ok
f_dup_resize: blocks claimed by the resize inode and another inode: ok
f_dupdot: duplicate '.' and '..' entries: ok
f_dupfsblks: blocks claimed by a file and bitmaps or inode tables: ok
f_dupsuper: blocks claimed by a file and superblock or group descriptors: ok
f_ea_checks: extended attribute block checks: ok
f_end-bitmap: corruption at end of block bitmap: ok
f_expand: expanding lost+found: ok
f_ext_journal: ok
f_extent_bad_node: bad interior node in extent tree: ok
f_extents: basic extents support: ok
f_extents2: multiply claimed blocks in extents and other illegal extents: ok
f_extra_journal: Valid journal inode, but has_journal feature not present: =
ok
f_fast_symlink_extents: fast symlink with extents flag set: ok
f_file_acl_high: i_file_acl_high should be zero: ok
f_filetype: set filetype information and illegal special files: ok
f_full_bg: inode table in last block of first bg: ok
f_h_badnode: hash directory with bad HTREE nodes: ok
f_h_badroot: bad htree root nodes: ok
f_h_normal: Normal (signed) HTREE directory: ok
f_h_reindex: reindex HTREE Directory with different hash seed: ok
f_h_unsigned: Unsigned HTREE directory: ok
f_holedir: directory with holes and illegal blocks: ok
f_hurd: GNU/Hurd specific tests: ok
f_illbbitmap: illegal block bitmap: ok
f_illibitmap: illegal inode bitmap: ok
f_illitable: illegal inode table: ok
f_illitable_flexbg: illegal inode table with FLEX_BG: ok
f_imagic: non-imagic filesystem with imagic inodes: ok
f_imagic_fs: imagic filesystem with imagic inodes: ok
f_journal: recover journal from corrupted inode table: ok
f_lotsbad: too many illegal blocks in inode: ok
f_lpf: missing lost+found: ok
f_lpf2: create lost+found and reconnect lost directory: ok
f_lpffile: lost+found is not a directory: ok
f_messy_inode: bad file and directory acl pointers: ok
f_miss_blk_bmap: missing block bitmap: ok
f_miss_journal: Non-existent journal inode: ok
f_misstable: missing inode table: ok
f_mke2fs2b: mke2fs version 0.2b created filesystem: ok
f_noroot: missing root directory: ok
f_okgroup: 8193 block long filesystem: ok
f_orphan: clearing orphan inodes: ok
f_orphan_dotdot_ft: filetype of .. in orphaned directories: ok
f_overfsblks: overlapping inode and block bitmaps: ok
f_preen: preen shouldn't destroy backup superblocks: ok
f_recnect_bad: Reconnecting bad inode: ok
f_reconnect: simple disconnected file inode: ok
f_resize_inode: e2fsck with resize_inode: ok
f_salvage_dir: salvage corrupted directories: ok
f_selinux: SE Linux generated symlinks with EA data: ok
f_special_ea: Special files with extended attributes: ok
f_summary_counts: incorrect inode/block free counts: ok
f_uninit_last_uninit: last group has BLOCK_UNINIT set: ok
f_unsorted_EAs: unsorted EAs in inode should not be deleted: ok
f_valid_ea_in_inode: valid ea-in-inode examplars: ok
f_zero_group: fallback for damaged group descriptors: ok
f_zero_inode_size: superblock with a zero inode size: ok
f_zero_super: fallback for damaged superblock: ok
m_dasd_bs: 2048 byte sector devices: ok
m_large_file: largefile fs type: ok
m_meta_bg: meta blockgroup feature: ok
m_mkfs_overhead: test bg overhead calculation: ok
m_no_opt: no filesystem extensions: ok
m_raid_opt: raid options: ok
m_std: standard filesystem options: ok
m_uninit: uninitialized group feature: ok
r_inline_xattr: shrinking filesystem with in-inode extended attributes: ok
r_move_itable: filesystem resize which requires moving the inode table: ok
r_resize_inode: filesystem resize with a resize_inode present: ok
u_mke2fs: e2undo with mke2fs: ok
u_tune2fs: e2undo with tune2fs: ok
103 tests succeeded	0 tests failed
make[1]: Leaving directory `/home/nick/src/e2fsprogs/build/tests'

--=-=-=--
