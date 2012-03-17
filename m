From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sat, 17 Mar 2012 08:46:13 GMT
Message-ID: <201203170846.q2H8kDFD009355@bugzilla.kernel.org>
References: <bug-14972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:36701 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2CQIqO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Mar 2012 04:46:14 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2H8kDh9009356
	for <linux-ext4@vger.kernel.org>; Sat, 17 Mar 2012 08:46:13 GMT
In-Reply-To: <bug-14972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #14 from Sergiy Zuban <s.zuban@gmail.com>  2012-03-17 08:46:13 ---
can someone else confirm it was really fixed? I'm still getting continual HDD
activity on Linux laptop 3.0.0-16-generic #28-Ubuntu SMP Fri Jan 27 17:50:54
UTC 2012 i686 i686 i386 GNU/Linux in some apps (e.g. Miranda IM
http://bugs.winehq.org/show_bug.cgi?id=24044#c13)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
