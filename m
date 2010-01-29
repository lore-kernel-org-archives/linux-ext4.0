From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Fri, 29 Jan 2010 06:37:59 GMT
Message-ID: <201001290637.o0T6bxPY011224@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34759 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0A2Gh7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jan 2010 01:37:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0T6bxnM011225
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jan 2010 06:37:59 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #16 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-01-29 06:37:55 ---
I had a chance to try noop and deadline:

With the amount of testing that I could do they seemed to behave
about the same, and:

1. the task timeouts are gone.

2. sync, which used to take over 20 minutes is consistently
   about 10 minutes.  I did retest by setting scheduler back
   to cfg and the sync time went back to 24 minutes.

3. I also tried 2 variations:
   1. rsync from source to target:  rsync machinea:/aaa bbb
   2. rsync of an NFS-mounted filesystem to local filesystem.
      (i.e the rsync thought it was local:  rsync aaa/  bbb,
      but aaa was NFS-mounted (NFS3).
   These two variation behaved just about identically.

I have left the system set to deadline, as recommended.  With
this setting (and with noop) things like du seem quicker too.

So, this is good, but 10 minutes for sync is still way too long.
With these systems, I cannot compile debug kernels or stuff like
that.  They are in use for backup.

Any other suggestions?

Michael

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
