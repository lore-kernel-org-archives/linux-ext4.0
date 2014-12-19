From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 19 Dec 2014 22:11:49 +0000
Message-ID: <bug-89511-13602-zUOtnsbNmi@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45117 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaLSWLx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 17:11:53 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6FED120145
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 22:11:52 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 270E720148
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 22:11:50 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #19 from Alan Stern <stern@rowland.harvard.edu> ---
Now I see the problem.  Your drive doesn't like the SYNCHRONIZE CACHE command;
it responds with an error "Illegal request, invalid operation code".  It does
this even though it claims to have a write cache and therefore to support
SYNCHRONIZE CACHE.

In short, the bug is in the drive or in its USB interface.  You may be able to
work around the bug by doing this before you mount it:

   echo 'temporary write through' >/sys/block/sdb/device/scsi_disk/*/cache_type

I don't know if that command will work with your kernel (it should work with
3.10 or later).  If it doesn't, try leaving out the word "temporary":

   echo 'write through' >/sys/block/sdb/device/scsi_disk/*/cache_type

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
