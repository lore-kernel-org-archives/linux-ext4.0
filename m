From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Mon, 13 Feb 2012 18:21:24 GMT
Message-ID: <201202131821.q1DILO3i024567@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54933 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab2BMSVZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 13:21:25 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1DILO0g024568
	for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 18:21:24 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #5 from Eric Sandeen <sandeen@redhat.com>  2012-02-13 18:21:23 ---
Ok, I'm traveling w/ limited time to try to reproduce but thanks for all the
info.

A sysrq-W or sysrq-T when it's hung might show us where the threads are at.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
