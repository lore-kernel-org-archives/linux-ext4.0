From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Wed, 09 Jul 2014 03:30:46 +0000
Message-ID: <bug-78651-13602-1noSGNrkjf@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47675 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaGIDas (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 23:30:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4D040202F0
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jul 2014 03:30:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 682AB202AE
	for <linux-ext4@vger.kernel.org>; Wed,  9 Jul 2014 03:30:46 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #16 from Joseph D. Wagner <joe@josephdwagner.info> ---
*Correction* Reformat with default options, and rerun with a trace?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
