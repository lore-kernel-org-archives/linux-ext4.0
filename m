From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Mon, 15 Jul 2013 19:55:50 +0200
Message-ID: <CACyNnZMxN7p9k0UOFLNmKL6sV0k+grNh85UpPJVyHck9pA7M5w@mail.gmail.com>
References: <loom.20130612T140739-743@post.gmane.org>
	<loom.20130623T082353-563@post.gmane.org>
	<20130623115953.GA16193@thunk.org>
	<CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
	<20130715134357.GA26359@thunk.org>
	<CACyNnZPnzEbcFj69+fGjm1rkLay51WTXFMqr25AOzY3vtvegpw@mail.gmail.com>
	<20130715163720.GC26359@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50752 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3GORzu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jul 2013 13:55:50 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro2so11492896pbb.13
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jul 2013 10:55:50 -0700 (PDT)
In-Reply-To: <20130715163720.GC26359@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Sorry for my dumb questions, but please, just 1 more =D

In another separate case, and a different partition being read too, I have:

/usr/ directory with information:
inode = 261837

superblock^.s_blocks_per_group = 32768
superblock^.s_inodes_per_group = 8128
superblock^.s_log_block_size = 2 -> so each block has 4k bytes
superblock^.s_inodes_per_group = 8128
number of block groups = (superblock^.s_blocks_count +
superblock^.s_blocks_per_group-1) div superblock^.s_blocks_per_group =
63

So I calculate (inodenr-1)/(inodes per group)=32 -> so the group nr
for inode /usr/ is 32

So next I decide to attempt to read the group descriptor for group 32

But my table of group descriptors read from group nr 0 is all correct
between group nr 0 and 31, but group nr 32 to 63 are filled with
zeroes.

>From what I had understood, the group descriptor in group zero should
contain all group descriptors from all groups, and subsequent
occurences of the group descriptor table would be backups.

Clearly it is not like that ... so I suppose that in group nr 32 I'll
find a table of group descriptors for groups between 32 and 63 or
something like that ... or maybe they did not fill in that block and
are somewhere else in group 0 .... any ideas?

full table of group descriptors read from group 0:

memoDebugOut
Group Descriptor Nr=0 bg_block_bitmap_lo=501 bg_inode_bitmap_lo=517
bg_inode_table_lo=533 bg_free_blocks_count_lo=21463
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=1232 bg_flags=4
Group Descriptor Nr=1 bg_block_bitmap_lo=503 bg_inode_bitmap_lo=519
bg_inode_table_lo=1549 bg_free_blocks_count_lo=47
bg_free_inodes_count_lo=23 bg_used_dirs_count_lo=633 bg_flags=4
Group Descriptor Nr=2 bg_block_bitmap_lo=505 bg_inode_bitmap_lo=521
bg_inode_table_lo=2565 bg_free_blocks_count_lo=2
bg_free_inodes_count_lo=8128 bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=3 bg_block_bitmap_lo=507 bg_inode_bitmap_lo=523
bg_inode_table_lo=3581 bg_free_blocks_count_lo=3410
bg_free_inodes_count_lo=8128 bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=4 bg_block_bitmap_lo=509 bg_inode_bitmap_lo=525
bg_inode_table_lo=4597 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=8128 bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=5 bg_block_bitmap_lo=511 bg_inode_bitmap_lo=527
bg_inode_table_lo=5613 bg_free_blocks_count_lo=16
bg_free_inodes_count_lo=8128 bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=6 bg_block_bitmap_lo=513 bg_inode_bitmap_lo=529
bg_inode_table_lo=6629 bg_free_blocks_count_lo=26803
bg_free_inodes_count_lo=8128 bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=7 bg_block_bitmap_lo=515 bg_inode_bitmap_lo=531
bg_inode_table_lo=7645 bg_free_blocks_count_lo=27542
bg_free_inodes_count_lo=8128 bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=8 bg_block_bitmap_lo=524288
bg_inode_bitmap_lo=524304 bg_inode_table_lo=524320
bg_free_blocks_count_lo=20867 bg_free_inodes_count_lo=0
bg_used_dirs_count_lo=573 bg_flags=4
Group Descriptor Nr=9 bg_block_bitmap_lo=524290
bg_inode_bitmap_lo=524306 bg_inode_table_lo=525336
bg_free_blocks_count_lo=171 bg_free_inodes_count_lo=0
bg_used_dirs_count_lo=423 bg_flags=4
Group Descriptor Nr=10 bg_block_bitmap_lo=524292
bg_inode_bitmap_lo=524308 bg_inode_table_lo=526352
bg_free_blocks_count_lo=0 bg_free_inodes_count_lo=499
bg_used_dirs_count_lo=1666 bg_flags=4
Group Descriptor Nr=11 bg_block_bitmap_lo=524294
bg_inode_bitmap_lo=524310 bg_inode_table_lo=527368
bg_free_blocks_count_lo=32243 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=12 bg_block_bitmap_lo=524296
bg_inode_bitmap_lo=524312 bg_inode_table_lo=528384
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=13 bg_block_bitmap_lo=524298
bg_inode_bitmap_lo=524314 bg_inode_table_lo=529400
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=14 bg_block_bitmap_lo=524300
bg_inode_bitmap_lo=524316 bg_inode_table_lo=530416
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=15 bg_block_bitmap_lo=524302
bg_inode_bitmap_lo=524318 bg_inode_table_lo=531432
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=16 bg_block_bitmap_lo=1048576
bg_inode_bitmap_lo=1048592 bg_inode_table_lo=1048608
bg_free_blocks_count_lo=20418 bg_free_inodes_count_lo=0
bg_used_dirs_count_lo=654 bg_flags=4
Group Descriptor Nr=17 bg_block_bitmap_lo=1048578
bg_inode_bitmap_lo=1048594 bg_inode_table_lo=1049624
bg_free_blocks_count_lo=12 bg_free_inodes_count_lo=0
bg_used_dirs_count_lo=2256 bg_flags=4
Group Descriptor Nr=18 bg_block_bitmap_lo=1048580
bg_inode_bitmap_lo=1048596 bg_inode_table_lo=1050640
bg_free_blocks_count_lo=0 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=19 bg_block_bitmap_lo=1048582
bg_inode_bitmap_lo=1048598 bg_inode_table_lo=1051656
bg_free_blocks_count_lo=0 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=20 bg_block_bitmap_lo=1048584
bg_inode_bitmap_lo=1048600 bg_inode_table_lo=1052672
bg_free_blocks_count_lo=17447 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=21 bg_block_bitmap_lo=1048586
bg_inode_bitmap_lo=1048602 bg_inode_table_lo=1053688
bg_free_blocks_count_lo=7625 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=22 bg_block_bitmap_lo=1048588
bg_inode_bitmap_lo=1048604 bg_inode_table_lo=1054704
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=23 bg_block_bitmap_lo=1048590
bg_inode_bitmap_lo=1048606 bg_inode_table_lo=1055720
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=24 bg_block_bitmap_lo=1572864
bg_inode_bitmap_lo=1572880 bg_inode_table_lo=1572896
bg_free_blocks_count_lo=20845 bg_free_inodes_count_lo=1
bg_used_dirs_count_lo=790 bg_flags=4
Group Descriptor Nr=25 bg_block_bitmap_lo=1572866
bg_inode_bitmap_lo=1572882 bg_inode_table_lo=1573912
bg_free_blocks_count_lo=0 bg_free_inodes_count_lo=0
bg_used_dirs_count_lo=188 bg_flags=4
Group Descriptor Nr=26 bg_block_bitmap_lo=1572868
bg_inode_bitmap_lo=1572884 bg_inode_table_lo=1574928
bg_free_blocks_count_lo=118 bg_free_inodes_count_lo=0
bg_used_dirs_count_lo=1314 bg_flags=4
Group Descriptor Nr=27 bg_block_bitmap_lo=1572870
bg_inode_bitmap_lo=1572886 bg_inode_table_lo=1575944
bg_free_blocks_count_lo=30412 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=28 bg_block_bitmap_lo=1572872
bg_inode_bitmap_lo=1572888 bg_inode_table_lo=1576960
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=29 bg_block_bitmap_lo=1572874
bg_inode_bitmap_lo=1572890 bg_inode_table_lo=1577976
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=30 bg_block_bitmap_lo=1572876
bg_inode_bitmap_lo=1572892 bg_inode_table_lo=1578992
bg_free_blocks_count_lo=32768 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=7
Group Descriptor Nr=31 bg_block_bitmap_lo=1572878
bg_inode_bitmap_lo=1572894 bg_inode_table_lo=1580008
bg_free_blocks_count_lo=14655 bg_free_inodes_count_lo=8128
bg_used_dirs_count_lo=0 bg_flags=5
Group Descriptor Nr=32 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=33 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=34 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=35 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=36 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=37 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=38 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=39 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=40 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=41 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=42 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=43 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=44 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=45 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=46 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=47 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=48 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=49 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=50 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=51 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=52 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=53 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=54 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=55 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=56 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=57 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=58 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=59 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=60 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=61 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0
Group Descriptor Nr=62 bg_block_bitmap_lo=0 bg_inode_bitmap_lo=0
bg_inode_table_lo=0 bg_free_blocks_count_lo=0
bg_free_inodes_count_lo=0 bg_used_dirs_count_lo=0 bg_flags=0


thank you very much,
-- 
Felipe Monteiro de Carvalho
