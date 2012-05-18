From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Fri, 18 May 2012 14:52:27 +0000 (UTC)
Message-ID: <20120518145227.212FA11FCF6@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60663 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab2EROwe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 May 2012 10:52:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3817A2042B
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2012 14:52:29 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 28960203BF
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2012 14:52:27 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #20 from Eugene <ivanovstm2@zmail.ru>  2012-05-18 14:52:26 ---
to Theodore Ts'o:

I'm on freshly formatted pure ext4 fs and it's at the very least not any slower
than my ext3 was, no questions here. I just used an opportunity to ask for
assistance in bug report related to my own and launchpad's "jbd2 writing block
every 5-10 seconds".

I'm not experiencing slowdowns. Just periodic writes. And after monitoring disk
activity and making some tweaks to applications (mostly firefox) it's got
better. After that the only thing that confused me was number of inodes which
jbd2 writes and you explained it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
