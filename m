From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 20:31:29 GMT
Message-ID: <200910272031.n9RKVTA4012312@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50788 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbZJ0UbZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 16:31:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9RKVTiZ012313
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 20:31:29 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #132 from Eric Sandeen <sandeen@redhat.com>  2009-10-27 20:31:28 ---
A few other observations from testing today.

I'm driving a test on a lab box by doing a make modules_install into
/tmp/modules on the victim box, and cycling power at some random point while
that runs.

2.6.32 seems to hit this reliably, with the root fs pretty well munged.  2.6.31
hasn't seen it hit yet in my testing, maybe Linus' ext4_write_inode vs.
writeback theory is correct ...

Perhaps more strange, doing the same test on a non-root fs under 2.6.32 also
doesn't seem to hit it reliably.  Could it be something about the remount,ro
flush of the root fs on the way down?

Suspecting that possibly "mount -o ro; e2fsck -a /dev/root" during bootup was
causing problems by writing to the mounted fs, I short-circuited the boot-time
fsck -a; things were still badly corrupted so that doesn't seem to be it.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
