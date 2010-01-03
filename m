From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sun, 3 Jan 2010 10:31:53 GMT
Message-ID: <201001031031.o03AVraM027501@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38871 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0ACKby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jan 2010 05:31:54 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o03AVrAJ027502
	for <linux-ext4@vger.kernel.org>; Sun, 3 Jan 2010 10:31:53 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #7 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-01-03 10:31:49 ---
Created an attachment (id=24417)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24417)
trace pipe output

blktrace produces zero output, so I'm attaching trace pipe output while running
this test application.

I tried using blktrace this way:

# mount -t debugfs nul /sys/kernel/debug
# echo blk > /sys/kernel/debug/tracing/current_tracer
# echo 1 > /sys/block/sda/sda3/trace/enable

# blktrace /dev/sda3
BLKTRACESETUP(2) /dev/sda3 failed: 16/Device or resource busy
Thread 0 failed open /sys/kernel/debug/block/(null)/trace0: 2/No such file or
directory
Thread 1 failed open /sys/kernel/debug/block/(null)/trace1: 2/No such file or
directory
FAILED to start thread on CPU 0: 1/Operation not permitted
FAILED to start thread on CPU 1: 1/Operation not permitted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
