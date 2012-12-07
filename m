From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Fri,  7 Dec 2012 20:13:06 +0000 (UTC)
Message-ID: <20121207201306.50D2911FE9C@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57776 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab2LGUNI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 15:13:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 745A0201EB
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 20:13:07 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 91394201DF
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 20:13:06 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEEDINFO                    |REJECTED
         Resolution|                            |UNREPRODUCIBLE




--- Comment #8 from Theodore Tso <tytso@mit.edu>  2012-12-07 20:13:05 ---
Can you replicate the problem **without** using Spruce?

In any case, I would suggest sending a bug report with Canonical, since this is
a Ubuntu kernel --- and despite my best efforts, I can not replicate the
problem as you have described it on a stock 3.2.29 or 3.7-rc4 development
kernel.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
