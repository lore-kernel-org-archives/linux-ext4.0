From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 15 Apr 2010 08:45:22 GMT
Message-ID: <201004150845.o3F8jMsx024449@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49199 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab0DOIpX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 04:45:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3F8jMT2024450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Apr 2010 08:45:22 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830


Neil Broomfield <neil.broomfield@caasaudio.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |neil.broomfield@caasaudio.c
                   |                            |om




--- Comment #33 from Neil Broomfield <neil.broomfield@caasaudio.com>  2010-04-15 08:44:13 ---
I think I might be seeing the same/similar issue, see "dmesg | tail" below, it
seams fairly repeatable and occurs usually when I move a file from my download
drive to my raid array 5 (5 disk, 6TB), I'm running Ubuntu 9.10 with all the
latest official patches.

[301080.930044] INFO: task kjournald2:1583 blocked for more than 120 seconds.
[301080.930048] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[301080.930051] kjournald2    D ffff88007734e8e0     0  1583      2 0x00000000
[301080.930056]  ffff88006c38dd10 0000000000000046 ffff88005695d850
0000000000015880
[301080.930060]  ffff880070d247c0 0000000000015880 0000000000015880
0000000000015880
[301080.930063]  0000000000015880 ffff880070d247c0 0000000000015880
0000000000015880
[301080.930066] Call Trace:
[301080.930075]  [<ffffffff811f096a>]
jbd2_journal_commit_transaction+0x1aa/0x1120
[301080.930080]  [<ffffffff8127c336>] ? rb_erase+0xd6/0x160
[301080.930085]  [<ffffffff81010785>] ? __switch_to+0x1e5/0x370
[301080.930088]  [<ffffffff8104f075>] ? finish_task_switch+0x65/0x120
[301080.930093]  [<ffffffff8152c98a>] ? _spin_lock_irqsave+0x2a/0x40
[301080.930097]  [<ffffffff8106af57>] ? lock_timer_base+0x37/0x70
[301080.930101]  [<ffffffff81078a30>] ? autoremove_wake_function+0x0/0x40
[301080.930105]  [<ffffffff811f6963>] kjournald2+0x103/0x270
[301080.930108]  [<ffffffff81078a30>] ? autoremove_wake_function+0x0/0x40
[301080.930111]  [<ffffffff811f6860>] ? kjournald2+0x0/0x270
[301080.930114]  [<ffffffff81078646>] kthread+0xa6/0xb0
[301080.930117]  [<ffffffff8101316a>] child_rip+0xa/0x20
[301080.930120]  [<ffffffff810785a0>] ? kthread+0x0/0xb0
[301080.930123]  [<ffffffff81013160>] ? child_rip+0x0/0x20
[301080.930145] INFO: task mv:2005 blocked for more than 120 seconds.
[301080.930146] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[301080.930148] mv            D ffff880079705928     0  2005   2464 0x00000000
[301080.930152]  ffff8800210f9868 0000000000000086 ffff8800210f97e8
0000000000015880
[301080.930155]  ffff880003b747c0 0000000000015880 0000000000015880
0000000000015880
[301080.930159]  0000000000015880 ffff880003b747c0 0000000000015880
0000000000015880
[301080.930162] Call Trace:
[301080.930165]  [<ffffffff8152c87d>] __down_read+0x8d/0xc6
[301080.930169]  [<ffffffff8152bc49>] down_read+0x19/0x20
[301080.930172]  [<ffffffff811b5fe2>] ext4_get_blocks+0x52/0x210
[301080.930175]  [<ffffffff811b62e7>] ext4_da_get_block_prep+0x77/0x100
[301080.930179]  [<ffffffff81148663>] __block_prepare_write+0x1c3/0x560
[301080.930182]  [<ffffffff811b6270>] ? ext4_da_get_block_prep+0x0/0x100
[301080.930185]  [<ffffffff81148b9f>] block_write_begin+0x5f/0x100
[301080.930188]  [<ffffffff811b8a0d>] ext4_da_write_begin+0x12d/0x260
[301080.930191]  [<ffffffff811b6270>] ? ext4_da_get_block_prep+0x0/0x100
[301080.930194]  [<ffffffff8104f075>] ? finish_task_switch+0x65/0x120
[301080.930198]  [<ffffffff810da1a2>] generic_perform_write+0xb2/0x1d0
[301080.930202]  [<ffffffff811e4dbb>] ? ext4_xattr_get+0x5b/0x90
[301080.930206]  [<ffffffff810dafd3>] generic_file_buffered_write+0x83/0x140
[301080.930209]  [<ffffffff810dc950>]
__generic_file_aio_write_nolock+0x240/0x470
[301080.930213]  [<ffffffff811348f3>] ? touch_atime+0x33/0x150
[301080.930216]  [<ffffffff810dcca0>] generic_file_aio_write+0x70/0xf0
[301080.930221]  [<ffffffff811ae7f9>] ext4_file_write+0x49/0x160
[301080.930225]  [<ffffffff8111f342>] do_sync_write+0xf2/0x130
[301080.930229]  [<ffffffff811511db>] ? fsnotify+0xfb/0x140
[301080.930232]  [<ffffffff81078a30>] ? autoremove_wake_function+0x0/0x40
[301080.930235]  [<ffffffff81133333>] ? dput+0xc3/0x190
[301080.930239]  [<ffffffff81224a11>] ? security_file_permission+0x11/0x20
[301080.930242]  [<ffffffff8111f628>] vfs_write+0xb8/0x1a0
[301080.930245]  [<ffffffff811200dc>] sys_write+0x4c/0x80
[301080.930249]  [<ffffffff81012082>] system_call_fastpath+0x16/0x1b

Let me know if I can be of any further assistance? If you require more info /
test running, I'm happy to help.

Neil

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
