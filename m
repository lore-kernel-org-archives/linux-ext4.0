From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 87821] New: luksSuspend causes 'sync' to block indefinitely
 when used on a mounted ext{2,3,4} filesystem
Date: Thu, 06 Nov 2014 01:28:16 +0000
Message-ID: <bug-87821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41252 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKFB2U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Nov 2014 20:28:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F174B2017A
	for <linux-ext4@vger.kernel.org>; Thu,  6 Nov 2014 01:28:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9376B20172
	for <linux-ext4@vger.kernel.org>; Thu,  6 Nov 2014 01:28:17 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=87821

            Bug ID: 87821
           Summary: luksSuspend causes 'sync' to block indefinitely when
                    used on a mounted ext{2,3,4} filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 3.16-3-amd64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: michael@ensslin.cc
        Regression: No

Created attachment 156841
  --> https://bugzilla.kernel.org/attachment.cgi?id=156841&action=edit
dmesg output from a system where I tried extensively to reproduce the issue
under different circumstances.

Apart from sync, suspend-to-memory is also affected.

The issue only occurs with partitions on my main drive (/dev/sda).
Partitions on /dev/sdb are not affected.

I have confirmed that btrfs and FAT are not affected.

I have confirmed that ext4 filesystems mounted with -onobarrier are not
affected.

The issue is discussed in this commit message:
https://github.com/vianney/arch-luks-suspend/commit/f5e2c8f3844b820596324021c40b4593b1965e42.
The conclusion is that it was intruduced by this commit:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=06a407f13daf9e48f0ef7189c7e54082b53940c7

A shell session that shows all sorts of cases that do and do not reproduce the
issue can be seen here: https://bpaste.net/show/9820f57406c7

The following commands will reproduce the issue reliably:

cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 crypt
mkfs.ext4 /dev/mapper/crypt
mount /dev/mapper/crypt /tmp/m
cryptsetup luksSuspend crypt
sync

At some point, my dmesg contained timeout messages with stacktraces. At some
point, I was even able to cause a deadlock in the kernel that froze the linux
consoles and left only the X server working, but I couldn't reproduce that
issue.

An example stacktrace from my dmesg log is:

[ 2040.168356] INFO: task sync:1751 blocked for more than 120 seconds.
[ 2040.171652]       Tainted: G        W     3.16-3-amd64 #1
[ 2040.175000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 2040.178418] sync            D ffff880036dc2668     0  1751   1604 0x00000000
[ 2040.178425]  ffff880036dc2210 0000000000000086 0000000000014240
ffff8800b3f7ffd8
[ 2040.178430]  0000000000014240 ffff880036dc2210 ffff8800b3f7fec0
ffff8800b3f7fe58
[ 2040.178434]  ffff8800b3f7feb8 ffff880036dc2210 ffffffff811d2680
0000000000000000
[ 2040.178436] Call Trace:
[ 2040.178455]  [<ffffffff811d2680>] ? do_fsync+0x70/0x70
[ 2040.178467]  [<ffffffff81508409>] ? schedule_timeout+0x229/0x2a0
[ 2040.178475]  [<ffffffff81508ad1>] ? __schedule+0x2b1/0x710
[ 2040.178483]  [<ffffffff811d2680>] ? do_fsync+0x70/0x70
[ 2040.178490]  [<ffffffff81509918>] ? wait_for_completion+0xa8/0x120
[ 2040.178504]  [<ffffffff81094a90>] ? wake_up_state+0x10/0x10
[ 2040.178511]  [<ffffffff81273ff0>] ? submit_bio_wait+0x50/0x60
[ 2040.178519]  [<ffffffff8127f495>] ? blkdev_issue_flush+0x55/0x80
[ 2040.178572]  [<ffffffffa0195298>] ? ext4_sync_fs+0xd8/0x140 [ext4]
[ 2040.178578]  [<ffffffff811a8afc>] ? iterate_supers+0xac/0x100
[ 2040.178583]  [<ffffffff811d27a2>] ? sys_sync+0x52/0x90
[ 2040.178589]  [<ffffffff8150c7ad>] ? system_call_fast_compare_end+0x10/0x15

Apart from those timeout stack traces, dmesg doesn't appear to contain anything
interesting.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
