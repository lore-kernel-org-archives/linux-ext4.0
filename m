From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Thu, 29 Jan 2015 21:55:50 +0000
Message-ID: <bug-92271-13602-D7hq5qnq17@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35802 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbbA2Vzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2015 16:55:53 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A33C720225
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 21:55:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 78F3920254
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 21:55:50 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #7 from Alexander Holler <holler@ahsoftware.de> ---
The problem is the missing promise from the FS that is has overwritten the used
blocks.

Even using fstrim --secure doesn't give that promise, because the user doesn't
know if the FS has given the blocks back to the device (as free).

And as long as the FS doesn't give such a promise, the only way for the user to
be sure is to shred the whole device/partition.

So in case of ext4, implementing a syscall like s[ecure_]unlink() doesn't seem
to be a big complicated thing and would be a very great start in solving the
problem.

Of course that might not be final ultimate solution because it doesn't solve
the problem about what happens when files have been modified, moved and then
deleted. Here something like the 's' bit could help.

But I'm a friend of starting with small steps and I think a special unlink
syscall would be a great and already useable start in solving the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
