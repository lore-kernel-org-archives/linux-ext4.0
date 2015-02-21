From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Sat, 21 Feb 2015 01:15:57 +0000
Message-ID: <bug-23732-13602-q4BrabpsG4@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42005 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbbBUBQD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2015 20:16:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7DB12045B
	for <linux-ext4@vger.kernel.org>; Sat, 21 Feb 2015 01:16:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AA8712049C
	for <linux-ext4@vger.kernel.org>; Sat, 21 Feb 2015 01:15:58 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
                 CC|                            |tytso@mit.edu
         Resolution|CODE_FIX                    |---

--- Comment #10 from Theodore Tso <tytso@mit.edu> ---
I'm not sure why the test cases have been passing but the true fix hasn't been
applied yet.  This is due to my not having time and the need for us to have
better test cases in e2fsprogs (for both the old and new encodings, etc.)   As
usual, the highly urgent problems with short-term deadlines tend to get higher
priority from the important long-term items.

Specifically, I want to be able to convert time strings to integers using both
the old the new encodings, and then have test cases to make sure that e2fsck
and the kernel are doing the right thing and coverting as necessary as we had
determined in the migration plan for this bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
