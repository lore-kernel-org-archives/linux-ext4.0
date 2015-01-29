From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Thu, 29 Jan 2015 22:11:31 +0000
Message-ID: <bug-92271-13602-lwDCxVGteX@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36795 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbbA2WLe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2015 17:11:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1563B20260
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 22:11:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 846AA2024C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 22:11:31 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #9 from Alexander Holler <holler@ahsoftware.de> ---
Unfortunately that 's' flag wouldn't be usable for other filesystems which
don't know about it, so I would still prefer a special unlink().

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
