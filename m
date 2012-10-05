From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Fri,  5 Oct 2012 18:07:33 +0000 (UTC)
Message-ID: <20121005180733.CE63F11FB37@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39063 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab2JESHl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 14:07:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B98FA2058D
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 18:07:39 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id DC3E12058B
	for <linux-ext4@vger.kernel.org>; Fri,  5 Oct 2012 18:07:38 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151


Jeff Moyer <jmoyer@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jmoyer@redhat.com




--- Comment #10 from Jeff Moyer <jmoyer@redhat.com>  2012-10-05 18:07:33 ---
(In reply to comment #8)
> 8K is to be understood instead of the usual 4K as page size (smallest read- and
> writeable entity).

Internal to the device, it's the smallest I/O size.  But the device continues
to export probably a 512 byte logical block size (or, more rarely, a 4k one).

> Eric: I doubt that anyone would file a bug report on it as
> the only effect of using a wrong fs block size will be degraded performance and
> a shortened lifetime of the SSD (nobody would in deed find out about it who
> hasn`t tried it with 8KB block size or heard about disks with page size != 4K).

Given that pretty much all file systems running on Linux and Windows will use a
block size less than or equal to the page size (4k), you can bet that the SSD
vendor took this into account when advertising both the performance of the
drive and the lifetime.  I'll also note that this SSD isn't posing any new
problems.  Consider RAID devices.  They would also like I/O in larger than page
size quantities.  We don't have to provide that in order to get good
performance, though, for a large number of reasons (which vary depending on the
exact hardware and software configuration you're talking about).  Also keep in
mind that the workload you intend to run will play a large role when
determining what file system block size you choose (for example, to avoid
unnecessary wasting of space).

> Feel free to care about it whenever you want as we do not have any users
> requiring it yet (to me for myself this isn`t any issue since I don`t plan to
> use the besaid disk at the time).

If you want to play around with things, try creating a 4k file system with a
stripe width of 2.  Of course, you'd have to have the hardware to try this, and
you don't, nor does anyone looking at this, so the discussion is moot.

The bottom line is that if someone wants to take on the work to get file system
block sizes pushed beyond page size, we're all for it.  Lobbying for this to
get done isn't going to help as much as doing the work or paying someone to do
the work, though.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
