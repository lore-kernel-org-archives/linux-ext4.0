From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 0/4] ext4: cleanup and bugfixes for grow/shrink logic
Date: Tue, 20 Sep 2011 19:02:13 +0400
Message-ID: <87obyfz28a.fsf@dmbot.sw.ru>
References: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60869 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1ITPCD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 11:02:03 -0400
Received: by bkbzt4 with SMTP id zt4so547956bkb.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Sep 2011 08:02:02 -0700 (PDT)
In-Reply-To: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 20 Sep 2011 18:49:26 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Hi, finally have some time to run some tests on recent kernels.
> # Trivial fsstress test  
BTW current test but with fsstress with ext_ioc_{set/get}_flags support
(Message-Id: <1316357699-22692-2-git-send-email-dmonakhov@openvz.org>)
result in following oops almost immediately.
BUG happens due to delayed block appeared in journal checkpoint list
and was submitted to IO layer. Right i'm working on that issue.
------------[ cut here ]------------
kernel BUG at fs/buffer.c:2917!
invalid opcode: 0000 [#1] SMP 
CPU 1 
Modules linked in: ext4 quota_v2 quota_tree jbd2 iTCO_wdt
iTCO_vendor_support virtio_balloon shpchp virtio_pci virtio_ring virtio
[last unloaded: ext4]

Pid: 15935, comm: fsstress Not tainted 3.1.0-rc2+ #6 Parallels Software
International Inc. Parallels Virtual Platform/Parallels Virtual Platform
RIP: 0010:[<ffffffff81153daa>]  [<ffffffff81153daa>]
submit_bh+0x41/0x10d
RSP: 0018:ffff880009ce5c48  EFLAGS: 00010202
RAX: 000000000004c225 RBX: ffff880027029410 RCX: ffff880009ce5c68
RDX: 0000000000000000 RSI: ffff880027029410 RDI: 0000000000000111
RBP: ffff880009ce5c68 R08: ffff880009ce5ab8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000111
R13: 000000000000002c R14: ffff88002657a160 R15: ffff880009ce4000
FS:  00007f19f8aa4700(0000) GS:ffff88003c800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f19f8a82008 CR3: 00000000056d4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsstress (pid: 15935, threadinfo ffff880009ce4000, task
ffff88003ba82360)
Stack:
 ffff880009ce5c68 ffff880027029410 0000000000000111 000000000000002c
 ffff880009ce5c88 ffffffff811563fc ffff88002657a000 ffff880009ce5d44
 ffff880009ce5ce8 ffffffffa002ce0e 0000000091827364 ffff8800129469b0
Call Trace:
 [<ffffffff811563fc>] write_dirty_buffer+0x43/0x48
 [<ffffffffa002ce0e>] __flush_batch+0x3f/0x8a [jbd2]
 [<ffffffffa002d7b8>] jbd2_log_do_checkpoint+0x3ab/0x6ff [jbd2]
 [<ffffffffa00310a6>] jbd2_journal_flush+0x98/0x183 [jbd2]
 [<ffffffffa04811f5>] ext4_change_inode_journal_flag+0x53/0xf0 [ext4]
 [<ffffffffa0485855>] ext4_ioctl+0x309/0x80f [ext4]
 [<ffffffff811308f5>] ? cp_new_stat+0xf7/0x10d
 [<ffffffff8113b93c>] do_vfs_ioctl+0x473/0x4f8
 [<ffffffff8112d669>] ? fcheck_files+0x88/0xe1
 [<ffffffff8113ba17>] sys_ioctl+0x56/0x79
 [<ffffffff81444102>] system_call_fastpath+0x16/0x1b
Code: 89 fc 48 89 f3 a8 04 75 04 0f 0b eb fe 48 8b 06 a8 20 75 04 0f 0b
eb fe 48 83 7e 38 00 75 04 0f 0b eb fe 48 8b 06 f6 c4 02 74 04 <0f> 0b
eb fe 48 8b 06 f6 c4 10 74 04 0f 0b eb fe f0 0f ba 2e 03 
RIP  [<ffffffff81153daa>] submit_bh+0x41/0x10d
 RSP <ffff880009ce5c48>
---[ end trace 3ad6c82780724b7c ]---
