From: Jan Kara <jack@suse.cz>
Subject: Re: [oops, 4.4-rc8] panic on ext3 during unlink
Date: Thu, 21 Jan 2016 17:28:56 +0100
Message-ID: <20160121162856.GA4514@quack.suse.cz>
References: <20160120033334.GB20456@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759961AbcAUQ2p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jan 2016 11:28:45 -0500
Content-Disposition: inline
In-Reply-To: <20160120033334.GB20456@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

On Wed 20-01-16 14:33:34, Dave Chinner wrote:
> I just had one of my test VMs panic with this from it's root ext3
> filesystem. This is on 4.4.-rc8, using the ext4 driver for ext2/3.

Thanks for report. We were shifting extended attributes inside inode to
make more space for new inode field and somehow we ended up moving some
attribute beyond end of inode. I think I see some supicious code in the
attribute moving code but can you provide e2image of the problematic
filesystem so that I'm sure? Thanks!

								Honza
 
> [11526.376361] ------------[ cut here ]------------
> [11526.377218] kernel BUG at fs/ext4/xattr.c:1243!
> [11526.378022] invalid opcode: 0000 [#1] PREEMPT SMP
> [11526.378918] Modules linked in:
> [11526.379479] CPU: 7 PID: 4667 Comm: rm Tainted: G        W       4.4.0-rc8-dgc+ #631
> [11526.380822] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> [11526.382372] task: ffff8801b22c22c0 ti: ffff8801c2ccc000 task.ti: ffff8801c2ccc000
> [11526.383619] RIP: 0010:[<ffffffff812e618b>]  [<ffffffff812e618b>] ext4_xattr_shift_entries+0x5b/0x60
> [11526.385146] RSP: 0018:ffff8801c2ccfcf8  EFLAGS: 00010202
> [11526.386043] RAX: 000000000030000e RBX: 000000000000000a RCX: ffff88025a336f9c
> [11526.387233] RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff88025a336fa0
> [11526.388421] RBP: ffff8801c2ccfcf8 R08: ffffffffffffffd0 R09: 0000000000001000
> [11526.389620] R10: 000000000000000e R11: ffff88025a336fa0 R12: ffff8801a406f3c0
> [11526.390814] R13: ffff8802f1d925c0 R14: 0000000000000000 R15: ffff88004401a7b0
> [11526.392009] FS:  00007fc60bf93700(0000) GS:ffff88043fce0000(0000) knlGS:0000000000000000
> [11526.393353] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [11526.394320] CR2: 0000000000b53000 CR3: 00000002ddbbf000 CR4: 00000000000006e0
> [11526.395509] Stack:
> [11526.395856]  ffff8801c2ccfde0 ffffffff812e8408 000000000000001c ffff88004401a718
> [11526.397157]  ffff8800bb3e13a8 0000000000000ebc ffff880428b3b0f0 ffff8801c2ccfda0
> [11526.398464]  ffff88025a336f00 0000000000000000 0000000000000000 ffff88025a336fa0
> [11526.399771] Call Trace:
> [11526.400191]  [<ffffffff812e8408>] ext4_expand_extra_isize_ea+0x368/0x790
> [11526.401313]  [<ffffffff812a8398>] ext4_mark_inode_dirty+0x1a8/0x210
> [11526.402370]  [<ffffffff812b43f8>] ext4_unlink+0x308/0x340
> [11526.403270]  [<ffffffff811e2641>] vfs_unlink+0xf1/0x180
> [11526.404142]  [<ffffffff811e52c5>] do_unlinkat+0x245/0x2b0
> [11526.405056]  [<ffffffff811e5cab>] SyS_unlinkat+0x1b/0x30
> [11526.405961]  [<ffffffff81dcbfae>] entry_SYSCALL_64_fastpath+0x12/0x71
> [11526.407041] Code: 77 29 66 44 89 57 02 0f b6 07 48 83 c0 13 48 83 e0 fc 48 01 c7 8b 07 85 c0 75 c9 4c 89 c2 48 89 ce 4c 89 df e8 67 9b 4c 00 5d c3 <0f> 0b 0f 1f 00
> [11526.411253] RIP  [<ffffffff812e618b>] ext4_xattr_shift_entries+0x5b/0x60
> [11526.412384]  RSP <ffff8801c2ccfcf8>
> [11526.413410] ---[ end trace c3688067451bf619 ]---
> 
> The filesystem had just gone ENOSPC, and I was cleaning up some
> files that I have no idea how long they'd been there. A boot time
> e2fsck check ran clean yesterday (the root fs is checked every 30
> boots), so the problem is recent.
> 
> rebooting, remounting and re-running the rm command results in the
> same panic.
> 
> Get it into single user mode, tell systemd's dhcp client to fuck off
> (netowrking hasn't been started!) so I can remount the root
> filesystem read only, and I get:
> 
> # e2fsck -f /dev/sda1
> e2fsck 1.42.13 (17-May-2015)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/sda1: 229275/624624 files (3.9% non-contiguous), 2366037/2496091 blocks
> #
> # mount -o rw,remount /
> [  588.745315] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
> # mount |grep " / "
> /dev/sda1 on / type ext3 (rw,relatime,errors=remount-ro,data=ordered)
> # rm -rf /mnt/scratch/*
> [  591.706140] ------------[ cut here ]------------
> [  591.707046] kernel BUG at fs/ext4/xattr.c:1243!
> [  591.707862] invalid opcode: 0000 [#1] PREEMPT SMP 
> [  591.708787] Modules linked in:
> .....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
