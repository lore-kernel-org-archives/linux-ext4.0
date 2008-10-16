From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: BUG in __journal_abort_soft when unmounting a corrupted image
Date: Thu, 16 Oct 2008 08:25:29 +0200
Message-ID: <20081016062529.GD28554@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54262 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751062AbYJPGZc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 02:25:32 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

since ext4 seems to get marked stable I started testing it with
corrupted images again. 

With todays -git and when using this image:

http://www.cccmz.de/~snakebyte/ext4.27.img.bz2

and issuing the following commands:

 # mount cfs/ext4.27.img /media/test/ -t ext4 -o loop
 # touch /media/test/lala
 touch: cannot touch `/media/test/lala': Input/output error
 # umount /media/test/

I get a BUG in jbd2

[   97.852678] EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory #2: inode out of bounds - offset=24, inode=33554443, rec_len=1000, name_len=10
[   98.876051] EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory #2: inode out of bounds - offset=24, inode=33554443, rec_len=1000, name_len=10
[   99.200811] EXT4-fs error (device loop0): ext4_add_entry: bad entry in directory #2: inode out of bounds - offset=24, inode=33554443, rec_len=1000, name_len=10
[  103.310036] Aborting journal on device loop0:8.
[  103.688410] ext4_abort called.
[  103.688580] EXT4-fs error (device loop0): ext4_put_super: Couldn't clean up the journal
[  103.688902] Remounting filesystem read-only
[  103.689042] BUG: unable to handle kernel paging request at cdc38bf0
[  103.689286] IP: [<c024af62>] __journal_abort_soft+0x12/0x60
[  103.689588] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  103.689878] Modules linked in:
[  103.690047] 
[  103.690118] Pid: 4083, comm: umount Not tainted (2.6.27 #48) 
[  103.690118] EIP: 0060:[<c024af62>] EFLAGS: 00010286 CPU: 0
[  103.690118] EIP is at __journal_abort_soft+0x12/0x60
[  103.690118] EAX: cdc38bf0 EBX: c82c5bf0 ECX: c012ae25 EDX: fffffffb
[  103.690118] ESI: c822cbf0 EDI: c0c05520 EBP: c82efebc ESP: c82efeb4
[  103.690118]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  103.690118] Process umount (pid: 4083, ti=c82ef000 task=c81e5718 task.ti=c82ef000)
[  103.690118] Stack:
[  103.690118]  c82c5bf0 c822cbf0 c82efec4 c024afbd c82efee0 c02262ac c0b061c4 c82efef4
[  103.690118]  c08dd552 c82efef4 c9e4a400 c82eff14 c02276f3 c82c5bf0 c08dd552 c0af3dfa
[  103.690118]  00000001 c82c5cb8 00000001 c82eff00 c82c5bf0 c82c5bf0 c08dd440 c0c05520
[  103.690118] Call Trace:
[  103.690118]  [<c024afbd>] ? jbd2_journal_abort+0xd/0x10
[  103.690118]  [<c02262ac>] ? ext4_abort+0xac/0xc0
[  103.690118]  [<c02276f3>] ? ext4_put_super+0x233/0x240
[  103.690118]  [<c019fe74>] ? generic_shutdown_super+0x54/0xd0
[  103.690118]  [<c08c868c>] ? down_write+0x4c/0x70
[  103.690118]  [<c01d6b20>] ? vfs_quota_off+0x0/0x5b0
[  103.690118]  [<c019ff04>] ? kill_block_super+0x14/0x30
[  103.690118]  [<c01a038a>] ? deactivate_super+0x7a/0x90
[  103.690118]  [<c01b33b8>] ? mntput_no_expire+0x58/0xd0
[  103.690118]  [<c01b3eb4>] ? sys_umount+0x54/0x310
[  103.690118]  [<c01b418e>] ? sys_oldumount+0x1e/0x20
[  103.690118]  [<c0103331>] ? sysenter_do_call+0x12/0x31
[  103.690118] Code: 89 4c 24 04 89 44 24 0c c7 04 24 54 a5 b0 c0 e8 95 04 ee fe 55 83 08 24 89 04 8d 26 00 02 c3 d6 15 40 75 03 04 d8 [  103.690118] EIP: [<c024af62>] __journal_abort_soft+0x12/0x60 SS:ESP 0068:c82efeb4
[  103.690118] ---[ end trace ac2604a9331c3848 ]---
[  103.690118] ------------[ cut here ]------------
[  103.690118] WARNING: at kernel/exit.c:1001 do_exit+0x820/0x830()
[  103.690118] Modules linked in:
[  103.690118] Pid: 4083, comm: umount Tainted: G      D   2.6.27 #48
[  103.690118] Call Trace:
[  103.690118]  [<c012a4d9>] warn_on_slowpath+0x59/0x80
[  103.690118]  [<c08c9a8c>] ? _spin_unlock_irqrestore+0x3c/0x60
[  103.690118]  [<c014a644>] ? trace_hardirqs_off_caller+0x14/0xa0
[  103.690118]  [<c014a6db>] ? trace_hardirqs_off+0xb/0x10
[  103.690118]  [<c08c9a8c>] ? _spin_unlock_irqrestore+0x3c/0x60
[  103.690118]  [<c012ae39>] ? release_console_sem+0x1c9/0x1e0
[  103.690118]  [<c0142b6f>] ? blocking_notifier_call_chain+0x1f/0x30
[  103.690118]  [<c012d040>] do_exit+0x820/0x830
[  103.690118]  [<c016ff76>] ? ftrace_record_ip+0xc6/0x1c0
[  103.690118]  [<c012b400>] ? printk+0x20/0x30
[  103.690118]  [<c012a3ef>] ? print_oops_end_marker+0x2f/0x40
[  103.690118]  [<c01058a5>] oops_end+0x95/0xa0
[  103.690118]  [<c01060f5>] die+0x55/0x70
[  103.690118]  [<c011a248>] do_page_fault+0x1b8/0x670
[  103.690118]  [<c011a090>] ? do_page_fault+0x0/0x670
[  103.690118]  [<c08c9c87>] error_code+0x6f/0x74
[  103.690118]  [<c012ae25>] ? release_console_sem+0x1b5/0x1e0
[  103.690118]  [<c024af62>] ? __journal_abort_soft+0x12/0x60
[  103.690118]  [<c024afbd>] jbd2_journal_abort+0xd/0x10
[  103.690118]  [<c02262ac>] ext4_abort+0xac/0xc0
[  103.690118]  [<c02276f3>] ext4_put_super+0x233/0x240
[  103.690118]  [<c019fe74>] generic_shutdown_super+0x54/0xd0
[  103.690118]  [<c08c868c>] ? down_write+0x4c/0x70
[  103.690118]  [<c01d6b20>] ? vfs_quota_off+0x0/0x5b0
[  103.690118]  [<c019ff04>] kill_block_super+0x14/0x30
[  103.690118]  [<c01a038a>] deactivate_super+0x7a/0x90
[  103.690118]  [<c01b33b8>] mntput_no_expire+0x58/0xd0
[  103.690118]  [<c01b3eb4>] sys_umount+0x54/0x310
[  103.690118]  [<c01b418e>] sys_oldumount+0x1e/0x20
[  103.690118]  [<c0103331>] sysenter_do_call+0x12/0x31
[  103.690118] ---[ end trace ac2604a9331c3848 ]---


(gdb) l *(__journal_abort_soft+0x12)
0xc024af62 is in __journal_abort_soft (fs/jbd2/journal.c:1839).
1834	
1835	/* Soft abort: record the abort error status in the journal superblock,
1836	 * but don't do any other IO. */
1837	static void __journal_abort_soft (journal_t *journal, int errno)
1838	{
1839		if (journal->j_flags & JBD2_ABORT)
1840			return;
1841	
1842		if (!journal->j_errno)
1843			journal->j_errno = errno;
(gdb) 

Greetings, Eric
