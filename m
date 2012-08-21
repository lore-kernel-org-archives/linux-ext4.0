From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Tue, 21 Aug 2012 21:34:33 +0000 (UTC)
Message-ID: <20120821213433.AB52A11FC6D@bugzilla.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54174 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588Ab2HUVej (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Aug 2012 17:34:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 580F02035E
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2012 21:34:38 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B26D520366
	for <linux-ext4@vger.kernel.org>; Tue, 21 Aug 2012 21:34:34 +0000 (UTC)
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182





--- Comment #15 from Theodore Tso <tytso@mit.edu>  2012-08-21 21:34:33 ---
Could you please open a new bug report with the e2fsck logs, and dumpe2fs
output, and lots of detail about your hardware setup, and whether you are using
LVM, software raid, etc.    We need to rule out all sorts of things, including
hardware bugs, problems with partition tables, etc.   Since no one else is
reporting this I have to rule out hardware bugs (disk bugs, memory bugs, etc.)
as well as stupid sysadmin configuration problems.   (This isn't to impunge
your skills, but a large number of bug reports I get end up not kernel bugs at
all.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
