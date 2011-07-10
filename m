From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Sun, 10 Jul 2011 03:49:00 GMT
Message-ID: <201107100349.p6A3n0db004255@demeter1.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59983 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab1GJDtC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jul 2011 23:49:02 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6A3n1hi004257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 10 Jul 2011 03:49:01 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2011-07-10 03:48:59 ---
By enabling the jbd2_run_stats tracepoint, I'm seeing a handful of handles
getting started every 5 seconds.

If I go into single user mode, with all user daemons killed off, jbd2 doesn't
trigger.   So it's one of the userspace daemons which is causing file system
activity.

I don't know why iotop isn't showing the activity, but I'm pretty sure that's a
shortcoming of iotop.

I'll add some jbd2 trace points so we can see what is constantly starting jbd2
handles.  But my quick testing seems to indicate to me that jbd2 is functioning
correctly, and it's active because something from userspace is ticking the file
system.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
