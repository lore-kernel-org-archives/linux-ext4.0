From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 6 Mar 2011 15:59:07 GMT
Message-ID: <201103061559.p26Fx7Un018152@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:44275 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1CFP7I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Mar 2011 10:59:08 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p26Fx8Lt018153
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 6 Mar 2011 15:59:08 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #39 from Alan Stern <stern@rowland.harvard.edu>  2011-03-06 15:59:05 ---
It is expected that processes will try to access files on a drive after it has
been removed.  After all, they have no way of knowing that the drive is gone.

I'm not convinced that the timing with respect to your resume is relevant. 
After all, you mentioned that the crashes are subject to random delays,
sometimes happening several seconds after the system resumes.

Also, the kernel does not automatically unmount missing drives.  Unmounting is
a separate operation from removal.  Unmounting takes place only when the user
(or a program) does the equivalent of running the umount command.

You did say that this problem doesn't arise in 2.6.36.  Your best chance of
tracking it down might be to try doing a git bisection between 2.6.36 and
2.6.37.  However, for this to work, you have to be able to detect reliably
whether or not a particular kernel has the bug.  The test you used in comment
#31 might do the job.  If you can narrow this down to an individual kernel
change, that would be a big help.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
