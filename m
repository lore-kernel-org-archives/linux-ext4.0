From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] jbd2 write on disk each 2/3 seconds
Date: Sat, 24 May 2014 14:42:23 +0000
Message-ID: <bug-76821-13602-lKfKAY8hNb@https.bugzilla.kernel.org/>
References: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41506 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaEXOm0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2014 10:42:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E6B532037A
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 14:42:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 592732025B
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 14:42:23 +0000 (UTC)
In-Reply-To: <bug-76821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76821

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
If your kernel doesn't have ftrace enabled, please enable it by enabling the
following kernel config options:

    CONFIG_FUNCTION_TRACER
    CONFIG_FUNCTION_GRAPH_TRACER
    CONFIG_STACK_TRACER
    CONFIG_DYNAMIC_FTRACE

Once you do that, make sure debugfs is mounted:

mount -t debugfs debugfs /sys/kernel/debug

Now enable the ext4_mark_inode_dirty tracepoint and start tracing:

cd /sys/kernel/debug/tracing
echo 1 > events/ext4/ext4_mark_inode_dirty/enable
cat trace_pipe

You will start seeing lines like this:

   kworker/u16:2-14718 [006] ...1 616239.342464: ext4_mark_inode_dirty: dev
252,0 ino 4203428 caller ext4_writepages+0x743/0x93e
 BrowserBlocking-5875  [006] ...1 616241.972533: ext4_mark_inode_dirty: dev 8,3
ino 3545316 caller ext4_dirty_inode+0x40/0x59


The first line indicates that process 14718, which is a kernel thread named
kworking/u16:2, dirtied inode 4203428 on device 252,0, which is /dev/dm-0
(which on my system has major number 252, minor 0, which you can see by the
command ls -l /dev/dm-0).   This is probably dirty inode writeback, so that
doesn't help tell you who dirtied the file.  You can find the filename using
debugfs:

debugfs /dev/dm-0
debugfs: ncheck 4203428
Inode    Pathname
4203428    /build/e2fsprogs-maint/tests/f_eofblocks.1.log

(and since /dev/dm-0 is mounted on /u1, I know the filename is
/u1/build/e2fsprogs-maint/....)  

The second line indicates the task id was 5875, and with a name like
BrowserBlocking, it's almost certainly one of the Chrome threads.  The ps
program won't show individual threads by default, but you can also use the
inode number to find which process has the file open by using lsof:

lsof | grep 3545316

Once you're done, don't forget to disable the tracing to save a bit on CPU and
battery life:

cat /dev/null > /sys/kernel/debug/tracing/set_event

Anyway, I hope this helps.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
