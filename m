From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: Oops when mounting corrupted image
Date: Wed, 14 May 2008 09:35:40 +0200
Message-ID: <20080514073540.GA8497@alice>
References: <20080509235442.GA2367@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56510 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753279AbYENHfn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 03:35:43 -0400
Content-Disposition: inline
In-Reply-To: <20080509235442.GA2367@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> hi,
> 
> i get the following oops when mounting a corrupted image with ext4:
> 
> [  181.076778] JBD: corrupted journal superblock
> [  181.081155] JBD: error -5 scanning journal
> [  181.085459] EXT4-fs: error loading journal.
> [  181.090472] BUG: unable to handle kernel NULL pointer dereference at
> 00000120
> [  181.090764] IP: [<c0200556>] ext4_sync_fs+0x16/0x90
> [  181.091006] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [  181.091289] Modules linked in: nfsd exportfs
> [  181.091351] 
> [  181.091351] Pid: 4556, comm: mount Not tainted
> (2.6.26-rc1-00279-g28a4acb-dirty #5)
> [  181.091351] EIP: 0060:[<c0200556>] EFLAGS: 00010286 CPU: 0
> [  181.091351] EIP is at ext4_sync_fs+0x16/0x90
> [  181.091351] EAX: 00000000 EBX: c86c0860 ECX: c0200540 EDX: 00000001
> [  181.091351] ESI: 00000001 EDI: c084db80 EBP: c8900de0 ESP: c8900dd0
> [  181.091351]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  181.091351] Process mount (pid: 4556, ti=c8900000 task=c86caf40
> task.ti=c8900000)
> [  181.091351] Stack: c01b6b70 c084db80 c86c0860 c01b6b70 c8900e48
> c01b6d08 00000246 c8900e08 
> [  181.091351]        c8900e20 00000000 ffffffff c86c0860 c86c09bc
> 00000002 c8900e20 00000000 
> [  181.091351]        00000000 c8900e3c c86c0ab8 c86c0ac0 c8900e3c
> 00000246 00000001 00000246 
> [  181.091351] Call Trace:
> [  181.091351]  [<c01b6b70>] ? vfs_quota_off+0x0/0x5d0
> [  181.091351]  [<c01b6b70>] ? vfs_quota_off+0x0/0x5d0
> [  181.091351]  [<c01b6d08>] ? vfs_quota_off+0x198/0x5d0
> [  181.091351]  [<c01b6b70>] ? vfs_quota_off+0x0/0x5d0
> [  181.091351]  [<c018293d>] ? deactivate_super+0x6d/0x90
> [  181.091351]  [<c0182e74>] ? get_sb_bdev+0x114/0x120
> [  181.091351]  [<c019780d>] ? alloc_vfsmnt+0xdd/0x120
> [  181.091351]  [<c019780d>] ? alloc_vfsmnt+0xdd/0x120
> [  181.091351]  [<c01fe962>] ? ext4_get_sb+0x22/0x30
> [  181.091351]  [<c0201090>] ? ext4_fill_super+0x0/0x21e0
> [  181.091351]  [<c018299a>] ? vfs_kern_mount+0x3a/0x90
> [  181.091351]  [<c0182a49>] ? do_kern_mount+0x39/0xd0
> [  181.091351]  [<c0198a45>] ? do_new_mount+0x65/0x90
> [  181.091351]  [<c0198bca>] ? do_mount+0x15a/0x1b0
> [  181.091351]  [<c01471fd>] ? trace_hardirqs_on+0xbd/0x140
> [  181.091351]  [<c06817d9>] ? _spin_unlock_irqrestore+0x39/0x70
> [  181.091351]  [<c013d279>] ? down+0x29/0x40
> [  181.091351]  [<c0198c8f>] ? sys_mount+0x6f/0xb0
> [  181.091351]  [<c0103d8d>] ? sysenter_past_esp+0x6a/0xb1
> [  181.091351]  =======================
> [  181.091351] Code: 00 c6 42 11 00 e8 3b e8 01 00 5d c3 89 f6 8d bc 27
> 00 00 00 00 55 89 e5 56 89 d6 53 89 c3 83 ec 08 85 c0 74 64 8b 83 ac 02
> 00 00 <8b> 90 20 01 00 00 85 d2 74 40 c6 43 11 00 8d 55 f4 8b 80 20 01 
> [  181.091351] EIP: [<c0200556>] ext4_sync_fs+0x16/0x90 SS:ESP
> 0068:c8900dd0
> [  181.106189] ---[ end trace e810f4375c8543b9 ]---

I just triggered the same oops on an ext3 image,
please let me know if youre interested in this,
i'll keep the image.

[  262.288141] BUG: unable to handle kernel NULL pointer dereference at 00000114
[  262.288498] IP: [<c01e852d>] ext3_sync_fs+0x1d/0x60
[  262.288744] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  262.289027] Modules linked in: nfsd exportfs
[  262.289361] 
[  262.289361] Pid: 5076, comm: mount Not tainted (2.6.26-rc2-00051-gc714a53 #9)
[  262.289361] EIP: 0060:[<c01e852d>] EFLAGS: 00010296 CPU: 0
[  262.289361] EIP is at ext3_sync_fs+0x1d/0x60
[  262.289361] EAX: 00000000 EBX: cbae8000 ECX: c01e8510 EDX: ca45bdd4
[  262.289361] ESI: 00000001 EDI: c084b840 EBP: ca45bde0 ESP: ca45bdd4
[  262.289361]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  262.289361] Process mount (pid: 5076, ti=ca45b000 task=cbad9f80 task.ti=ca45b000)
[  262.289361] Stack: c084b840 cbae8000 c01b63c0 ca45be48 c01b6558 00000246 ca45be08 ca45be20 
[  262.289361]        00000000 ffffffff cbae8000 cbae815c 00000002 ca45be20 00000000 00000000 
[  262.289361]        ca45be3c cbae8258 cbae8260 ca45be3c 00000246 00000001 00000246 c0849ac0 
[  262.289361] Call Trace:
[  262.289361]  [<c01b63c0>] ? vfs_quota_off+0x0/0x5d0
[  262.289361]  [<c01b6558>] ? vfs_quota_off+0x198/0x5d0
[  262.289361]  [<c01b63c0>] ? vfs_quota_off+0x0/0x5d0
[  262.289361]  [<c018228d>] ? deactivate_super+0x6d/0x90
[  262.289361]  [<c01827c4>] ? get_sb_bdev+0x114/0x120
[  262.289361]  [<c019718d>] ? alloc_vfsmnt+0xdd/0x120
[  262.289361]  [<c019718d>] ? alloc_vfsmnt+0xdd/0x120
[  262.289361]  [<c01e6de2>] ? ext3_get_sb+0x22/0x30
[  262.289361]  [<c01e8f30>] ? ext3_fill_super+0x0/0x1bb0
[  262.289361]  [<c01822ea>] ? vfs_kern_mount+0x3a/0x90
[  262.289361]  [<c0182399>] ? do_kern_mount+0x39/0xd0
[  262.289361]  [<c01983c5>] ? do_new_mount+0x65/0x90
[  262.289361]  [<c019854a>] ? do_mount+0x15a/0x1b0
[  262.289361]  [<c017bac5>] ? kmem_cache_alloc+0x95/0xc0
[  262.289361]  [<c015fc2b>] ? __get_free_pages+0x1b/0x30
[  262.289361]  [<c0196258>] ? copy_mount_options+0x38/0x140
[  262.289361]  [<c0188ce7>] ? getname+0xa7/0xc0
[  262.289361]  [<c019860f>] ? sys_mount+0x6f/0xb0
[  262.289361]  [<c0103d7d>] ? sysenter_past_esp+0x6a/0xb1
[  262.289361]  =======================
[  262.289361] Code: da 02 00 5d c3 89 f6 8d bc 27 00 00 00 00 55 89 e5
83 ec 0c 89 5d f8 89 c3 89 75 fc 89 d6 c6 40 11 00 8b 80 ac 02 00 00 8d
55 f4 <8b> 80 14 01 00 00 e8 88 31 03 00 85 c0 74 04 85 f6 75 10 8b 5d 
[  262.289361] EIP: [<c01e852d>] ext3_sync_fs+0x1d/0x60 SS:ESP
0068:ca45bdd4
[  262.303800] ---[ end trace caa114ab964b5c0b ]---



Greetings, Eric
