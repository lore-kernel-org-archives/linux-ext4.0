From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114701] ubsan: "shift exponent -1 is negative" in
 fs/ext4/mballoc.c:2612:15
Date: Fri, 06 May 2016 01:19:48 +0000
Message-ID: <bug-114701-13602-jeIqBBJiyL@https.bugzilla.kernel.org/>
References: <bug-114701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbcEFBTw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 21:19:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 749A0203EC
	for <linux-ext4@vger.kernel.org>; Fri,  6 May 2016 01:19:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AE288203F7
	for <linux-ext4@vger.kernel.org>; Fri,  6 May 2016 01:19:48 +0000 (UTC)
In-Reply-To: <bug-114701-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114701

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |CODE_FIX

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
I will be applying these patches:

        http://patchwork.ozlabs.org/patch/599805/
        http://patchwork.ozlabs.org/patch/599804/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
