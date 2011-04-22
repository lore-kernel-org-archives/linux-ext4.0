From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Fri, 22 Apr 2011 10:13:18 GMT
Message-ID: <201104221013.p3MADIHM002052@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36052 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1DVKNT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Apr 2011 06:13:19 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3MADIRa002053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Apr 2011 10:13:18 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #60 from Theodore Tso <tytso@mit.edu>  2011-04-22 10:13:05 ---
One of the problems which has made this hard to debug is (a) the kernel
oops/panic messages are inconsistent (they're not all the same, and some of
them don't have anything file system related at all), and (b) mant of them are
incomplete.

Note that we need more than just the stack traces, too.  We also need the
beginning of the oops message, complete with the IP/RIP information. 

At least one of these systems looks like it's using some kind of network
console?   Can you set up a simple serial console, and then do some experiments
where you yank out the USB drive, and tell us whether it happens reliably 100%
of the time?   50% of the time?   10% of the time?    If you run sync first and
the system is idle, does that make it more or less likely to happen?   If you
then start writing to the now-disappeared file system with a single command,
does it crash right away?  Does it crash 30 seconds later?

I've done a simple experiment where I've mounted a USB stick, written to it,
typed sync, but then without typing umount, yanked the stick out, and then
tried writing to the file system.  It didn't crash for me.   So some explicit
instructions of what you can do that causes reliable crashes would be very
useful, and then if you can set up a serial console so we can get complete and
reliably crash logs, that would also be very useful.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
