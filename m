From: Jan Kara <jack@suse.cz>
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Date: Fri, 16 Mar 2012 09:52:31 +0100
Message-ID: <20120316085231.GA24821@quack.suse.cz>
References: <20120313133945.4642.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jkosina@suse.cz, Linus Torvalds <torvalds@linux-foundation.org>
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030202Ab2CPIwg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Mar 2012 04:52:36 -0400
Content-Disposition: inline
In-Reply-To: <20120313133945.4642.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 13-03-12 09:39:45, George Spelvin wrote:
> During last night's backups, I got the following oops; I figured I should
> report it.
  Thanks for report!

> I don't see any changes in all of fs/ext3 between -rc4 and -rc7, so I
> presume the report is still valid.
> 
> [1536254.006284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000094
> [1536254.006327] IP: [<ffffffff810fbc32>] ext3_block_to_path.isra.40+0x26/0x11b
> [1536254.006363] PGD 102451067 PUD 10c872067 PMD 0 
> [1536254.006392] Oops: 0000 [#1] SMP 
> [1536254.006414] CPU 1 
> [1536254.006424] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169 iTCO_wdt
> [1536254.006516] 
> [1536254.006526] Pid: 5250, comm: rsync Not tainted 3.3.0-rc4-00008-g0a3fa4f #43 Gigabyte Technology Co., Ltd. H55M-UD2H/H55M-UD2H
> [1536254.006576] RIP: 0010:[<ffffffff810fbc32>]  [<ffffffff810fbc32>] ext3_block_to_path.isra.40+0x26/0x11b
> [1536254.006617] RSP: 0018:ffff88010c84f978  EFLAGS: 00010206
> [1536254.006640] RAX: 0000000000000400 RBX: 00000000003980a3 RCX: 0000000000000000
> [1536254.006670] RDX: ffff88010c84fa90 RSI: 00000000003980a3 RDI: ffff88011340cc00
> [1536254.006699] RBP: ffff88010c84f998 R08: ffff88010c84fc50 R09: 0000000000000000
> [1536254.006728] R10: 00000000003980a4 R11: 0000000000000001 R12: 0000000000000400
> [1536254.006758] R13: ffff88010c84fab0 R14: ffff88010c84fc50 R15: 0000000000000000
> [1536254.006788] FS:  0000000000000000(0000) GS:ffff880117c80000(0063) knlGS:00000000f75786c0
> [1536254.006821] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [1536254.006846] CR2: 0000000000000094 CR3: 000000010fb35000 CR4: 00000000000006e0
> [1536254.006875] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [1536254.006905] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [1536254.006935] Process rsync (pid: 5250, threadinfo ffff88010c84e000, task ffff880021af9f40)
> [1536254.006968] Stack:
> [1536254.006979]  ffff88010c84fc50 ffff8801120dc0e0 0000000000000000 ffff88010c84fc50
> [1536254.007016]  ffff88010c84fae8 ffffffff810fd5a0 0000000000000001 ffff88010c84fad8
> [1536254.007054]  ffff88010c84fb08 0000000000000001 ffff88010c84fa18 ffffffff810baed3
> [1536254.007092] Call Trace:
> [1536254.007107]  [<ffffffff810fd5a0>] ext3_get_blocks_handle+0x64/0x916
> [1536254.007137]  [<ffffffff810baed3>] ? poll_freewait+0x41/0xa5
> [1536254.007163]  [<ffffffff8130c4fc>] ? tcp_poll+0x24/0x16b
> [1536254.007186]  [<ffffffff810bb66f>] ? do_select+0x4bd/0x4da
> [1536254.007210]  [<ffffffff810fdef1>] ext3_get_block+0x9f/0xdf
> [1536254.007237]  [<ffffffff810d4cee>] do_mpage_readpage+0x175/0x48e
> [1536254.007265]  [<ffffffff810299de>] ? local_bh_enable_ip+0x9/0xb
> [1536254.007290]  [<ffffffff810d5051>] mpage_readpage+0x4a/0x65
> [1536254.007314]  [<ffffffff810fde52>] ? ext3_get_blocks_handle+0x916/0x916
> [1536254.007342]  [<ffffffff8130e453>] ? tcp_sendmsg+0x693/0x785
> [1536254.007369]  [<ffffffff8107a693>] ? file_read_actor+0x9c/0x117
> [1536254.007396]  [<ffffffff810403af>] ? should_resched+0x9/0x28
> [1536254.007422]  [<ffffffff8135db84>] ? _cond_resched+0x9/0x1d
> [1536254.007445]  [<ffffffff810fb663>] ext3_readpage+0x13/0x15
> [1536254.007469]  [<ffffffff8107b2b8>] generic_file_aio_read+0x4a7/0x62c
> [1536254.007498]  [<ffffffff810ace6a>] do_sync_read+0xbd/0xfd
> [1536254.007521]  [<ffffffff810b801c>] ? getname_flags+0x29/0x1d0
> [1536254.007546]  [<ffffffff810acc5a>] ? fsnotify_modify+0x5a/0x62
> [1536254.007571]  [<ffffffff810ad567>] vfs_read+0xa4/0xeb
> [1536254.007594]  [<ffffffff810ad5f3>] sys_read+0x45/0x69
> [1536254.007617]  [<ffffffff8136011b>] sysenter_dispatch+0x7/0x1e
> [1536254.007642] Code: 5b 41 5c 5d c3 55 48 89 e5 41 55 49 89 cd 41 54 53 48 89 f3 41 50 48 8b 47 18 48 8b 8f b0 02 00 00 48 c1 e8 02 48 85 db 41 89 c4 <8b> b1 94 00 00 00 79 0c 48 c7 c2 3c 82 44 81 e9 b1 00 00 00 48 
> [1536254.007875] RIP  [<ffffffff810fbc32>] ext3_block_to_path.isra.40+0x26/0x11b
> [1536254.007908]  RSP <ffff88010c84f978>
> [1536254.007923] CR2: 0000000000000094
> [1536254.068173] ---[ end trace 87b810932dd8374d ]---
> 
> The 8 local patches are in drivers/media/rc/ati_remote.c, and the module
> wasn't even loaded.
> 
> Although the NFS modules are loaded, nothing is exported.
> Likewise, the battery module is purely accidental.
> There is one NFS mount, but it's quiescent.
> 
> CPU is a Core i3 530, on a Gigabyte motherbord, 4 GB RAM.  No ECC,
> unfortunately, so I can't rule out hardware bit rot.  Distribution is
> a fairly stock Debian/unstable.
  Hmm, is any mounting & unmounting happening during your backup? Because
the oops happened because sb->s_fs_info was NULL. Dissassembly shows:
  16:	48 8b 47 18          	mov    0x18(%rdi),%rax
store sb->s_blocksize into RAX
  1a:	48 8b 8f b0 02 00 00 	mov    0x2b0(%rdi),%rcx
store sb->s_fs_info into RCX
  21:	48 c1 e8 02          	shr    $0x2,%rax
This is division from EXT3_ADDR_PER_BLOCK() - RAX carries 1024 after
division so that looks correct.

  25:	48 85 db             	test   %rbx,%rbx
Now check passed i_block argument.

  28:	41 89 c4             	mov    %eax,%r12d
  2b:*	8b b1 94 00 00 00    	mov    0x94(%rcx),%esi     <-- trapping ins
Try to get RCX->s_addr_per_block_bits...

 sb->s_fs_info is set when a superblock is mounted and cleared when
superblock gets unmounted and otherwise it is never changed. So most likely
it was some memory corruption clearing that pointer (I wouldn't really
suspect HW here).

It somewhat looks like the issue described here:
http://lkml.indiana.edu/hypermail/linux/kernel/1202.3/00132.html

Although there we had f_path.dentry (completely different structure) being
NULL. But similarity here is that something stomped NULL over our existing
structure.

Linus, Jiri, that bug didn't get resolved, did it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
