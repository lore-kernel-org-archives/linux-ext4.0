From: Tony Lindgren <tony@atomide.com>
Subject: Regression in next with ext4 oops
Date: Mon, 3 Oct 2016 16:30:55 -0700
Message-ID: <20161003233054.eltv3coiweht3ui4@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:43650 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752783AbcJCXa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Oct 2016 19:30:59 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm seeing a repeatable oops with Linux next while running
update-initramfs, see below. I tried reverting commit 59aa5a3aeead
("fscrypto: make filename crypto functions return 0 on success")
as that's the only commit changing ext4_htree_store_dirent, but
that did not help.

Anybody else seeing something like this?

Regards,

Tony

8< --------------
Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = ee7e7280
[00000004] *pgd=00000000
Internal error: Oops: 205 [#1] SMP ARM
Modules linked in: ledtrig_default_on ledtrig_heartbeat hid_generic usbhid smsc95xx smsc]
CPU: 1 PID: 2299 Comm: mkinitramfs Not tainted 4.8.0-rc8-next-20160930+ #974
Hardware name: Generic OMAP5 (Flattened Device Tree)
task: ed0b8380 task.stack: ec216000
PC is at rb_insert_color+0x1c/0x1b8
LR is at ext4_htree_store_dirent+0xe0/0x104
pc : [<c0594930>]    lr : [<c042aa70>]    psr: 600e0013
sp : ec217db8  ip : ed177948  fp : c0a17618
r10: 00000001  r9 : ec217e08  r8 : ed177940
r7 : ec224b80  r6 : 2d7d188a  r5 : 83aa4108  r4 : 00000000
r3 : 00000000  r2 : ed389e88  r1 : ec224b80  r0 : ed177948
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 30c5387d  Table: ae7e7280  DAC: 55555555
Process mkinitramfs (pid: 2299, stack limit = 0xec216218)
Stack: (0xec217db8 to 0xec218000)
7da0:                                                       00000000 83aa4108
7dc0: 2d7d188a c042aa70 c0f1a628 ed80c040 ed80d6d0 ec217e60 c0f1a630 c0f1aff8
7de0: 00000001 c043ecc8 ec217e08 ed80c040 c0f1a000 00001000 00001628 00000000
7e00: 0000005c ebaf9c80 c0f1a630 0000000b ec224bc2 00000000 00000002 ed80d6d0
7e20: 00000000 ebaf9c80 00000000 ec217e60 ec217e70 c043fb8c 00000000 00000000
7e40: 00000006 024080c0 ec224ba0 ec216000 600e0013 c100253c c0f19014 00000002
7e60: 83aa4108 2d7d188a 00000004 ee7bb8b8 ed80c080 c0f19020 c0f19020 00000000
7e80: ec224b80 c028ac34 ab5552a8 ec224b80 ed80d800 ec217f70 ed80d6d0 ed80d770
7ea0: ebaf9c80 ed80d6d0 ee7b8000 c042a694 00000055 ed80d7a4 00000000 00000000
7ec0: 00000001 00000000 600e0013 c1093070 00000000 00000000 00000001 00000000
7ee0: 00000000 c03b49e8 00000000 00000000 00000000 600e0013 00000000 00020000
7f00: ed80d6d0 ed80d770 00000000 ed80d6d0 ec217f70 ed80d770 ec216000 ebaf9c80
7f20: 00000000 00000001 ec217f70 ed80d770 ec216000 00000000 7f5edef4 c03b4ae8
7f40: 7f60261c 7f602611 000000c5 7f617428 ebaf9c80 00008000 0000008d ebaf9c80
7f60: ec216000 00000000 7f5edef4 c03b4f80 c03b4b30 00000000 00000000 00000000
7f80: 7f617428 00000000 00008000 00000000 7f617408 7f60261c 7f617428 0000008d
7fa0: c02080c4 c0207f40 7f617408 7f60261c 00000003 7f617428 00008000 00000000
7fc0: 7f617408 7f60261c 7f617428 0000008d b6f98820 00000002 7f6004c8 7f5edef4
7fe0: 0000008d bed19808 b6edaf41 b6e836f6 600e0030 00000003 cf30eaa8 d31d966f
[<c0594930>] (rb_insert_color) from [<c042aa70>] (ext4_htree_store_dirent+0xe0/0x104)
[<c042aa70>] (ext4_htree_store_dirent) from [<c043ecc8>] (htree_dirblock_to_tree+0xb0/0x)
[<c043ecc8>] (htree_dirblock_to_tree) from [<c043fb8c>] (ext4_htree_fill_tree+0x1c8/0x2a)
[<c043fb8c>] (ext4_htree_fill_tree) from [<c042a694>] (ext4_readdir+0x62c/0x910)
[<c042a694>] (ext4_readdir) from [<c03b4ae8>] (iterate_dir+0x14c/0x194)
[<c03b4ae8>] (iterate_dir) from [<c03b4f80>] (SyS_getdents+0x7c/0x118)
[<c03b4f80>] (SyS_getdents) from [<c0207f40>] (ret_fast_syscall+0x0/0x1c)
Code: e5923000 e3130001 1a000062 e92d4070 (e593c004)
