From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Fri, 24 Feb 2012 02:22:16 GMT
Message-ID: <201202240222.q1O2MG1K003936@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:57230 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2BXCWR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Feb 2012 21:22:17 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1O2MGFi003937
	for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2012 02:22:16 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #11 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-24 02:22:15 ---
Applied to 3.2.7, and it seems to fix it; at least I ran the same test for
about 4x as long as before without the problem exhibiting itself.

Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
