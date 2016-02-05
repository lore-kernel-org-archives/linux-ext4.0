From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111891] access to file does not change access time to folders
 above up to /(root)
Date: Fri, 05 Feb 2016 20:36:29 +0000
Message-ID: <bug-111891-13602-sez3OpBxFx@https.bugzilla.kernel.org/>
References: <bug-111891-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40845 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbcBEUgd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2016 15:36:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 18496203AC
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 20:36:32 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 76386203A5
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 20:36:29 +0000 (UTC)
In-Reply-To: <bug-111891-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111891

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED
                 CC|                            |tytso@mit.edu
         Resolution|WILL_NOT_FIX                |INVALID

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
Andreas, I don't have access to change the access controls.  We need to ask the
bugzilla.kernel.org admins to add you to the appropriate ACL.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
