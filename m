From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Sat, 07 Dec 2013 10:08:16 +0000
Message-ID: <bug-62751-13602-lZWhRkeGnY@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39652 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3LGKIT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Dec 2013 05:08:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D9C9620426
	for <linux-ext4@vger.kernel.org>; Sat,  7 Dec 2013 10:08:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 077A420395
	for <linux-ext4@vger.kernel.org>; Sat,  7 Dec 2013 10:08:17 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

Zheng Liu <gnehzuil.liu@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gnehzuil.liu@gmail.com

--- Comment #10 from Zheng Liu <gnehzuil.liu@gmail.com> ---
Hi Loris,

Sorry for my late reply.  I haven't had a chance to take a closer look at this
problem until now.

(In reply to Loris Luise from comment #8)
> Hello,
> 
> what can I do on my side?

I am not sure whether you use 'delalloc' on your system.  I don't see these
details from the log that you pasted.  So now only I could suggest is that you
can try to turn off the delalloc.  The step is as below:

 % sudo mount -t ext4 -o remount,nodelalloc ${DEV} ${MNT}

After this, it won't track the delayed entry on extent status tree.  So it will
avoid es shrinker to take too much time to scan delayed entries that couldn't
be reclaimed.

Then I will try to reproduce this problem on my sand box and think about how to
improve es shrinker.

Thanks,
- Zheng

> 
> I've done the following modifications:
> 
> 1) Installed latest mainline kernel 3.12
> 
> 2) Replaced SCSI drivers from vmw_pvsci to LSI Logic SAS (mptsas)
> 
> 3) reduced number of CPUs from 8 to 4
> 
> 4) enabled on ESXi (4.1) setting for this machine "CPU Hot add" feature
> 
> The issue is still affecting ths machine... other 2 almost equals machine
> running on this host (same kernel) but with XFS on root are not affected and
> very
> stable.
> 
> I reattached another info file (bug-20131118084007.txt) which contains a lot
> of infos.
> 
> Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
