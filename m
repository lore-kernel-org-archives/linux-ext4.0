From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Fri, 20 Dec 2013 15:45:25 +0000
Message-ID: <bug-62751-13602-8m0q36vxgk@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50595 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab3LTPpc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Dec 2013 10:45:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 47B9F206B8
	for <linux-ext4@vger.kernel.org>; Fri, 20 Dec 2013 15:45:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B5AF1206AD
	for <linux-ext4@vger.kernel.org>; Fri, 20 Dec 2013 15:45:25 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

--- Comment #11 from Loris Luise <loris.luise@gmail.com> ---
Hello,

I had cloned root partition to a XFS one and curently I have no more problems.

Previously I used a mount line in fstab like this

/dev/mapper/h30server2-root /               ext4   
errors=remount-ro,noatime,nodiratime,data=writeback 0       1

and later (after your suggestion)

/dev/mapper/h30server2-root /               ext4   
errors=remount-ro,noatime,nodiratime,nodelalloc,data=writeback 0       1


but I did not test it with this new option for a sufficient amount of time to
be considered valid and come to a conclusion.

(I had to stabilize the system so I was forced to switch to XFS).

I collected more buginfos If they can be usefult I can post them here.

Thanks a lot.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
