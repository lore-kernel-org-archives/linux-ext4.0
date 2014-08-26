From: Liwei <xieliwei@gmail.com>
Subject: Recovering from a damaged root inode
Date: Tue, 26 Aug 2014 19:32:59 +0800
Message-ID: <CAPE0SYxva9AkaynNDofObS-U5VW7RYW8io+N9Pz+6jVsCody8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59315 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaHZLdV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2014 07:33:21 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so14376533wgh.20
        for <linux-ext4@vger.kernel.org>; Tue, 26 Aug 2014 04:33:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,
    I have an ext4 volume that went through a power failure,
corrupting both the first superblock and apparently at least the root
inode.
    fsck managed to restore a backup superblock, so I believe that is
fine, but I am unable to see any files when the volume is mounted.
    dmesg gives me the following:

        EXT4-fs error (device dm-2): htree_dirblock_to_tree:919: inode
#2: block 9249: comm ls: bad entry in directory: rec_len % 4 != 0 -
offset=0(0), inode=1848761160, rec_len=32290, name_len=62

    I thought a second fsck run would help, but running it with -n
gave me the following:

Resize inode not valid.  Recreate? no
Pass 1: Checking inodes, blocks, and sizes
Inode 1049 has imagic flag set.  Clear? no
Inode 1049 has a extra size (21138) which is invalid
Fix? no
Inode 1049 has a bad extended attribute block 470477004.  Clear? no
Extended attribute block 470477004 has h_blocks > 1.  Clear? no
Extended attribute block 470477004 is corrupt (invalid value).  Clear? no
Extended attribute block 470477004 is corrupt (invalid value).  Clear? no
Extended attribute block 470477004 is corrupt (allocation collision).  Clear? no
Error while reading over extent tree in inode 1049: Corrupt extent header
Clear inode? no
Inode 1049, i_size is 11664618411086678673, should be 0.  Fix? no
Inode 1049, i_blocks is 263842572654276, should be 1.  Fix? no
Inode 1050 is in use, but has dtime set.  Fix? no
Inode 1050 has a extra size (22079) which is invalid
Fix? no

--------snip--------

Block #1032 (1256803293) causes symlink to be too big.  IGNORED.
Block #1033 (18311953) causes symlink to be too big.  IGNORED.
Block #1034 (2250429016) causes symlink to be too big.  IGNORED.
Block #1035 (1392819776) causes symlink to be too big.  IGNORED.
Illegal indirect block (4041828270) in inode 1065.  IGNORED.
Illegal triple indirect block (3637063325) in inode 1065.  IGNORED.
Error while iterating over blocks in inode 1065: Illegal triply
indirect block found

Archive: ********** WARNING: Filesystem still has errors **********
e2fsck: aborted
Archive: ********** WARNING: Filesystem still has errors **********

    Which is a bad sign that something is majorly messed up.

    It might also be relevant that a few days prior to this, I ran an
online resize from 10TB to 12TB. The volume had not been unmounted for
almost a year prior to that nor the days leading up to the power
failure.

    # uname -a
        Linux Archiver 3.9.0+ #2 SMP PREEMPT Mon Jun 17 21:25:29 SGT
2013 x86_64 GNU/Linux
    fsck from util-linux 2.20.1

    What would be the best way to proceed? The volume is sitting on
top of a LVM, which I had already taken a snapshot of.

Liwei
