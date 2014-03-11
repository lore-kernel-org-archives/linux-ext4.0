From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: A couple of ext4 crashes with inlinedata/bigalloc
Date: Mon, 10 Mar 2014 20:06:04 -0700
Message-ID: <20140311030604.GK9875@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaCKDGL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Mar 2014 23:06:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

A couple of errors to complain about before I send out the e2fsprogs patchbomb.
:)

Zheng: I've been running the metadata checksum test with inline_data set.
flat_dir_test is a stress test which copies /usr/share/doc into a filesystem
and then "enlarges" the directories by recursively renaming "$foo" to
"$foo.longer", with the results below.  e2fsck complained that the directories
involved (4156, 4251) have multiple links to the subdir inode.  I'm not sure
what this is all about; the only (circumstantial) evidence I have is that it
goes away if I don't turn on inline_data.

[16570.712313] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #4156: block 676: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=1201, name_len=0
[16570.716608] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16570.718875] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4156), 2, error=-5
[16570.904570] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #4251: block 682: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=2056(2056), inode=1394505028, rec_len=30021, name_len=30
[16570.909581] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16570.911428] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4251), 2, error=-5
[16571.022583] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #4307: block 686: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=522, name_len=0
[16571.027072] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16571.028874] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4307), 2, error=-5
[16571.077139] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #4330: block 687: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=1439, name_len=0
[16571.081986] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16571.083706] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4330), 2, error=-5
[16571.148006] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #4361: block 689: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=581, name_len=0
[16571.152803] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16571.154683] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4361), 3, error=-5
[16571.217496] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4391), 2, error=-5
[16571.246602] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4404), 2, error=-5
[16571.442620] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4502), 2, error=-5
[16571.466456] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4512), 2, error=-5
[16571.766035] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (4665), 2, error=-5
[16576.188425] EXT4-fs error: 60 callbacks suppressed
[16576.189695] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #6110: block 798: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=2201, name_len=0
[16576.194567] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16576.196469] EXT4-fs warning: 25 callbacks suppressed
[16576.197759] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (6110), 3, error=-5
[16576.430344] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #6233: block 806: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=2829, name_len=0
[16576.435207] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16576.437199] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (6233), 2, error=-5
[16576.905949] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #132107: block 524384: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=1707, name_len=0
[16576.910461] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16576.928594] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (132107), 2, error=-5
[16577.061520] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #6274: block 809: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=1978, name_len=0
[16577.065880] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16577.067579] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (6274), 2, error=-5
[16577.482352] EXT4-fs error (device vda): ext4_generic_delete_entry:2118: inode #6421: block 818: comm mv: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=33188, rec_len=1450, name_len=0
[16577.487154] EXT4-fs error (device vda) in ext4_delete_entry:2178: IO failure
[16577.489174] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (6421), 2, error=-5
[16577.501151] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (132218), 2, error=-5
[16577.515396] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (132223), 2, error=-5
[16577.653652] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (6426), 3, error=-5
[16577.705341] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (6451), 2, error=-5
[16577.723995] EXT4-fs warning (device vda): ext4_rename:3151: Deleting old file (6457), 2, error=-5

Ted: The second error is if I run xfstests on a bigalloc filesystem, I
sometimes see this when running generic/299:

[16364.032279] ------------[ cut here ]------------
[16364.034736] kernel BUG at ../../../linux-mcsum/fs/buffer.c:1280!
[16364.037266] invalid opcode: 0000 [#1] PREEMPT SMP 
[16364.037266] Modules linked in: dm_flakey fuse ext4 jbd2 mbcache sch_fq_codel eeprom lpc_ich mfd_core nfsd exportfs auth_rpcgss af_packet btrfs raid6_pq xor zlib_deflate libcrc32c
[16364.037266] CPU: 1 PID: 24917 Comm: fio Tainted: G        W    3.14.0-rc6-mcsum #2
[16364.037266] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[16364.037266] task: ffff88003777e000 ti: ffff8800abafa000 task.ti: ffff8800abafa000
[16364.037266] RIP: 0010:[<ffffffff815b5b34>]  [<ffffffff815b5b34>] check_irqs_on.part.15+0x4/0x6
[16364.037266] RSP: 0018:ffff8800abafb518  EFLAGS: 00010046
[16364.037266] RAX: 0000000000000086 RBX: 0000000000001000 RCX: 00000000001fffff
[16364.037266] RDX: 0000000000001000 RSI: 0000000000000023 RDI: ffff8800ab438340
[16364.058379] RBP: ffff8800abafb518 R08: 0000000000000000 R09: 0000000000000000
[16364.058379] R10: 0000000000000000 R11: ffff8802422aaff0 R12: ffff8800abafb6f0
[16364.058379] R13: ffff880018344830 R14: 0000000000000023 R15: ffff8800ab438340
[16364.058379] FS:  00007f4b57573740(0000) GS:ffff88024fc80000(0000) knlGS:0000000000000000
[16364.058379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16364.058379] CR2: 000000000209d008 CR3: 000000002f79a000 CR4: 00000000001407e0
[16364.058379] Stack:
[16364.058379]  ffff8800abafb588 ffffffff811c8975 ffff88017fcf3618 ffff8800a367d750
[16364.058379]  ffff8800ab41b478 ffff8800a367d5b0 ffff880232094478 ffff880100003080
[16364.058379]  ffff8800abafb588 ffffffffa01a8583 0000000000001000 ffff8800abafb6f0
[16364.058379] Call Trace:
[16364.058379]  [<ffffffff811c8975>] __find_get_block+0x265/0x270
[16364.058379]  [<ffffffffa01a8583>] ? find_revoke_record+0xa3/0xb0 [jbd2]
[16364.058379]  [<ffffffff811c89a4>] __getblk+0x24/0x2d0
[16364.058379]  [<ffffffffa01d20b3>] __ext4_get_inode_loc+0x1a3/0x4f0 [ext4]
[16364.058379]  [<ffffffffa01a3530>] ? jbd2_journal_dirty_metadata+0x110/0x2f0 [jbd2]
[16364.058379]  [<ffffffffa01d3fcc>] ext4_get_inode_loc+0x1c/0x20 [ext4]
[16364.058379]  [<ffffffffa01d5f5d>] ext4_reserve_inode_write+0x2d/0xa0 [ext4]
[16364.058379]  [<ffffffffa01d601e>] ext4_mark_inode_dirty+0x4e/0x240 [ext4]
[16364.058379]  [<ffffffffa01fdb0b>] ? __ext4_ext_dirty+0x7b/0x80 [ext4]
[16364.058379]  [<ffffffffa01fdb0b>] __ext4_ext_dirty+0x7b/0x80 [ext4]
[16364.058379]  [<ffffffffa01fecd7>] ext4_ext_insert_extent+0x477/0x1200 [ext4]
[16364.058379]  [<ffffffff8118693b>] ? __kmalloc+0x16b/0x1b0
[16364.058379]  [<ffffffffa0202c5c>] ext4_ext_map_blocks+0x90c/0x1040 [ext4]
[16364.058379]  [<ffffffff811487a7>] ? release_pages+0x77/0x1f0
[16364.058379]  [<ffffffffa01d37b5>] ext4_map_blocks+0x325/0x530 [ext4]
[16364.058379]  [<ffffffffa01d8891>] ext4_writepages+0x701/0xd20 [ext4]
[16364.058379]  [<ffffffff81143088>] ? free_hot_cold_page_list+0x48/0xf0
[16364.058379]  [<ffffffff81146c40>] do_writepages+0x20/0x40
[16364.058379]  [<ffffffff8113c689>] __filemap_fdatawrite_range+0x59/0x60
[16364.058379]  [<ffffffff8113cd3c>] filemap_flush+0x1c/0x20
[16364.058379]  [<ffffffffa01d3d39>] ext4_alloc_da_blocks+0x49/0xc0 [ext4]
[16364.058379]  [<ffffffffa01cc9c9>] ext4_release_file+0x79/0xc0 [ext4]
[16364.058379]  [<ffffffff811972f9>] __fput+0xa9/0x220
[16364.058379]  [<ffffffff811974be>] ____fput+0xe/0x10
[16364.058379]  [<ffffffff8109494c>] task_work_run+0xbc/0xe0
[16364.058379]  [<ffffffff81076d0b>] do_exit+0x27b/0xa30
[16364.058379]  [<ffffffff8100d036>] ? ___preempt_schedule+0x56/0xb0
[16364.058379]  [<ffffffff81077604>] do_group_exit+0x44/0xa0
[16364.058379]  [<ffffffff81087bde>] get_signal_to_deliver+0x28e/0x660
[16364.058379]  [<ffffffff81002448>] do_signal+0x58/0x990
[16364.058379]  [<ffffffff81002e0c>] do_notify_resume+0x8c/0xa0
[16364.058379]  [<ffffffff815bd568>] int_signal+0x12/0x17
[16364.058379] Code: 88 c0 02 00 00 31 c0 e8 75 e1 ff ff 48 85 db 74 11 48 8d 7b 58 e8 7d 65 00 00 48 89 df e8 b5 5f bf ff 5b 41 5c 5d c3 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 66 
[16364.058379] RIP  [<ffffffff815b5b34>] check_irqs_on.part.15+0x4/0x6
[16364.058379]  RSP <ffff8800abafb518>
[16364.058379] ---[ end trace 4db094dad13d9c71 ]---

Most of the time it just spits this out and freezes:

[17845.350700] EXT4-fs error (device vdb): mb_free_blocks:1433: group 1, block 542368:freeing already freed block (bit 1130); block bitmap corrupt.
[17845.353287] EXT4-fs error (device vdb): ext4_mb_generate_buddy:756: group 1, 30843 clusters in bitmap, 30844 in gd; block bitmap corrupt.
[17845.355637] JBD2: Spotted dirty metadata buffer (dev = vdb, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
[17866.997006] EXT4-fs error (device vdb): mb_free_blocks:1433: group 2, block 1101152:freeing already freed block (bit 3286); block bitmap corrupt.
[17866.999539] EXT4-fs error (device vdb): ext4_mb_generate_buddy:756: group 2, 28913 clusters in bitmap, 28914 in gd; block bitmap corrupt.
[17867.002589] JBD2: Spotted dirty metadata buffer (dev = vdb, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
[17867.110632] EXT4-fs error (device vdb): mb_free_blocks:1433: group 3, block 1573376:freeing already freed block (bit 32); block bitmap corrupt.
[17867.113080] EXT4-fs error (device vdb): ext4_mb_generate_buddy:756: group 3, 32426 clusters in bitmap, 32427 in gd; block bitmap corrupt.
[17867.115615] JBD2: Spotted dirty metadata buffer (dev = vdb, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
[17868.288255] EXT4-fs error (device vdb): mb_free_blocks:1433: group 0, block 31184:freeing already freed block (bit 1949); block bitmap corrupt.
[17868.290755] EXT4-fs error (device vdb): ext4_mb_generate_buddy:756: group 0, 30687 clusters in bitmap, 30688 in gd; block bitmap corrupt.

Note that after rebooting the VM, e2fsck doesn't complain about errors.

Not sure what either of these are; just thought I'd report them.

-D
