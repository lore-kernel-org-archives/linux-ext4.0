From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39732] JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr
 = 2512725). There's a risk of filesystem corruption in case of system crash.
Date: Tue, 24 Jan 2012 23:17:12 GMT
Message-ID: <201201242317.q0ONHCJo032491@bugzilla.kernel.org>
References: <bug-39732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:39505 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2AXXRM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jan 2012 18:17:12 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0ONHCrh032492
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jan 2012 23:17:12 GMT
In-Reply-To: <bug-39732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39732





--- Comment #2 from Florian Mickler <florian@mickler.org>  2012-01-24 23:17:10 ---
Is this still a problem in v3.2 / v3.3-rc1 ?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
