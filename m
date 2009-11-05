From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14452] Syscall to ftruncate hangs on ext4 + mdadm raid0
 filesystem on a file preallocated with fallocate
Date: Thu, 5 Nov 2009 14:22:37 GMT
Message-ID: <200911051422.nA5EMbCr008750@demeter.kernel.org>
References: <bug-14452-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57675 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZKEOWb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 09:22:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA5EMbfk008751
	for <linux-ext4@vger.kernel.org>; Thu, 5 Nov 2009 14:22:37 GMT
In-Reply-To: <bug-14452-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14452


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #1 from Jan Kara <jack@suse.cz>  2009-11-05 14:22:32 ---
This looks like a deadlock that was fixed by commit
487caeef9fc08c0565e082c40a8aaf58dad92bbb. The fix went into vanilla kernel
shortly after 2.6.31 was released so you shouldn't see this deadlock anymore
with 2.6.32. I'll attach the patch here for reference if you want to test it by
itself.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
