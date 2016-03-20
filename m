From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Sun, 20 Mar 2016 16:54:16 +0000
Message-ID: <bug-23732-13602-1sdiWRAX62@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44893 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbcCTQyT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2016 12:54:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 63E00201D3
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 16:54:18 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C03C7202D1
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 16:54:16 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #11 from Theodore Tso <tytso@mit.edu> ---
This has been fixed in the latest kernel and e2fsprogs

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
