From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 16 Oct 2009 23:02:34 GMT
Message-ID: <200910162302.n9GN2Y9U018197@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40864 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZJPXC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 19:02:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GN2YMg018198
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 23:02:34 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #69 from Brian Rogers <brian@xyzw.org>  2009-10-16 23:02:32 ---
I have an idea for anyone who gets this problem on a clean reboot. Do what it
takes to reproduce the problem, then quit to single-user mode (sudo telinit 1)
and try to remount root as read-only:

mount -o ro,remount /

If you can't do this because the filesystem is busy, look for and kill any
process that might have a file open for writing. Remounting as read-only does
not seem to be forcible, as the command appears to succeed, but you still have
write access. So it's a good idea to 'touch /blah' to make sure you've turned
off write access.

Plan A. If you've successfully remounted as read-only, run 'e2fsck -f' on your
filesystem. If you had no errors on the filesystem before, but you do now, you
know the errors were introduced during the session. If there are no errors on
this check and you never get the corruption on the next boot after doing this,
it's probably a problem with data not getting flushed by the time the system
reboots.

Plan B. If you can't remount as read-only and can't find a process responsible
for that to kill, run sync, then 'e2fsck -fn' on the partition and report the
results.

I just did a dist-upgrade on my desktop machine running Karmic and the standard
Karmic 2.6.31 kernel, and I was going to do the above before rebooting, but had
to resort to plan B because I couldn't remount / as read-only. Even after sync,
e2fsck warned that it was skipping journal recovery, and it reported errors.

Ted, is it to be expected that e2fsck would find a journal recovery necessary
and see errors even if the filesystem was still mounted rw, but had been synced
and no write access had taken place since the sync? I know no writing had taken
place because I could run sync after the drive had spun down, and it wouldn't
spin up again. Yet e2fsck continued to report the same result.

I did 'reboot -f' after this to avoid any script shenanigans and used
'init=/bin/bash' on the next boot so I could manually examine the situation.
When my root fs was been mounted read-only, it replayed the journal, then there
were no errors on 'e2fsck -f'.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
