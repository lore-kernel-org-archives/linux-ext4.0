From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 52521] New: hibernations problems: ext4 errors after some
 hibernation cycles
Date: Wed,  9 Jan 2013 02:23:05 +0000 (UTC)
Message-ID: <bug-52521-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38963 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab3AICXL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jan 2013 21:23:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3F86720333
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jan 2013 02:23:07 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 659FF2031A
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jan 2013 02:23:06 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=52521

           Summary: hibernations problems: ext4 errors after some
                    hibernation cycles
           Product: File System
           Version: 2.5
    Kernel Version: 2.7.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: higuita@gmx.net
        Regression: No


i'm using a ext4 root partition on my slackware64 and i regularly hibernate the
machine. After some hibernation cycles i usually get the root partition mounted
as read-only. Strangely, my home partition, also ext4 its always fine.

After the reboot and fsck and some minor corrections (mostly freeing unused
blocks, after all the /tmp is on the root partition) all works fine.

i'm getting this on mainline kernel 2.7.1 but i have this for several months
(more than six at least), time where i started to use the hibernation.

The problem is hard to reproduce, i get it some times with 2-3 hibernation,
other after many hibernation cycles or don't get it at all.

i don't know if its related, but if i force enable HPET on my machine, the
system works well, but after hibernate the many process act strangely,
specially related with X11. Due to this i stop forcing the HPET, but this
incident turned me more alert for small problems. I start to note that my xterm
are sometime slower rendering the text after hibernating the machine. On a
normal powerup the xterms work fine.

This may or may not be related, the main problem is still the ext4 corruption.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
