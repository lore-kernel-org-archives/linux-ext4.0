From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Ext4: deadlock occurs when running fsstress and ENOSPC errors are seen.
Date: Tue, 15 Apr 2014 13:24:26 +0530
Message-ID: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	darrick.wong@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Initially in normal write path, when the disk was almost full =E2=80=93=
 we got
hung for the =E2=80=98sync=E2=80=99 because the flusher (which is busy =
in the
writepages is not responding). Before the hung task, we also found the
logs like:

EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1493, 0
clusters in bitmap, 58339 in gd
EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1000, 0
clusters in bitmap, 3 in gd
EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1425, 0
clusters in bitmap, 1 in gd
JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). Ther=
e's
a risk of filesystem corruption in case of system crash.
JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). Ther=
e's
a risk of filesystem corruption in case of system crash.

EXT4-fs (sda1): error count: 58
EXT4-fs (sda1): initial error at 607: ext4_mb_generate_buddy:742
EXT4-fs (sda1): last error at 58: ext4_mb_generate_buddy:742

When we analysed the problem, it occurred from the writepages path in e=
xt4.
This is because of the difference in the free blocks reported by
cluster bitmap and the number of free blocks reported by group
descriptor.
During ext4_fill_super, ext4 calculates the number of free blocks by
reading all the descriptors in function ext4_count_free_clusters and
store it in percpu counter s_freeclusters_counter.
ext4_count_free_clusters:
desc_count =3D 0;
for (i =3D 0; i < ngroups; i++) {
gdp =3D ext4_get_group_desc(sb, i, NULL);
if (!gdp)
continue;
desc_count +=3D ext4_free_group_clusters(sb, gdp);
}
return desc_count;

During writebegin call, ext4 checks this s_freeclusters_counter
counter to know if there are free blocks present or not.
When the free blocks reported by group descriptor are greater than the
actual free blocks reported by bitmap, a call to writebegin could
still succeed even if the free blocks represented by bitmaps are 0.

This situation was seen from our logs above:
EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1493, 0
clusters in bitmap, 58339 in gd
EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1000, 0
clusters in bitmap, 3 in gd
EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1425, 0
clusters in bitmap, 1 in gd

In this situation, during writeback, block allocation fails as
actually there are no free blocks available and ext4 revolves in
unbreakable loop in function ext4_da_writepages.
Due to this looping, sync thread which is waiting for completion for
the flusher thread, which initiated the ext4 writeback, is never
completed and hung task occur for sync thread.

When searching for the relevant problem which occurs in this path. We
got the patch-set from =E2=80=98Darrick=E2=80=99 which revolves around =
this problem.
ext4: error out if verifying the block bitmap fails
ext4: fix type declaration of ext4_validate_block_bitmap
ext4: mark block group as corrupt on block bitmap error
ext4: mark block group as corrupt on inode bitmap error
ext4: mark group corrupt on group descriptor checksum
ext4: don't count free clusters from a corrupt block group


After adopting the patch-set and performing verification on the
similar setup, we ran =E2=80=98fsstress=E2=80=99. But now it is resulti=
ng in hang at
different points.

In the current logs we got:
EXT4-fs error (device sdb1): ext4_mb_generate_buddy:743: group 1,
20480 clusters in bitmap, 25443 in gd; block bitmap corrupt.
JBD2: Spotted dirty metadata buffer (dev =3D sdb1, blocknr =3D 0). Ther=
e's
a risk of filesystem corruption in case of system crash.

Hinting at the corruption in the filesystem for block bitmap

And then logs like:
EXT4-fs (sdb1): delayed block allocation failed for inode 241 at
logical offset 17 with max blocks 22 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7847
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D22
EXT4-fs (sdb1): i_reserved_meta_blocks=3D1
EXT4-fs (sdb1): delayed block allocation failed for inode 218 at
logical offset 82 with max blocks 17 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): delayed block allocation failed for inode 196 at
logical offset 527 with max blocks 7 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D106
EXT4-fs (sdb1): i_reserved_meta_blocks=3D5
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D17
EXT4-fs (sdb1): i_reserved_meta_blocks=3D1
EXT4-fs (sdb1): delayed block allocation failed for inode 251 at
logical offset 197 with max blocks 14 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D44
EXT4-fs (sdb1): i_reserved_meta_blocks=3D2
EXT4-fs (sdb1): delayed block allocation failed for inode 251 at
logical offset 364 with max blocks 30 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D44
EXT4-fs (sdb1): i_reserved_meta_blocks=3D2
EXT4-fs (sdb1): delayed block allocation failed for inode 243 at
logical offset 23 with max blocks 14 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D14
EXT4-fs (sdb1): i_reserved_meta_blocks=3D1
EXT4-fs (sdb1): delayed block allocation failed for inode 249 at
logical offset 62 with max blocks 15 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D48
EXT4-fs (sdb1): i_reserved_meta_blocks=3D3
EXT4-fs (sdb1): delayed block allocation failed for inode 249 at
logical offset 155 with max blocks 6 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D48
EXT4-fs (sdb1): i_reserved_meta_blocks=3D3
EXT4-fs (sdb1): delayed block allocation failed for inode 249 at
logical offset 225 with max blocks 27 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 12
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25455
EXT4-fs (sdb1): dirty_blocks=3D7874
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D48
EXT4-fs (sdb1): i_reserved_meta_blocks=3D3
EXT4-fs (sdb1): delayed block allocation failed for inode 221 at
logical offset 1 with max blocks 2 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25455
EXT4-fs (sdb1): dirty_blocks=3D7901
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D2
EXT4-fs (sdb1): i_reserved_meta_blocks=3D1
EXT4-fs (sdb1): delayed block allocation failed for inode 250 at
logical offset 140 with max blocks 13 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25455
EXT4-fs (sdb1): dirty_blocks=3D7901
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D13
EXT4-fs (sdb1): i_reserved_meta_blocks=3D1

=46ollowed by the hungtask traces for:
Pid: 662, comm:          jbd2/sdb1-8
jbd2/sdb1-8     [2] D [e5354840] c03e910c     0   662 0x00000000
2            663     635      (kernel thread)
Backtrace:
[<c03e8f00>] (__schedule+0x0/0x5f4) from [<c03e9590>] (schedule+0x40/0x=
80)
[<c03e9550>] (schedule+0x0/0x80) from [<c03e9644>] (io_schedule+0x74/0x=
a0)
[<c03e95d0>] (io_schedule+0x0/0xa0) from [<c01737c0>]
(sleep_on_buffer+0x18/0x20)
 r6:e5921dd4 r5:002ecac6 r4:e5921dcc r3:00000002
[<c01737a8>] (sleep_on_buffer+0x0/0x20) from [<c03e7a54>]
(__wait_on_bit+0x8c/0xc4)
[<c03e79c8>] (__wait_on_bit+0x0/0xc4) from [<c03e7b04>]
(out_of_line_wait_on_bit+0x78/0x80)
[<c03e7a8c>] (out_of_line_wait_on_bit+0x0/0x80) from [<c01737a0>]
(__wait_on_buffer+0x30/0x38)
 r8:e5343e68 r7:e5343c00 r6:00000000 r5:e5677680 r4:00000000
[<c0173770>] (__wait_on_buffer+0x0/0x38) from [<c01f449c>]
(jbd2_journal_commit_transaction+0xbe8/0x1830)
[<c01f38b4>] (jbd2_journal_commit_transaction+0x0/0x1830) from
[<c01f9768>] (kjournald2+0xb8/0x24c)
[<c01f96b0>] (kjournald2+0x0/0x24c) from [<c005c700>] (kthread+0xb4/0xc=
0)
[<c005c64c>] (kthread+0x0/0xc0) from [<c0013188>] (ret_from_fork+0x14/0=
x20)
 r7:00000000 r6:00000000 r5:c005c64c r4:e4cf5c04


Pid: 635, comm:           flush-8:16
flush-8:16      [1] D [e5357b40] c03e910c     0   635 0x00000000
2            662     628      (kernel thread)
Backtrace:
[<c03e8f00>] (__schedule+0x0/0x5f4) from [<c03e9590>] (schedule+0x40/0x=
80)
[<c03e9550>] (schedule+0x0/0x80) from [<c01f93e8>]
(jbd2_log_wait_commit+0xa8/0x120)
[<c01f9340>] (jbd2_log_wait_commit+0x0/0x120) from [<c01fb3c0>]
(jbd2_journal_force_commit_nested+0x70/0xb4)
[<c01fb350>] (jbd2_journal_force_commit_nested+0x0/0xb4) from
[<c01afc48>] (ext4_da_writepages+0x450/0x5ec)
 r6:e588e000 r5:e5433660 r4:00000001 r3:ffffffe4
[<c01af7f8>] (ext4_da_writepages+0x0/0x5ec) from [<c0110178>]
(do_writepages+0x34/0x48)
[<c0110144>] (do_writepages+0x0/0x48) from [<c016b15c>]
(__writeback_single_inode+0x3c/0x17c)
[<c016b120>] (__writeback_single_inode+0x0/0x17c) from [<c016cc54>]
(writeback_sb_inodes+0x1fc/0x39c)
[<c016ca58>] (writeback_sb_inodes+0x0/0x39c) from [<c016d82c>]
(wb_writeback+0xf8/0x334)
[<c016d734>] (wb_writeback+0x0/0x334) from [<c016db18>]
(wb_do_writeback+0xb0/0x280)
[<c016da68>] (wb_do_writeback+0x0/0x280) from [<c016dd68>]
(bdi_writeback_thread+0x80/0x27c)
[<c016dce8>] (bdi_writeback_thread+0x0/0x27c) from [<c005c700>]
(kthread+0xb4/0xc0)
[<c005c64c>] (kthread+0x0/0xc0) from [<c0013188>] (ret_from_fork+0x14/0=
x20)
 r7:00000000 r6:00000000 r5:c005c64c r4:e5923e9c


Kernel Version: 3.8
Test command:
fsstress -p 10 -n 100 -l 100 -d /mnt/test_dir
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
