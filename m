From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112161] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1274:11
Date: Fri, 06 May 2016 01:19:33 +0000
Message-ID: <bug-112161-13602-k1Zwl2nkbv@https.bugzilla.kernel.org/>
References: <bug-112161-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44710 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbcEFBTh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 21:19:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B4AA2041B
	for <linux-ext4@vger.kernel.org>; Fri,  6 May 2016 01:19:36 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6252F203F3
	for <linux-ext4@vger.kernel.org>; Fri,  6 May 2016 01:19:34 +0000 (UTC)
In-Reply-To: <bug-112161-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112161

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
