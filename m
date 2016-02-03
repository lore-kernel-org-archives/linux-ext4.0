From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111801] mount fails silently if mount point is "busy"
Date: Wed, 03 Feb 2016 15:15:04 +0000
Message-ID: <bug-111801-13602-AqVemKkoU4@https.bugzilla.kernel.org/>
References: <bug-111801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44403 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbcBCPPL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2016 10:15:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E6012200D0
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2016 15:15:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A12D120221
	for <linux-ext4@vger.kernel.org>; Wed,  3 Feb 2016 15:15:04 +0000 (UTC)
In-Reply-To: <bug-111801-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111801

--- Comment #1 from David Knight <diemkae@gmail.com> ---
Actually, the mount succeeds, but the shell's CWD is not updated.  A cd to
somehwere else and back to /boot resolves this.

Probably should withdraw this bug report.

Sorry about that...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
