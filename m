From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22302] 2.6.36 BUG: scheduling while atomic:
 rc.sysinit/1376/0x00000002
Date: Sun, 7 Nov 2010 22:25:03 GMT
Message-ID: <201011072225.oA7MP38n001526@demeter1.kernel.org>
References: <bug-22302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39480 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0KGWZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Nov 2010 17:25:04 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA7MP30m001527
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 7 Nov 2010 22:25:03 GMT
In-Reply-To: <bug-22302-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22302


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2010-11-07 22:25:01 ---
This is caused by an interaction in two changes that happened in parallel in
2.6.36: commit id's dd3932eddf4 (block: remove BLKDEV_IFL_WAIT) and 
commit 5c521830cf3 (ext4: Support discard requests when running in no-journal
mode).

The problem is that ext4_free_blocks() can be called by functions which are
holding spinlocks, so it can't sleep --- and sb_issue_discard() now always
waits for the discard to be completed.  It doesn't support an asynchronous mode
at all.

The fix for the short-term is to remove the call to ext4_issue_discard() in
ext4_free_blocks().  This effectively removes the functionality of commit 
5c521830cf3.  The long-term fix would be to implement a version of
sb_issue_discard() which supports asynchronous mode, with an optional callback.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
