From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Tue, 21 Aug 2012 00:44:56 +0000 (UTC)
Message-ID: <20120821004456.9043611FC6C@bugzilla.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48377 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab2HUApA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2012 20:45:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6BF0C20287
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2012 00:44:58 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 977F22029A
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2012 00:44:56 +0000 (UTC)
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #13 from Theodore Tso <tytso@mit.edu>  2012-08-21 00:44:56 ---
The error messages listed above just means that file system has been corrupted.

Have you tried rebooting and letting e2fsck repair the file system?   If you
can reliably cause the file system to get corrupted in this way, please open a
new bug report with the reproduction instructions.

But the mere fact that you see these messages doesn't mean that the kernel is
buggy....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
