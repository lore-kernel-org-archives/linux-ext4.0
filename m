From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 20 Oct 2015 13:40:55 +0000
Message-ID: <bug-102731-13602-L5nzgPYpP8@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46202 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbbJTNlC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2015 09:41:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C59972041D
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 13:41:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 345B920220
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 13:40:56 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #26 from John Hughes <john@calva.com> ---
Well I've just had the problem happen when running the 4.2.3 kernel (on the
guest, the host is still 3.16).

This time it was on the root filesystem, so no log messages unfortunately.

Will try and schedule some time to move the host to 4.2.3 this week.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
