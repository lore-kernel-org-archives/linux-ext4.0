From: Christian Hesse <mail@earthworm.de>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 23:03:35 +0200
Message-ID: <200808132303.38764.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kolab.mylinuxtime.de ([212.112.242.22]:43226 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYHMV0i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 17:26:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm not sure if the last mail left my system, so I send it again...

On Wednesday 13 August 2008, you wrote:
> On Wed, Aug 13, 2008 at 08:28:18PM +0200, eworm@lugor.de wrote:
> > After mounting the partitions and logging in it took half a minute to
> > hang the system (or at least freeze all applications that access the fs).
> > The log contains the following:
> >
> > kernel BUG at fs/ext4/mballoc.c:3963!
>
> This means that we tried to truncate/delete a file while there were
> still blocks on i_prealloc_list.  I think I see the problem.  And the
> reason why we haven't noticed it is that it only shows up if you have
> an indirect block-based file, and you truncate it when you have
> previously been writing to it (so i_prealloc_list is not empty).
>
> The problem is that we call ext4_discard_reservation() too late, after
> we've started calling ext4_free_branches(), which calls
> ext4_free_blocks(), which ultimately calls
> ext4_mb_return_to_preallocation(), which is what is BUG-checking.
>
> Can you reproduce the bug?

I can. ;)

> Things are a little busy on my end, so I 
> don't have time to try to create a reproducer and test the patch, at
> least not for a day or so.  The following patch passes the "It Builds,
> Ship It!" test, but not much else.  :-)
>
> If you could report (a) whether or not you can reproduce the failure,
> and (b) whether this patch fixes things, I would be most grateful.

This time I got the following:

kernel BUG at fs/ext4/inode.c:1568!
invalid opcode: 0000 [#1] SMP
Modules linked in: snd_hda_intel vboxdrv iwl3945

Pid: 4049, comm: kontact Not tainted (2.6.27-rc3 #1)
EIP: 0060:[<c021aac5>] EFLAGS: 00010202 CPU: 0
EIP is at ext4_da_invalidatepage+0xa5/0x120
EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 000003ff
ESI: eeb900b8 EDI: eeb90138 EBP: ef165d94 ESP: ef165d70
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process kontact (pid: 4049, ti=ef164000 task=ef16c430 task.ti=ef164000)
Stack: 00000000 eeb902d8 00000000 c1d7f600 f7314000 00000000 c021aa20 00000001
       c1d7f600 ef165da0 c0167799 c1d7f600 ef165dac c0167ca9 00000000 ef165e2c
       c0167dd1 0000000e eeb6e2a8 00000001 00000003 f7380078 00000000 00000000
Call Trace:
 [<c021aa20>] ? ext4_da_invalidatepage+0x0/0x120
 [<c0167799>] ? do_invalidatepage+0x19/0x20
 [<c0167ca9>] ? truncate_complete_page+0x49/0x60
 [<c0167dd1>] ? truncate_inode_pages_range+0x111/0x350
 [<c023d7ec>] ? jbd2_journal_stop+0x14c/0x1d0
 [<c016802a>] ? truncate_inode_pages+0x1a/0x20
 [<c021db6e>] ? ext4_delete_inode+0x2e/0x290
 [<c021db40>] ? ext4_delete_inode+0x0/0x290
 [<c01964ac>] ? generic_delete_inode+0x7c/0x120
 [<c0196685>] ? generic_drop_inode+0x135/0x160
 [<c0195547>] ? iput+0x47/0x50
 [<c0192cd7>] ? dentry_iput+0x67/0xb0
 [<c0192da5>] ? d_kill+0x35/0x60
 [<c0193496>] ? dput+0x76/0x120
 [<c018b9bb>] ? sys_renameat+0x1cb/0x200
 [<c01768dc>] ? free_pages_and_swap_cache+0x7c/0xa0
 [<c0171156>] ? remove_vma+0x46/0x60
 [<c01720eb>] ? do_munmap+0x1db/0x230
 [<c018ba19>] ? sys_rename+0x29/0x30
 [<c01032b1>] ? sysenter_do_call+0x12/0x25
 =======================
Code: 87 a0 01 00 00 89 45 e0 e8 09 33 32 00 8b 5d f0 89 f8 8b 96 10 02 00 00 
29 da e8 17 ff ff ff 89 c3 8b 86 14 02 00 00 39 c3 76 2a <0f> 0b eb fe 89 9e 
14 02 00 00 8b 55 e0 fe 87 a0 01 00 00 8b 55
EIP: [<c021aac5>] ext4_da_invalidatepage+0xa5/0x120 SS:ESP 0068:ef165d70

And another one:

kernel BUG at fs/ext4/inode.c:1568!
invalid opcode: 0000 [#1] SMP
Modules linked in: snd_hda_intel vboxdrv iwl3945

Pid: 4097, comm: kontact Not tainted (2.6.27-rc3 #1)
EIP: 0060:[<c021aac5>] EFLAGS: 00010202 CPU: 1
EIP is at ext4_da_invalidatepage+0xa5/0x120
EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 000003ff
ESI: ed9404c0 EDI: ed940540 EBP: ee7d7dfc ESP: ee7d7dd8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process kontact (pid: 4097, ti=ee7d6000 task=ee7d51e0 task.ti=ee7d6000)
Stack: ec9ef3ec ed9406e0 00000000 c1e586c0 f5a3f800 00000000 c021aa20 00000001
       c1e586c0 ee7d7e08 c0167799 c1e586c0 ee7d7e14 c0167ca9 00000000 ee7d7e94
       c0167dd1 0000000e 00000296 ee6a04c0 ee6a04fc ec9ef3ec 00000000 00000000
Call Trace:
 [<c021aa20>] ? ext4_da_invalidatepage+0x0/0x120
 [<c0167799>] ? do_invalidatepage+0x19/0x20
 [<c0167ca9>] ? truncate_complete_page+0x49/0x60
 [<c0167dd1>] ? truncate_inode_pages_range+0x111/0x350
 [<c0227517>] ? __ext4_journal_stop+0x27/0x60
 [<c02195a5>] ? ext4_dirty_inode+0x55/0x80
 [<c016802a>] ? truncate_inode_pages+0x1a/0x20
 [<c021db6e>] ? ext4_delete_inode+0x2e/0x290
 [<c021db40>] ? ext4_delete_inode+0x0/0x290
 [<c01964ac>] ? generic_delete_inode+0x7c/0x120
 [<c0196685>] ? generic_drop_inode+0x135/0x160
 [<c0195547>] ? iput+0x47/0x50
 [<c0192cd7>] ? dentry_iput+0x67/0xb0
 [<c0192da5>] ? d_kill+0x35/0x60
 [<c0193496>] ? dput+0x76/0x120
 [<c0182550>] ? __fput+0x110/0x160
 [<c01825bf>] ? fput+0x1f/0x30
 [<c017113d>] ? remove_vma+0x2d/0x60
 [<c01720eb>] ? do_munmap+0x1db/0x230
 [<c0172170>] ? sys_munmap+0x30/0x50
 [<c01032b1>] ? sysenter_do_call+0x12/0x25
 =======================
Code: 87 a0 01 00 00 89 45 e0 e8 09 33 32 00 8b 5d f0 89 f8 8b 96 10 02 00 00 
29 da e8 17 ff ff ff 89 c3 8b 86 14 02 00 00 39 c3 76 2a <0f> 0b eb fe 89 9e 
14 02 00 00 8b 55 e0 fe 87 a0 01 00 00 8b 55
EIP: [<c021aac5>] ext4_da_invalidatepage+0xa5/0x120 SS:ESP 0068:ee7d7dd8
-- 
Regards,
Chris
