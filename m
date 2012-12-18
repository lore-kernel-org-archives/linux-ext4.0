From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51781] System got hanged with firefox. Filesystem not
 responding.
Date: Tue, 18 Dec 2012 14:57:18 +0000 (UTC)
Message-ID: <20121218145718.0FF6611FF01@bugzilla.kernel.org>
References: <bug-51781-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33392 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab2LRO52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 09:57:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5D5C4202B9
	for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2012 14:57:23 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B04F5202B1
	for <linux-ext4@vger.kernel.org>; Tue, 18 Dec 2012 14:57:18 +0000 (UTC)
In-Reply-To: <bug-51781-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51781


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |INVALID




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-12-18 14:57:17 ---
The kernel syslog shows a huge number of hard drive errors.  So it looks like
the problem is caused by a hardware failure.  It is most likely a failing hard
drive, but it's possible that the problem could be caused by a loose HDD cable.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
