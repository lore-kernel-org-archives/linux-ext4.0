From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [BUG] ext4: i_size, EOFBLOCKS_FS corruption with xfstests 269
Date: Wed, 18 Jul 2012 16:58:11 +0900
Message-ID: <50066C93.1070006@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34978 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GRH6i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jul 2012 03:58:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I got a issue which makes i_size and EOFBLOCKS_FL corrupted
on ext4 with xfstests 269.
In my environment (linux-3.5-rc7), this can be reproduced
once of 10 times trial.

Kernel: 3.5-rc7
Arch: x86_64

Step and log are as bellow, after xfstests 269, e2fsck outputs
i_size and EOFBLOCKS_FL corruption.
Is this an already known issue?

# ./check 269
    FSTYP         -- ext4
    PLATFORM      -- Linux/x86_64 mcds1 3.5.0-rc7
    MKFS_OPTIONS  -- /dev/sdb3
    MOUNT_OPTIONS -- -o acl,user_xattr /dev/sdb3 /mnt/mp2

    269 97s ... [failed, exit status 1] - output mismatch (see 269.out.bad)
    --- 269.out	2012-07-02 10:51:34.000000000 +0900
    +++ 269.out.bad	2012-07-18 14:09:03.000000000 +0900
    @@ -3,3 +3,4 @@
     Run fsstress

     Run dd writers in parallel
    +_check_generic_filesystem: filesystem on /dev/sdb3 is inconsistent (see 269.full)
    Ran: 269
    Failures: 269
    Failed 1 of 1 tests


    # cat 269.full
      (snip)

    e2fsck 1.41.12 (17-May-2010)
    Pass 1: Checking inodes, blocks, and sizes
    Inode 2336, i_size is 625045, should be 1277952.  Fix? no

    Inode 3193 should not have EOFBLOCKS_FL set (size 1928717, lblk 218)
    Clear? no

    Inode 4198 should not have EOFBLOCKS_FL set (size 380389, lblk 73)
    Clear? no


Regards,
Akira Fujita
