From: Lukas Czerner <lczerner@redhat.com>
Subject: kernel BUG at fs/jbd2/transaction.c:1086!
Date: Wed, 30 Mar 2011 17:32:06 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1103301651240.17917@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jack@suse.cz, tytso@mit.edu, Eric Sandeen <esandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab1C3PcQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Mar 2011 11:32:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have hit BUG_ON while running xfstest 234 in the loop
on the ext4. Backtrace below .

I thought that this problem was solved with
67eeb5685d2a211c0252ac7884142e503c759500 however it is still present.
I might be a bit hard to hit, but once you run

while true; do sync; sleep 0.3; done

concurrently it is reproducible almost all the time. I have tried to
understand what is going on but only thing I can see is this course
of action:

ext4_write_dquot
  ext4_journal_start <- h_buffer_credits = 2
  dquot_commit
    v2_write_dquot
      qtree_write_dquot
        ext4_quota_write
          ext4_handle_dirty_metadata	<- this takes one block reserved
	  				   for journal
					   h_buffer_credits--
    v2_write_file_info
      ext4_quota_write
        ext4_handle_dirty_metadata	<- this takes second block reserved
	  				   for journal
					   h_buffer_credits--
  ext4_journal_stop

However apparently I am missing something, because according to the
backtrace the second call of jbd2_journal_dirty_metadata() may end up
with BUG_ON -> J_ASSERT_JH(jh, handle->h_buffer_credits > 0);

So someone else is touching our handle apparently, but I go not exacly
know what is going on. From my simple debugging printk information I
have put with before ext4_handle_dirty_metadata() in ext4_quota_write()
we can see:

[  226.450263] ext4_quota_write: len 48, off 5136, type 0 h_ref 1
credits 2
[  226.458950] ext4_quota_write: len 24, off 8, type 0 h_ref 1 credits 0

It is clear someone changed handle between v2_write_dquot() and
v2_write_file_info() does anyone have idea what is going on ?


Trace:

[  226.465409] ------------[ cut here ]------------
[  226.470006] kernel BUG at fs/jbd2/transaction.c:1086!
[  226.475038] invalid opcode: 0000 [#1] SMP 
[  226.479134] last sysfs file:
/sys/devices/pci0000:00/0000:00:03.0/0000:03:00.0/0000:04:00.0/0000:05:0
[  226.494117] CPU 3 
[  226.495944] Modules linked in: sunrpc ipv6 joydev ghes bnx2 pcspkr
serio_raw hed dcdbas i7core_edac e
[  226.519637] 
[  226.521120] Pid: 2308, comm: setquota Not tainted 2.6.38+ #8 Dell
Inc. PowerEdge R810/05W7DG
[  226.529553] RIP: 0010:[<ffffffff811c68c2>]  [<ffffffff811c68c2>]
jbd2_journal_dirty_metadata+0x50/0xd
[  226.538843] RSP: 0018:ffff880659563b48  EFLAGS: 00010246
[  226.544133] RAX: 0000000000000000 RBX: ffff8808771eea80 RCX:
0000000000000000
[  226.551244] RDX: ffff8808771f5000 RSI: ffff8804772a0b60 RDI:
ffff8804772a0b60
[  226.558351] RBP: ffff880659563b78 R08: ffff8804772a0b60 R09:
ffff8808771eea80
[  226.565456] R10: ffff8804766e3d0c R11: ffff880800000000 R12:
ffff88066ff4c000
[  226.572562] R13: ffff8808771f5000 R14: ffff8804772a0b60 R15:
ffff88086f949400
[  226.579670] FS:  00007f4d2dc07720(0000) GS:ffff88087f800000(0000)
knlGS:0000000000000000
[  226.587728] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  226.593449] CR2: 00007f5d18512800 CR3: 00000004763a4000 CR4:
00000000000006e0
[  226.600554] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  226.607659] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  226.614766] Process setquota (pid: 2308, threadinfo ffff880659562000,
task ffff88067766ae00)
[  226.623169] Stack:
[  226.625169]  ffff880659563b68 0000000000000000 ffff8808771f5000
ffff8804772a0b60
[  226.632571]  0000000000001267 ffffffff8161f7f0 ffff880659563bc8
ffffffff811b35db
[  226.639973]  ffff880659563ba8 ffffffff810691ae ffff8804772a0b60
ffff8808771a0450
[  226.647377] Call Trace:
[  226.649818]  [<ffffffff811b35db>]
__ext4_handle_dirty_metadata+0xf1/0xfa
[  226.656498]  [<ffffffff810691ae>] ? wake_up_bit+0x25/0x2a
[  226.661884]  [<ffffffff811a7a9b>] ext4_quota_write+0x18d/0x20b
[  226.667700]  [<ffffffff811638d6>] ? qtree_write_dquot+0x114/0x126
[  226.673771]  [<ffffffff811623f9>] v2_write_file_info+0xa7/0xd6
[  226.679581]  [<ffffffff8115f246>] dquot_commit+0xb7/0xcf
[  226.684871]  [<ffffffff811a90d4>] ext4_write_dquot+0x61/0x83
[  226.690510]  [<ffffffff8115fe59>] dqput+0xb5/0x161
[  226.695282]  [<ffffffff81160d2f>] dquot_set_dqblk+0x302/0x312
[  226.701022]  [<ffffffff81163c21>] quota_setquota+0x131/0x153
[  226.706660]  [<ffffffff811eab8f>] ? avc_has_perm+0x5c/0x6e
[  226.712125]  [<ffffffff81164040>] do_quotactl+0x36b/0x47c
[  226.717509]  [<ffffffff8103cc69>] ? need_resched+0x23/0x2d
[  226.722989]  [<ffffffff8103cc81>] ? should_resched+0xe/0x2e
[  226.728545]  [<ffffffff81474bb3>] ? _cond_resched+0xe/0x22
[  226.734013]  [<ffffffff8112f3a0>] ? iput+0x36/0x138
[  226.738870]  [<ffffffff81164279>] sys_quotactl+0x128/0x15b
[  226.744339]  [<ffffffff8147c842>] system_call_fastpath+0x16/0x1b
[  226.750320] Code: eb ff ff 85 c0 4d 8b 27 0f 85 94 00 00 00 4c 89 f7
e8 97 eb ff ff 83 7b 10 00 75 18
[  226.769914] RIP  [<ffffffff811c68c2>]
jbd2_journal_dirty_metadata+0x50/0xd6
[  226.776901]  RSP <ffff880659563b48>
[  226.780402] ---[ end trace 6d2d535a183db323 ]---



