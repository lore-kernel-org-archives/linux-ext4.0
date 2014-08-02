From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81461] EXT-4 kernel panic
Date: Sat, 02 Aug 2014 00:17:00 +0000
Message-ID: <bug-81461-13602-36iE7KTjtV@https.bugzilla.kernel.org/>
References: <bug-81461-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33454 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaHBARE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 20:17:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0EE1D20225
	for <linux-ext4@vger.kernel.org>; Sat,  2 Aug 2014 00:17:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6160820218
	for <linux-ext4@vger.kernel.org>; Sat,  2 Aug 2014 00:17:01 +0000 (UTC)
In-Reply-To: <bug-81461-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=81461

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |OBSOLETE

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
There have been a huge number of fixes involving ext4_evict_inode, including
some races that look like they could be responsible for this crash that have
been made since v3.4.

And it's not something which can be easily backported to a kernel that old, so
there's not much we can do our end.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
