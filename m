From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Tue, 11 Aug 2015 18:16:09 +0000
Message-ID: <bug-89621-13602-VvjMyunzWm@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbbHKSQN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2015 14:16:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6504E202E9
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2015 18:16:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 734FC205F7
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2015 18:16:09 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #17 from Theodore Tso <tytso@mit.edu> ---
John, are you willing to give us a lot more details about your set up?  
Hardware, software, details of the host OS, details of the guest OS, what is
the workload where the problem is happening, etc?

And it might be helpful if you opened a separate bug which we use exclusively
for tracking your particular issue.   One of the things which is often
disastrous, and why I've largely given up on Ubuntu's launchpad, is when
multiple people assume that the problem that they are seeing is the same as
everyone else's. when in fact they could be separate bugs, or one of the bugs
could be a hardware problem, etc.

Then when one person doesn't give details about their hardware because they saw
someone else already had, it makes finding the problems even harder.

One thing to keep in mind when we are talking about problems found in the guest
OS is that misconfigurations at the host OS level can be indistinguishable from
hardware problems.   So for example, depending on the caching policy used by
KVM in the host OS issues, it may be that cache flush commands in the guest OS
don't peculate down all the way down to the actual hardware platters.   Thus,
after a power fail event, even if everything is configured correctly at the
guest OS, it can result in an inconsistent file system image because the KVM /
the host OS didn't make sure everything got pushed to the disk after a journal
commit.

So knowing whether or not were any shutdowns caused either by KVM crashing, or
the host OS crashing, or the guest OS crashing, is all very important in trying
to debug things, because the error message reported simply means that there was
an inconsistency detected in the allocation bitmaps.   This can be caused by
any number of things --- which is why doctors hate it when someone asks them
what's wrong because "I have a cough" at a social occasion, and then someone
else chimes in, "well, my grandfather had a cough right before he was diagnosed
with terminal lung cancer"...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
