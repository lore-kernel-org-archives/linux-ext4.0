From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Tue, 09 Jun 2015 21:35:14 +0000
Message-ID: <bug-61601-13602-J8opJG3MeP@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60538 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbbFIVfR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2015 17:35:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A70EF2055D
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 21:35:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1066320555
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 21:35:15 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

Christian Kujau <lists@nerdbynature.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #16 from Christian Kujau <lists@nerdbynature.de> ---
Try rootflags=noatime as a kernel boot option?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
