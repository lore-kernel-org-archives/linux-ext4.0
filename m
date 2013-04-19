From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56821] New: an ext4 commit ee0906f causes weird disk hangs
Date: Fri, 19 Apr 2013 12:25:53 +0000 (UTC)
Message-ID: <bug-56821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968317Ab3DSM0A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 08:26:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8409E20592
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 12:25:58 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id F404120625
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 12:25:54 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56821

           Summary: an ext4 commit ee0906f causes weird disk hangs
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kynde@ts.ray.fi
        Regression: Yes


Created an attachment (id=99301)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=99301)
A console msg often seen during the hang

The commit (ee0906fc8da3447d168a73570754a160ecbe399b ext4: use
s_extent_max_zeroout_kb value as number of kb) causes a strange disk/raid/fs
hang for me.

Steps to reproduce:
1) login 
2) startx (I've tried with nv and nvidia)
3) launch thunderbird and wait 3..10 secs

Expected results:
- just another day in the office

Actual results:
- A hang. First I see some refreshes not happening and shortly I can't do
anything besides jump from X to consoles and back. I tap something out on those
terminals that are still live, but any disk access will hang them, too. The
attached console_msg.txt pops out sometimes if I wait long enough. Magic sysrq
sync,mount ro, boot is what I do next.

I've used practically every stable release on this box since some time before
3.0 without problems. And ever since 3.8.5 I've been stuck to 3.8.4. Since then
I've tried every stable release up to 3.8.8 and none of them work.

The ee0906f commit seems to cause it. I did double checks on surrounding
commits, but not more than that. I takes 10 minutes to resync my raid-1 after a
failure and that kinda limits my enthusiasm to work it further on my own. No
damage seems to be caused by such an event though. The raid sync succeeds every
time it only takes a while.

The setup is an updated Fedora 18 on an AMD 4184, 16 Gb ram, LSI SAS controller
with two 300GB disks. Three partitions each, first on both is a 50Gb raid1 ext4
as root and second of both is a 100Gb raid1 ext4 as /home. Third partitions are
non-raid old ext3 or ext4 filesystems that aren't mounted or used.

I haven't managed to cause the hang when outside of X. I've tried some kernel
compiling and catting files to null, but no. Equally while in X (nv or nvidia,
doesn't matter) thunderbird seems to trigger it. It launches fully but within a
few to ten seconds things start to fail. Another interesting tid bit is that
the disk leds in the array both get turned off, which is anomalous. Usually
they only blink during access.

I'm willing to provide information and try out things, just let me know what
you need.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
