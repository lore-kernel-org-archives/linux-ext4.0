From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Sat, 5 May 2012 20:42:44 GMT
Message-ID: <201205052042.q45Kgi53006617@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:35253 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2EEUmp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 May 2012 16:42:45 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q45Kgi5w006618
	for <linux-ext4@vger.kernel.org>; Sat, 5 May 2012 20:42:44 GMT
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #7 from Hugues Tranli <huguelectro@hotmail.fr>  2012-05-05 20:42:44 ---
Ok, I turned off my extensions (was just using "Silver Bird" and "Adblock").
That's all.
Tried with an empty browser and the result was almost the same as before.
Even with a single tab (this bug report), the fsync() activity is very high.
I am using Chromium 18.0.1024 build which seems to be buggy.

Pastebin: http://pastebin.archlinux.fr/443140

Wanted thank you for your help (especially debug, I didn't know it).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
