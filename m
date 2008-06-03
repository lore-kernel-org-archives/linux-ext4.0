From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ftest01:16876 blocked for more than 120 seconds
Date: Wed, 4 Jun 2008 00:00:06 +0400
Message-ID: <20080603200006.GA9823@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:28588 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYFCUG5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 16:06:57 -0400
Received: by nf-out-0910.google.com with SMTP id d3so662783nfc.21
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jun 2008 13:04:14 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This happened during LTP run together with mass-compiling kernels.
Kernel is 2.6.26-rc4-1beee8dc8cf58e3f605bd7b34d7a39939be7d8d2
fs is ext3 mounted with noatime.


INFO: task ftest01:16876 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ftest01       D 0000000000000000     0 16876  16863
 ffff810066fd3d68 0000000000000046 ffff810066fd3d08 ffffffff80254aae
 ffff81005e7ab3c0 ffff810075530000 ffff81005e7ab600 0000000000000002
 ffff810066fd3d28 ffffffff80254c55 ffff81000c043440 0000000000000282
Call Trace:
 [<ffffffff80254aae>] ? mark_held_locks+0x3e/0x80
 [<ffffffff80254c55>] ? trace_hardirqs_on+0xd5/0x160
 [<ffffffff80460722>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff802a54a9>] inode_wait+0x9/0x10
 [<ffffffff8045dfd5>] __wait_on_bit+0x55/0x80
 [<ffffffff802a54a0>] ? inode_wait+0x0/0x10
 [<ffffffff802b164a>] __writeback_single_inode+0x21a/0x320
 [<ffffffff80247860>] ? wake_bit_function+0x0/0x30
 [<ffffffff802b1bff>] sync_sb_inodes+0x1df/0x2d0
 [<ffffffff802b1d8f>] sync_inodes_sb+0x9f/0xc0
 [<ffffffff802b1e3a>] __sync_inodes+0x8a/0xe0
 [<ffffffff802b1ebe>] sync_inodes+0x2e/0x40
 [<ffffffff802b4f54>] do_sync+0x34/0x70
 [<ffffffff802b4f9e>] sys_sync+0xe/0x20
 [<ffffffff8020b68b>] system_call_after_swapgs+0x7b/0x80

1 lock held by ftest01/16876:
 #0:  (&type->s_umount_key#3){----}, at: [<ffffffff802b1e28>] __sync_inodes+0x78/0xe0

