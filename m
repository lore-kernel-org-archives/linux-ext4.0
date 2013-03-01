From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 54551] write fails with one short >2GB write.
Date: Fri,  1 Mar 2013 09:20:51 +0000 (UTC)
Message-ID: <20130301092051.568EC11FB5D@bugzilla.kernel.org>
References: <bug-54551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57456 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3CAJUy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 04:20:54 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DAC4520340
	for <linux-ext4@vger.kernel.org>; Fri,  1 Mar 2013 09:20:52 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 59ECD2031A
	for <linux-ext4@vger.kernel.org>; Fri,  1 Mar 2013 09:20:51 +0000 (UTC)
In-Reply-To: <bug-54551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=54551


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #2 from Jan Kara <jack@suse.cz>  2013-03-01 09:20:51 ---
You cannot easily overcome this limit. Also I'd note that POSIX does not say
how much is going to be written. So you have to be prepared for the fact that
your write writes e.g. 1 byte (although in practice that doesn't tend to
happen). If some program relies on write(2) writing as much as it was told to,
it is a buggy program.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
