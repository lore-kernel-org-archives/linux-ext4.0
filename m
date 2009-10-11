From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 11 Oct 2009 23:01:09 GMT
Message-ID: <200910112301.n9BN19Xg030607@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39436 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZJKXBp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2009 19:01:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9BN1912030608
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2009 23:01:09 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #16 from Theodore Tso <tytso@mit.edu>  2009-10-11 23:01:06 ---
I've been trying to recreate this failure mode, and haven't had any luck.   It
looks like you are using LVM, so a really good thing to do is to use the
e2croncheck script right after you reboot and login to the system.  If it
reports a clean filesystem, no worries.  If it doesn't, then it would really be
good to snapshot the output of dmesg to /tmp (I assume you have /tmp mounted as
tmpfs) and e-mail it someplace safe, and e2croncheck can also be configured to
e-mail the e2fsck output someplace safe as well.

I'll note that that what Holger and Alexey are seeing are somewhat different. 
Holger seems to be seeing a problem after a clean shutdown after re-installing
glibc from a build directory.  That would imply orphaned inode handling getting
screwed up some how, but I haven't been able to reproduce this on my systems.  
Alexey is seeing a problem after a crash/power failure, which implies some sort
of issue with journal replay.  One change that we did make between 2.6.31 and
2.6.32 is that we enable journal checksums by default.  In theory if the hard
drive is ignoring barriers, or is otherwise screwing up the journal I/O, we
could get a journal checksum error that would abort the journal playback.  That
in theory could explain Alexey's symptoms, but he didn't report a journal
checksum error message.

So I really don't know what's going on right now.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
