From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 2 May 2012 18:49:28 GMT
Message-ID: <201205021849.q42InSVF002222@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:52241 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2EBSt2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 14:49:28 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q42InSfT002223
	for <linux-ext4@vger.kernel.org>; Wed, 2 May 2012 18:49:28 GMT
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #5 from Hugues Tranli <huguelectro@hotmail.fr>  2012-05-02 18:49:27 ---
Ok mate, I tried what you asked. I am lucky, the FTRACE is unable in my kernel
and I mounted the debugfs.
After around one minute (maybe more), here what I get:
http://pastebin.archlinux.fr/441700

Best Regards.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
