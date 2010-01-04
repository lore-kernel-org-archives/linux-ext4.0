From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Mon, 4 Jan 2010 03:35:24 GMT
Message-ID: <201001040335.o043ZOrW020607@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36330 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0ADDfZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jan 2010 22:35:25 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o043ZOTK020608
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jan 2010 03:35:24 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #10 from Eric Sandeen <sandeen@redhat.com>  2010-01-04 03:35:22 ---
(In reply to comment #9)
> grep BLK.*TRACE /usr/src/linux/.config
> 
> CONFIG_BLK_DEV_IO_TRACE=y
> 
> Yes, I'm running under root. SeLinux is disabled in the kernel. I've no idea
> what to do :(

Drop the echos.  Just mounting debugfs & running blktrace will suffice:

[root@inode ~]# mount -t debugfs none /sys/kernel/debug/
[root@inode ~]# blktrace /dev/sda
^C=== sda ===
  CPU  0:                    0 events,        0 KiB data
  CPU  1:                    1 events,        1 KiB data
  Total:                     1 events (dropped 0),        1 KiB data

but if you do this first:

[root@inode ~]# echo blk > /sys/kernel/debug/tracing/current_tracer
[root@inode ~]# echo 1 > /sys/block/sda/sda3/trace/enable

you get the -EBUSY:

[root@inode ~]# blktrace /dev/sda
BLKTRACESETUP(2) /dev/sda failed: 16/Device or resource busy
Thread 1 failed open /sys/kernel/debug/block/(null)/trace1: 2/No such file or
directory
Thread 0 failed open /sys/kernel/debug/block/(null)/trace0: 2/No such file or
directory
FAILED to start thread on CPU 0: 1/Operation not permitted
FAILED to start thread on CPU 1: 1/Operation not permitted

It's not related to selinux.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
