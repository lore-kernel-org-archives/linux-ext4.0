From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 26 Dec 2014 15:51:58 +0000
Message-ID: <bug-89511-13602-4c6zAsoUKs@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51215 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaLZPwD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Dec 2014 10:52:03 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BACA920166
	for <linux-ext4@vger.kernel.org>; Fri, 26 Dec 2014 15:52:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 346F5201C7
	for <linux-ext4@vger.kernel.org>; Fri, 26 Dec 2014 15:51:59 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #27 from Alan Stern <stern@rowland.harvard.edu> ---
Jan Kara, maybe you can explain the ext4 page allocation error in this log.

Jun Itou, can you attach a usbmon trace for this drive (with the cache set to
"temporary write through")?

I don't know what a GLANTANK is.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
