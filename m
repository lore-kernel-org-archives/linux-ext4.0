From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 7 Feb 2011 01:20:04 GMT
Message-ID: <201102070120.p171K3LD026389@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:36729 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab1BGBUF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Feb 2011 20:20:05 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p171K4sD026390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Feb 2011 01:20:04 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #22 from Theodore Tso <tytso@mit.edu>  2011-02-07 01:20:01 ---
Memory doesn't get freed just because a device disappears.   The file system is
still shown as mounted after the system resumes.  Attempts to access the
mounted file system will result in errors, but the data structures don't get
magically freed until you explicit umount the failed file system.

It's more likely that the kernel is stuck in some loop trying to access the
failed file system, and looping, but in that case, it would be caused by a
specific process trying to access the file system after the system resumed. 
Say, if you were executing a program that was located on the now-failed file
system, or if a file from the now-failed file system was mmap'ed into memory,
and for some reason the kernel was looping forever instead of returning an
error to the program and/or killing the program.

This is why I asked you if you could use the various sysrq commands to try to
figure out what the kernel was doing after it locked up.  In answer to your
previous message, no, sysrq doesn't require access over the network.  It
requires access to the console.  If you have a VT console, sysrq-p can be
triggered by holding down the alt, sysrq and p keys; sysrq-l can be triggered
by alt-sysrq-l, etc.   If you have a serial console, you can send a break
followed by an l to trigger a sysrq-l, and so on.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
