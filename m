From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45631] Caught 32-bit read from uninitialized memory in
 ext4_da_get_block_prep
Date: Sun, 26 Aug 2012 10:48:54 +0000 (UTC)
Message-ID: <20120826104854.6648611FC6D@bugzilla.kernel.org>
References: <bug-45631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49995 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab2HZKs5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Aug 2012 06:48:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0111620294
	for <linux-ext4@vger.kernel.org>; Sun, 26 Aug 2012 10:48:56 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 67C8B20298
	for <linux-ext4@vger.kernel.org>; Sun, 26 Aug 2012 10:48:54 +0000 (UTC)
In-Reply-To: <bug-45631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45631


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #2 from Florian Mickler <florian@mickler.org>  2012-08-26 10:48:54 ---
A patch referencing this bug report has been merged in Linux v3.6-rc3:

commit 7e731bc9a12339f344cddf82166b82633d99dd86
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Aug 5 23:28:16 2012 -0400

    ext4: avoid kmemcheck complaint from reading uninitialized memory

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
