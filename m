From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Mon, 18 Jan 2010 23:58:11 GMT
Message-ID: <201001182358.o0INwBkc011745@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59149 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0ARX6M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 18:58:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0INwBjb011746
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 23:58:11 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #3 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-01-18 23:58:09 ---
>This problem prevents production use of systems using this kernel.

>evokes a question: Do you have a kernel which behaved better for you? Which
>one?

Yes.  RHEL5.4 does not show this problem.  It is the production
system that works in this environment.

The response above is disappointing.  Is sync response of 20 minutes,
including several task timeouts to be considered "normal?"

>If you think the time is inappropriately long, we can have a look at it
>but for that we'd need much more details like amount and nature of data writen
>(many small files vs a few large ones), time it takes sync to complete, speed
>of disks for sequential IO...

I am sorry to have to tell you that in this environment we do not
deal in exclusively small or large files, we actually have quite a
few of both. When an rsync which transfers about 50GB of files of
various sizes is running, the hung condition is continuous until the rsync
completes.  This is just a pretty typical load.  You could try it
yourself.  No special sizes of files are required.  I think I
mentioned that the ext4 LVM is a RAID 50 3ware 9650SE-8LPML,
with 8 2T drives.  Its throughput for reading and writing is good
when the system is not locked up.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
