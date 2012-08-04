From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Sat,  4 Aug 2012 23:45:52 +0000 (UTC)
Message-ID: <20120804234552.0D1C811FC6A@bugzilla.kernel.org>
References: <bug-45621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50156 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab2HDXpz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2012 19:45:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 426E920203
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 23:45:54 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 709E620200
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 23:45:53 +0000 (UTC)
In-Reply-To: <bug-45621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45621





--- Comment #1 from markus.doits@googlemail.com  2012-08-04 23:45:51 ---
Ah and one thing: Filesystem is dead afterwards (e.g. shell simply does not
return and hangs forever if I do a `ls` or so), have to reboot system or
reattach usb device to mount/access it again.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
