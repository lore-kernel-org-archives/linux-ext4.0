From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Tue, 03 Feb 2015 17:47:27 +0000
Message-ID: <bug-92271-13602-QpB8HjDX0i@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40413 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965907AbbBCRr3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2015 12:47:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2B6EA201BC
	for <linux-ext4@vger.kernel.org>; Tue,  3 Feb 2015 17:47:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4A60720154
	for <linux-ext4@vger.kernel.org>; Tue,  3 Feb 2015 17:47:27 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #24 from Alexander Holler <holler@ahsoftware.de> ---
Sorry, but that doesn't make any sense (comment #22).

As all these companies already fail with 'rm', still offer 'shred', there is
nothing more to loose. It can't become worse, just better.

And that is would this approach is or was about (as written on LKML, I've
already given up).

And if people do answer with complications like snapshots and whatever (as bug
#92261), I really have to wonder. Where does the documentation for 'rm' or even
'shred' mention that it is unable to delete files from backups, snapshots or
the like?

Nobody has to advertise this scheme in way it doesn't work.

Maybe it was a fault to mention the word secure, and I should have used
unlinkat_w() (for wipe), because everyone seems to end up in panic nowadays
when they get in contact with the word secure.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
