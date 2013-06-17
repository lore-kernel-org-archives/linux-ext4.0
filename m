From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59801] kernel BUG at /kernel/fs/ext4/extents.c:1996!
Date: Mon, 17 Jun 2013 03:22:31 +0000 (UTC)
Message-ID: <20130617032231.AFB7211FB56@bugzilla.kernel.org>
References: <bug-59801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38552 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab3FQDWf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Jun 2013 23:22:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6AD3F2017A
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 03:22:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5B6B02013C
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 03:22:32 +0000 (UTC)
In-Reply-To: <bug-59801-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=59801


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2013-06-17 03:22:31 ---
What version of e2fsprogs are you using?   The BUG_ON looks like it was
triggered by a zero-length extent, and older versions of e2fsprogs didn't check
for this condition.

I would suggest upgrading to e2fsprogs 1.42.7 (or e2fsprogs 1.42.8, which will
be released in a few days), especially if you are using something older than
1.42.2 or so.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
