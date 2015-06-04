From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 04 Jun 2015 07:47:54 +0000
Message-ID: <bug-89511-13602-0tl4oDPvSm@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54686 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbbFDHr7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2015 03:47:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AE350203FB
	for <linux-ext4@vger.kernel.org>; Thu,  4 Jun 2015 07:47:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7FBBA20254
	for <linux-ext4@vger.kernel.org>; Thu,  4 Jun 2015 07:47:55 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

Markus Rathgeb <maggu2810@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maggu2810@gmail.com

--- Comment #50 from Markus Rathgeb <maggu2810@gmail.com> ---
I ran in the same trouble with an old USB case for 2.5'' IDE hard discs.

The drive cache_type is set to "write back" if it plugged in.
The drive is working using if I set the cache type to "temporary write
through".

So, I think this is the exact same problem discussed here.

At the moment I tested the workaround using v3.18.2 (gentoo-sources).
Without the workaround the problem also exists using the Kernel v4.0.4 (used
gentoo-sources, but I think that should not be related to the problem at all).

Is there anything I / we can do, to solve this problem at all in the kernel
space (e.g. if SYNCHRONIZE CACHE command is not working, fallback to write
through)?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
