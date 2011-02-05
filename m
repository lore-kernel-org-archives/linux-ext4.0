From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 5 Feb 2011 23:10:23 GMT
Message-ID: <201102052310.p15NAN3Q010368@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47198 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab1BEXKY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 18:10:24 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p15NAN5V010369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Feb 2011 23:10:23 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #16 from Theodore Tso <tytso@mit.edu>  2011-02-05 23:10:20 ---
Hmm, can you tell me how your hard drives are arranged?  Based on the comment
in #15, the bug was while the kernel was trying to wake up firefox.  There's
nothing in the (truncated) strace trace that looks like a file system would be
involved, but if there was file system involvement, presumably it would be
related to firefox writing to its dot files in your home directory.  Is your
home directory located on a USB drive?

Here's another thought.  What happens if you try a series of suspend/resumes
where you pull all of your hard drives, but you don't pull the USB hub.  Does
that change the pattern of the crashes/freezes?

Also, is the system largely quiet before the suspend --- were there any
processes downloading torrents, doing compiles, or otherwise using a large
amount of CPU or disk bandwidth before you suspended your system?

Hmm.... this looks like a real puzzler.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
