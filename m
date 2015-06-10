From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Wed, 10 Jun 2015 16:04:53 +0000
Message-ID: <bug-61601-13602-dp4isp7GCM@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60845 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966571AbbFJQE6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 12:04:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 45BBB20604
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2015 16:04:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1BB30205D8
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2015 16:04:54 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

--- Comment #17 from Karol Herbst <linux@karolherbst.de> ---
for obvious reasons "rootflags=noatime" does result in a kernel error as shown
in the above comments

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
