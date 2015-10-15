From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Thu, 15 Oct 2015 15:41:05 +0000
Message-ID: <bug-102731-13602-9IlJJiaQ1I@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34831 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbbJOPlM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 11:41:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AA6352058C
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2015 15:41:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 92A4D20735
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2015 15:41:05 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #22 from John Hughes <john@calva.com> ---
But on reflection maybe it's better to move to 4.2 as Theodore says:

"Ext4 with the 4.2 kernel will support ext3 with zero unexpected test failures,
but there are a handful of test failures that are showing up with the 3.18.21
kernel."

Decisions, decisions.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
