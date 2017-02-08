From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194511] filesystem slow down
Date: Wed, 08 Feb 2017 19:49:29 +0000
Message-ID: <bug-194511-13602-4iNiAKu6JG@https.bugzilla.kernel.org/>
References: <bug-194511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdBHTu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 8 Feb 2017 14:50:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0FAEF2025A
        for <linux-ext4@vger.kernel.org>; Wed,  8 Feb 2017 19:49:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id DB1152024F
        for <linux-ext4@vger.kernel.org>; Wed,  8 Feb 2017 19:49:29 +0000 (UTC)
In-Reply-To: <bug-194511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194511

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
I am currently running with a 4.9 kernel (and previously I was using a 4.8
kernel, and before that I was using 4.4) on my development laptop and I
certainly wasn't seeing the sort of performance numbers you are seeing.

Nor has anyone else been complaining about this --- and given that there are a
lot of people running Debian testing with a 4.8 kernel, I'm sure we would have
heard the complaints if this was a widespread problem.

So there must be something fairly unique about either your hardware or software
configuration.   Or perhaps your kernel configuration.   We would need all of
that information in order to be able to even start looking at your complaint.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
