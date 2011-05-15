From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Kernel BUG when syncing ext2 if USB stick is removed
Date: Sun, 15 May 2011 19:37:29 +0200
Message-ID: <201105151937.30017.maciej.rutecki@gmail.com>
References: <4DCBF4B0.10607@secunet.com>
Reply-To: maciej.rutecki@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42695 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1EORhf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 May 2011 13:37:35 -0400
In-Reply-To: <4DCBF4B0.10607@secunet.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=35162
for your bug report, please add your address to the CC list in there, thanks!

On czwartek, 12 maja 2011 o 16:54:40 Torsten Hilbrich wrote:
> The error can be reproduced in both linux-2.6 master
> (3568bd9720b4a775f28a718fcbb462ce2f386988) and v2.6.38.6. It cannot be
> reproduced in v2.6.38.5, because the error occurs only after:
> 
> commit 1f74c190e1e97a38823c07fdc71780580a0fc03f
> Author: James Bottomley <James.Bottomley@suse.de>
> Date:   Fri Apr 22 10:39:59 2011 -0500
> 
>     put stricter guards on queue dead checks
> 
>     commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b upstream.
> 
> in the 2.6.38 stable line.
> 
> Here is the error message for master:
> 
> general protection fault: 0000 [#1] SMP
> last sysfs file:
> CPU 1
> Modules linked in:
> 
> Pid: 1926, comm: sync Not tainted 2.6.39-rc7+ #39 LENOVO 20077KG/20077KG
> RIP: 0010:[<ffffffff811231bf>]  [<ffffffff811231bf>]
> __mark_inode_dirty+0x14f/0x200
> RSP: 0018:ffff88007bebbe08  EFLAGS: 00010246
> RAX: ffff88007d031470 RBX: ffff88007d031408 RCX: ffff88007d031470
> RDX: 6b6b6b6b6b6b6b6b RSI: ffffffff81d33f2a RDI: ffffffff82002300
> RBP: ffff88007bebbe28 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff88007bde3d68 R11: ffff88007c2fba6f R12: ffff88007c350300
> R13: ffff88007c350458 R14: 0000000000000000 R15: ffffffff81127e30
> FS:  00007f8306063700(0000) GS:ffff88007fd00000(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000001f40600 CR3: 000000007b968000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process sync (pid: 1926, threadinfo ffff88007beba000, task
> ffff88007c610820) Stack:
>  ffff88007d031550 ffffea0000082638 0000000000000000 0000000000000000
>  ffff88007bebbe58 ffffffff8112a5ff ffffffff81d3c8d8 ffff88007d223eb0
>  ffff880002541400 ffff88007d223eb0 ffff88007bebbe78 ffffffff8112a6b6
> Call Trace:
>  [<ffffffff8112a5ff>] __set_page_dirty+0x6f/0xc0
>  [<ffffffff8112a6b6>] mark_buffer_dirty+0x66/0xa0
>  [<ffffffff8117c3ce>] ext2_sync_super+0x8e/0xf0
>  [<ffffffff8117c495>] ext2_sync_fs+0x65/0x80
>  [<ffffffff81127dfe>] __sync_filesystem+0x5e/0x90
>  [<ffffffff81127e4f>] sync_one_sb+0x1f/0x30
>  [<ffffffff81100021>] iterate_supers+0x71/0xd0
>  [<ffffffff81127e8f>] sys_sync+0x2f/0x70
>  [<ffffffff819c69ab>] system_call_fastpath+0x16/0x1b
> Code: e8 67 be 89 00 48 8b 05 20 47 ff 00 48 8b 53 70 48 8b 4b 68 48 89
> 43 50 48 8d 43 68 48 89 51 08 48 89 0a 49 8b 94 24 58 01 00 00
>  89 42 08 48 89 53 68 4c 89 6b 70 49 89 84 24 58 01 00 00 fe
> RIP  [<ffffffff811231bf>] __mark_inode_dirty+0x14f/0x200
>  RSP <ffff88007bebbe08>
> ---[ end trace 04d7660d6043ca51 ]---
> 
> If I parsed the error location correctly, it is the:
> 
>   next->prev = prev; // mov %rcx,(%rdx)
> 
> statement from __list_del called via __list_del_entry, list_move from
> the line:
> 
>   list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
> 
> in __mark_inode_dirty. rdx seems to be
> 
> Here are the steps for reproduction:
> 
> 1. mount an USB stick with ext2 FS (mount /dev/sdb1 /mnt)
> 2. open file on USB stick for writing (cat > /mnt/foo)
> 3. press some return
> 4. Remove USB stick
> 5. In another console run sync
> 
> I will append the full kernel log (screenlog.0) and the configuration
> (config-master) to this mail.
> 
> 	Torsten

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
