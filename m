From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13230] unexplained fsck error with ext4 on software raid 10
Date: Fri, 15 May 2009 17:24:57 GMT
Message-ID: <200905151724.n4FHOv6j031502@demeter.kernel.org>
References: <bug-13230-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50662 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZEORY4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2009 13:24:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4FHOvei031503
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 17:24:57 GMT
In-Reply-To: <bug-13230-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13230





--- Comment #4 from Theodore Tso <tytso@mit.edu>  2009-05-15 17:24:56 ---
As a matter of fact we think we found the cause of the problem just yesterday.

The fix is now in mainline:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ec0ae3acec47f628179ee95fe2c4da01b5e9fc4

Was this a problem you can easily reproduce?  If so, I'd appreciate it if you
could try out this patch, and confirm that you can no longer reproduce the
problem with this patch.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
