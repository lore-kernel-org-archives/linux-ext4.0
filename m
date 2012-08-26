From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45631] Caught 32-bit read from uninitialized memory in
 ext4_da_get_block_prep
Date: Sun, 26 Aug 2012 18:55:58 +0000 (UTC)
Message-ID: <20120826185558.7F2AF11FC6E@bugzilla.kernel.org>
References: <bug-45631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57647 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2HZS4B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Aug 2012 14:56:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0BDA520293
	for <linux-ext4@vger.kernel.org>; Sun, 26 Aug 2012 18:56:00 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9470120289
	for <linux-ext4@vger.kernel.org>; Sun, 26 Aug 2012 18:55:58 +0000 (UTC)
In-Reply-To: <bug-45631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45631


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2012-08-26 18:55:58 ---
Fixed with commit 7e731bc9a123

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
