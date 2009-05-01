From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Fri, 1 May 2009 13:52:35 GMT
Message-ID: <200905011352.n41DqZqj014119@demeter.kernel.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33748 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZEANwf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 09:52:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n41DqZCK014120
	for <linux-ext4@vger.kernel.org>; Fri, 1 May 2009 13:52:35 GMT
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #8 from Theodore Tso <tytso@mit.edu>  2009-05-01 13:52:35 ---
We're desperately looking for a reliable reproduction case for this problem.  
My suggestion at this point is if you have a large filesystem (the reports for
this seem to come from users with > 1TB filesystems) to take a periodic e2image
backup of your filesystem before the corruption, and save it on some other
filesystem so there is a backup of your filesystem metadata.   This will help
recover the filesystem after the corruption.

If you can reproduce this reliably, please let us know.  We haven't been able
to get this problem reproduced yet.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
