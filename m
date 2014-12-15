From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Mon, 15 Dec 2014 14:51:12 +0000
Message-ID: <bug-89621-13602-jU0kETaTk2@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57900 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaLOOvQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 09:51:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F074020A0D
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 14:51:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9F12D20A0C
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 14:51:12 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
Well, was this a one-time thing or can you easily reproduce this error?   The
problem is that almost anything can cause this --- bad memory, a wild pointer
derference coming from a proprietary video driver from Nvidia, etc.   And by
the time we get the ext4-error, basically what we have is the dead body lying
in the alley.   Where the bullet came from, and from what direction, and who
fired the gun, is not something that will be immediately evident; just that we
have a very specific kind of inconsistency between the allocation bitmap and
the block group summary statistics.  So in order to track it down, we need to
be able to try to isolate causes.   So for example, does the problem show up if
you use the latest bleeding edge kernel from mainline, etc.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
