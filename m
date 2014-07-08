From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Tue, 08 Jul 2014 13:43:27 +0000
Message-ID: <bug-78651-13602-8ZQD70nh2D@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43448 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaGHNna (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 09:43:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A266D202FF
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:43:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C0B6C2015A
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:43:27 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #12 from Joseph D. Wagner <joe@josephdwagner.info> ---
Created attachment 142481
  --> https://bugzilla.kernel.org/attachment.cgi?id=142481&action=edit
memstats 1gb journal

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
