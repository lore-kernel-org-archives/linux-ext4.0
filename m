From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Fri, 24 Oct 2014 15:14:55 +0000
Message-ID: <bug-86471-13602-LEC3CccjRC@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbaJXPO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Oct 2014 11:14:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3E8972025B
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2014 15:14:56 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 61A37201C0
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2014 15:14:55 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D86471

--- Comment #7 from Markus K=C3=B6nigshaus <m.koenigshaus@wut.de> ---
Addition: I have identified the code that generates the underflow:
cancel_dirty_page in mm/truncate.c. To reproduce the error, you can per=
form the
following change:

[...]
if (mapping && mapping_cap_account_dirty (mapping)) {
++WARN_ON ((int) global_page_state(NR_FILE_DIRTY) <0);
dec_zone_page_state (page, NR_FILE_DIRTY);
[...]

Test result:

[   21.427121] ------------[ cut here ]------------
[   21.431769] WARNING: CPU: 0 PID: 309 at mm/truncate.c:78
cancel_dirty_page+0x144/0x1cc()
[   21.439899] Modules linked in: wutbox_cp sata_mv
[   21.444572] CPU: 0 PID: 309 Comm: kworker/0:1 Not tainted 3.14.21-Wu=
T #77
[   21.451395] Workqueue: events free_ioctx
[   21.455362] [<c0016a64>] (unwind_backtrace) from [<c0012f88>]
(show_stack+0x20/0x24)
[   21.463164] [<c0012f88>] (show_stack) from [<c03f8bec>]
(dump_stack+0x24/0x28)
[   21.470441] [<c03f8bec>] (dump_stack) from [<c0023ae4>]
(warn_slowpath_common+0x84/0x9c)
[   21.478577] [<c0023ae4>] (warn_slowpath_common) from [<c0023bb8>]
(warn_slowpath_null+0x2c/0x34)
[   21.487402] [<c0023bb8>] (warn_slowpath_null) from [<c00c05f0>]
(cancel_dirty_page+0x144/0x1cc)
[   21.496125] [<c00c05f0>] (cancel_dirty_page) from [<c00c073c>]
(truncate_inode_page+0x8c/0x158)
[   21.504874] [<c00c073c>] (truncate_inode_page) from [<c00c09c4>]
(truncate_inode_pages_range+0x11c/0x53c)
[   21.514493] [<c00c09c4>] (truncate_inode_pages_range) from [<c00c0e9=
c>]
(truncate_pagecache+0x88/0xac)
[   21.523855] [<c00c0e9c>] (truncate_pagecache) from [<c00c0f1c>]
(truncate_setsize+0x5c/0x74)
[   21.532332] [<c00c0f1c>] (truncate_setsize) from [<c013b2d8>]
(put_aio_ring_file.isra.14+0x34/0x90)
[   21.541428] [<c013b2d8>] (put_aio_ring_file.isra.14) from [<c013b354=
>]
(aio_free_ring+0x20/0xcc)
[   21.550262] [<c013b354>] (aio_free_ring) from [<c013b424>]
(free_ioctx+0x24/0x44)
[   21.557791] [<c013b424>] (free_ioctx) from [<c003d8d8>]
(process_one_work+0x134/0x47c)
[   21.565732] [<c003d8d8>] (process_one_work) from [<c003e988>]
(worker_thread+0x130/0x414)
[   21.575225] [<c003e988>] (worker_thread) from [<c00448ac>]
(kthread+0xd4/0xec)
[   21.590695] [<c00448ac>] (kthread) from [<c000ec18>]
(ret_from_fork+0x14/0x20)
[   21.600721] ---[ end trace a9d8eecdd373e997 ]---


The error only occurs when the Kernel Asynchronous I/O is used. Without=
 AIO I
get no error.

Markus

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
