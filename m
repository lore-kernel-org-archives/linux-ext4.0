From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 3.5.1 kernel: Oops + stracktrace + ext4 kernel errors!
Date: Fri, 24 Aug 2012 11:31:44 -0400
Message-ID: <CAO9zADxVjZ7y-wGqV2n89yov_z=XT6zxhHQW4Yp+whe0RO5tuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, al piszcz <ap@solarrain.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48670 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2HXPbp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Aug 2012 11:31:45 -0400
Received: by obbuo13 with SMTP id uo13so4430758obb.19
        for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 08:31:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Thoughts?

Saw this when trying to copy files to array with Samba and doing file
operations:

[28939.505792] ------------[ cut here ]------------
[28939.505818] WARNING: at include/linux/iocontext.h:140
copy_process.part.50+0x115e/0x1220()
[28939.505826] Hardware name: X8DTH-i/6/iF/6F
[28939.505833] Pid: 16976, comm: dump Not tainted 3.5.1+ #3
[28939.505838] Call Trace:
[28939.505847]  [<ffffffff8102f355>] warn_slowpath_common+0x75/0xb0
[28939.505855]  [<ffffffff8102f465>] warn_slowpath_null+0x15/0x20
[28939.505862]  [<ffffffff8102e67e>] copy_process.part.50+0x115e/0x1220
[28939.505869]  [<ffffffff8102e8ab>] do_fork+0x13b/0x2f0
[28939.505880]  [<ffffffff8103ceb2>] ? recalc_sigpending+0x12/0x30
[28939.505888]  [<ffffffff8103f75a>] ? __set_current_blocked+0x3a/0x60
[28939.505898]  [<ffffffff8100a263>] sys_clone+0x23/0x30
[28939.505908]  [<ffffffff816bebf3>] stub_clone+0x13/0x20
[28939.505916]  [<ffffffff816be9a6>] ? system_call_fastpath+0x1a/0x1f
[28939.505922] ---[ end trace bb4eebc57a10f73a ]---

[29113.279716] 3w-sas: scsi0: AEN: INFO (0x04:0x0029): Verify started:unit=0.
[29367.345433] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000028
[29367.345455] IP: [<ffffffff8116539c>] ext4_ext_remove_space+0x89c/0xc90
[29367.345471] PGD c1ef31067 PUD aa4435067 PMD 0
[29367.345485] Oops: 0000 [#1] SMP
[29367.345495] CPU 4
[29367.345503] Pid: 16922, comm: rsync Tainted: G        W    3.5.1+
#3 Supermicro X8DTH-i/6/iF/6F/X8DTH
[29367.345520] RIP: 0010:[<ffffffff8116539c>]  [<ffffffff8116539c>]
ext4_ext_remove_space+0x89c/0xc90
[29367.345534] RSP: 0018:ffff880a7db79c98  EFLAGS: 00010246
[29367.345542] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 00000003c06c3600
[29367.345550] RDX: 0000000000000001 RSI: 00000001f4b88bf3 RDI: 0000000000000002
[29367.345558] RBP: ffff880a7db79d88 R08: 00000000c06c3600 R09: ffff8806245245c0
[29367.345566] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[29367.345574] R13: ffff8806245245f0 R14: ffff88029948b0cc R15: ffff8800b53596f0
[29367.345582] FS:  00007f8b5c30e700(0000) GS:ffff88063fc80000(0000)
knlGS:0000000000000000
[29367.345593] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[29367.345598] CR2: 0000000000000028 CR3: 0000000b59a6c000 CR4: 00000000000007e0
[29367.345604] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[29367.345609] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[29367.345615] Process rsync (pid: 16922, threadinfo ffff880a7db78000,
task ffff8800bb318cf0)
[29367.345621] Stack:
[29367.345624]  ffff880a7db79cd8 ffffffff8116821b ffff880a7db79ce8
ffff8800b53596f0
[29367.345638]  ffff8808840eb600 ffff880a7db79d40 ffff88062554a000
ffff8800fffffff5
[29367.345651]  ffff880a7db79d28 ffff8800b5359660 ffff88062554a000
ffff880624524620
[29367.345664] Call Trace:
[29367.345671]  [<ffffffff8116821b>] ? __ext4_handle_dirty_metadata+0x7b/0x100
[29367.345678]  [<ffffffff81167313>] ext4_ext_truncate+0x173/0x1b0
[29367.345685]  [<ffffffff8114e696>] ? ext4_mark_inode_dirty+0x66/0x170
[29367.345693]  [<ffffffff8114bd3d>] ext4_truncate+0x5d/0x70
[29367.345699]  [<ffffffff81150658>] ext4_evict_inode+0x378/0x3d0
[29367.345707]  [<ffffffff810dadea>] evict+0xaa/0x1a0
[29367.345713]  [<ffffffff810dba13>] iput+0x103/0x210
[29367.345720]  [<ffffffff810d1794>] do_unlinkat+0x154/0x1c0
[29367.345729]  [<ffffffff810c3a28>] ? vfs_write+0x118/0x160
[29367.345739]  [<ffffffff810c3b55>] ? sys_write+0x45/0xa0
[29367.345745]  [<ffffffff810d1851>] sys_unlink+0x11/0x20
[29367.345753]  [<ffffffff816be9a6>] system_call_fastpath+0x1a/0x1f
[29367.345759] Code: 8b 4d 20 0f b7 41 02 48 8d 04 40 48 8d 04 81 49
89 45 18 0f b7 49 02 48 83 c1 01 49 89 4d 00 e9 c5 f8 ff ff 0f 1f 00
49 8b 45 28 <48> 8b 40 28 49 89 45 20 e9 9c f8 ff ff 0f 1f 80 00 00 00
00 41
[29367.345874] RIP  [<ffffffff8116539c>] ext4_ext_remove_space+0x89c/0xc90
[29367.345881]  RSP <ffff880a7db79c98>
[29367.345885] CR2: 0000000000000028
[29367.345890] ---[ end trace bb4eebc57a10f73b ]---
[35775.632435] 3w-sas: scsi0: AEN: INFO (0x04:0x002B): Verify completed:unit=0.
[39395.965177] 3w-sas: scsi0: AEN: INFO (0x04:0x0091): Unit now in
standby mode:unit=0.
[50143.132858] 3w-sas: scsi0: AEN: INFO (0x04:0x0090): Unit now in
active mode:unit=0.

Justin.
