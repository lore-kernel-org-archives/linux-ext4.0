From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70121] Increasing efficiency of full data journaling
Date: Fri, 07 Mar 2014 15:42:13 +0000
Message-ID: <bug-70121-13602-v2ZpdxuZ92@https.bugzilla.kernel.org/>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaCGPmR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2014 10:42:17 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BF5F120295
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 15:42:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 29F14202D1
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 15:42:14 +0000 (UTC)
In-Reply-To: <bug-70121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70121

--- Comment #8 from sworddragon2@aol.com ---
Thanks for the information :)

In this case full data journaling seems not to make all the things I thought it
does. Maybe my last tests are just too long ago. But this means also that I
still can have data loss if the system crashes while writing to the disk. It
would be really nice if the filesystem would provide such a mechanism in the
future.


> How does the file system know that the file has "successfully been
> written"?

Does the filesystem really not know if the file is complete? If this could be
achieved a transaction safety should be not the problem here.


> If you think it can be done, plesae submit patches.  :-)

Sure I would if:

- My experience with C would be a little higher.
- Or at least if I would have the time to make a deeper look into the
sourcecode and the coding rules for the kernel.


I have posted the last few years many hundred bugs/feature requests in ~100
different projects and am still doing this many times a week. But don't worry,
they don't have so many bogus reports as I'm reporting here :)
The kernel is really a difficult place if you are not directly involved with it
but want to improve something. But some of my tickets here had already success.
Also I'm programming on own projects and this all together consumes much time.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
