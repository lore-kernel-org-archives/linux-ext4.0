From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 19 Jan 2016 12:00:10 +0000
Message-ID: <bug-102731-13602-3skRizoBut@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54902 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbcASMAS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jan 2016 07:00:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7CB0A203A0
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2016 12:00:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A6BD1203AA
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2016 12:00:10 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #32 from John Hughes <john@calva.com> ---
Well I've (finally) rebooted with guest kernel 3.16 and 1Go memory.  It took a
long time to convince the users to risk a (potentially) unstable system after a
long time of all working OK.

For memory -- the problem went away when I moved the host kernel to 4.2.3 and
increased the memory of the guest system to 2Go.  Changing the guest kernel
from 4.2.3 to 3.16 *did not* make the problem go away.

Possible results --

1. problem does not show up, implies the fix is moving the host kernel to 4.2.3

2. problem does show up, implies the fix is either:

   a. increasing the guest memory to 2Go, or

   b. moving the host to 4.2.3 *and* increasing the guest memory to 2Go

   c. moving the guest to 4.2.3 *and* increasing the guest memory to 2Go

   d. moving the host to 4.2.3 *and* moving the guest to 4.2.3

   e. moving the host to 4.2.3 *and* moving the guest to 4.2.3 *and* increasing
      the guest memory to 2Go.

More news as it happens.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
