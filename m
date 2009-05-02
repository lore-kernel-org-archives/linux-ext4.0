From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Sat, 2 May 2009 20:24:56 GMT
Message-ID: <200905022024.n42KOu2P016186@demeter.kernel.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51652 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbZEBUY5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 May 2009 16:24:57 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n42KOvPi016187
	for <linux-ext4@vger.kernel.org>; Sat, 2 May 2009 20:24:57 GMT
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151





--- Comment #11 from Theodore Tso <tytso@mit.edu>  2009-05-02 20:24:56 ---
Hi guys (and gals), please don't assume that your problem is the same as a
previously reported bug --- especially if the bug report title is as vague as
"unexplained fsck errors".     That could mean software bugs, or hardware bugs
--- and just because you have an "unexplained fsck error", please don't assume
your problem is the same as another person's.   It could be, if the kernel
versions are the same, and the symptoms are exactly the same, and especially if
the way to reproduce it is the same.

The original bug report dated from a 2.6.27 kernel, and there have been a huge
number of bugs fixed since then.   To be honest, not all bug fixes have been
backported to the 2.6.27.x series, either.   In some cases it was just way too
difficult to do.   So Nathan, if you're at 2.6.29, and you're not seeing any
problem, then we're probably better of closing this bug.

Florian, my guess is that whatever problem Nathan reported back in the 2.6.27
kernel is very different what you're seeing.   May I suggest that you open a
new bugzilla entry for your problems, and please give us as much detail as
possible?

Many thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
