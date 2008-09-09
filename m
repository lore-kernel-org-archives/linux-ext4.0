From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 11525] New: Unable to handle paging request at
 ext3_rmdir() and ext4_rmdir() on intentionally corrupted fs
Date: Tue, 9 Sep 2008 13:46:27 -0700
Message-ID: <20080909134627.75bd0a80.akpm@linux-foundation.org>
References: <bug-11525-27@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, sliedes@cc.hut.fi
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940AbYIIUrB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 16:47:01 -0400
In-Reply-To: <bug-11525-27@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).
On Tue,  9 Sep 2008 11:27:52 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11525
> 
>            Summary: Unable to handle paging request at ext3_rmdir() and
>                     ext4_rmdir() on intentionally corrupted fs
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.27-rc5 (ext4), 2.6.27-rc3 (ext3)
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: sliedes@cc.hut.fi
> 
> 
> Hardware Environment: qemu x86
> Software Environment: Minimal Debian sid (unstable)
> Problem Description:
> 
> [I really thought I had already reported this, but since I can't find it either
> via bugzilla or google, I assume I haven't.]
> 
> Hi,
> 
> Unfortunately this is one of those bugs that I can't find a way to reproduce
> except by randomly breaking one fs after another. This happens with ext3 and
> ext4, but so far I haven't seen it happen with ext2.
> 
> On doing rm -rf on an intentionally corrupted ext3/ext4 filesystem, I
> occasionally hit bugs like this (ext3 backtrace from -rc3, two ext4 traces from
> -rc5). If you want me to try to reproduce the ext3 crash on latest -rc, just
> mention.
> 
> ----------
> *** seed 270, ext3, 2.6.27-rc3 ***
> EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
> block = 1479317508, count = 1
> EXT3-fs error (device hdb): ext3_free_blocks: Freeing blocks not in datazone -
> block = 4718764, count = 1
> attempt to access beyond end of device
> hdb: rw=0, want=1048578, limit=20480
> EXT3-fs error (device hdb): ext3_free_branches: Read failure, inode=1428,
> block=524288
> EXT3-fs warning (device hdb): empty_dir: bad directory (dir #1360) - no `.' or
> `..'
> EXT3-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
> #1332: directory entry across blocks - offset=0, inode=1332, rec_len=
> BUG: unable to handle kernel paging request at c7c3240c
> IP: [<c02e4be6>] empty_dir+0xe1/0x305
> *pde = 00007067 *pte = 07c32160
> Oops: 0000 [#1] DEBUG_PAGEALLOC
> [ 1306.100454]
> Pid: 24302, comm: rm Not tainted (2.6.27-rc3 #2)
> EIP: 0060:[<c02e4be6>] EFLAGS: 00000246 CPU: 0
> EIP is at empty_dir+0xe1/0x305
> EAX: c7c3240c EBX: c3fa7cc4 ECX: 00000534 EDX: 00000534
> ESI: c7c2a400 EDI: c74d4888 EBP: c1e6cef4 ESP: c1e6cec0
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process rm (pid: 24302, ti=c1e6c000 task=c5664d00 task.ti=c1e6c000)
> Stack: 00000000 c1e6cee4 c7aab400 00000058 38583e14 72b9e783 00000002 c7c3240c
>        c7aaa800 00000000 c7440000 c744471c fffffffb c1e6cf28 c02e7910 00000246
>        c0620de0 c3c67690 c0620de0 c3c67688 c3fa7cc4 c3f6e230 c7cab9a0 00000000
> Call Trace:
>  [<c02e7910>] ? ext3_rmdir+0xb7/0x18f
>  [<c026ba2d>] ? vfs_rmdir+0x7e/0xb3
>  [<c026d2b7>] ? do_rmdir+0xb7/0xc3
>  [<c026d2f4>] ? sys_unlinkat+0x31/0x36
>  [<c0202f3e>] ? syscall_call+0x7/0xb
>  =======================
> Code: 08 5c b4 5d c0 c7 44 24 04 a4 26 55 c0 8b 45 ec 89 04 24 e8 47 45 00 00
> b8 01 00 00 00 83 c4 28 5b 5e 5f 5d c3 8d 04 06 89 45 e8 <8b> 00 85 c0 74 86 8d
> 56 08 b8 6c cb 5f c0 e8 a8 9d 17 00 85 c0
> EIP: [<c02e4be6>] empty_dir+0xe1/0x305 SS:ESP 0068:c1e6cec0
> ---[ end trace 3a33b21de407e362 ]---
> ----------
> *** seed 451, ext4, 2.6.27-rc5 ***
> attempt to access beyond end of device
> hdb: rw=0, want=268435458, limit=20480
> EXT4-fs error (device hdb): ext4_xattr_delete_inode: inode 507: block 134217728
> read error
> EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
> #653: directory entry across blocks - offset=0, inode=653, rec_len=16
> BUG: unable to handle kernel paging request at c7d2540c
> IP: [<c02fb496>] empty_dir+0xe1/0x305
> *pde = 00007067 *pte = 07d25160
> Oops: 0000 [#1] DEBUG_PAGEALLOC
> [ 2151.877484]
> Pid: 20705, comm: rm Not tainted (2.6.27-rc5 #2)
> EIP: 0060:[<c02fb496>] EFLAGS: 00000246 CPU: 0
> EIP is at empty_dir+0xe1/0x305
> EAX: c7d2540c EBX: c48440e0 ECX: 0000028d EDX: 0000028d
> ESI: c7d21400 EDI: c1b99428 EBP: c1bd7ef4 ESP: c1bd7ec0
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process rm (pid: 20705, ti=c1bd7000 task=c1a38000 task.ti=c1bd7000)
> Stack: 00000000 c1bd7ee4 c6169800 0000007e e18fea3c 54ed2757 00000001 c7d2540c
>        c6169400 00000000 c4a35020 c4982138 fffffffb c1bd7f28 c02fe5ef 00000246
>        c0620de0 c485bbe8 c0620de0 c485bbe0 c48440e0 c4a15dc8 c2b7a5c8 00000000
> Call Trace:
>  [<c02fe5ef>] ? ext4_rmdir+0xd5/0x1e8
>  [<c026bd5d>] ? vfs_rmdir+0x7e/0xb3
>  [<c026d5e7>] ? do_rmdir+0xb7/0xc3
>  [<c026d624>] ? sys_unlinkat+0x31/0x36
>  [<c0202f3e>] ? syscall_call+0x7/0xb
>  =======================
> Code: 08 54 b4 5d c0 c7 44 24 04 a4 34 55 c0 8b 45 ec 89 04 24 e8 73 4b 00 00
> b8 01 00 00 00 83 c4 28 5b 5e 5f 5d c3 8d 04 06 89 45 e8 <8b> 00 8
> EIP: [<c02fb496>] empty_dir+0xe1/0x305 SS:ESP 0068:c1bd7ec0
> ---[ end trace 79e4e3dfd3fb9e7d ]---
> umount: /mnt: device is busy
> ----------
> *** seed 10000193, ext4, 2.6.27-rc5 ***
> EXT4-fs warning (device hdb): empty_dir: bad directory (dir #733) - no `.' or
> `..'
> EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
> #461: directory entry across blocks - offset=0, inode=461, rec_len=82
> BUG: unable to handle kernel paging request at c769940c
> IP: [<c02fb496>] empty_dir+0xe1/0x305
> *pde = 079e7163 *pte = 07699160
> Oops: 0000 [#1] DEBUG_PAGEALLOC
> [  961.774442]
> Pid: 4518, comm: rm Not tainted (2.6.27-rc5 #2)
> EIP: 0060:[<c02fb496>] EFLAGS: 00000246 CPU: 0
> EIP is at empty_dir+0xe1/0x305
> EAX: c769940c EBX: c3fc36c8 ECX: 000001cd EDX: 000001cd
> ESI: c7697400 EDI: c3fc8380 EBP: c7a6cef4 ESP: c7a6cec0
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process rm (pid: 4518, ti=c7a6c000 task=c78bc360 task.ti=c7a6c000)
> Stack: 00000000 c7a6cee4 c532ec00 0000007e 1da9562e eb3f2f99 00000001 c769940c
>        c532e000 00000000 c3ee0020 c3eada08 fffffffb c7a6cf28 c02fe5ef 00000246
>        c0620de0 c747c560 c0620de0 c747c558 c3fc36c8 c3fc8d90 c76965f0 00000000
> Call Trace:
>  [<c02fe5ef>] ? ext4_rmdir+0xd5/0x1e8
>  [<c026bd5d>] ? vfs_rmdir+0x7e/0xb3
>  [<c026d5e7>] ? do_rmdir+0xb7/0xc3
>  [<c026d624>] ? sys_unlinkat+0x31/0x36
>  [<c0202f3e>] ? syscall_call+0x7/0xb
>  =======================
> Code: 08 54 b4 5d c0 c7 44 24 04 a4 34 55 c0 8b 45 ec 89 04 24 e8 73 4b 00 00
> b8 01 00 00 00 83 c4 28 5b 5e 5f 5d c3 8d 04 06 89 45 e8 <8b> 00 8
> EIP: [<c02fb496>] empty_dir+0xe1/0x305 SS:ESP 0068:c7a6cec0
> ---[ end trace 7aaee6ca8f8adc20 ]---
> ----------
> 

