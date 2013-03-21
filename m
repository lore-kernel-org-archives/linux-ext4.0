From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: xfstest failure: #68, with data=journal
Date: Thu, 21 Mar 2013 18:12:18 -0400
Message-ID: <20130321221218.GA3349@wallace>
References: <nsxfvzov3em.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:44288 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3CUWMZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2013 18:12:25 -0400
Received: by mail-vb0-f50.google.com with SMTP id ft2so2236799vbb.23
        for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2013 15:12:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <nsxfvzov3em.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> 
> I'm not sure why I wasn't seeing this test fail earlier, but I'm now
> seeing the following reliable test failure.  I can repro on v3.8-rc3
> (although when I took my baseline on February 21st it test #68 was
> passing), which is why I didn't let this hold up sending a PULL request
> to Linus.
> 
> Regardless of why it wasn't failing earlier, I'm now seeing it failing
> reliably on two different testing setups, with the following kernel BUG:
> 
> BEGIN TEST: Ext4 4k block w/data=journal Thu Mar 21 17:27:32 EDT 2013
> Device: /dev/vdb
> mk2fs options: -q
> mount options: -o block_validity,data=journal
> 000 - unknown test, ignored
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 candygram 9b2ff35753c0
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/vdc /vdc
> 
> [   27.640833] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
> 068	[   81.197193] fsstress (3426) used greatest stack depth: 5724 bytes left
> [   87.114210] fsstress (3425) used greatest stack depth: 5660 bytes left
> [   98.464599] ------------[ cut here ]------------
> [   98.466113] kernel BUG at /usr/projects/linux/ext4/fs/jbd2/transaction.c:2016!
> [   98.467335] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [   98.467335] Modules linked in:
> [   98.467335] Pid: 3449, comm: fstest Not tainted 3.8.0-rc3 #1036 Bochs Bochs
> [   98.467335] EIP: 0060:[<c02b2f8f>] EFLAGS: 00010206 CPU: 1
> [   98.467335] EIP is at jbd2_journal_invalidatepage+0x1ce/0x23a
> [   98.467335] EAX: 001c4025 EBX: cee4a588 ECX: 00000000 EDX: 00000001
> [   98.467335] ESI: c8622800 EDI: 00000000 EBP: ce82dcd0 ESP: ce82dca0
> [   98.467335]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   98.467335] CR0: 80050033 CR2: b75d1000 CR3: 0eb2c000 CR4: 000006f0
> [   98.467335] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   98.467335] DR6: ffff0ff0 DR7: 00000400
> [   98.467335] Process fstest (pid: 3449, ti=ce82c000 task=c82dc220 task.ti=ce82c000)
> [   98.467335] Stack:
> [   98.467335]  ceed2b48 cee4a588 00001000 cee4a588 00000000 00000001 c8622b80 c8622814
> [   98.467335]  cfe76ec8 c022f624 cfe76ec8 00000000 ce82dce8 c02748cc c8622800 c022f624
> [   98.467335]  ceefc29c cfe76ec8 ce82dcf0 c0274cd6 ce82dcfc c01e9aa0 cfe76ec8 ce82dd0c
> [   98.467335] Call Trace:
> [   98.467335]  [<c022f624>] ? bh_uptodate_or_lock+0x30/0x30
> [   98.467335]  [<c02748cc>] __ext4_journalled_invalidatepage+0x5a/0x6e
> [   98.467335]  [<c022f624>] ? bh_uptodate_or_lock+0x30/0x30
> [   98.467335]  [<c0274cd6>] ext4_journalled_invalidatepage+0xd/0x22
> [   98.467335]  [<c01e9aa0>] do_invalidatepage+0x21/0x24
> [   98.467335]  [<c01e9aed>] truncate_inode_page+0x4a/0x72
> [   98.467335]  [<c01e9bbb>] truncate_inode_pages_range+0xa6/0x207
> [   98.467335]  [<c01e9dc8>] truncate_inode_pages+0x11/0x15
> [   98.467335]  [<c01e9e1c>] truncate_pagecache+0x50/0x6d
> [   98.467335]  [<c0278cc2>] ext4_setattr+0x3dc/0x47d
> [   98.467335]  [<c02788e6>] ? ext4_mark_inode_dirty+0x1c9/0x1c9
> [   98.467335]  [<c0220459>] notify_change+0x1af/0x282
> [   98.467335]  [<c020c642>] do_truncate+0x63/0x82
> [   98.467335]  [<c0217ab8>] do_last+0x7c1/0x8c2
> [   98.467335]  [<c0215c01>] ? link_path_walk+0x9c/0x3a7
> [   98.467335]  [<c0217c58>] path_openat+0x9f/0x2ae
> [   98.467335]  [<c0182c68>] ? sched_clock_cpu+0x11a/0x13e
> [   98.467335]  [<c02180c9>] do_filp_open+0x26/0x62
> [   98.467335]  [<c0221290>] ? __alloc_fd+0xbf/0xc9
> [   98.467335]  [<c020d155>] do_sys_open+0x59/0xcf
> [   98.467335]  [<c07281a4>] ? fetch_memory_u32+0x58/0x58
> [   98.467335]  [<c020d1eb>] sys_open+0x20/0x25
> [   98.467335]  [<c0723350>] syscall_call+0x7/0xb
> [   98.467335]  [<c0720000>] ? skb_warn_bad_offload+0x3b/0x9d
> [   98.467335] Code: e8 d9 ea ff ff 89 d8 e8 2c eb ff ff 8b 45 ec e8 f0 fa 46 00 eb 05 bf 01 00 00 00 89 d8 e8 95 ea ff ff 8b 03 a9 00 00 08 00 74 02 <0f> 0b f0 80 23 df f0 80 23 f7 f0 80 23 bf f0 80 63 01 fd f0 80
> [   98.467335] EIP: [<c02b2f8f>] jbd2_journal_invalidatepage+0x1ce/0x23a SS:ESP 0068:ce82dca0
> [   98.518357] ---[ end trace 5a1e3fce364fcdf8 ]---
> 
> 
> BEGIN TEST: Ext4 4k block w/data=journal Thu Mar 21 13:16:40 EDT 2013
> Device: /dev/vdb
> mk2fs options: -q
> mount options: -o block_validity,data=journal
> 000 - unknown test, ignored
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 candygram 3.8.0-rc3
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/vdc /vdc
> 
> [   27.669520] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
> 068	[   53.589583] ------------[ cut here ]------------
> [   53.590024] kernel BUG at /usr/projects/linux/ext4/fs/jbd2/transaction.c:1986!
> [   53.593358] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [   53.593358] Modules linked in:
> [   53.593358] Pid: 3373, comm: fstest Not tainted 3.8.0-rc3 #1034 Bochs Bochs
> [   53.593358] EIP: 0060:[<c02b11d4>] EFLAGS: 00010206 CPU: 0
> [   53.593358] EIP is at jbd2_journal_invalidatepage+0x1ce/0x23a
> [   53.593358] EAX: 001c4025 EBX: cee97eb8 ECX: 00000000 EDX: 00000001
> [   53.593358] ESI: c8b72800 EDI: 00000000 EBP: c66abcd0 ESP: c66abca0
> [   53.593358]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   53.593358] CR0: 80050033 CR2: b7124004 CR3: 0eaad000 CR4: 000006f0
> [   53.593358] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   53.593358] DR6: ffff0ff0 DR7: 00000400
> [   53.593358] Process fstest (pid: 3373, ti=c66aa000 task=c88545e0 task.ti=c66aa000)
> [   53.593358] Stack:
> [   53.593358]  cee03888 cee97eb8 00001000 cee97eb8 00000000 00000001 c8b72b80 c8b72814
> [   53.593358]  cfe75554 c022f624 cfe75554 00000000 c66abce8 c0274860 c8b72800 c022f624
> [   53.593358]  cefcc29c cfe75554 c66abcf0 c0274cf1 c66abcfc c01e9aa0 cfe75554 c66abd0c
> [   53.593358] Call Trace:
> [   53.593358]  [<c022f624>] ? bh_uptodate_or_lock+0x30/0x30
> [   53.593358]  [<c0274860>] __ext4_journalled_invalidatepage+0x5a/0x6e
> [   53.593358]  [<c022f624>] ? bh_uptodate_or_lock+0x30/0x30
> [   53.593358]  [<c0274cf1>] ext4_journalled_invalidatepage+0xd/0x22
> [   53.593358]  [<c01e9aa0>] do_invalidatepage+0x21/0x24
> [   53.593358]  [<c01e9aed>] truncate_inode_page+0x4a/0x72
> [   53.593358]  [<c01e9bbb>] truncate_inode_pages_range+0xa6/0x207
> [   53.593358]  [<c01e9dc8>] truncate_inode_pages+0x11/0x15
> [   53.593358]  [<c01e9e1c>] truncate_pagecache+0x50/0x6d
> [   53.593358]  [<c0278b53>] ext4_setattr+0x3bd/0x45c
> [   53.593358]  [<c0278796>] ? ext4_mark_inode_dirty+0x1c9/0x1c9
> [   53.593358]  [<c0220459>] notify_change+0x1af/0x282
> [   53.593358]  [<c020c642>] do_truncate+0x63/0x82
> [   53.593358]  [<c0217ab8>] do_last+0x7c1/0x8c2
> [   53.593358]  [<c0215c01>] ? link_path_walk+0x9c/0x3a7
> [   53.593358]  [<c0217c58>] path_openat+0x9f/0x2ae
> [   53.593358]  [<c0182c68>] ? sched_clock_cpu+0x11a/0x13e
> [   53.593358]  [<c02180c9>] do_filp_open+0x26/0x62
> [   53.593358]  [<c0221290>] ? __alloc_fd+0xbf/0xc9
> [   53.593358]  [<c020d155>] do_sys_open+0x59/0xcf
> [   53.593358]  [<c07281a4>] ? iret_exc+0x48c/0xaa8
> [   53.593358]  [<c020d1eb>] sys_open+0x20/0x25
> [   53.593358]  [<c0720c38>] syscall_call+0x7/0xb
> [   53.593358] Code: e8 d0 ec ff ff 89 d8 e8 23 ed ff ff 8b 45 ec e8 93 f1 46 00 eb 05 bf 01 00 00 00 89 d8 e8 8c ec ff ff 8b 03 a9 00 00 08 00 74 02 <0f> 0b f0 80 23 df f0 80 23 f7 f0 80 23 bf f0 80 63 01 fd f0 80
> [   53.593358] EIP: [<c02b11d4>] jbd2_journal_invalidatepage+0x1ce/0x23a SS:ESP 0068:c66abca0
> [   53.673641] ---[ end trace bb1d9ddb16e2dd7e ]---
> 

We were giving this one some attention in late February on the mailing list,
but I don't think a full solution was found.  Here's a pointer to Jan Kara's
analysis:

http://www.spinics.net/lists/linux-ext4/msg36858.html

Back then, it typically took a number of runs to see this problem.

Eric

