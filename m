From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Thu, 15 Oct 2015 15:38:17 +0000
Message-ID: <bug-102731-13602-t2iReRhQAL@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbJOPiU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 11:38:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E5F3A2074E
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2015 15:38:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 62C2E20852
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2015 15:38:17 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #21 from John Hughes <john@calva.com> ---
(In reply to cwseys from comment #19)
> Might be interesting to convert the filesystem to XFS via a series of
> partition adds / copies / removes .  At least then the ext4 connection
> could be more firmly established.

Well, since I've demirrored the system (ugh) I have enough space to make a
copies of my filesystmes.

> (Actually, might want to "convert" to ext4 instead of XFS first and verify
> that the problem does not go away.)

I'm planning to move to ext4 over the weekend.  I've not yet decided whether to
do it in-place or by copying the data to a new filesystem.

Will doing an in place conversion be enough?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
