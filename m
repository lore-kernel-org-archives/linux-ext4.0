From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sun, 3 Jan 2010 12:11:57 GMT
Message-ID: <201001031211.o03CBvL3007984@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60842 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0ACML6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jan 2010 07:11:58 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o03CBvRj007985
	for <linux-ext4@vger.kernel.org>; Sun, 3 Jan 2010 12:11:57 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #8 from Theodore Tso <tytso@mit.edu>  2010-01-03 12:11:56 ---
I'm not sure why you are getting the device busy or resource busy error to the
BLKTRACESETUP ioctl.   Are you sure this is a kernel with the blktrace support
configured in?  And I assume the '#' error message indicates that you are
running as root.  You don't have SELinux or some other LSM configured, do you?

Blktrace running alone does not produce output; it produces trace files for
each CPU that can be parsed using the blkparse program.  If you look back,
you'll see that I suggested running the btrace program after you install the
blktrace package.   The btrace program is a convenience script which runs
blktrace and blkparse to produce immediate output to standard out.   There are
man pages for blktrace, blkparse, and btrace which should have been installed
when you installed the binaries for blktrace.

Still, it shouldn't have spit out those error messages....

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
