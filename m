From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sun, 20 Oct 2013 02:10:45 +0000
Message-ID: <bug-61631-13602-gQNhUe70L5@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45668 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3JTCKs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Oct 2013 22:10:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7D33420580
	for <linux-ext4@vger.kernel.org>; Sun, 20 Oct 2013 02:10:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E7D2F20569
	for <linux-ext4@vger.kernel.org>; Sun, 20 Oct 2013 02:10:45 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #15 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
Looks like bf7bd3e98be5c74813bee6ad496139fb0a011b3b indeed fixed it.  I ran
3.11.5 (which I believe includes that patch) for a few days, doing normal
activities such as nfs i/o and rdiff-backups.  I was able to umount without
problems.  Thanks for fixing this!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
