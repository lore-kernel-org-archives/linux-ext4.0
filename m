From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Subject: Oops fs/ext4/inode.c:2188
Date: Sun, 05 Jun 2011 20:57:56 +0200
Message-ID: <4DEBD1B4.3000307@odi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fep22.mx.upcmail.net ([62.179.121.42]:46636 "EHLO
	fep22.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab1FES7N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jun 2011 14:59:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jun  5 20:34:11 box kernel: ------------[ cut here ]------------
Jun  5 20:34:11 box kernel: kernel BUG at fs/ext4/inode.c:2188!
Jun  5 20:34:11 box kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Jun  5 20:34:11 box kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.
0/host7/target7:0:0/7:0:0:0/block/sdc/dev
Jun  5 20:34:11 box kernel: Modules linked in:
Jun  5 20:34:11 box kernel:
Jun  5 20:34:11 box kernel: Pid: 13696, comm: flush-8:32 Not tainted
2.6.38.7 #2 To Be Filled By
O.E.M. To Be Filled By O.E.M./P4P800
Jun  5 20:34:12 box kernel: EIP: 0060:[<c1106622>] EFLAGS: 00010246 CPU: 1
Jun  5 20:34:12 box kernel: EIP is at mpage_da_map_and_submit+0x56c/0x5ba
Jun  5 20:34:12 box kernel: EAX: 40000024 EBX: dfe17e00 ECX: 0000000e
EDX: 00000000
Jun  5 20:34:12 box kernel: ESI: 001b4800 EDI: 001b4fff EBP: c1dafd4c
ESP: c1dafcb0
Jun  5 20:34:12 box kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jun  5 20:34:12 box kernel: Process flush-8:32 (pid: 13696, ti=c1dae000
task=df2a0f40 task.ti=c1d
ae000)
Jun  5 20:34:12 box kernel: Stack:
Jun  5 20:34:12 box kernel: 0000000e c14898ca c1494b28 00000015 001b4800
00000000 00000800 ffffff
fb
Jun  5 20:34:12 box kernel: 0000000c 00000000 001b500a 00000000 dedfe390
0000000e 00000000 000000
0e
Jun  5 20:34:12 box kernel: 00000004 dfe17e00 dfcd8220 dfdbe980 dfd0bc40
dfbed540 dfca32e0 dfe94c
c0
Jun  5 20:34:12 box kernel: Call Trace:
Jun  5 20:34:12 box kernel: [<c11066c0>] mpage_add_bh_to_extent+0x50/0xdd
Jun  5 20:34:12 box kernel: [<c110696c>] write_cache_pages_da+0x21f/0x312
Jun  5 20:34:12 box kernel: [<c1106c97>] ext4_da_writepages+0x238/0x45f
Jun  5 20:34:12 box kernel: [<c1070335>] do_writepages+0x17/0x2d
Jun  5 20:34:12 box kernel: [<c10afa73>] writeback_single_inode+0x78/0x1b1
Jun  5 20:34:12 box kernel: [<c10aff7d>] writeback_sb_inodes+0x86/0x118
Jun  5 20:34:12 box kernel: [<c10b0691>] wb_writeback+0x162/0x235
Jun  5 20:34:12 box kernel: [<c107057e>] ? global_dirty_limits+0x23/0xb9
Jun  5 20:34:12 box kernel: [<c10b07c9>] wb_do_writeback+0x65/0x191
Jun  5 20:34:12 box kernel: [<c10b0958>] bdi_writeback_thread+0x63/0x10b
Jun  5 20:34:12 box kernel: [<c10b08f5>] ? bdi_writeback_thread+0x0/0x10b
Jun  5 20:34:12 box kernel: [<c10406a0>] kthread+0x68/0x6a
Jun  5 20:34:12 box kernel: [<c1040638>] ? kthread+0x0/0x6a
Jun  5 20:34:12 box kernel: [<c1002fb6>] kernel_thread_helper+0x6/0x10
Jun  5 20:34:12 box kernel: Code: 24 04 c7 04 24 80 a0 48 c1 e8 f2 42 2d
00 8b 86 08 02 00 00 89 44 24 04 c7 04 24 9e a0 48 c1 e8 dc 42 2d 00 8b
03 e9 64 fd ff ff <0f> 0b eb fe 0f 0b eb fe 89 f0 e8 98 44 ff ff 09 c2
75 07 8b 03
Jun  5 20:34:12 box kernel: EIP: [<c1106622>]
mpage_da_map_and_submit+0x56c/0x5ba SS:ESP 0068:c1dafcb0
Jun  5 20:34:12 box kernel: JBD2: Detected IO errors while flushing file
data on sdc1-8
Jun  5 20:34:12 box kernel: Aborting journal on device sdc1-8.
Jun  5 20:34:12 box kernel: JBD2: I/O error detected when updating
journal superblock for sdc1-8.
Jun  5 20:34:12 box kernel: ---[ end trace 736424b87d636c31 ]---
