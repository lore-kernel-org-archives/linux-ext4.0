From: "Alex Lyakas" <alex@zadarastorage.com>
Subject: free_buffer_head: BUG_ON(!list_empty(&bh->b_assoc_buffers))
Date: Wed, 20 Jul 2016 12:52:55 +0300
Message-ID: <8A179514DC1442C6999F3739176C4E16@alyakaslap>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35510 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbcGTJw7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2016 05:52:59 -0400
Received: by mail-wm0-f52.google.com with SMTP id f65so168501541wmi.0
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2016 02:52:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greetings ext4 community,

I have hit the following stack trace [1] on the long-term mainline kernel 
3.18.19. Although it goes through the XFS function, XFS does not use the 
b_assoc_buffers field.

Grepping through kernel sources, I see:
- direct users of b_assoc_buffers are nilfs2, reiserfs and jbd2. Relevant 
for my case is jbd2, because I have two ext4 file systems mounted.
- the only other place where somebody can use the "b_assoc_buffers" link is 
by calling mark_buffer_dirty_inode(), which puts the bufferhead on 
"mapping->private_list" using the "b_assoc_buffers" link. There are several 
users of this API, but for my case the only relevant being again jbd2.

So asking community help with this issue.

Thanks,
Alex.



[1]
[2540217.134291] ------------[ cut here ]------------
[2540217.135008] kernel BUG at fs/buffer.c:3339!
[2540217.135008] invalid opcode: 0000 [#1] PREEMPT SMP
[2540217.135008] CPU: 0 PID: 38 Comm: kswapd0 Tainted: G        WC OE 
3.18.19-zadara05 #1
[2540217.135008] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[2540217.135008] task: ffff8800db499440 ti: ffff880118934000 task.ti: 
ffff880118934000
[2540217.135008] RIP: 0010:[<ffffffff8121b117>]  [<ffffffff8121b117>] 
free_buffer_head+0x67/0x70
[2540217.135008] RSP: 0000:ffff880118937980  EFLAGS: 00010293
[2540217.135008] RAX: ffff8800a6b4e2b8 RBX: ffff8800a6b4e270 RCX: 
0000000000000000
[2540217.135008] RDX: 0000000000000000 RSI: 0000000000001000 RDI: 
ffff8800a6b4e270
[2540217.135008] RBP: ffff8801189379b8 R08: 0000000000000018 R09: 
ffff88001d9d32f8
[2540217.135008] R10: ffff880118937990 R11: ffffea00029ad380 R12: 
0000000000000001
[2540217.135008] R13: ffff88001d9d3388 R14: ffffea000166c920 R15: 
ffff880118937ab0
[2540217.135008] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) 
knlGS:0000000000000000
[2540217.135008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2540217.135008] CR2: 00007ff5ce91d77c CR3: 0000000115897000 CR4: 
00000000001406f0
[2540217.135008] Stack:
[2540217.135008]  ffffffff8121b25c ffff88001f035240 ffff8800a6b4e270 
0000000000000000
[2540217.135008]  ffff880118937e50 ffffea000166c900 ffff88001d9d31a8 
ffff8801189379f8
[2540217.135008]  ffffffffc0a8933b 0000000000000000 0000000000000000 
ffffffff811abc60
[2540217.135008] Call Trace:
[2540217.193019]  [<ffffffff8121b25c>] ? try_to_free_buffers+0x7c/0xc0
[2540217.193019]  [<ffffffffc0a8933b>] xfs_vm_releasepage+0x4b/0x120 [xfs]
[2540217.193019]  [<ffffffff811abc60>] ? page_get_anon_vma+0xb0/0xb0
[2540217.193019]  [<ffffffff811722f2>] try_to_release_page+0x32/0x50
[2540217.193019]  [<ffffffff8118596d>] shrink_page_list+0x8fd/0xad0
[2540217.193019]  [<ffffffff817173e9>] ? _raw_spin_unlock_irq+0x19/0x50
[2540217.193019]  [<ffffffff81186116>] shrink_inactive_list+0x1a6/0x550
[2540217.193019]  [<ffffffff81399119>] ? 
radix_tree_gang_lookup_tag+0x89/0xd0
[2540217.193019]  [<ffffffff81186e0d>] shrink_lruvec+0x58d/0x750
[2540217.193019]  [<ffffffff81187053>] shrink_zone+0x83/0x1d0
[2540217.193019]  [<ffffffff8118727b>] kswapd_shrink_zone+0xdb/0x1b0
[2540217.193019]  [<ffffffff811884fd>] kswapd+0x4ed/0x8f0
[2540217.193019]  [<ffffffff81188010>] ? 
mem_cgroup_shrink_node_zone+0x190/0x190
[2540217.193019]  [<ffffffff810911b9>] kthread+0xc9/0xe0
[2540217.193019]  [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
[2540217.193019]  [<ffffffff81717918>] ret_from_fork+0x58/0x90
[2540217.193019]  [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
[2540217.193019] Code: 04 fb 00 00 3d ff 0f 00 00 7f 19 65 ff 0c 25 20 b8 00 
00 74 07 5d c3 0f 1f 44 00 00 e8 34 6a 18 00 5d c3 90 e8 8b fa ff ff eb e0 
<0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 45
[2540217.193019] RIP  [<ffffffff8121b117>] free_buffer_head+0x67/0x70

