From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 01 Sep 2015 16:08:57 +0000
Message-ID: <bug-102731-13602-19NqpFiBDC@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbbIAQJB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2015 12:09:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1F59202E9
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2015 16:08:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6BB68205FD
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2015 16:08:57 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #11 from John Hughes <john@calva.com> ---
On 01/09/15 16:43, bugzilla-daemon@bugzilla.kernel.org wrote:
> If you're getting failures faster in kernel 3.16 you might also get failures
> faster by backtracking
> 3.15.x
> 3.14.x
> etc towards 3.2
Well, since a similar bug is known to be present before 3.16.something 
that doesn't seem like a good idea.

But you're right in one thing, since the bug happens faster with the 
Debian 3.16 than with my 3.18.19 I might try running that one without 
the raid.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
