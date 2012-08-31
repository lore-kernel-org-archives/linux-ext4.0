From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Fri, 31 Aug 2012 09:23:44 +0000 (UTC)
Message-ID: <20120831092344.8855F11FB39@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51200 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2HaJXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2012 05:23:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 21705202D7
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2012 09:23:47 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 8E8C0202E4
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2012 09:23:45 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #14 from Jan Kara <jack@suse.cz>  2012-08-31 09:23:44 ---
The culprit of your hang now is:
------------[ cut here ]------------
kernel BUG at /build/buildd/linux-3.2.0/fs/jbd2/transaction.c:1093!
 invalid opcode: 0000 [#1] SMP 
 CPU 0 
 Modules linked in: binfmt_misc vesafb dcdbas ses enclosure mac_hid lp parport
bnx2 megaraid_sas

 Pid: 20387, comm: pifs4/eio Not tainted 3.2.0-23-generic #36-Ubuntu Dell Inc.
PowerEdge R210 II/09T7VV
 RIP: 0010:[<ffffffff8125f27c>]  [<ffffffff8125f27c>]
jbd2_journal_dirty_metadata+0x1ec/0x230
 RSP: 0018:ffff880102c29ae8  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff88022e128f00 RCX: ffff8801444048e0
 RDX: ffff88022312ce58 RSI: 0000000000000000 RDI: ffff88022312ce58
 RBP: ffff880102c29b38 R08: ffff880192ce9138 R09: 7010000000000000
 R10: fe4f31d37b9c4e02 R11: 0000000000000000 R12: ffff880192ce9138
 R13: ffff88014575ff50 R14: ffff88022fbae000 R15: ffff88022312ce58
 FS:  00007ffc9fe65700(0000) GS:ffff88023fc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007f702b43a04c CR3: 00000002304b0000 CR4: 00000000000406f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process pifs4/eio (pid: 20387, threadinfo ffff880102c28000, task
ffff88010065ade0)
 Stack:
  ffff88022312ce58 ffff88014575ff50 ffff880102c29b48 ffffffff8125f9e8
  ffff880102c29b28 ffff8801444048e0 000000000000038a ffffffff8182bb37
  ffff88022312ce58 ffff88022312ce58 ffff880102c29b88 ffffffff81241bcb
 Call Trace:
  [<ffffffff8125f9e8>] ? jbd2_journal_get_create_access+0xd8/0x170
  [<ffffffff81241bcb>] __ext4_handle_dirty_metadata+0x8b/0x130
  [<ffffffff8123d3f2>] ext4_ext_split+0x2f2/0x710
  [<ffffffff8123e104>] ? ext4_ext_find_extent+0x134/0x3a0
  [<ffffffff8123e4a4>] ext4_ext_create_new_leaf+0x134/0x180
  [<ffffffff8123eb47>] ext4_ext_insert_extent+0xc7/0x440
  [<ffffffff8123bffc>] ? ext4_ext_check_overlap.isra.20+0xbc/0xd0
  [<ffffffff8124036c>] ext4_ext_map_blocks+0x58c/0xe70
  [<ffffffff8125dd8a>] ? start_this_handle.isra.9+0x37a/0x3e0
  [<ffffffff81215e45>] ext4_map_blocks+0x1b5/0x280
  [<ffffffff81240fb2>] ext4_fallocate+0x192/0x3e0
  [<ffffffff81176602>] do_fallocate+0xf2/0x160
  [<ffffffff811766bb>] sys_fallocate+0x4b/0x70
  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
 Code: 08 49 8b 54 24 18 49 8d b6 58 03 00 00 89 04 24 49 89 d9 48 c7 c7 c0 0b
a2 81 31 c0 e8 c4 4e 3e 00 b8 ea ff ff ff e9 d2 fe ff ff <0f> 0b 4d 85 c9 74 04
41 8b 41 08 45 31 c0 48 85 c9 74 04 44 8b 
  RIP  [<ffffffff8125f27c>] jbd2_journal_dirty_metadata+0x1ec/0x230
  RSP <ffff880102c29ae8>
---
  Which means that we reserved too few credits for the transaction allocating
blocks from fallocate. I was looking into the code and the math in
ext4_chunk_trans_blocks() looks sound. But I don't know all the details of
extent code. Maybe other ext4 guys will see the problem quicker than me...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
