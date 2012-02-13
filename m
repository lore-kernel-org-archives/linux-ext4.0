From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Mon, 13 Feb 2012 15:55:12 GMT
Message-ID: <201202131555.q1DFtCis021686@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54653 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2BMPzM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 10:55:12 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1DFtCdl021687
	for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 15:55:12 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #1 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-13 15:55:11 ---
More info:

After a reboot (and forced but uneventful fsck), the problem is gone until I
run my program again. The program consists of multiple threads traversing and
stat()ing different directory trees simultaneously.

The program will actually work fine for several iterations before getting
stuck,
but once it gets stuck, that directory is a trap for all processes until
reboot.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
