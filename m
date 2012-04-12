From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Thu, 12 Apr 2012 15:04:24 GMT
Message-ID: <201204121504.q3CF4OkG031795@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:40683 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab2DLPEZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Apr 2012 11:04:25 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3CF4OP7031796
	for <linux-ext4@vger.kernel.org>; Thu, 12 Apr 2012 15:04:24 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #14 from Theodore Tso <tytso@mit.edu>  2012-04-12 15:04:23 ---
Use the one which is shipped with e2fsprogs.   Better yet, use libext2fs to
access the file system, and busybox will be future-proofed against future
changes / improvements in the ext 2/3/4 family of file systems.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
