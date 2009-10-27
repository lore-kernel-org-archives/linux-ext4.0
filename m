From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 20:00:53 GMT
Message-ID: <200910272000.n9RK0rMd006037@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34212 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbZJ0UAs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 16:00:48 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9RK0r3h006038
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 20:00:53 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #131 from Linus Torvalds <torvalds@linux-foundation.org>  2009-10-27 20:00:51 ---
Some more testing of this issue:

 - if I do something like

     [root@inspiron-laptop linux]# sync
     [root@inspiron-laptop linux]# echo b > /proc/sysrq-trigger

   I never seem to see any problems.

I've done the above several times - I started using it as my shutdown
replacement, and I'm bisecting another independent issue on the same laptop.
And no problems so far.

 - but when I did the whole power-button thing even when the system looked
otherwise idle (it was hung at shutdown, and I waited ten+ seconds), I get in
trouble very easily.

This makes me suspect that the background flush by bdflush simply isn't working
well for ext4. Even when you'd expect things to be idle, and bdflush should
hopefully get your metadata out, it just doesn't.

I'd suspect the 'wait=0' case in ext4_write_inode. It does the same 'don't do
anything' that ext3 does, but presumably the delayed allocation makes for much
worse trouble. Notice how just returning zero from ext4_write_inode() will make
the general fs/fs-writeback.c just remove the inode from the dirty lists
entirely.

One thing to note is that the ext4_write_inode() behavior certainly isn't new,
but it's entirely possible that the per-bdi writeback logic has changed timing
of the writebacks a lot. Which may explain why it's apparently getting more
attention in the 2.6.32-rc series, although some people seem to have seen it
earlier too.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
