From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42872] fstat()/ext3_iget() sometime takes over 2 minutes...
Date: Tue, 6 Mar 2012 20:29:01 GMT
Message-ID: <201203062029.q26KT1u8024537@bugzilla.kernel.org>
References: <bug-42872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:33324 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab2CFU3C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 15:29:02 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q26KT1uf024538
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 20:29:01 GMT
In-Reply-To: <bug-42872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42872


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #1 from Jan Kara <jack@suse.cz>  2012-03-06 20:29:00 ---
Hmm, we are waiting for buffer lock so likely someone is writing that inode
out. It would be good to have stack traces of all hanging processes at that
moment to tell what they are doing.

So can you please do one more run and when things like suspiciously long fstat
happen, run as fast as possible "echo w >/proc/sysrq-trigger" and attach here
the output? Thanks

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
