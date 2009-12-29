From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14911] kernel BUG at fs/ext4/inode.c
Date: Tue, 29 Dec 2009 07:46:59 GMT
Message-ID: <200912290746.nBT7kxwP024874@demeter.kernel.org>
References: <bug-14911-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59662 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZL2HrA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 02:47:00 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBT7kxT9024876
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 07:46:59 GMT
In-Reply-To: <bug-14911-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14911


Artem Anisimov <aanisimov@inbox.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aanisimov@inbox.ru




--- Comment #1 from Artem Anisimov <aanisimov@inbox.ru>  2009-12-29 07:46:56 ---
I am experiencing a similar problem with ext4 (BUG at inode.c:1063) and I'd
like to provide some more information on it.

In my setup /boot partition is mounted read-only at startup. The error occurs
when I remount it rw and try to copy a file to that partition.

Stack trace that I get is, however, a bit different, so it's necessary to note
that I use UP implementation of RCU (in my case mpage_da_map_blocks() is called
from rcu_read_unlock()).

Here is my stack trace and error message:

kernel BUG at fs/ext4/inode.c:1063!
invalid opcode: 0000 [#1] PREEMPT
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:01:05.0/resource
Modules linked in: ipw2200 libipw

Pid: 2415, comm: flush-8:0 Not tainted 2.6.33-rc2 #2 M5A       /M5A
EIP: 0060:[<c10a704c>] EFLAGS: 00010297 CPU: 0
EIP is at ext4_get_blocks+0x19f/0x297
EAX: 00000001 EBX: 00000002 ECX: 00000009 EDX: 00000006
ESI: 00000009 EDI: d71e5d5c EBP: f6d20648 ESP: d71e5d18
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process flush-8:0 (pid: 2415, ti=d71e4000 task=e5bfd130 task.ti=d71e4000)
Stack:
 f6d206c8 00000040 000006fe 0000010c f6d206bc f69cf200 d71e5d5c e5bfd130
<0> d71e5e88 f6e73000 c10a7236 00000040 d71e5d5c 0000000d 0000010c e234fa68
<0> 00000000 00000060 0000000e d71e5d70 0000110d 00000400 0000005f f6d011c0
Call Trace:
 [<c10a7236>] ? mpage_da_map_blocks+0x74/0x2ab
 [<c1044e59>] ? rcu_read_unlock+0x14/0x1e
 [<c10456c5>] ? find_get_pages_tag+0x9b/0xb7
 [<c10a78d1>] ? mpage_add_bh_to_extent+0x6f/0x86
 [<c10a79b7>] ? __mpage_da_writepage+0xcf/0x10a
 [<c104aa56>] ? write_cache_pages+0x16e/0x232
 [<c10a78e8>] ? __mpage_da_writepage+0x0/0x10a
 [<c10a76e1>] ? ext4_da_writepages+0x274/0x3f5
 [<c104ab4b>] ? do_writepages+0x14/0x20
 [<c107e5d2>] ? writeback_single_inode+0xca/0x260
 [<c107ee39>] ? writeback_inodes_wb+0x337/0x3f1
 [<c107efe2>] ? wb_writeback+0xef/0x14c
 [<c1310827>] ? schedule+0x2af/0x2bf
 [<c107f122>] ? wb_do_writeback+0x68/0x132
 [<c107f20c>] ? bdi_writeback_task+0x20/0x7b
 [<c10522a9>] ? bdi_start_fn+0x51/0xa0
 [<c1052258>] ? bdi_start_fn+0x0/0xa0
 [<c102a879>] ? kthread+0x5e/0x63
 [<c102a81b>] ? kthread+0x0/0x63
 [<c1002af6>] ? kernel_thread_helper+0x6/0x10
Code: 08 89 c2 8b 04 24 e8 09 ed ff ff 89 c6 8b 85 f0 01 00 00 39 c6 76 04 0f
0b eb fe 31 db 29 f0 74 35 8b 9d f4 01 00 00 39 d8 7d 04 <0f> 0b eb fe 89 c2 8b
44 24 14 29 da 89 d1 c1 f9 1f 05 a8 00 00
EIP: [<c10a704c>] ext4_get_blocks+0x19f/0x297 SS:ESP 0068:d71e5d18
---[ end trace 5e36b9d9dd2f2ce5 ]---
note: flush-8:0[2415] exited with preempt_count 1

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
