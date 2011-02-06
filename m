From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 6 Feb 2011 04:26:27 GMT
Message-ID: <201102060426.p164QRoV003763@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:50838 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1BFE02 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 23:26:28 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p164QRlr003764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 6 Feb 2011 04:26:27 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #19 from Theodore Tso <tytso@mit.edu>  2011-02-06 04:26:25 ---
Hmm.... what if you only remove one drive while suspended?   Can you try
removing each of the drives as separate experiments, and see if you can narrow
it down to a single drive that seems to cause the problem when it is removed?

And then can you see how that drive is being used (if it is being used at all)?

If the system is mostly quiet, then presumably it would die immediately on
resume, but when the system actually tried to access the file system.  So if we
can narrow it down to a single file system, and then figure out which processes
had files opened on that file system, maybe that would give us a clue.

You said, "paging request error" --- were you running programs off of any of
the external drives?   What programs if any were accessing the drive?

I'll note that I've tried some simple experiments with removing a quiescent USB
drive from my system while it was suspended, and I haven't been able to
reproduce the problem.   I have often forgotten to unmount a hot-swapping AHCI
attached hot-swappable SATA drive in my Ultrabay slot which is idle while
suspending, and it's never caused a hang on resume.  It gets a new sdN drive
letter on resume, so all of the file system mounts are invalidated, but I've
never gotten a crash when that happens --- and I've been using 2.6.37 on my
laptop almost ever since it has been released.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
