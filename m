From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Tue, 09 Jun 2015 09:52:17 +0000
Message-ID: <bug-61601-13602-AOwdtJZsUt@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46009 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbbFIJwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2015 05:52:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C431520524
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 09:52:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9D9ED204DF
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 09:52:18 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

Karol Herbst <linux@karolherbst.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux@karolherbst.de

--- Comment #15 from Karol Herbst <linux@karolherbst.de> ---
Hi,

I have the same problem, which is causing me to remount / later in the boot
process, which increases my boot time by about 12%.

linux-4.0.5
fstype=btrfs

Is there any good workaround on kernel level to mount / directly as noatime
before init gets started?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
