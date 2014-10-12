From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 82201] ext4 crash in ext4_superblock_csum
Date: Sun, 12 Oct 2014 11:27:58 +0000
Message-ID: <bug-82201-13602-bKRdLnO9sf@https.bugzilla.kernel.org/>
References: <bug-82201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaJLL2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Oct 2014 07:28:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EA2DA2018E
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2014 11:28:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BEB3520131
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2014 11:27:58 +0000 (UTC)
In-Reply-To: <bug-82201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=82201

Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org

--- Comment #3 from Dmitry Monakhov <dmonakhov@openvz.org> ---
Same happen with me. I've tries to mount corrupted image and have got OOPS.
This is axboe's tree linux-block/2d5d786aa56

[18398.037383] EXT4-fs (ram0): mounted filesystem with ordered data mode. Opts:
(null)
[18541.898630] EXT4-fs (ram0): mounted filesystem with ordered data mode. Opts:
(null)
[57606.443588] EXT4-fs warning (device ram0): warn_no_space_for_csum:336: no
space in directory inode 2 leaf for checksum.  Please run e2fsck -D.
[57606.457943] EXT4-fs error (device ram0): ext4_readdir:182: inode #2: comm
ls: path /mnt: directory fails checksum at offset 0
[57606.470648] BUG: unable to handle kernel NULL pointer dereference at        
  (null)
[57606.479451] IP: [<ffffffff8121a3a6>] ext4_superblock_csum_set+0x26/0x80
[57606.486886] PGD 343b01067 PUD 2fd50a067 PMD 0 
[57606.491917] Oops: 0000 [#1] SMP 
[57606.495658] Modules linked in: null_blk brd iTCO_wdt lpc_ich mfd_core igb
ptp dm_mirror dm_region_hash dm_log dm_mod
[57606.507876] CPU: 3 PID: 9491 Comm: ls Not tainted
3.17.0-rc5-01296-g77ffecb-dirty #3
[57606.516731] Hardware name: Intel Corporation W2600CR/W2600CR, BIOS
SE5C600.86B.99.99.x028.061320111235 06/13/2011
[57606.528388] task: ffff8802fd494fc0 ti: ffff880338f40000 task.ti:
ffff880338f40000
[57606.536937] RIP: 0010:[<ffffffff8121a3a6>]  [<ffffffff8121a3a6>]
ext4_superblock_csum_set+0x26/0x80
[57606.547263] RSP: 0018:ffff880338f43c48  EFLAGS: 00010202
[57606.553298] RAX: 0000000000000000 RBX: ffff880351059400 RCX:
00000000000057e0
[57606.561369] RDX: 000000000009ffd5 RSI: 0000000000000156 RDI:
ffff88034384c800
[57606.569434] RBP: ffff880338f43c78 R08: ffffffff81af96f0 R09:
0000000000000000
[57606.577558] R10: 0000000000000002 R11: 0000000000000000 R12:
ffff88040b1c4e38
[57606.587045] R13: ffff880351059400 R14: 0000000000000001 R15:
0000000000020ae5
[57606.595119] FS:  00007f982e1b37a0(0000) GS:ffff88042c600000(0000)
knlGS:0000000000000000
[57606.604340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[57606.610857] CR2: 0000000000000000 CR3: 0000000338e5b000 CR4:
00000000000407e0
[57606.618938] Stack:
[57606.621271]  ffff880338f43c78 ffffffff812cd8ad ffff88034384c800
ffff88040b1c4e38
[57606.629772]  ffff880351059400 ffff88034384c800 ffff880338f43cc8
ffffffff8121a5bc
[57606.638314]  ffffffff816354a8 0000000000020ae5 ffff880338f43cc8
ffff88034384c800
[57606.646824] Call Trace:
[57606.649662]  [<ffffffff812cd8ad>] ? __percpu_counter_sum+0x6d/0x80
[57606.656660]  [<ffffffff8121a5bc>] ext4_commit_super+0x1bc/0x230
[57606.663371]  [<ffffffff8121aa63>] save_error_info+0x23/0x30
[57606.669691]  [<ffffffff8121b29f>] __ext4_error_file+0x17f/0x1a0
[57606.676405]  [<ffffffff81218c21>] ? __ext4_warning+0x91/0xb0
[57606.682840]  [<ffffffff811ff05e>] ext4_readdir+0x59e/0x820
[57606.689064]  [<ffffffff81190f7b>] iterate_dir+0x8b/0x140
[57606.695091]  [<ffffffff811911ac>] SyS_getdents+0x8c/0x100
[57606.701285]  [<ffffffff811912b0>] ? SyS_old_readdir+0x90/0x90
[57606.707815]  [<ffffffff815dbb12>] system_call_fastpath+0x16/0x1b
[57606.714618] Code: c4 08 5b c9 c3 55 48 89 e5 53 48 83 ec 28 66 66 66 66 90
48 8b 87 20 06 00 00 48 8b 58 68 f6 43 65 04 74 5a 48 8b 80 70 06 00 00 <83> 38
04 74 0d 0f 0b 0f 1f 00 eb fe 66 0f 1f 44 00 00 48 8d 7d 
[57606.736740] RIP  [<ffffffff8121a3a6>] ext4_superblock_csum_set+0x26/0x80
[57606.744338]  RSP <ffff880338f43c48>
[57606.748327] CR2: 0000000000000000
[57606.752701] ---[ end trace cf229272b9e9a4d1 ]---
[57614.547998] EXT4-fs (dm-4): recovery complete
[57614.569512] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts:
(null)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
