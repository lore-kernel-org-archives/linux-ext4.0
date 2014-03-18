From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71791] Unlinking a file that was moved to another folder but
 still open by other process blocks either process (not always reproducible)
Date: Tue, 18 Mar 2014 15:35:03 +0000
Message-ID: <bug-71791-13602-iPRVZPnwn7@https.bugzilla.kernel.org/>
References: <bug-71791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaCSR65 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 13:58:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AF699203AA
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 15:35:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 15AF4203AF
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 15:35:04 +0000 (UTC)
In-Reply-To: <bug-71791-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71791

--- Comment #3 from edpeur@gmail.com ---
Yes, the journal mode was 'data=ordered'.
This problem is reproduced on this external USB drive on my laptop using a
quite light workload.
It is not always reproducible and I had to change the way I work so I might not
be able to reproduce this bug in the near time.
There was another hang when shutdown tried to umount this drive:
[374641.816086] INFO: task shutdown:20015 blocked for more than 120 seconds.
[374641.816096]       Tainted: G        W    3.12-1-rt-amd64 #1
[374641.816099] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[374641.816103] shutdown        D ffff8800b4ce6af0     0 20015      1
0x00000000
[374641.816116]  ffff8800b4ce6780 0000000000000086 ffff880103177fd8
ffff880103177fd8
[374641.816119]  ffff880103177fd8 ffff880103177fd8 ffff8800b4ce6780
ffff8800b4ce6780
[374641.816122]  0000000000000002 ffffffff81123410 ffff880103177d90
000000000000c394
[374641.816129] Call Trace:
[374641.816142]  [<ffffffff81123410>] ? wait_on_page_read+0x60/0x60
[374641.816147]  [<ffffffff814aecb1>] ? schedule+0x21/0x90
[374641.816151]  [<ffffffff814aeda3>] ? io_schedule+0x83/0xd0
[374641.816154]  [<ffffffff81123415>] ? sleep_on_page+0x5/0x10
[374641.816158]  [<ffffffff814ad594>] ? __wait_on_bit+0x54/0x80
[374641.816162]  [<ffffffff8112322f>] ? wait_on_page_bit+0x7f/0x90
[374641.816166]  [<ffffffff81082050>] ? wake_atomic_t_function+0x30/0x30
[374641.816171]  [<ffffffff811307b8>] ? pagevec_lookup_tag+0x18/0x20
[374641.816175]  [<ffffffff81123318>] ? filemap_fdatawait_range+0xd8/0x150
[374641.816179]  [<ffffffff8108e6b9>] ? get_parent_ip+0x9/0x20
[374641.816182]  [<ffffffff8108e6b9>] ? get_parent_ip+0x9/0x20
[374641.816186]  [<ffffffff814b42d7>] ? add_preempt_count+0x97/0xe0
[374641.816191]  [<ffffffff8105ed50>] ? pin_current_cpu+0x90/0x1b0
[374641.817981]  [<ffffffff8108e6b9>] ? get_parent_ip+0x9/0x20
[374641.817983]  [<ffffffff8105ee7d>] ? unpin_current_cpu+0xd/0x60
[374641.817986]  [<ffffffff811ac869>] ? sync_inodes_sb+0x169/0x1f0
[374641.817989]  [<ffffffff811b1c80>] ? generic_write_sync+0x60/0x60
[374641.817991]  [<ffffffff811877ba>] ? iterate_supers+0xba/0x120
[374641.817993]  [<ffffffff811b1ecd>] ? sys_sync+0x2d/0x90
[374641.817996]  [<ffffffff814b7ab9>] ? system_call_fastpath+0x16/0x1b

I have upgraded to:
http://ftp.debian.org/debian/pool/main/l/linux/linux-image-3.13-1-amd64_3.13.5-1_amd64.deb

I have enabled 'data=writeback' now. So, I will report if I see this problem
again.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
