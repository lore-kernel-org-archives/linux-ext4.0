From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113041] mbcache NULL pointer dereference
Date: Wed, 27 Apr 2016 07:36:35 +0000
Message-ID: <bug-113041-13602-W8C9oYRTFv@https.bugzilla.kernel.org/>
References: <bug-113041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbcD0Hgi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2016 03:36:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 58B1D20219
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2016 07:36:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9133D20225
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2016 07:36:35 +0000 (UTC)
In-Reply-To: <bug-113041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113041

--- Comment #6 from Johnny <johnny+bugzilla@appdata.biz> ---
What's new in latest trace is that the comm is kswapd0 and not java.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
