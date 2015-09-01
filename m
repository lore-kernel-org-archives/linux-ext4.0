From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 01 Sep 2015 14:43:07 +0000
Message-ID: <bug-102731-13602-8yZq1N2zSO@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50190 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbbIAOnM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2015 10:43:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5C9A7205FA
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2015 14:43:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1EABB205FD
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2015 14:43:08 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #10 from cwseys@physics.wisc.edu ---
If you're getting failures faster in kernel 3.16 you might also get failures 
faster by backtracking
3.15.x
3.14.x
etc towards 3.2

until you have to wait long enough to be confident you've passed the bug.

Also, less surgery on Linux raid.

Chad.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
