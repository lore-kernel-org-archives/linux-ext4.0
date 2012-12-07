From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Fri,  7 Dec 2012 17:10:51 +0000 (UTC)
Message-ID: <20121207171051.26AA711FB81@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51767 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422888Ab2LGRK6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 12:10:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AE89E2034A
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 17:10:57 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 443D820355
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 17:10:52 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2012-12-07 17:10:50 ---
I just built 3.2.29, and running under KVM, I created a file system, mounted it
with -o nodev, and then unmounted it.  It didn't crash.

I then mounted it without nodev, ran "mknod /mnt/null c 3 1" to create a
/dev/null character device, unmounted the file system, remounted it with -o
nodev, tried writing to /mnt/null, which failed as it should, and then
unmounted the file system.   Still no crash.

Can you tell me if there was anything else special about how you ran your test?
 Did it fail right on the mount?  Was this the root file system that you were
testing trying to mount -o nodev, etc.?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
