From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66881] New: [3.12.1][ext4]kernel BUG at
 fs/ext4/extents_status.c:709!
Date: Thu, 12 Dec 2013 04:56:16 +0000
Message-ID: <bug-66881-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34668 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3LLE4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Dec 2013 23:56:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1F2B12026D
	for <linux-ext4@vger.kernel.org>; Thu, 12 Dec 2013 04:56:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 21C11201BD
	for <linux-ext4@vger.kernel.org>; Thu, 12 Dec 2013 04:56:17 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66881

            Bug ID: 66881
           Summary: [3.12.1][ext4]kernel BUG at
                    fs/ext4/extents_status.c:709!
           Product: File System
           Version: 2.5
    Kernel Version: 3.12.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: rnsastry@linux.vnet.ibm.com
        Regression: No

With 'fsfuzz - file system fuzzer' found the following kernel bug:

[  416.118860] ------------[ cut here ]------------
[  416.118865] kernel BUG at fs/ext4/extents_status.c:709!
[  416.118909] illegal operation: 0001 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  416.118915] Modules linked in: loop dm_multipath scsi_dh dm_mod vmur autofs4
[  416.118925] CPU: 0 PID: 798 Comm: fstest Not tainted 3.12.1 #1
[  416.118928] task: 000000003c3b4b20 ti: 000000003d0b8000 task.ti:
000000003d0b8000
[  416.118939] Krnl PSW : 0704d00180000000 00000000003c68ec
(ext4_es_cache_extent+0x144/0x1e8)
[  416.118942]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0
EA:3
Krnl GPRS: 0000000000000000 0000000000000020 000000003c44c950 000000000000ae56
[  416.118947]            00000000ffff798a 1fffffffffffffff 1000000000000000
000000003688a848
[  416.118950]            0000000000000020 000000003688a854 000000000000ae56
00000000ffff798a
[  416.118952]            000000003c44c950 00000000000027df 000000003d0bb648
000000003d0bb5c0
[  416.118962] Krnl Code: 00000000003c68e2: 15da                clr    
%r13,%r10
           00000000003c68e4: a7a40004           brc     10,3c68ec
          #00000000003c68e8: a7f40001           brc     15,3c68ea
          >00000000003c68ec: 41b0c488           la      %r11,1160(%r12)
           00000000003c68f0: b904002b           lgr     %r2,%r11
           00000000003c68f4: c0e5001ad134       brasl   %r14,720b5c
           00000000003c68fa: 4120c478           la      %r2,1144(%r12)
           00000000003c68fe: b904003a           lgr     %r3,%r10
[  416.118987] Call Trace:
[  416.118990] ([<00000000003c6930>] ext4_es_cache_extent+0x188/0x1e8)
[  416.118993]  [<00000000003a69c6>] __read_extent_tree_block+0x2de/0x410
[  416.118996]  [<00000000003a793c>] ext4_ext_find_extent+0x210/0x43c
[  416.118998]  [<00000000003acf12>] ext4_ext_map_blocks+0x196/0x1d30
[  416.119002]  [<0000000000379e06>] ext4_map_blocks+0xfe/0x544
[  416.119005]  [<000000000037c0f8>] _ext4_get_block+0xf4/0x1e0
[  416.119009]  [<00000000002f5574>] do_mpage_readpage+0x220/0x770
[  416.119012]  [<00000000002f5b76>] mpage_readpages+0xb2/0x11c
[  416.119016]  [<000000000024648e>] __do_page_cache_readahead+0x292/0x34c
[  416.119019]  [<000000000024685a>] ra_submit+0x42/0x54
[  416.119021]  [<0000000000246ea8>] page_cache_sync_readahead+0x70/0x80
[  416.119025]  [<0000000000239450>] generic_file_aio_read+0x308/0x8ac
[  416.119029]  [<00000000002a78b6>] do_sync_read+0x7e/0xac
[  416.119032]  [<00000000002a885c>] vfs_read+0x98/0x16c
[  416.119035]  [<00000000002a8b32>] SyS_read+0x5e/0x9c
[  416.119039]  [<0000000000721efc>] sysc_nr_ok+0x22/0x28
[  416.119042]  [<000003fffd147e98>] 0x3fffd147e98
[  416.119044] INFO: lockdep is turned off.
[  416.119046] Last Breaking-Event-Address:
[  416.119048]  [<00000000003c68e8>] ext4_es_cache_extent+0x140/0x1e8
[  416.119052]
[  416.119055] Kernel panic - not syncing: Fatal exception: panic_on_oops



And the reason is:
from v3.12.1/fs/ext4/extents.c
...
 506                        if (prev && (prev != lblk))
 507                                ext4_es_cache_extent(inode, prev,
 508                                                     lblk - prev, ~0,
 509                                                     EXTENT_STATUS_HOLE);

Suggested solution:
There should be extra condition for checking 'prev' can not be bigger than
'lblk',
because the difference is passed to 'ext4_es_cache_extent' as len.
And this 'len' is used in other calculations.

v3.12.1/fs/ext4/extents_status.c
...
 698        ext4_lblk_t end = lblk + len - 1;
...
 706        if (!len)
 707                return;
 708
 709        BUG_ON(end < lblk);
...

Proof:
Here is the calculation from real data:
when,
prev=44630
lblk=10208
prev != lblk condition passed and
len = lblk - prev
len = 10208 - 44630 = -34422
since 'len' is of data type 'ext4_lblk_t' -> '_u32' it overflowed.
The variable 'end' is depending on 'len' and it hits the bug at
"BUG_ON(end < lblk);" .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
