From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Sun, 30 Mar 2014 16:06:13 +0000
Message-ID: <bug-61601-13602-rMCt167SWa@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbaC3QGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2014 12:06:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9611F203AA
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 16:06:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A4BC520386
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 16:06:13 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

Conrad Meyer <cse.cem@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cse.cem@gmail.com

--- Comment #3 from Conrad Meyer <cse.cem@gmail.com> ---
Attempt to repro (3.14-rc8-next-20140328), root fs is ext4.

Added rootflags=noatime to my 'append' line in extlinux.conf.

Could not repro. System boots fine.

Looking at relatime flag, kernel only adds this when NOATIME is not already
specified. So that doesn't seem likely to be the issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
