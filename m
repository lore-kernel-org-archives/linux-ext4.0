From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Tue, 21 Aug 2012 20:33:31 +0000 (UTC)
Message-ID: <20120821203331.4E54611FC6C@bugzilla.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52526 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2HUUdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Aug 2012 16:33:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 92D0A203CD
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2012 20:33:35 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9AC8620337
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2012 20:33:32 +0000 (UTC)
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182





--- Comment #14 from Peter Hanecak <hany+kernel.org@hany.sk>  2012-08-21 20:33:30 ---
Reboot + fsck was done quite a lot of times since it started occuring. Some
bugs do get found and fixed but the message never goes away. I have no further
info to open new bug.

Any suggestions as to what I might try to either fix the inode or compile some
more information so as to file bug report? Thanks in advance.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
