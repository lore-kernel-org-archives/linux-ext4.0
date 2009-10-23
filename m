From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 23 Oct 2009 04:30:44 GMT
Message-ID: <200910230430.n9N4UiQA028497@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55885 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZJWEaj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Oct 2009 00:30:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9N4UitR028498
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2009 04:30:44 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #108 from James Cloos <cloos@jhcloos.com>  2009-10-23 04:30:36 ---
> I'd appreciate by the way getting reports from other people who have been
> suffering file system corruption problems whether or not the patch in
> attachment #23468 helps, and whether they are seeing any "File system is
> read-only" followed by a kernel stack trace in their system logs.  Thanks!!

I got some corruption, but not ro changes.

In an early rc nothing seemed wrong until, after a reboot, I saw enough
corruption in a db that I had to dump, clean up several bogus records
and restore it.  (It was a busy but ephemeral db, so that wasn't too
much of a problem.

Today, however, running -rc5 the box simply rebooted without notice.
and I got a number of log entries after the reboot.  Most specified
ext4_mb_generate_buddy and jbd complained that it spotted a dirty
metadata buffer.  There were also a couple of bad header/extents.

I stut down enough to unmoount /var and ran e2fsck.  That generated a
*slew* of errors, mostly complaining about multiple files claiming
the same blocks.  A second e2fsck right after (with -f) showed no
further errors.  I now have about 70 megs of data in lost+found.

The box is only partly up right now (I'm writing this over ssh);
I'll be able to provide more details after a reboot....

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
