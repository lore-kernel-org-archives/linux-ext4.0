From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Mon, 13 Feb 2012 17:57:18 GMT
Message-ID: <201202131757.q1DHvIqh024085@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54886 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2BMR5S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 12:57:18 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1DHvItN024086
	for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 17:57:18 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #4 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-13 17:57:16 ---
fsck did not find any problems with the filesystem.

I rebooted without any fsck, and was found the same symptoms; a couple dozen
successful runs, then a hang (this time, it seems to be on two directories
simultaneously).

I have been dropping caches between runs. I haven't tried to trigger the bug
without dropping caches.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
