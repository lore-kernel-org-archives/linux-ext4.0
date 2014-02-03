From: Jon Bernard <jbernard@tuxion.com>
Subject: kernel bug at fs/ext4/resize.c:409
Date: Mon, 3 Feb 2014 13:26:34 -0500
Message-ID: <20140203182634.GA28811@shaniqua>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46705 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbaBCS0g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Feb 2014 13:26:36 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 8073C209FE
	for <linux-ext4@vger.kernel.org>; Mon,  3 Feb 2014 13:26:35 -0500 (EST)
Received: from localhost (unknown [216.252.204.85])
	by mail.messagingengine.com (Postfix) with ESMTPA id 45786680219
	for <linux-ext4@vger.kernel.org>; Mon,  3 Feb 2014 13:26:35 -0500 (EST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

A coworker is seeing the following bug when attempting to resize a root
volume (during init by calling resizefs) from 1GB to the size of the
underlying partition size of 20GB.

If the partition size is changed (to i.e. 10GB), the bug seems to not
trigger.  I have access to this machine, if there are any experiments
that would provide more useful information - please let me know.

    [  112.136896] ext4-fs (sda1): resizing filesystem from 1080688 to 5243214 blocs
    [  112.164072] ------------[ cut here ]------------
    [  112.164179] kernel bug at fs/ext4/resize.c:409!
    [  112.164285] invalid opcode: 0000 [#1] smp 
    [  112.164488] modules linked in: openvswitch vxlan ip_tunnel gre libcrc32c noui
    [  112.165042] cpu: 0 pid: 968 comm: resize2fs tainted: g          i  3.12.9-301
    [  112.165042] hardware name: dell inc. optiplex 760                 /0m858n, b9
    [  112.165042] task: ffff8800b7969080 ti: ffff8800b74f4000 task.ti: ffff8800b740
    [  112.165042] rip: 0010:[<ffffffff81254fa1>]  [<ffffffff81254fa1>] set_flexbg_0
    [  112.165042] rsp: 0018:ffff8800b74f5c28  eflags: 00010216
    [  112.165042] rax: ffff8800b743bf00 rbx: ffff88007fae9000 rcx: 0000000000001000
    [  112.165042] rdx: ffff88007f4e2c00 rsi: 0000000000000001 rdi: 0000000000000010
    [  112.165042] rbp: ffff8800b74f5c70 r08: ffff8800afd27750 r09: ffff8800b7daee00
    [  112.165042] r10: 0000000000000000 r11: ffff8800afd27750 r12: 0000000000188000
    [  112.165042] r13: 0000000000000010 r14: 0000000000188000 r15: ffff8800b743b800
    [  112.165042] fs:  00007f858a7f4780(0000) gs:ffff8800be800000(0000) knlgs:00000
    [  112.165042] cs:  0010 ds: 0000 es: 0000 cr0: 000000008005003b
    [  112.165042] cr2: 00007f8589c1eea6 cr3: 00000000b7979000 cr4: 00000000000407f0
    [  112.165042] stack:
    [  112.165042]  ffff8800afd27750 ffff8800b96cb060 ffff880000188000 000000108125b
    [  112.165042]  0000000000000010 ffff88007f4e2ed0 00000000000007ff ffff8800b7430
    [  112.165042]  ffff8800b743b800 ffff8800b74f5d68 ffffffff81256768 0000000000180
    [  112.165042] call trace:
    [  112.165042]  [<ffffffff81256768>] ext4_flex_group_add+0x1448/0x1830
    [  112.165042]  [<ffffffff81257de2>] ext4_resize_fs+0x7b2/0xe80
    [  112.165042]  [<ffffffff8123ac50>] ext4_ioctl+0xbf0/0xf00
    [  112.165042]  [<ffffffff811c111d>] do_vfs_ioctl+0x2dd/0x4b0
    [  112.165042]  [<ffffffff811b9df2>] ? final_putname+0x22/0x50
    [  112.165042]  [<ffffffff811c1371>] sys_ioctl+0x81/0xa0
    [  112.165042]  [<ffffffff81676aa9>] system_call_fastpath+0x16/0x1b
    [  112.165042] code: c8 4c 89 df e8 41 96 f8 ff 44 89 e8 49 01 c4 44 29 6d d4 0 
    [  112.165042] rip  [<ffffffff81254fa1>] set_flexbg_block_bitmap+0x171/0x180
    [  112.165042]  rsp <ffff8800b74f5c28>
    [  112.175633] ---[ end trace f179f994a575df06 ]---

-- 
Jon
