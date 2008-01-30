From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: [Bugme-new] [Bug 9849] New: NULL pointer deref in
 journal_wait_on_commit_record
Date: Wed, 30 Jan 2008 12:00:55 -0800
Message-ID: <20080130120055.7dc3331b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYA3UBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Begin forwarded message:

Date: Wed, 30 Jan 2008 03:24:08 -0800 (PST)
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 9849] New: NULL pointer deref in journal_wait_on_commit_record


http://bugzilla.kernel.org/show_bug.cgi?id=9849

           Summary: NULL pointer deref in journal_wait_on_commit_record
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.24-03997-g85004cc
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: snakebyte@gmx.de


Latest working kernel version: -
Earliest failing kernel version: 2.6.24-03863-g0ba6c33
Distribution: Ubuntu
Problem Description:

using a corrupted image causes an oops in unmount, seems as if
journal_wait_on_commit_record() gets passed a NULL pointer

Steps to reproduce:

using fsfuzz with ext4, I'll attach the image which causes this for me

one oops can be found here
http://kerneloops.org/raw.php?rawid=3160&msgid=

here is another one with full jbd2 debugging enabled (there are a lot of
log_do_checkpoint messages above this)

[  242.863778] (fs/jbd2/checkpoint.c, 308): jbd2_log_do_checkpoint: Start
checkpoint
[  242.863790] (fs/jbd2/checkpoint.c, 316): jbd2_log_do_checkpoint:
cleanup_journal_tail returned 1
[  242.863810] (fs/jbd2/checkpoint.c, 308): jbd2_log_do_checkpoint: Start
checkpoint
[  242.863822] (fs/jbd2/checkpoint.c, 316): jbd2_log_do_checkpoint:
cleanup_journal_tail returned 1
[  242.863842] (fs/jbd2/checkpoint.c, 308): jbd2_log_do_checkpoint: Start
checkpoint
[  242.863854] (fs/jbd2/checkpoint.c, 316): jbd2_log_do_checkpoint:
cleanup_journal_tail returned 1
[  242.863874] (fs/jbd2/checkpoint.c, 308): jbd2_log_do_checkpoint: Start
checkpoint
[  242.863886] (fs/jbd2/checkpoint.c, 316): jbd2_log_do_checkpoint:
cleanup_journal_tail returned 1
[  242.864017] (fs/jbd2/journal.c, 193): kjournald2: kjournald2 wakes
[  242.864027] (fs/jbd2/journal.c, 201): kjournald2: woke because of timeout
[  242.864035] (fs/jbd2/journal.c, 145): kjournald2: commit_sequence=1,
commit_request=2
[  242.864044] (fs/jbd2/journal.c, 148): kjournald2: OK, requests differ
[  242.864055] (fs/jbd2/commit.c, 415): jbd2_journal_commit_transaction: super
block updated
[  242.864066] (fs/jbd2/journal.c, 1264): jbd2_journal_update_superblock: JBD:
updating superblock (start 15335425, seq 2, errno 0)
[  242.864385] (fs/jbd2/commit.c, 428): jbd2_journal_commit_transaction: JBD:
starting commit of transaction 2
[  242.864409] (fs/jbd2/commit.c, 501): jbd2_journal_commit_transaction: JBD:
commit phase 1
[  242.864428] (fs/jbd2/commit.c, 519): jbd2_journal_commit_transaction: JBD:
commit phase 2
[  242.864459] (fs/jbd2/revoke.c, 537): jbd2_journal_write_revoke_records:
Wrote 0 revoke records
[  242.864469] (fs/jbd2/commit.c, 561): jbd2_journal_commit_transaction: JBD:
commit phase 2
[  242.864478] (fs/jbd2/commit.c, 571): jbd2_journal_commit_transaction: JBD:
commit phase 3
[  242.864487] (fs/jbd2/commit.c, 780): jbd2_journal_commit_transaction: JBD:
commit phase 4
[  242.864496] (fs/jbd2/commit.c, 839): jbd2_journal_commit_transaction: JBD:
commit phase 5
[  242.864505] (fs/jbd2/commit.c, 866): jbd2_journal_commit_transaction: JBD:
commit phase 6
[  242.864599] attempt to access beyond end of device
[  242.864609] loop0: rw=0, want=200708, limit=16384
[  242.864633] jbd2_journal_bmap: journal block not found at offset 15335425 on
loop0
[  242.864680] Aborting journal on device loop0.
[  242.864733] (fs/jbd2/journal.c, 1264): jbd2_journal_update_superblock: JBD:
updating superblock (start 15335425, seq 2, errno -5)
[  242.864868] BUG: unable to handle kernel NULL pointer dereference at virtual
address 00000000
[  242.864962] printing eip: c023c2a7 *pde = 00000000 
[  242.865048] Oops: 0002 [#1] PREEMPT 
[  242.865108] Modules linked in:
[  242.865218] 
[  242.865243] Pid: 3698, comm: kjournald2 Not tainted (2.6.24-03997-g85004cc
#16)
[  242.865268] EIP: 0060:[<c023c2a7>] EFLAGS: 00010202 CPU: 0
[  242.865382] EIP is at journal_wait_on_commit_record+0x7/0x50
[  242.865407] EAX: 00000000 EBX: 00000000 ECX: 00000001 EDX: 00000001
[  242.865431] ESI: 00000000 EDI: c07835d2 EBP: cb229ee4 ESP: cb229edc
[  242.865455]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  242.865539] Process kjournald2 (pid: 3698, ti=cb229000 task=cb208000
task.ti=cb229000)
[  242.865564] Stack: 00000000 00000000 cb229f88 c023cb07 ffffffff c07835d2
00000362 c069c620 
[  242.865864]        cb2316e0 cb231504 cb2314f0 cb134960 00000000 cb231920
00000000 00000000 
[  242.865918]        cb208000 00000000 00000000 00000008 ffffffff 00000000
00000000 00000000 
[  242.865918] Call Trace:
[  242.865918]  [<c0104c0a>] show_trace_log_lvl+0x1a/0x30
[  242.865918]  [<c0104cc9>] show_stack_log_lvl+0xa9/0xd0
[  242.865918]  [<c0104dba>] show_registers+0xca/0x250
[  242.865918]  [<c01051e1>] die+0x101/0x220
[  242.865918]  [<c011759b>] do_page_fault+0x28b/0x630
[  242.865918]  [<c0682d52>] error_code+0x6a/0x70
[  242.865918]  [<c023cb07>] jbd2_journal_commit_transaction+0x627/0x12a0
[  242.865918]  [<c02422d1>] kjournald2+0xd1/0x3b0
[  242.865918]  [<c0136d22>] kthread+0x42/0x70
[  242.865918]  [<c0104667>] kernel_thread_helper+0x7/0x10
[  242.865918]  =======================
[  242.865918] Code: 8d 74 26 00 e8 db 43 44 00 e9 3e ff ff ff 8d b6 00 00 00
00 e8 cb 43 44 00 eb d1 0f 0b eb fe 90 8d 74 26 00 55 89 e5 56 89 c6 53 <0f> ba
30 01 b8 6b 07 78 c0 ba 3e 01 00 00 e8 d6 18 ee ff 8b 06 
[  242.865918] EIP: [<c023c2a7>] journal_wait_on_commit_record+0x7/0x50 SS:ESP
0068:cb229edc
[  242.865954] ---[ end trace 66f543972254226c ]---
[  242.879551] (fs/jbd2/checkpoint.c, 308): jbd2_log_do_checkpoint: Start
checkpoint
[  242.879631] (fs/jbd2/checkpoint.c, 316): jbd2_log_do_checkpoint:
cleanup_journal_tail returned 1
[  242.879731] ext4_abort called.
[  242.879755] EXT4-fs error (device loop0): ext4_journal_start_sb: Detected
aborted journal
[  242.879846] Remounting filesystem read-only
[  242.897757] EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry
in directory #2: inode out of bounds - offset=24, inode=11019, rec_len=2024,
name_len=10
[  243.177213] EXT4-fs error (device loop0): htree_dirblock_to_tree: bad entry
in directory #2: inode out of bounds - offset=24, inode=11019, rec_len=2024,
name_len=10
[  243.501597] (fs/jbd2/journal.c, 544): jbd2_log_wait_commit: JBD: want 2,
j_commit_sequence=1


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
