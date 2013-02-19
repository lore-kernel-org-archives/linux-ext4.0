From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [BUG] xfstests #68 with data=journal hang against 3.8-rc7 and
 'dev' branch
Date: Tue, 19 Feb 2013 14:57:53 -0500
Message-ID: <20130219195753.GA14724@wallace>
References: <20130217172208.GB4059@gmail.com>
 <20130218050422.GD10361@thunk.org>
 <20130218173326.GB3056@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:37643 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933880Ab3BST57 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2013 14:57:59 -0500
Received: by mail-vb0-f54.google.com with SMTP id l1so4528575vba.27
        for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2013 11:57:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130218173326.GB3056@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Zheng Liu <gnehzuil.liu@gmail.com>:
> On Mon, Feb 18, 2013 at 12:04:22AM -0500, Theodore Ts'o wrote:
> > On Mon, Feb 18, 2013 at 01:22:08AM +0800, Zheng Liu wrote:
> > > Hi all,
> > > 
> > > Xfstests #68 will hang with data=journal in 3.8-rc7 and 'dev' branch. I
> > > remember that there has a patch for ext4 to fix filesystem freeze bug
> > > but I am not sure whether it can fix this bug and it has been applied
> > > into 'dev' branch.  So I file this bug here.
> > 
> > Hmm.... I have never seen this test fail with my tests (although I'm
> > just using the dev branch; I have not tried merging in 3.8-rc7 into
> > the dev branch for any of my tests).
> > 
> > Is it failing for you reliably?
> 
> I dig this bug again and I always reproduce it in my own machine with
> SSD disk in 3.8-rc7 and dev branch.  But, interestingly, I run the same
> test case in another machine, which is the same as previous one except
> that it only has a HDD, and I never trigger this bug.  So it seems that
> this bug could be triggered in a high-speed device, but we need to
> verify this conclusion.  Sorry I haven't another server with SSD/Flash
> device to run test case.  That would be great if others could give it a
> try.
> 
> Thanks,
>                                                 - Zheng


I saw a similar hang (stall) of 068 on ARM in one of two runs I made
with the xfstests auto group on 3.8-rc7.

The test system was a Pandaboard using a USB-attached SATA disk.  I've not yet
seen it on x86-64 using a virtual disk.

I've made three sets of xfstest 068 runs on a fresh 3.8 kernel on the same
system to get a sense of repeatability, terminating each set at the first 
occurrence of a hang.  The hang occurred at the eighth run in the first set,
second run in the second set, and third run in the third set.  So, it's
possible to see the problem reasonably easily on a slow test system.

Example trace follows.

Regards,
Eric


FSTYP         -- ext4
PLATFORM      -- Linux/armv7l panda 3.8.0
MKFS_OPTIONS  -- -q /dev/sda2
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/sda2 /vdc

068 88s ...	[13:58:56]

<test stalls>

kernel: [  742.672546] kernel BUG at fs/jbd2/transaction.c:1986!
kernel: [  742.677856] Internal error: Oops - BUG: 0 [#1] SMP ARM
kernel: [  742.683227] Modules linked in:
kernel: [  742.686431] CPU: 0    Tainted: G        W     (3.8.0 #1)
kernel: [  742.692016] PC is at jbd2_journal_invalidatepage+0x370/0x38c
kernel: [  742.697967] LR is at jbd2_journal_invalidatepage+0x1c0/0x38c
kernel: [  742.703887] pc : [<c01ffb68>]    lr : [<c01ff9b8>]    psr: 00000113
kernel: [  742.703887] sp : e8399ba8  ip : 00000000  fp : e8399bec
kernel: [  742.715942] r10: eca09788  r9 : 00080000  r8 : eca09788
kernel: [  742.721405] r7 : 00000000  r6 : 00000000  r5 : eca09788  r4 : 00001000
kernel: [  742.728240] r3 : 00000002  r2 : 001c4025  r1 : eca09788  r0 : 00000000
kernel: [  742.735076] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
kernel: [  742.742584] Control: 10c5387d  Table: a21b404a  DAC: 00000015
kernel: [  742.748596] Process fstest (pid: 3909, stack limit = 0xe8398240)
kernel: [  742.754882] Stack: (0xe8399ba8 to 0xe839a000)
kernel: [  742.759460] 9ba0:                   e8399bd4 eca63488 c1f39040 e30cc328 e30cc000 00000001
kernel: [  742.768035] 9bc0: 00000000 c1f39040 00000000 c1f39040 e30cc000 e41b123c 000000df 00000000
kernel: [  742.776611] 9be0: e8399c0c e8399bf0 c01ad7f0 c01ff804 c1f39040 e41b123c 0000000d c1f39040
kernel: [  742.785186] 9c00: e8399c1c e8399c10 c01aed44 c01ad7a4 e8399c44 e8399c20 c00e5cd8 c01aed38
kernel: [  742.793762] 9c20: e8399c44 e8399c30 c00d8a84 c005c3cc ffffffff e8399c58 e8399cc4 e8399c48
kernel: [  742.802337] 9c40: c00e5dfc c00e5c2c e41b127c e41b1280 00000000 00000000 0000000e 00000000
kernel: [  742.810913] 9c60: c1f60460 c1f60440 c1f60420 c1f60400 c1f297e0 c1f297c0 c1f297a0 c1f29780
kernel: [  742.819458] 9c80: c1f29760 c1f29740 c1f390a0 c1f39080 c1f39060 c1f39040 c05a5108 ffffffff
kernel: [  742.828033] 9ca0: ffffffff 00000000 00000000 00000001 00000000 e41b123c e8399ce4 e8399cc8
kernel: [  742.836608] 9cc0: c00e6118 c00e5cec ffffffff ffffffff 00000000 00000000 e8399d1c e8399ce8
kernel: [  742.845184] 9ce0: c00e6190 c00e60fc 00000000 00000000 00000001 00000000 c1f4b440 e30cc014
kernel: [  742.853759] 9d00: e41b1118 e8399db0 00000000 0000a068 e8399d6c e8399d20 c01b2e54 c00e612c
kernel: [  742.862335] 9d20: 00000000 00000000 00100000 00000000 e8399db0 00000000 00000001 e30cc000
kernel: [  742.870910] 9d40: c003f0b8 00000000 00000001 ecadd660 0000a068 e8399db0 000081a4 e41b1118
kernel: [  742.879486] 9d60: e8399dac e8399d70 c0131c50 c01b2a64 22222222 22222222 5123cb94 22c98098
kernel: [  742.888031] 9d80: e41b1118 ecadd660 00000001 e41b1230 e41b1118 e8399e98 00000026 e8399f60
kernel: [  742.896606] 9da0: e8399dfc e8399db0 c0115dbc c0131a74 0000a068 c00e3a64 ee29eb40 e8399e94
kernel: [  742.905181] 9dc0: 00000000 00000000 5123cb94 22c98098 5123cb94 22c98098 5123cb94 22c98098
kernel: [  742.913757] 9de0: ecc279c0 c0115814 e8399ee0 00000001 e8399e74 e8399e00 c01254f0 c0115d44
kernel: [  742.922332] 9e00: 00008060 ecc279c0 c00653b0 e8399ee0 00000051 e440a010 00000001 ec96b118
kernel: [  742.930908] 9e20: 00000000 ecadd660 00000001 00000000 ecadd078 ecc279c0 00cfb4c9 e41b1118
kernel: [  742.939483] 9e40: ee1260d0 ecadd078 00000020 ecc279c0 e8399ee0 e8399f60 e8399e98 e8398000
kernel: [  742.948059] 9e60: 00000000 00000000 e8399ed4 e8399e78 c0125b34 c0124eb4 e8399e94 00000000
kernel: [  742.956634] 9e80: 60000113 e8398000 e8399ee4 e8399e98 00000000 00000002 ee1260d0 ecadd660
kernel: [  742.965179] 9ea0: 00000000 c01335ec 00000000 e8399f60 00000001 e440a000 ffffff9c 00000001
kernel: [  742.973754] 9ec0: e8398000 00000000 e8399f54 e8399ed8 c0126244 c0125a88 00000041 02320231
kernel: [  742.982330] 9ee0: ee1260d0 ecadd660 90cfb4c9 00000005 e440a02c c02e3690 00000000 ed5cd7b0
kernel: [  742.990905] 9f00: e41b1118 00000301 00000004 00000000 00000000 00020242 00000300 00020242
kernel: [  742.999481] 9f20: e440a000 000120a4 ffffff9c 00000001 e8398000 00000000 00020242 e440a000
kernel: [  743.008056] 9f40: 00000003 ffffff9c e8399f94 e8399f58 c0116da8 c0126214 e8399f84 e8399f68
kernel: [  743.016632] 9f60: 00020242 c00881a4 00000026 00000300 bec54b14 000120a4 000120a4 00000005
kernel: [  743.025207] 9f80: c000e628 00000000 e8399fa4 e8399f98 c0116e60 c0116cc0 00000000 e8399fa8
kernel: [  743.033752] 9fa0: c000e3c0 c0116e40 bec54b14 000120a4 bec54b14 00020242 000001a4 00000000
kernel: [  743.042327] 9fc0: bec54b14 000120a4 000120a4 00000005 00000003 00000017 b6d0f000 00000001
kernel: [  743.050903] 9fe0: 00000005 bec54698 b6e95b5d b6e261e6 20000130 bec54b14 00000000 00000000
kernel: [  743.059509] [<c01ffb68>] (jbd2_journal_invalidatepage+0x370/0x38c) from [<c01ad7f0>] (__ext4_journalled_invalidatepage+0x58/0xa0)
kernel: [  743.071716] [<c01ad7f0>] (__ext4_journalled_invalidatepage+0x58/0xa0) from [<c01aed44>] (ext4_journalled_invalidatepage+0x18/0x34)
kernel: [  743.084045] [<c01aed44>] (ext4_journalled_invalidatepage+0x18/0x34) from [<c00e5cd8>] (truncate_inode_page+0xb8/0xc0)
kernel: [  743.095153] [<c00e5cd8>] (truncate_inode_page+0xb8/0xc0) from [<c00e5dfc>] (truncate_inode_pages_range+0x11c/0x35c)
kernel: [  743.106109] [<c00e5dfc>] (truncate_inode_pages_range+0x11c/0x35c) from [<c00e6118>] (truncate_inode_pages+0x28/0x30)
kernel: [  743.117126] [<c00e6118>] (truncate_inode_pages+0x28/0x30) from [<c00e6190>] (truncate_pagecache+0x70/0x90)
kernel: [  743.127258] [<c00e6190>] (truncate_pagecache+0x70/0x90) from [<c01b2e54>] (ext4_setattr+0x3fc/0x67c)
kernel: [  743.136840] [<c01b2e54>] (ext4_setattr+0x3fc/0x67c) from [<c0131c50>] (notify_change+0x1e8/0x334)
kernel: [  743.146148] [<c0131c50>] (notify_change+0x1e8/0x334) from [<c0115dbc>] (do_truncate+0x84/0xa8)
kernel: [  743.155181] [<c0115dbc>] (do_truncate+0x84/0xa8) from [<c01254f0>] (do_last.isra.28+0x648/0xbd4)
kernel: [  743.164367] [<c01254f0>] (do_last.isra.28+0x648/0xbd4) from [<c0125b34>] (path_openat+0xb8/0x49c)
kernel: [  743.173675] [<c0125b34>] (path_openat+0xb8/0x49c) from [<c0126244>] (do_filp_open+0x3c/0x90)
kernel: [  743.182525] [<c0126244>] (do_filp_open+0x3c/0x90) from [<c0116da8>] (do_sys_open+0xf4/0x180)
kernel: [  743.191375] [<c0116da8>] (do_sys_open+0xf4/0x180) from [<c0116e60>] (sys_open+0x2c/0x30)
kernel: [  743.199890] [<c0116e60>] (sys_open+0x2c/0x30) from [<c000e3c0>] (ret_fast_syscall+0x0/0x3c)
kernel: [  743.208648] Code: e3a07001 eaffff74 e7f001f2 e7f001f2 (e7f001f2) 
kernel: [  743.250122] ---[ end trace 3cd8ea773e9935b2 ]---
