From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101751] 0009103: INFO: task nginx:2334 blocked for more than
 120 seconds.
Date: Mon, 20 Jul 2015 11:46:28 +0000
Message-ID: <bug-101751-13602-6JM9AIu9xq@https.bugzilla.kernel.org/>
References: <bug-101751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59294 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbbGTLqd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2015 07:46:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 661C920652
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 11:46:32 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0D1F220601
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 11:46:29 +0000 (UTC)
In-Reply-To: <bug-101751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=101751

--- Comment #1 from zakrzewskim@wp.pl ---
More logs:

INFO: task qmail-send:1630 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-send D 0000000000000009 0 1630 1617 0x00000080
 ffff880633917dc8 0000000000000086 0000000000000000 0000000000000001
000000000000000e ffff880633917de8 000006a8c1b5a492 ffffffff81123f80
 ffff8801e9818608 00000001006b0138 ffff88063036fad8 ffff880633917fd8 Call
Trace:
 [<ffffffff81123f80>] ? find_get_pages_tag+0x40/0x130 [<ffffffff8109ef4e>] ?
prepare_to_wait+0x4e/0x80 [<ffffffffa02795a5>] jbd2_log_wait_commit+0xc5/0x140
[jbd2] [<ffffffff8109ec20>] ? autoremove_wake_function+0x0/0x40
[<ffffffffa0279938>] jbd2_complete_transaction+0x68/0xb0 [jbd2]
[<ffffffffa0295061>] ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task auditd:6614 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
auditd D 0000000000000005 0 6614 1 0x00000080
 ffff88053d1eddc8 0000000000000086 0000000000000000 ffff88053d1edd8c
000000000000000e ffff88063fc24b80 000006c4a84b0693 ffff8800282158c0
0000000000000400 00000001006cd4ae ffff880016b285f8 ffff88053d1edfd8 Call Trace:
 [<ffffffffa02795a5>] jbd2_log_wait_commit+0xc5/0x140 [jbd2]
[<ffffffff8109ec20>] ? autoremove_wake_function+0x0/0x40 [<ffffffffa0279938>]
jbd2_complete_transaction+0x68/0xb0 [jbd2] [<ffffffffa0295061>]
ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task qmail-queue:30267 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-queue D 000000000000000a 0 30267 30264 0x00000080
 ffff8804dc24ddc8 0000000000000086 ffff8804dc24dd90 ffff8804dc24dd8c
000000000000000e ffff88063fc25580 000006a8c1b243af ffff8800282958c0
 00000000000006e2 00000001006b0135 ffff88063306c5f8 ffff8804dc24dfd8 Call
Trace:
 [<ffffffff8109ef4e>] ? prepare_to_wait+0x4e/0x80 [<ffffffffa02795a5>]
jbd2_log_wait_commit+0xc5/0x140 [jbd2] [<ffffffff8109ec20>] ?
autoremove_wake_function+0x0/0x40 [<ffffffffa0279938>]
jbd2_complete_transaction+0x68/0xb0 [jbd2] [<ffffffffa0295061>]
ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task qmail-queue:32226 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-queue D 0000000000000002 0 32226 32223 0x00000080
 ffff88044d5eddc8 0000000000000082 ffff88044d5edd90 ffff88044d5edd8c
000000000000000e ffff88063fc24580 000006c4a84a990c ffff8800283158c0
0000000000000400 00000001006cd4c0 ffff88063028b068 ffff88044d5edfd8 Call Trace:
 [<ffffffffa02795a5>] jbd2_log_wait_commit+0xc5/0x140 [jbd2]
[<ffffffff8109ec20>] ? autoremove_wake_function+0x0/0x40 [<ffffffffa0279938>]
jbd2_complete_transaction+0x68/0xb0 [jbd2] [<ffffffffa0295061>]
ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task qmail-queue:2594 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-queue D 000000000000000b 0 2594 2591 0x00000080
 ffff88048d4c3dc8 0000000000000086 0000000000000000 0000000000000001
000000000000000e ffff88048d4c3de8 000006c4a898847a ffffffff81123f80
 ffff88011702bdd8 00000001006cd4c5 ffff8806301ac5f8 ffff88048d4c3fd8 Call
Trace:
 [<ffffffff81123f80>] ? find_get_pages_tag+0x40/0x130 [<ffffffffa02795a5>]
jbd2_log_wait_commit+0xc5/0x140 [jbd2] [<ffffffff8109ec20>] ?
autoremove_wake_function+0x0/0x40 [<ffffffffa0279938>]
jbd2_complete_transaction+0x68/0xb0 [jbd2] [<ffffffffa0295061>]
ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task qmail-queue:5369 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-queue D 0000000000000002 0 5369 5366 0x00000080
 ffff880542327dc8 0000000000000082 0000000000000000 0000000000000001
000000000000000e ffff880542327de8 000006c4a84aabb6 ffffffff81123f80
 ffff8801527c0dd8 00000001006cd4c0 ffff88044d359068 ffff880542327fd8 Call
Trace:
 [<ffffffff81123f80>] ? find_get_pages_tag+0x40/0x130 [<ffffffffa02795a5>]
jbd2_log_wait_commit+0xc5/0x140 [jbd2] [<ffffffff8109ec20>] ?
autoremove_wake_function+0x0/0x40 [<ffffffffa0279938>]
jbd2_complete_transaction+0x68/0xb0 [jbd2] [<ffffffffa0295061>]
ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task qmail-queue:5913 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-queue D 0000000000000005 0 5913 5910 0x00000080
 ffff8804cf915dc8 0000000000000082 ffff8804cf915e70 0000000000000001
000000000000000e ffff8804cf915de8 ffff8804cf915d88 ffffffff81123f80
 ffff880538503dd8 ffff8804cf915de8 ffff8800ab0d3ad8 ffff8804cf915fd8 Call
Trace:
 [<ffffffff81123f80>] ? find_get_pages_tag+0x40/0x130 [<ffffffff8109ef4e>] ?
prepare_to_wait+0x4e/0x80 [<ffffffffa02795a5>] jbd2_log_wait_commit+0xc5/0x140
[jbd2] [<ffffffff8109ec20>] ? autoremove_wake_function+0x0/0x40
[<ffffffffa0279938>] jbd2_complete_transaction+0x68/0xb0 [jbd2]
[<ffffffffa0295061>] ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task qmail-queue:6816 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-queue D 000000000000000b 0 6816 6813 0x00000080
 ffff880513305dc8 0000000000000086 0000000000000000 0000000000000001
000000000000000e ffff880513305de8 000006c4a84afe28 ffffffff81123f80
 ffff88018811ddd8 00000001006cd4c1 ffff88060ec105f8 ffff880513305fd8 Call
Trace:
 [<ffffffff81123f80>] ? find_get_pages_tag+0x40/0x130 [<ffffffffa02795a5>]
jbd2_log_wait_commit+0xc5/0x140 [jbd2] [<ffffffff8109ec20>] ?
autoremove_wake_function+0x0/0x40 [<ffffffffa0279938>]
jbd2_complete_transaction+0x68/0xb0 [jbd2] [<ffffffffa0295061>]
ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
INFO: task qmail-queue:8784 blocked for more than 120 seconds.
      Not tainted 2.6.32-504.30.3.el6.x86_64 #1 "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-queue D 0000000000000002 0 8784 8753 0x00000080
 ffff88044b039dc8 0000000000000082 0000000000000000 0000000000000001
000000000000000e ffff88044b039de8 000006bfaf0590c4 ffffffff81123f80
 ffff8802f05c2dd8 00000001006c8166 ffff8805435845f8 ffff88044b039fd8 Call
Trace:
 [<ffffffff81123f80>] ? find_get_pages_tag+0x40/0x130 [<ffffffff8109ef4e>] ?
prepare_to_wait+0x4e/0x80 [<ffffffffa02795a5>] jbd2_log_wait_commit+0xc5/0x140
[jbd2] [<ffffffff8109ec20>] ? autoremove_wake_function+0x0/0x40
[<ffffffffa0279938>] jbd2_complete_transaction+0x68/0xb0 [jbd2]
[<ffffffffa0295061>] ext4_sync_file+0x121/0x1d0 [ext4] [<ffffffff811c0c51>]
vfs_fsync_range+0xa1/0x100 [<ffffffff811c0d1d>] vfs_fsync+0x1d/0x20
[<ffffffff811c0d5e>] do_fsync+0x3e/0x60 [<ffffffff811c0db0>]
sys_fsync+0x10/0x20 [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
